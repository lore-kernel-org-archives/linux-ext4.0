From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Thu, 29 Apr 2010 09:31:06 GMT
Message-ID: <201004290931.o3T9V6iq023616@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40848 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039Ab0D3Rbn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Apr 2010 13:31:43 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3T9V7oS023619
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 29 Apr 2010 09:31:07 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830


Ritesh Raj Sarraf <rrs@researchut.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rrs@researchut.com




--- Comment #36 from Dave Chinner <david@fromorbit.com>  2010-04-20 05:24:39 ---
(In reply to comment #35)

> Are you aware that this blocks other IO so that a user who requests
> a read of some data may have to wait for something like 20 minutes
> before getting a response? This includes, for instance, just typing
> vi xxx.

That's not a just a read - vi(m) writes a backup file when you open
it. So it's blocking on writes.

However, that sort of antisocial behaviour under heavy write loads is usually
caused by a filesystem concurrency limitation or a IO scheduler problem, not
sync. However, unless you can reproduce the read hangs on XFS when sync is
running, then I'm not the expert you're looking for to debug them. ;)

But I do know the endless sync problem is filesystem independent and I'm trying
to do something about mitigating it's effects:

http://lkml.org/lkml/2010/4/19/410

> Take a look at the reports above which show nfsd being effectively
> blocked for periods of more than 20 minutes.

Can't say I've heard of any such recent problems on XFS....

Cheers,

Dave.

--- Comment #37 from Neil Broomfield <neil.broomfield@caasaudio.com>  2010-04-20 09:00:28 ---
"Can't say I've heard of any such recent problems on XFS...."

Are these not effectivly the same issue?:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/276476

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/494476

Neil

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
