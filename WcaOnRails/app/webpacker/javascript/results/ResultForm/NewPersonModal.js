/* eslint-disable */
import React, { useState, useCallback, useEffect } from 'react';

import { Button, Icon, Modal } from 'semantic-ui-react';

import NewPersonForm from '../../persons/NewPersonForm/NewPersonForm';
import useSaveData from '../../hooks/useSaveData';

const NewPersonModal = ({ trigger, onPersonCreate, competitionId }) => {
  const [open, setOpen] = useState(false);

  const { save, saving } = useSaveData({ method: 'POST' });

  const onCreate = useCallback((data) => {
    onPersonCreate(data);
    setOpen(false);
  }, [setOpen]);

  return (
    <Modal
      dimmer="blurring"
      closeIcon
      closeOnDimmerClick={false}
      onClose={() => setOpen(false)}
      onOpen={() => setOpen(true)}
      open={open}
      size="large"
      trigger={trigger}
    >
      <Modal.Header>Create new person</Modal.Header>
      <Modal.Content>
        <Modal.Description>
          <NewPersonForm
            save={save}
            saving={saving}
            onCreate={onCreate}
            competitionId={competitionId}
          />
        </Modal.Description>
      </Modal.Content>
      <Modal.Actions>
        <Button negative onClick={() => setOpen(false)}>
          Cancel
        </Button>
      </Modal.Actions>
    </Modal>
  );
};

export default NewPersonModal;
