From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Mon, 7 Feb 2011 15:36:03 GMT
Message-ID: <201102071536.p17Fa3dM029952@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50305 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab1BGPgF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Feb 2011 10:36:05 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p17Fa4A8029954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 7 Feb 2011 15:36:04 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #27 from Theodore Tso <tytso@mit.edu>  2011-02-07 15:35:59 ---
There is shared umount code paths that are used by all file systems in
fs/super.c, in the VFS layer, of course.

But again, unless you or some userspace program has explicitly requested a
umount, a umount does not happen just because a disk drive has disappeared.  So
if you are locking up right after a resume, there wouldn't have been any _time_
for you or some userspace program to request an umount.   And certainly the
standard desktop userspace programs (e.g., the GNOME desktop) do not
automagically look for kernel I/O error messages caused by a disk disappearing,
and then umount the file system automagically.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
