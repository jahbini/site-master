
const config = require('config');

function augment(original,addition) {
  _(addition).reduce(original,function(key,value,original){
    original[key]=value;
    return original;
  });
}

const sans = {
  fontFamily: 'Roboto, sans-serif'
}

const caps = {
  textTransform: 'uppercase',
  letterSpacing: '.1em'
}

const colors = {
    red: '#e54',
    blue: '#059',
    green: '#0b7',
    midgray: '#444',
    gray: '#eee'
}

const biblio = {
  name: 'Biblio',
  fontFamily: 'Palatino, Georgia, serif',
  color: '#111',
  backgroundColor: '#fff',

  colors: augment(augment({
    primary: colors.red,
    error: colors.red,
    info: colors.blue,
    success: colors.green,
    secondary: colors.midgray
  }, config.colors),colors),

  borderColor: `rgba(0, 0, 0, ${1/8})`,

  scale: [
    0, 12, 24, 48, 96
  ],

  fontSizes: [
    72, 64, 48, 32, 18, 16, 14
  ],

  bold: 500,

  Heading_alt: augment(augment({
    opacity: 1,
    fontSize: 14,
    color: colors.red
  },sans),caps),

  Banner: {
    backgroundColor: '#f6fee6',
    // backgroundImage: 'none',
    boxShadow: 'inset 0 0 320px 0 rgba(128, 64, 0, .5), inset 0 0 0 99999px rgba(128, 128, 96, .25)'
  },

  Toolbar: {
    color: 'inherit',
    backgroundColor: '#fff',
    borderBottom: `1px solid rgba(0, 0, 0, ${1/8})`
  },

  Button: augment(augment({
    fontSize: 12
  },sans),caps),
  ButtonOutline: augment(augment({
    fontSize: 12
  },sans),caps),
  NavItem: augment(augment({
    fontSize: 12
  },sans),caps),
  PanelHeader: augment({
  },sans),
  Label: augment(augment({
    fontSize: 12,
    opacity: 5/8
  },sans),caps),
  SequenceMap: augment(augment({
    fontSize: 12
  },sans),caps),
  Donut: augment({
  },sans),
  Stat: augment({
  },sans),
  Breadcrumbs: augment({
    color: '#e54',
  },sans),

  PageHeader: {
    borderColor: '#e54',
  },
  SectionHeader: {
    borderColor: '#e54',
  },

}

module.exports = biblio

