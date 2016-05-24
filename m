From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Tue, 24 May 2016 13:07:59 +0000
Message-ID: <bug-118401-13602-xe3X6XPlS9@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37819 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbcEXNIE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2016 09:08:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D817420425
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2016 13:08:00 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 95A552041C
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2016 13:07:59 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

Navin <navinp1912@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |navinp1912@gmail.com

--- Comment #6 from Navin <navinp1912@gmail.com> ---

https://ext4.wiki.kernel.org/index.php/UpgradeToExt4
says in section 
"Converting an ext3 filesystem to ext4"

Note: The ext3 driver will be removed from the kernel in 4.3.


Your root filesystem is ext3 .

Maybe your second image drop is says root image is not found due to the above.

Your options are like

1) Convert your data to ext4 

2) Enable the ext3 filesystem driver explicitly in your menuconfig /xconfig
After saving your .config diff with the older non-working configuration should
look like  ie added EXT3_FS and build a kernel
-# CONFIG_EXT3_FS is not set
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS_POSIX_ACL=y
+CONFIG_EXT3_FS_SECURITY=y

3) Convert your data to ext2 and then try with the current non-working kernels.







The first file in diff is working (4.2) and the second file is non working .

# CONFIG_EXT2_FS is not set
 # CONFIG_EXT3_FS is not set
 CONFIG_EXT4_FS=y
-CONFIG_EXT4_USE_FOR_EXT23=y
+CONFIG_EXT4_USE_FOR_EXT2=y
 CONFIG_EXT4_FS_POSIX_ACL=y
 CONFIG_EXT4_FS_SECURITY=y
 CONFIG_EXT4_ENCRYPTION=m
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set

Looks like you have removed in EXT23 in your config and used it as EXT2 .

This is for first file as (4.2.) and 4.6 as the second file (.config).

 # CONFIG_EXT2_FS is not set
 # CONFIG_EXT3_FS is not set
 CONFIG_EXT4_FS=y
-CONFIG_EXT4_USE_FOR_EXT23=y
+CONFIG_EXT4_USE_FOR_EXT2=y
 CONFIG_EXT4_FS_POSIX_ACL=y
 CONFIG_EXT4_FS_SECURITY=y
 CONFIG_EXT4_ENCRYPTION=m

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
