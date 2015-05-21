From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Thu, 21 May 2015 19:01:44 +0000
Message-ID: <bug-89621-13602-ceo13wPcy5@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58674 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbbEUTBs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 May 2015 15:01:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E7D3420532
	for <linux-ext4@vger.kernel.org>; Thu, 21 May 2015 19:01:46 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E261F2052C
	for <linux-ext4@vger.kernel.org>; Thu, 21 May 2015 19:01:44 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

Michal Cihar <michal@cihar.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |michal@cihar.com

--- Comment #8 from Michal Cihar <michal@cihar.com> ---
I've seen this several times as well. All cases were after upgrade to Debian
Jessie with 3.16.0 kernel running in KVM. The host kernel is unchanged, so I'm
pretty sure the guest kernel is guilty here. The host does LVM + RAID, the
guest just gets virtio based disk so nothing complex on it's side.

The error in my case:

[149757.256024] EXT4-fs (vda1): pa ffff88001c92bd90: logic 0, phys. 1944064,
len 64
[149757.323573] EXT4-fs error (device vda1): ext4_mb_release_inode_pa:3773:
group 59, free 4, pa_free 2
[149757.349776] Aborting journal on device vda1-8.
[149757.386808] EXT4-fs (vda1): Remounting filesystem read-only
[236229.600081] EXT4-fs (vda1): error count since last fsck: 1
[236229.600086] EXT4-fs (vda1): initial error at time 1432088178:
ext4_mb_release_inode_pa:3773
[236229.600088] EXT4-fs (vda1): last error at time 1432088178:
ext4_mb_release_inode_pa:3773

I'm not able to reproduce this, but I've already seen the error several times.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
