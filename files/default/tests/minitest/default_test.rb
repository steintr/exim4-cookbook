#
# Copyright (C) 2013 Michael Weinrich
# 
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# TODO: fix the deprecated file layout

require File.expand_path('../support/helpers', __FILE__)

describe 'exim4::default' do
  include Helpers::Exim4

  it 'installs the exim4 package' do
    package('exim4-daemon-heavy').must_be_installed
  end

  it 'enables the exim4 service' do
    service('exim4').must_be_enabled
  end

  it 'starts the exim4 service' do
    service('exim4').must_be_running
  end

  it 'configures exim4.conf' do
    file('/etc/exim4/exim4.conf').must_include('# This file is managed by chef.')
    file('/etc/exim4/exim4.conf').must_include('dnslists      = zen.spamhaus.org')
    file('/etc/exim4/exim4.conf').wont_include('av_scanner =')
    file('/etc/exim4/exim4.conf').wont_include('spamd_address =')
    file('/etc/exim4/exim4.conf').wont_include('This message contains a virus')
    file('/etc/exim4/exim4.conf').wont_include('add_header = X-Spam_score: $spam_score')
    file('/etc/exim4/exim4.conf').must_include('userforward:')
    file('/etc/exim4/exim4.conf').must_include('localuser:')

  end

  it 'makes the exim4 daemon listen on the right ports' do
    result = assert_sh('netstat -tulpen | grep exim4')
    assert_includes result, ':25 '
    assert_includes result, ':465 '
    assert_includes result, ':587 '
  end

end
