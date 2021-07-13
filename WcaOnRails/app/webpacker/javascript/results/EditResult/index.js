import React from 'react';

import useLoadedData from '../../hooks/useLoadedData';
import { resultUrl } from '../../requests/routes.js.erb';
import { registerComponent } from '../../wca/react-utils';

import Loading from '../../requests/Loading';
import Errored from '../../requests/Errored';
import ResultForm from '../ResultForm/ResultForm';
import ShowSingleResult from './ShowSingleResult';

const EditResult = ({
  id,
}) => {
  const {
    data, sync, loading, error,
  } = useLoadedData(resultUrl(id));
  return (
    <>
      {error && (
        <Errored componentName="PostsWidget" />
      )}
      {loading && (
        <Loading />
      )}
      {data && (
        <>
          {!loading && (
            <>
              <h3>
                Result previously saved in the database
              </h3>
              <ShowSingleResult result={data} />
            </>
          )}
          <ResultForm result={data} sync={sync} />
        </>
      )}
    </>
  );
};

registerComponent(EditResult, 'EditResult');
