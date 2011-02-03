From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Thu, 3 Feb 2011 18:22:26 GMT
Message-ID: <201102031822.p13IMQsi031573@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:47091 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab1BCSW1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Feb 2011 13:22:27 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p13IMQ13031574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 3 Feb 2011 18:22:26 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #6 from Theodore Tso <tytso@mit.edu>  2011-02-03 18:22:24 ---
I've looked at the kernel log, and the kernel messages displayed, and
unfortunately there's no stack trace that would help narrow down what might be
going on.

Did you have CONFIG_DETECT_SOFTLOCKUP enabled?   If not, I would suggest
enabling it, and see if you can get a stack trace.   Another useful thing to do
is to try getting some information via sysrq-l and sysrq-d.  Using sysrq-p
multiple times to see where the PC is on the various machines can be useful to
detect livelocks.  Sysrq-t can also be useful, but it's a huge amount of
information.

In general, for most of the sysrq dumps, you'll really going to need to use a
serial console attached to a second computer to record all of this output.   So
if someone would like to help reproduce this problem.  Even if the problem is
gone in 2.6.38, it would be useful to see what is going the problem in 2.6.37
so that perhaps the patches could be backported into the stable release if the
changes aren't too invasive.  So if someone can help us gather this
information, it would be really helpful.

-- Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
