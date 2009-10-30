From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 30 Oct 2009 08:22:14 GMT
Message-ID: <200910300822.n9U8ME3o010732@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48491 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbZJ3IWK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 04:22:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9U8MFHq010733
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 08:22:15 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #152 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-30 08:22:10 ---
Ted,
Thank you for explanation :)
Notice: i learning computer forensic, and was trained to mount all evidence
systems with "-o ro" to not contaminate it. It seems like ext4 break this
tradition, so many forensics will surprised  why md5sum do not match.

Sandeen,
One more thing: i noticed on my system, after fresh system install (partition
was reformatted too), is harder to reproduce first corruption as on partition
were i had corruption and fixed it with fsck. So there is possibly more false
results. Do fs really good fixed after fsck?

s/Avery/Alexey/g

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
