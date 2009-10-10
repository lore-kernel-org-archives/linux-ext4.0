From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 10 Oct 2009 16:48:58 GMT
Message-ID: <200910101648.n9AGmwjO024950@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50847 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZJJQtf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Oct 2009 12:49:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9AGmwjj024951
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2009 16:48:58 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #6 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-10 16:48:58 ---
Ok, i think i know now how it's happed. I nneded some time to play to reproduce
it. There is _no_difference_ if you just boot 2.6.32 kernel run fsck and then
boot 2.6.31 kernel and run fsck again - nothing will happen.

here is the way i reproduced it:
1. crash (reset or poweroff) 2.6.32-rc3 kernel,
2. start again in 2.6.32-rc3
3. run fsck it well looks clean.. but some progrums will lost it setting.

4. reboot and start with 2.6.31 kernel
5. run fsck and this will find that ext4 is brocken.
6. after fsck fix it.. many fils will be lost.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
