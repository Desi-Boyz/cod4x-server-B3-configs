#
# BigBrotherBot(B3) (www.bigbrotherbot.com)
# Copyright (C) 2006 Walker
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
# CHANGELOG
# 	01/03/2006 - 1.0.0 - Walker
#       Copied Thorn's censor plugin and created the chat plugin from it.
#	14/11/2009 - 1.1.0 - Courgette
#		Add keywords $time and $nextmap
#	14/11/2009 - 1.1.1 - Courgette
#		Add missing module time


__author__  = 'Walker'
__version__ = '1.1.1'

import b3, re, traceback, sys, threading, random, time
import b3.events
import b3.plugin
import b3.functions

#--------------------------------------------------------------------------------------------------
class ChatPlugin(b3.plugin.Plugin):
	_adminPlugin = None
	_reClean = re.compile(r'[^0-9a-z ]+', re.I)
	_maxLevel = 0

	def onStartup(self):
		self._adminPlugin = self.console.getPlugin('admin')
		if not self._adminPlugin:
			return False

		self.registerEvent(b3.events.EVT_CLIENT_SAY)
		self.registerEvent(b3.events.EVT_CLIENT_TEAM_SAY)

	def onLoadConfig(self):
		self.console.verbose('ChatPlugin: Fetching chat messages')
		self._messages = []
		for e in self.config.get('messages/message'):
			trigger = e.find('trigger').text
			i = 0
			_reactions = []
			for reaction in e.findall('reaction'):
				_reactions.append ( reaction.text )

			try:
				self._messages.append ([re.compile(trigger, re.I), _reactions])
			except Exception, msg:
				self.error('ChatPlugin error: %s - %s', msg, traceback.extract_tb(sys.exc_info()[2]))
		self.console.verbose('ChatPlugin: Chat messages loaded into memory')
			

	def onEvent(self, event):
		try:
			if not event.client:
				return
			sentance = ' ' + self.clean(event.data) + ' '
			for m in self._messages:
				if m[0].search(sentance):
					message = m[1][random.randint(0, len(m[1]) - 1)]
					variables = { 
								 'player' : event.client.name,
								 'time' : self.console.formatTime(time.time())
								 }
					if '$nextmap' in message:
						# only include nextmap if required as getNextMap 
						# can cost a rcon query to the server
						variables['nextmap'] = self.console.getNextMap()
					message = b3.functions.vars2printf( message )
					self.console.say(message % variables)

		except Exception, msg:
			self.error('Chat plugin error: %s - %s', msg, traceback.extract_tb(sys.exc_info()[2]))

	def clean(self, data):
		return re.sub(self._reClean, ' ', self.console.stripColors(data.lower()))

    
if __name__ == '__main__':
    from b3.fake import fakeConsole
    from b3.fake import joe
    import time
    
    #p = ChatPlugin(fakeConsole, 'C:/Users/Thomas/workspace/b3/testconf/extplugins/plugin_chat.xml')
    p = ChatPlugin(fakeConsole, '@conf/extplugins/plugin_chat.xml')
    p.onStartup()
    
    joe.says("nextmap")
    time.sleep(1)
    joe.says('time')
    time.sleep(1)
    joe.says('cheater')
    time.sleep(1)
    joe.says('fuk*** cheater')
    time.sleep(1)
