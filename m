From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Tue, 20 Apr 2010 03:46:33 GMT
Message-ID: <201004200346.o3K3kXDn020782@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54855 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0DTDqe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 23:46:34 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3K3kX6w020783
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 20 Apr 2010 03:46:33 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #35 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-04-20 03:46:28 ---
Dave (above) said:

"Sync is acting as designed right now. I agree it's not ideal, but it's now
defaulting to slow-but-safe behaviour rather than the previous behaviour of
potentially not syncing everything that was dirty at the time of the sync call.

Dave,"

Are you aware that this blocks other IO so that a user who requests
a read of some data may have to wait for something like 20 minutes
before getting a response?  This includes, for instance, just typing
vi xxx.  Take a look at the reports above which show nfsd being effectively
blocked for periods of more than 20 minutes.

For me this is not just "not ideal" but simply useless.  I do not
see how a system with this behavior can be used.

I also do not see why sync completing with dirty data is a problem.
In an active system there will be new dirty data within milliseconds
of sync completion no matter what it does.

I am well-aware that this is not a simple problem.  But, a solution
that is consistent with the usability of the system is necessary.

Michael

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
