From: Christian Kujau <lists@nerdbynature.de>
Subject: Free blocks count wrong following shrink with resize2fs
Date: Sun, 28 Dec 2008 11:00:11 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0812281047450.24239@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61714 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbYL1KAP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Dec 2008 05:00:15 -0500
Received: from localhost ([127.0.0.1] helo=localhost.localdomain)
	by bogon.housecafe.de with esmtp (Exim 4.63)
	(envelope-from <lists@nerdbynature.de>)
	id 1LGsRP-0000jd-SM
	for linux-ext4@vger.kernel.org; Sun, 28 Dec 2008 11:00:11 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since I'm not *entirely* sure if this is related to the the extent header 
issue[0], I thought I just report it:

When shrinking a filesystem with resize2fs, fsck.ext4 (1.41.3, 
12-Oct-2008) reports:

------------
Pass 5: Checking group summary information
Block bitmap differences:  -(2488--2493) -(149959--151395)
Fix<y>? yes
Free blocks count wrong for group #0 (3188, counted=3194).
Fix<y>? yes
Free blocks count wrong for group #4 (10182, counted=11619).
Fix<y>? yes
Free blocks count wrong (26225, counted=27668).
Fix<y>? yes
-----------

After this, the filesystem is perfectly fine though, no corruptions have 
been noticed yet. I'm even able to mount it without running fsck after the 
resize2fs. I've put a few more details here:

   http://nerdbynature.de/bits/2.6.28/

Thanks,
Christian.
[0] http://thread.gmane.org/gmane.comp.file-systems.ext4/10736


PS: As my rootfs is also on ext4, I noticed another, completely unrelated oddity:

[    1.604198] Using IPI Shortcut mode
[    1.608394] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.737198] EXT3-fs: hda1: couldn't mount because of unsupported optional features (240).
[    1.754302] EXT4-fs: barriers enabled
[    1.773267] kjournald2 starting.  Commit interval 5 seconds

...this is befor INIT starts, so who's trying to mount "/" as ext3 first?

-- 
BOFH excuse #55:

Plumber mistook routing panel for decorative wall fixture
