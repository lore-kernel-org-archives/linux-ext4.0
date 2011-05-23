From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35562] ext4 regression in 2.6.39
Date: Mon, 23 May 2011 16:15:28 GMT
Message-ID: <201105231615.p4NGFSUk024002@demeter2.kernel.org>
References: <bug-35562-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:60384 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab1EWQP3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 12:15:29 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p4NGFSpF024033
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 16:15:28 GMT
In-Reply-To: <bug-35562-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=35562





--- Comment #2 from Arthur Titeica <arthur@psw.ro>  2011-05-23 16:15:27 ---
1)   Can you reproduce this problem reliably?

Re: No, I've tried to replicate the conditions but nothing unusual happened.

2)   What were you doing at the time of that you saw these messages?

Re: I noticed that all apps got stuck. They looked normal but didn't react to
any commands. I tried to su in a terminal emulator I had open but that didn't
work either (no error but no login also).

3)  Did the system recover eventually, or did it completely hang?

Re: I managed to reboot using magic sysrq (REISUB)

Some other thing I forgot to mention: the whole system (except /boot) is LVM2
encrypted (crypto_luks).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
