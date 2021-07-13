import React from 'react';
import { Form } from 'semantic-ui-react';

import countries from '../../wca/countries.js.erb';
import CountryFlag from '../../wca/CountryFlag';
import './CountrySelector.scss';

const countryOptions = countries.real.map((country) => ({
  key: country.iso2,
  text: country.name,
  value: country.iso2,
  image: <CountryFlag iso2={country.iso2} />,
}));

const CountrySelector = ({ countryIso2, onChange, error }) => (
  <Form.Select
    className="country-selector"
    label="Country"
    value={countryIso2}
    error={error}
    options={countryOptions}
    onChange={onChange}
  />
);

export default CountrySelector;
