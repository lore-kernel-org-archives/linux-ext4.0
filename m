From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 16 Oct 2009 15:27:55 GMT
Message-ID: <200910161527.n9GFRtMo004250@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41989 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZJPP2c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 11:28:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9GFRtex004251
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 15:27:55 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #63 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-16 15:27:54 ---
First result with v2.6.31:
I made some scripts to make me kill my pc easier. Now i log fsck, dmesg and
md5sum every time after i kill it.
2.6.31 acting worse in this situation than 2.6.32 do. On mount readonly, kernel
trying to recovery fs (... 6 orphan inodes deleted ... recovery complete) fsck
-y -f return no warnings (only  "FILE SYSTEM WAS MODIFIED"). After reboot there
is many _corrupt_ modules, files are existing but do not match (md5sum) with
original files... diff <(xxd file_corrupt) <(xxd file_orig) show about 30% of
difference. I expected fsck will remove korrupted files warn me about this.

I do not using sync in my script. This will be really nice if kernel did sync
before pc die.

I will test now v2.6.32-rc4 again with md5sum and see the difference. After
this i will try auto_da_alloc=0

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
