import React from 'react';
import { Message, List } from 'semantic-ui-react';

import {
  adminCheckExistingResultsUrl,
  adminCADUrl,
  personUrl,
} from '../../requests/routes.js.erb';

const AfterActionMessage = ({ wcaId, competitionId, message }) => (
  <Message positive>
    <Message.Header>
      <a href={personUrl(wcaId)} target="_blank" rel="noreferrer">{wcaId}</a>
      :
      {' '}
      {message}
    </Message.Header>
    <div>
      Please make sure to:
      <List ordered>
        <List.Item>
          <a
            href={`/results/admin/check_regional_record_markers.php?competitionId=${competitionId}&show=Show`}
            target="_blank"
            rel="noreferrer"
          >
            Check Records
          </a>
        </List.Item>
        <List.Item>
          <a
            href={adminCheckExistingResultsUrl(competitionId)}
            target="_blank"
            rel="noreferrer"
          >
            Check Competition Validators
          </a>
        </List.Item>
        <List.Item>
          <a
            href={adminCADUrl}
            target="_blank"
            rel="noreferrer"
          >
            Run Compute Auxiliary Data
          </a>
        </List.Item>
      </List>
    </div>
  </Message>
);

export default AfterActionMessage;
