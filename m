From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 34302] Errors from kjournald
Date: Tue, 3 May 2011 15:02:15 GMT
Message-ID: <201105031502.p43F2Fo5030112@demeter2.kernel.org>
References: <bug-34302-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39688 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab1ECPCP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 11:02:15 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p43F2FvU030113
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 15:02:15 GMT
In-Reply-To: <bug-34302-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=34302





--- Comment #1 from Theodore Tso <tytso@mit.edu>  2011-05-03 15:02:14 ---
You've given us a bunch of stack dumps, but not the explanation of why
kernel dumped them.  There should have been a few more informative
messages before the stack dumps in your syslog.  I'm going to guess it
was a soft lockup warning message, perhaps?

                         - Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
