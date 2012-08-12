var div = document.createElement('div');
var support = {};

function getVendorPropertyName(prop) {
  var prefixes = ['Moz', 'Webkit', 'O', 'ms'];
  var prop_ = prop.charAt(0).toUpperCase() + prop.substr(1);

  if (prop in div.style) { return prop; }

  for (var i=0; i<prefixes.length; ++i) {
    var vendorProp = prefixes[i] + prop_;
    if (vendorProp in div.style) { return vendorProp; }
  }
}

function checkTransform3dSupport() {
  div.style[support.transform] = '';
  div.style[support.transform] = 'rotateY(90deg)';
  return div.style[support.transform] !== '';
}

var isChrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;

var eventNames = {
  'MozTransition':    'transitionend',
  'OTransition':      'oTransitionEnd',
  'WebkitTransition': 'webkitTransitionEnd',
  'msTransition':     'MSTransitionEnd'
};

support.transition      = getVendorPropertyName('transition');
support.transitionDelay = getVendorPropertyName('transitionDelay');
support.transform       = getVendorPropertyName('transform');
support.transformOrigin = getVendorPropertyName('transformOrigin');
support.transform3d     = checkTransform3dSupport();
support.transitionEnd = eventNames[support.transition] || null;

$.extend($.support, support);



div = null;
