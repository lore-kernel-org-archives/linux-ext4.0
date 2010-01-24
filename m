From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Sun, 24 Jan 2010 18:17:59 GMT
Message-ID: <201001241817.o0OIHxvv031424@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60202 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0AXSSA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jan 2010 13:18:00 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0OII00H031426
	for <linux-ext4@vger.kernel.org>; Sun, 24 Jan 2010 18:18:00 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #39 from carlos.velasco@nimastelecom.com  2010-01-24 18:17:58 ---
Not sure about the patch.
With patch applied, after testing and installing glibc I see plenty of tmp
files left in /tmp:

-rw-------  1 root root     0 Jan 24 18:56 tst-atime.HiK5Qd

-rw-------  1 root root     0 Jan 24 19:07 cc2mcjSe.o
-rw-------  1 root root     0 Jan 24 19:07 cc3s3qwc.c
-rw-------  1 root root  9766 Jan 24 19:07 ccNVp9dh.ld
-rw-------  1 root root     0 Jan 24 19:07 cckbLeAj.le

I don't remember to see them without patch applied.

Also, when rebooting I see this error:

Unmounting all other currently mounted file systems...
umount: /: device is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))

Very odd...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
