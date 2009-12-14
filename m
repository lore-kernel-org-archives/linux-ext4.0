From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Mon, 14 Dec 2009 12:40:26 GMT
Message-ID: <200912141240.nBECeQxc018079@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60446 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbZLNMk1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Dec 2009 07:40:27 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nBECeQWP018080
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2009 12:40:26 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #14 from Mikael Pettersson <mikpe@it.uu.se>  2009-12-14 12:40:25 ---
With Jan Kara'a debugging patch on top of 2.6.32 final I get the following
after shutdown -r:

Unmounting file systems:  sb orphan head is 22
sb_info orphan list:
  inode sda2:22 at cc7c1618: mode 100600, nlink 0, next 13, i_count=2501
dentry=
NULL
  iget IPs:
 c009e590,
 c009dd08,
  inode sda2:13 at d1d932b8: mode 100600, nlink 0, next 12, i_count=2 dentry=
NULL
  iget IPs:
 c009e590,
 c009dd08,
  inode sda2:12 at d1de0618: mode 100600, nlink 0, next 0, i_count=1 dentry=
NULL
  iget IPs:
 c009e590,
 c009dd08,
kernel BUG at fs/ext3/super.c:450!

c009e590 is fs/fs-writeback.c:writeback_inodes_wb(), line 681.

c009dd08 is fs/fs-writeback.c:wait_sb_inodes(), line 1170.

I get this with both gcc-4.3.4 and gcc-4.4.2 compiled kernels.

On a second machine I got a similar result, except the three inodes had only
one iget IP recorded, and it was the one in writeback_inodes_wb().

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
