From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 16 Oct 2009 20:05:37 GMT
Message-ID: <200910162005.n9GK5bkm021793@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44283 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZJPUFc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 16:05:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9GK5bYA021794
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 20:05:37 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #66 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-16 20:05:36 ---
Do not trust dmesg or fsck.log, use md5sum!
Ok, now testresults based on md5sums:
2.6.32-rc4
16 corrupt ( parts of files )
120 not found (!!??)

2.6.31
7 corrupt

2.6.32-rc4 + auto_da_alloc=0
nothing lost :)

for all test was used same script.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
