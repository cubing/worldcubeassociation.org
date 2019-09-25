import React from 'react'
// Import leaflet, and the fix for the icon url
import 'leaflet-wca';
import { Map, TileLayer, Marker } from "react-leaflet"
import { userTileProvider } from 'leaflet-wca/providers.js';
import { toDegrees } from '../utils'
import { Row, Col } from 'react-bootstrap'

class InvisibleIFrame extends React.Component {

  componentDidMount() {
    this.iframe.contentWindow.addEventListener('resize', this.props.onResizeAction);
  }

  componentWillUnmount() {
    this.iframe.contentWindow.removeEventListener('resize', this.props.onResizeAction);
  }

  render() {
    return (
      <iframe src="about:blank" className="invisible-iframe-map" ref={m => { this.iframe = m }} />
    );
  }
}

export class VenueLocationInput extends React.Component {

  invalidateSize = () => {
    this.mapElem.leafletElement.invalidateSize(false);
  }

  componentDidMount() {
    let map = this.mapElem.leafletElement;
    wca.createSearchInput(map);
    let handleGeoSearchResult = (result) => {
      let marker = this.markerElem.leafletElement;
      marker.setLatLng({
        lat: result.location.y,
        lng: result.location.x,
      });
      marker.bindPopup(result.location.label).openPopup();
    }
    map.on('geosearch/showlocation', handleGeoSearchResult);
    map.zoomControl.setPosition("bottomright");
  }

  render() {
    let { lat, lng, actionHandler } = this.props;
    let provider = userTileProvider;
    let mapPosition = { lat: toDegrees(lat), lng: toDegrees(lng) };
    return (
      <Row>
        <Col xs={12}>
          <span className="venue-form-label control-label">Please pick the venue location below:</span>
        </Col>
        <Col xs={12} className="venue-map">
          <Map center={mapPosition}
               zoom={16}
               scrollWheelZoom={false}
               ref={m => { this.mapElem = m; }}
          >
            <InvisibleIFrame onResizeAction={this.invalidateSize} />
            <TileLayer url={provider.url} attribution={provider.attribution}/>
            <Marker
              position={mapPosition}
              draggable={true}
              onMove={actionHandler}
              ref={m => { this.markerElem = m; }}
            />
          </Map>
        </Col>
      </Row>
    );
  }
}
