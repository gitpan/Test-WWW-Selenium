#!/usr/bin/perl -w
use strict;
use Test::More tests => 15;
use lib 'lib';

use_ok 'WWW::Selenium::Launcher::Base';
#use_ok 'WWW::Selenium::Launcher::NoLaunch';
use_ok 'WWW::Selenium::Launcher::Pick';
use_ok 'WWW::Selenium::Launcher::WindowsDefault';
use_ok 'WWW::Selenium::Launcher::UnixDefault';
use_ok 'WWW::Selenium::Launcher::MacDefault';
use_ok 'WWW::Selenium::Launcher::Default';
use_ok 'WWW::Selenium::Launcher::Safari';
use_ok 'WWW::Selenium';
use_ok 'WWW::Selenium::Command';
use_ok 'WWW::Selenium::CommandBridge';
use_ok 'WWW::Selenium::CommandBridge::Backend';
use_ok 'WWW::Selenium::CommandBridge::Backend::File';
use_ok 'WWW::Selenium::CommandBridge::Backend::InMemory';
use_ok 'WWW::Selenium::Driver';
use_ok 'Test::WWW::Selenium';
