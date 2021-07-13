import React, { useState, useEffect } from 'react';
import { Button, Icon, Table } from 'semantic-ui-react';
import useLoadedData from '../hooks/useLoadedData';
import { registerComponent } from '../wca/react-utils';
import Loading from '../requests/Loading';
import Errored from '../requests/Errored';
import './index.scss';
import EventNavigation from '../event_navigation';
import ResultRow from './ResultRow';
import ResultRowHeader from './ResultRowHeader';
import { getUrlParams, setUrlParams } from '../wca/utils';
import {
  newResultUrl, competitionApiUrl, competitionEventResultsApiUrl,
} from '../requests/routes.js.erb';

const RoundResultsTable = ({ round, competitionId, canAdminResults }) => (
  <>
    <h2>{round.name}</h2>
    {canAdminResults && (
      <Button positive as="a" href={newResultUrl(competitionId, round.id)} size="tiny">
        <Icon name="plus" />
        Add a result to this round
      </Button>
    )}
    <Table striped>
      <Table.Header>
        <ResultRowHeader />
      </Table.Header>
      <Table.Body>
        {round.results.map((result, index, results) => (
          <ResultRow
            key={result.id}
            result={result}
            results={results}
            index={index}
            canAdminResults={canAdminResults}
          />
        ))}
      </Table.Body>
    </Table>
  </>
);

const EventResults = ({ competitionId, eventId, canAdminResults }) => {
  const { loading, error, data } = useLoadedData(
    competitionEventResultsApiUrl(competitionId, eventId),
  );

  if (loading) return <Loading />;
  if (error) return <Errored />;
  return (
    <div className="event-results">
      {data.rounds.map((round) => (
        <RoundResultsTable
          key={round.id}
          round={round}
          competitionId={competitionId}
          canAdminResults={canAdminResults}
        />
      ))}
    </div>
  );
};

const CompetitionResults = ({ competitionId, canAdminResults }) => {
  const { loading, error, data } = useLoadedData(competitionApiUrl(competitionId));
  const [selectedEvent, setSelectedEvent] = useState(null);
  useEffect(() => {
    if (data) {
      const params = getUrlParams();
      const event = params.event || data.event_ids[0];
      setSelectedEvent(event);
    }
  }, [data]);
  useEffect(() => {
    if (selectedEvent) {
      setUrlParams({ event: selectedEvent });
    }
  }, [selectedEvent]);
  if (loading || !selectedEvent) return <Loading />;
  if (error) return <Errored />;
  return (
    <div className="competition-results">
      <EventNavigation
        eventIds={data.event_ids}
        selected={selectedEvent}
        onSelect={(eventId) => setSelectedEvent(eventId)}
      />
      {selectedEvent === 'all'
        ? (
          <>
            {data.event_ids.map((eventId) => (
              <EventResults key={eventId} competitionId={competitionId} eventId={eventId} />))}
          </>
        )
        : (
          <EventResults
            competitionId={competitionId}
            eventId={selectedEvent}
            canAdminResults={canAdminResults}
          />
        )}
      <EventNavigation
        eventIds={data.event_ids}
        selected={selectedEvent}
        onSelect={(eventId) => setSelectedEvent(eventId)}
      />
    </div>
  );
};
registerComponent(CompetitionResults, 'CompetitionResults');
