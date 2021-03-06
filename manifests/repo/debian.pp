# This class file is not called directly
class torque::repo::debian(
    $manage_repo    = true,
    $package_source = 'hu-berlin',
  ) {

  if $caller_module_name != $module_name {
    warning("${name} is deprecated as a public API of the ${module_name} module and should no longer be directly included in the manifest.")
  }

  $codename = $::lsbdistcodename

  anchor { 'torque::apt_repo' : }

  include '::apt'

  if $manage_repo {
    case $package_source {
      'hu-berlin': {
        apt::source { 'torque':
          location => "http://debian.physik.hu-berlin.de/addons/${codename}",
          repos    => 'torque',
          notify   => Exec['apt_get_update_for_torque'],
        }
      }
      default: {}
    }

    exec { 'apt_get_update_for_torque':
      command     => '/usr/bin/apt-get update',
      timeout     => 240,
      returns     => [ 0, 100 ],
      refreshonly => true,
      before      => Anchor['torque::apt_repo'],
    }
  }
}
