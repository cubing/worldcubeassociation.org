import { useState, useCallback } from 'react';
import { fetchJsonOrError } from '../requests/fetchWithAuthenticityToken';

const throwError = (err) => { throw err; };

// This is a hook that can be used to save some data to the website (as json)
// It assumes that 'url' is a valid, PATCH-able, url.
// Example of usage:
// const { save, saving } = useSaveData();
// // or if you want to override some options:
// const { save, saving } = useSaveData({ method: 'DELETE' });
// // and then:
// save(modelUrl(), { /* model attrs */ }, () => console.log("success"));
const useSaveData = (options = {}) => {
  const [saving, setSaving] = useState(false);

  const save = useCallback((url, data, onSuccess, onError = throwError) => {
    setSaving(true);
    fetchJsonOrError(url, {
      headers: {
        'Content-Type': 'application/json',
      },
      method: 'PATCH',
      body: JSON.stringify(data),
      ...options,
    }).then(onSuccess).catch(onError).finally(() => setSaving(false));
  }, [setSaving, options]);

  return {
    saving,
    save,
  };
};

export default useSaveData;
