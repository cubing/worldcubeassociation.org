import React from 'react';
import { Form, Grid } from 'semantic-ui-react';

import formats from '../../wca/formats.js.erb';
import events from '../../wca/events.js.erb';
import roundTypes from '../../wca/roundTypes.js.erb';

const RoundForm = ({ roundData }) => {
  const {
    competitionId, roundTypeId, eventId, formatId,
  } = roundData;
  return (
    <Form>
      <Grid stackable padded columns={4}>
        <Grid.Column>
          <Form.Input
            label="Competition ID"
            readOnly
            value={competitionId}
          />
        </Grid.Column>
        <Grid.Column>
          <Form.Input
            label="Event"
            readOnly
            value={events.byId[eventId].name}
          />
        </Grid.Column>
        <Grid.Column>
          <Form.Input
            label="Round type"
            readOnly
            value={roundTypes.byId[roundTypeId].name}
          />
        </Grid.Column>
        <Grid.Column>
          <Form.Input
            label="Format"
            readOnly
            value={formats.byId[formatId].name}
          />
        </Grid.Column>
      </Grid>
    </Form>
  );
};

export default RoundForm;
