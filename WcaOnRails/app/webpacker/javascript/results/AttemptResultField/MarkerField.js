import React from 'react';
import { Dropdown } from 'semantic-ui-react';

import allMarkers from '../../wca/regionalMarkers.js.erb';

const MarkersOptions = allMarkers.map((val) => ({
  key: val,
  value: val,
  text: val,
}));

const MarkerField = ({ onChange, marker }) => (
  <Dropdown
    button
    basic
    onChange={onChange}
    value={marker}
    options={MarkersOptions}
  />
);

export default MarkerField;
