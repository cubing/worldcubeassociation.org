import React from 'react';
import { Table } from 'semantic-ui-react';
import ResultRow from '../../competition_results/ResultRow';
import ResultRowHeader from '../../competition_results/ResultRowHeader';

const ShowSingleResult = ({ result }) => (
  <div className="competition-results">
    <Table striped className="event-results">
      <Table.Header>
        <ResultRowHeader />
      </Table.Header>
      <Table.Body>
        <ResultRow result={result} results={[result]} index={0} />
      </Table.Body>
    </Table>
  </div>
);

export default ShowSingleResult;
