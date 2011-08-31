From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Wed, 31 Aug 2011 14:36:00 GMT
Message-ID: <201108311436.p7VEa0uQ001551@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:41887 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1HaOgC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 10:36:02 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7VEa04i001552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 14:36:00 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #87 from Alan Stern <stern@rowland.harvard.edu>  2011-08-31 14:35:39 ---
I think all I had was  CONFIG_NETCONSOLE=y.

As for fixing the problem...  To be honest, you shouldn't expect it to get
fixed until somebody can identify what's causing it.  Since you seem to be one
of the very few people experiencing it regularly, the situation doesn't look
good until you can provide more information.

The best course of action is to narrow down the variables as much as possible. 
That means not running any extraneous programs (i.e., don't run a graphical
desktop, and indeed, don't run X at all).  It also means coming up with a very
repeatable scenario to trigger the problem.  Something like what you described
in comment #75 would be good.

Speaking of which, you mentioned in that comment that on each loop through the
test, the driver letter would go up by one.  That should not have happened! 
It's another indication of something strange.  Can you verify -- does this
still happen with 3.1-rc4?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
