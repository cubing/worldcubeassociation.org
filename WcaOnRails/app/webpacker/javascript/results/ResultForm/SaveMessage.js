import React from 'react';

import { Message } from 'semantic-ui-react';

const SaveMessage = ({ response }) => (
  <>
    {response.messages && (
      <Message
        positive
        header="Save was successful!"
        list={response.messages}
      />
    )}
    {response.errors && (
      <Message
        error
        list={response.errors}
        header="Something went wrong when saving the result."
      />
    )}
  </>
);

export default SaveMessage;
