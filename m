From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13604] cascade of "mpage_da_map_blocks block allocation failed"
 errors
Date: Thu, 17 Sep 2009 14:44:45 GMT
Message-ID: <200909171444.n8HEijdB012292@demeter.kernel.org>
References: <bug-13604-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35523 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZIQOom (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Sep 2009 10:44:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8HEijSb012293
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 14:44:45 GMT
In-Reply-To: <bug-13604-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13604


procaccia <jehan.procaccia@it-sudparis.eu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jehan.procaccia@it-sudparis
                   |                            |.eu




--- Comment #2 from procaccia <jehan.procaccia@it-sudparis.eu>  2009-09-17 14:44:42 ---
Any news on this bug ?

I get lots of the same error messages with ext4 and quotas on those ext4 FS:

Message from syslogd@ at Thu Sep 17 16:39:51 2009 ...
gizeh kernel: mpage_da_map_blocks block allocation failed for inode 15407 at
logical offset 0 with max blocks 2 with error -122
Message from syslogd@ at Thu Sep 17 16:39:51 2009 ...
gizeh kernel: This should not happen.!! Data will be lost

$ uname -a
Linux gizeh.int-evry.fr 2.6.18-164.el5 #1 SMP Tue Aug 18 15:51:48 EDT 2009
x86_64 x86_64 x86_64 GNU/Linux
$ rpm -q quota
quota-3.16-7

Will data really be lost ? or is this alert is for people over-quota only ?
I have opened a bug on redhat:
https://bugzilla.redhat.com/show_bug.cgi?id=522615
I've been told to wait until kernel quota for ext4 will be supported, but what
is the probleme ? is there a plan to solve this issue ? perhaps it's already
solve on a newer kernel than mine (2.6.18-164.el5 ) ?
Any news & advice greatly appreciated.
regards .

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
