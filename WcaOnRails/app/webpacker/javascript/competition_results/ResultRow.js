import React from 'react';
import { Icon, Table } from 'semantic-ui-react';
import cn from 'classnames';

import { personUrl, editResultUrl } from '../requests/routes.js.erb';
import CountryFlag from '../wca/CountryFlag';
import {
  formatAttemptResult,
  formatAttemptsForResult,
} from '../wca-live/attempts';
import './index.scss';

const getRecordClass = (record) => {
  switch (record) {
    case '':
      return '';
    case 'WR': // Intentional fallthrough
    case 'NR':
      return record;
    default:
      return 'CR';
  }
};

const ResultRow = ({
  result, index, results, canAdminResults,
}) => (
  <Table.Row>
    <Table.Cell className={cn({ 'text-muted': index > 0 && results[index - 1].pos === result.pos })}>
      {result.pos}
      {canAdminResults && (
        <a href={editResultUrl(result.id)} role="menuitem" className="edit-link">
          <Icon name="pencil" />
        </a>
      )}
    </Table.Cell>
    <Table.Cell>
      <a href={personUrl(result.wca_id)}>{`${result.name}`}</a>
    </Table.Cell>
    <Table.Cell className={getRecordClass(result.regional_single_record)}>
      {formatAttemptResult(result.best, result.event_id)}
    </Table.Cell>
    <Table.Cell>{result.regional_single_record}</Table.Cell>
    <Table.Cell className={getRecordClass(result.regional_average_record)}>
      {formatAttemptResult(result.average, result.event_id)}
    </Table.Cell>
    <Table.Cell>{result.regional_average_record}</Table.Cell>
    <Table.Cell><CountryFlag iso2={result.country_iso2} /></Table.Cell>
    <Table.Cell className="table-cell-solves">
      {formatAttemptsForResult(result, result.event_id)}
    </Table.Cell>
  </Table.Row>
);

export default ResultRow;
