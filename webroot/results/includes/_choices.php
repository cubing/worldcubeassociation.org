<?php

#----------------------------------------------------------------------
function displayChoices ( $choices ) {
#----------------------------------------------------------------------

  displayChoicesWithMethod( 'get', $choices );
}

#----------------------------------------------------------------------
function displayChoicesWithMethod ( $method, $choices ) {
#----------------------------------------------------------------------

  if( wcaDebug() )
    $choices[] = "<input type='hidden' name='debug5926' value='1' />";

  echo "<form method='$method' class='form-inline'>\n";
  foreach( $choices as $choice ) {
    if (is_array($choice)) {
      $choice = implode("\n", $choice);
    }
    echo "<div class='form-group'>$choice</div>\n\n";
  }
  echo "</form>\n\n";
}

#----------------------------------------------------------------------
function choiceButton ( $chosen, $id, $text, $blankHead = true ) {
#----------------------------------------------------------------------

  $class = $chosen ? 'chosenButton' : 'butt';
  $br = $blankHead ? "<br class='hidden-xs'>" : '';
  return "<label>$br<input class='$class' type='submit' name='$id' value='$text' /></label>";
}

#----------------------------------------------------------------------
function choice ( $id, $caption, $options, $chosenOption ) {
#----------------------------------------------------------------------
  $result = "<label for='$id'>";
  $result .= $caption ? "$caption:<br />" : '';
  $result .= "<select class='drop' id='$id' name='$id'>\n";
  $chosen = urlEncode( $chosenOption );
  foreach( $options as $option ){
    $nick = urlEncode( $option[0] );
    $text = htmlEntities( $option[1], ENT_QUOTES, "UTF-8" );
    $selected = ($chosen  &&  $nick == $chosen) ? " selected='selected'" : "";
    $result .= "<option value='$nick'$selected>$text</option>\n";
  }
  $result .= "</select>";
  $result .= "</label>";
  return $result;
}

#----------------------------------------------------------------------
function eventChoice ( $required ) {
#----------------------------------------------------------------------
  global $chosenEventId;

  if( ! $required ){
    $options[] = array( '', 'All' );
    $options[] = array( '', '' );
  }

  foreach( getAllEvents() as $event ) {
    $options[] = array( $event['id'], $event['cellName'] );
  }
  return choice( 'eventId', 'Event', $options, $chosenEventId );
}

#----------------------------------------------------------------------
function competitionChoice () {
#----------------------------------------------------------------------
  global $wcadb_conn, $chosenCompetitionId;

  $options[] = array( '', 'All' );
  $options[] = array( '', '' );

  $competitions_query = "SELECT id, name, countryId
                         FROM Competitions
                         ORDER BY (STR_TO_DATE(CONCAT(year,',',month,',',day),'%Y,%m,%d') BETWEEN DATE_SUB(NOW(), INTERVAL 7 DAY) AND DATE_ADD(NOW(), INTERVAL 7 DAY)) DESC,
                            year DESC, month DESC, day DESC
                         ";
  $competitions = $wcadb_conn->dbQuery($competitions_query);

  foreach( $competitions as $competition )
    $options[] = array(
          $competition->id,
          ($competition->name) . " | "
            . ($competition->id) . " | "
            . ($competition->countryId)
        );
  return choice( 'competitionId', 'Competition', $options, $chosenCompetitionId );
}

#----------------------------------------------------------------------
function yearsChoice ($all, $current, $until, $only ) {
#----------------------------------------------------------------------
  global $chosenYears;

  if( $all ){
    $options[] = array( '', 'All' );
    if( $current )
      $options[] = array( 'current', 'Current' );
    $options[] = array( '', '' );
  }

  if( $until ){
    foreach( getAllUsedYears() as $row )
      $options[] = array( "until $row[year]", "until $row[year]" );
    $options[] = array( '', '' );
  }

  if( $only ){
    foreach( getAllUsedYears() as $row )
      $options[] = array( "only $row[year]", "only $row[year]" );
  }

  return choice( 'years', 'Years', $options, $chosenYears );
}

#----------------------------------------------------------------------
function regionChoice ( $competitions ) {
#----------------------------------------------------------------------
  global $chosenRegionId;

  $options[] = array( '', 'World' );

  $options[] = array( '', '' );
  foreach( getAllUsedContinents() as $row )
    $options[] = array( $row['id'], $row['name'] );

  $options[] = array( '', '' );
  if( $competitions )
    foreach( getAllUsedCountriesCompetitions() as $row )
      $options[] = array( $row['id'], $row['name'] );

  else
    foreach( getAllUsedCountries() as $row )
      $options[] = array( $row['id'], $row['name'] );

  return choice( 'regionId', 'Region', $options, $chosenRegionId );
}

#----------------------------------------------------------------------
function textFieldChoice ( $id, $caption, $content ) {
#----------------------------------------------------------------------

  return "<label for='$id'>$caption:<br /><input name='$id' type='text' value='$content' /></label>";
}


#----------------------------------------------------------------------
function numberSelect ( $id, $label, $from, $to, $default ) {
#----------------------------------------------------------------------

  $result = "<select id='$id' name='$id' style='width:6em'>\n";
  foreach( range( $from, $to ) as $i ){
    if( $i == $default )
      $result .= "<option value='$i' selected='selected'>$i</option>\n";
    else
      $result .= "<option value='$i'>$i</option>\n";
  }
  $result .= "</select>\n\n";
  return "<label for='$id'>$label:</label> $result";

}
