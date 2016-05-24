From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Tue, 24 May 2016 14:37:23 +0000
Message-ID: <bug-118401-13602-g6eHUpi4JY@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43178 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867AbcEXOh3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2016 10:37:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EAE5520351
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2016 14:37:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D5D24203AC
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2016 14:37:23 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #7 from Theodore Tso <tytso@mit.edu> ---
The ext4 file system will happily mount file systems that are intended for ext2
and ext3.   That is, ext4 supports a superset of the features supported by the
ext2 and ext3 file system implementations.    

The CONFIG_EXT4_USE_FOR_EXT23 (before ext3 dropped was dropped) and
CONFIG_EXT4_USE_FOR_EXT2 (after the ext3 driver was dropped) merely determines
whether or not ext4 claims to be the ext2 or ext3 drivers.   This matters only
if the file system type is explicitly used in the mount command (e.g., "mount
-t ext3 ...") or if you are mounting a non-root file system in /etc/fstab.  
Now, the distribution is doing something wierd with initramfs, so it's possible
this is the cause of the issue, but when the kernel is mounting the root file
system it will try using all of the file systems available to it to try to
mount it.

Furthermore the error message of not being able to find the file system with
the specific UUID isn't the error message in the boot logs that would indicate
that the problem was that the initramfs was trying to mount with ext3 and
failed to find it.
Still, if you want to try compiling with CONFIG_EXT4_USE_FOR_EXT2, that
certainly wouldn't hurt and would probably help once you get the system
working.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
