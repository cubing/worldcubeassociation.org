import React, { useState, useEffect, useCallback } from 'react';

import { Button } from 'semantic-ui-react';

import _ from 'lodash';
import AttemptsForm from './AttemptsForm';
import PersonForm from './PersonForm';
import RoundForm from './RoundForm';
import NewPersonModal from './NewPersonModal';
import DeleteResultButton from './DeleteResultButton';
import SaveMessage from './SaveMessage';
import AfterActionMessage from './AfterActionMessage';
import formats from '../../wca/formats.js.erb';
import useSaveData from '../../hooks/useSaveData';
import { average, best } from '../../wca-live/attempts';
import { resultUrl } from '../../requests/routes.js.erb';
import { fetchJsonOrError } from '../../requests/fetchWithAuthenticityToken';
import countries from '../../wca/countries.js.erb';
import './ResultForm.scss';

const roundDataFromResult = (result) => ({
  competitionId: result.competition_id || '',
  roundTypeId: result.round_type_id || '',
  formatId: result.format_id || '',
  eventId: result.event_id || '',
});

const attemptsDataFromResult = (solveCount, result) => ({
  attempts: _.times(solveCount, (index) => (result.attempts && result.attempts[index]) || 0),
  markerBest: result.regional_single_record || '',
  markerAvg: result.regional_average_record || '',
});

const personDataFromResult = (result) => ({
  wcaId: result.wca_id || '',
  name: result.name || '',
  countryIso2: result.country_iso2 || '',
});

const dataToResult = (round, person, attemptsData) => {
  const country = countries.byIso2[person.countryIso2];
  const res = {
    personId: person.wcaId,
    personName: person.name,
    countryId: country ? country.id : undefined,
    best: best(attemptsData.attempts),
    average: average(attemptsData.attempts, round.eventId, attemptsData.attempts.length),
    regionalAverageRecord: attemptsData.markerAvg,
    regionalSingleRecord: attemptsData.markerBest,
  };
  // Map individual attempts to valueN...
  attemptsData.attempts.forEach((a, index) => { res[`value${index + 1}`] = a; });
  // NOTE: we pass 'round' as a separate attribute because:
  //   - if we're editing a result, it's immutable (the result's id is enough
  //   to identify it!)
  //   - if we're creating a result, we want to let the backend take the
  //   requested round attribute, and figure out if the data are appropriate
  //   (ie: if it matches an existing round).
  return { result: res, round };
};

const ResultForm = ({
  result, save, saving, onCreate, onUpdate, onDelete,
}) => {
  const { id } = result;
  const solveCount = result.format_id
    ? formats.byId[result.format_id].expectedSolveCount : 0;
  const computeAverage = [3, 5].includes(solveCount) && result.event_id !== '333mbf';

  // Person-related state.
  const [personData, setPersonData] = useState(personDataFromResult(result));

  // Immutable round-related data.
  // FIXME: now that we have a 'Round' object for every round in the database
  // (I think), we may consider showing its data here, which would make it
  // slightly easier to select the appropriate round when creating a result,
  // if at some point we want to make it selectable.
  const [roundData, setRoundData] = useState(roundDataFromResult(result));

  // Attempts-related state.
  const [attemptsState, setAttemptsState] = useState(attemptsDataFromResult(solveCount, result));

  // Populate the original states whenever the original result changes.
  useEffect(() => {
    setAttemptsState(attemptsDataFromResult(solveCount, result));
    setRoundData(roundDataFromResult(result));
    setPersonData(personDataFromResult(result));
  }, [result]);

  // Use response to store errors and messages.
  const [response, setResponse] = useState({});

  const onSuccess = useCallback((data, responseJson) => {
    // First of all, set the errors/messages.
    setResponse(responseJson);
    if (responseJson.errors === undefined) {
      // Notify the parent(s) based on creation/update.
      if (id === undefined) {
        onCreate(data);
      } else {
        onUpdate(data);
      }
    }
  }, [id, setResponse, onCreate, onUpdate]);

  const onError = useCallback((err) => {
    // 'onError' is called only if the request fails, which shouldn't happen
    // whatever the user input is. If this does happen, ask them to report to us!
    setResponse({
      errors: [
        'The request to the server failed. This is definitely unexpected, you may consider contacting the WST with the error below!',
        err.toString(),
      ],
    });
  }, [setResponse]);

  const saveAction = useCallback((data) => {
    const url = id === undefined ? resultUrl('') : resultUrl(id);
    const onSuccessAction = (responseJson) => onSuccess(data.result, responseJson);
    save(
      url,
      data,
      onSuccessAction,
      onError,
    );
  }, [save, id, onSuccess, onError]);

  const deleteAction = useCallback(() => {
    fetchJsonOrError(resultUrl(result.id), {
      method: 'DELETE',
    }).then(() => onDelete(result))
      .catch(onError);
  }, [result, onDelete, setResponse]);

  const onPersonCreate = useCallback((data) => {
    setPersonData(personDataFromResult(data));
    setResponse({});
  }, [setResponse, setPersonData]);

  return (
    <div className="result-form">
      <h3>
        Round data
      </h3>
      <RoundForm roundData={roundData} />
      <h3>
        Person data
      </h3>
      <NewPersonModal
        trigger={<Button positive compact size="small">Create new person</Button>}
        onPersonCreate={onPersonCreate}
        competitionId={roundData.competitionId}
      />
      <PersonForm personData={personData} setPersonData={setPersonData} />
      <h3>
        Attempts
      </h3>
      <AttemptsForm
        eventId={result.event_id}
        state={attemptsState}
        setState={setAttemptsState}
        computeAverage={computeAverage}
      />
      <SaveMessage response={response} />
      <Button
        positive
        loading={saving}
        disabled={saving}
        onClick={() => saveAction(dataToResult(roundData, personData, attemptsState))}
      >
        Save
      </Button>
      {result.id && (
        <DeleteResultButton deleteAction={deleteAction} />
      )}
    </div>
  );
};

// This is a simple wrapper to be able to manage request-specific states,
// and to be able to hide the form upon creation.
const ResultFormWrapper = ({ result, sync }) => {
  const { id } = result;

  // Saving and user-feedback states.
  // If 'id' is undefined, then we're creating a new result and it's a POST,
  // otherwise it's a PATCH.
  const { save, saving } = useSaveData({ method: id === undefined ? 'POST' : 'PATCH' });

  // This is used to track if we did save something.
  const [created, setCreated] = useState(undefined);
  const [deleted, setDeleted] = useState(undefined);

  if (created) {
    return (
      <AfterActionMessage
        wcaId={created.personId}
        competitionId={result.competition_id}
        message="result for that person was created!"
      />
    );
  }
  if (deleted) {
    return (
      <AfterActionMessage
        wcaId={deleted.wca_id}
        competitionId={result.competition_id}
        message="result for that person was deleted!"
      />
    );
  }
  return (
    <ResultForm
      result={result}
      save={save}
      saving={saving}
      onCreate={setCreated}
      onUpdate={sync}
      onDelete={setDeleted}
    />
  );
};

export default ResultFormWrapper;
