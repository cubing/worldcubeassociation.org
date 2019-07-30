<?php
/* @file
 *
 * Just something to print out stylesheet links a bit more cleanly.
 * Should add 'media' functionality.
 */
namespace WCAClasses;

class WCAStyles
{
    const VERSION = '201409231900';
    private $styles;

    public function __construct()
    {
        $this->styles = array();
    }

    public function add($file)
    {
        // append default styles path to paths that don't start with http(s)://
        if(preg_match('/(https?\:\/\/)(.*)/i', $file)) {
            $this->styles[] = $file;
        } else {
            $this->styles[] = pathToRoot() . 'style/' . $file;
        }
    }

    public function getHTMLAll()
    {
        $out = '';
        foreach($this->styles as $style) {
            $out .= $this->_getHTML($style);
        }
        return $out;
    }

    public function _getHTML($style)
    {
        if (strpos($style, '?') !== false) {
            $style .= '&v=' . self::VERSION;
        } else {
            $style .= '?v=' . self::VERSION;
        }
        return '<link rel="stylesheet" href="'.$style.'" type="text/css" />';
    }

}
