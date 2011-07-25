From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39732] JBD: Spotted dirty metadata buffer (dev = dm-2, blocknr
 = 2512725). There's a risk of filesystem corruption in case of system crash.
Date: Mon, 25 Jul 2011 03:52:00 GMT
Message-ID: <201107250352.p6P3q0e8020298@demeter2.kernel.org>
References: <bug-39732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:33755 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1GYDwB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jul 2011 23:52:01 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p6P3q02F020299
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jul 2011 03:52:00 GMT
In-Reply-To: <bug-39732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39732





--- Comment #1 from Witold Baryluk <baryluk@smp.if.uj.edu.pl>  2011-07-25 03:51:59 ---
May it be because of bugs in dcache in rc7? If so, then it should not be issue
in 3.0. I also do not seen this again in later rc7, and 3.0 or after that. It
was single event.

But it may by also some rare event I accidentally triggered. No data was lost,
as I safely rebooted system without problem.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
