import React, { useState } from 'react';

import { Button, Checkbox } from 'semantic-ui-react';

const DeleteResultButton = ({ deleteAction }) => {
  const [confirmed, setConfirmed] = useState(false);
  return (
    <div>
      <Button
        negative
        className="delete-result-button"
        disabled={!confirmed}
        onClick={deleteAction}
      >
        Delete the result
      </Button>
      <Checkbox
        label="Yes, I want to delete that result"
        checked={confirmed}
        onChange={() => setConfirmed((prev) => !prev)}
      />
    </div>
  );
};

export default DeleteResultButton;
