From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 104571] ext4_mb_generate_buddy block bitmap and bg descriptor
 inconsistent
Date: Wed, 04 Nov 2015 21:12:08 +0000
Message-ID: <bug-104571-13602-t4ogcYYFmv@https.bugzilla.kernel.org/>
References: <bug-104571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40139 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428AbbKDVMM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2015 16:12:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1C8D9205DD
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2015 21:12:11 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5B5C7202FE
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2015 21:12:08 +0000 (UTC)
In-Reply-To: <bug-104571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=104571

Sander Smeenk <linux-ext4@freshdot.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|3.19.8-ckt4                 |4.2.0-16-generic

--- Comment #3 from Sander Smeenk <linux-ext4@freshdot.net> ---
Since then, running 4.2.0-16-generic (Ubuntu 'Wily', 15.10), problem still
persists. I've re-created the FS, made it 10T bigger (20T total, 11T in use),
copied all data.

Logs:

Nov  4 15:45:16 [447918.885531] EXT4-fs (vdb): pa ffff88002162ef08: logic
192512, phys. 2823200768, len 1929
Nov  4 15:45:16 [447918.885776] EXT4-fs error (device vdb):
ext4_mb_release_inode_pa:3788: group 86157, free 1917, pa_free 1915
Nov  4 15:45:16 [447918.926300] EXT4-fs (vdb): Remounting filesystem read-only
Nov  4 15:45:16 [447918.926652] EXT4-fs error (device vdb) in
ext4_writepages:2520: IO failure
Nov  4 15:45:16 [447918.968068] EXT4-fs (vdb): ext4_writepages: jbd2_start:
9223372036854775790 pages, ino 310215523; err -30

Nov  4 15:54:39 [448481.868756] EXT4-fs error (device vdb):
ext4_mb_generate_buddy:758: group 86156, block bitmap and bg descriptor
inconsistent: 28672 vs 21008 free clusters
Nov  4 15:54:39 [448481.869114] EXT4-fs (vdb): pa ffff880105bb9888: logic
301056, phys. 2823186432, len 2048
Nov  4 15:54:39 [448481.869343] EXT4-fs error (device vdb):
ext4_mb_release_inode_pa:3788: group 86156, free 2048, pa_free 1926
Nov  4 15:54:39 [448482.020157] EXT4-fs (vdb): pa ffff88010b6298f0: logic
464896, phys. 2823178240, len 2048
Nov  4 15:54:39 [448482.020434] EXT4-fs error (device vdb):
ext4_mb_release_inode_pa:3788: group 86156, free 2048, pa_free 1683
Nov  4 15:54:40 [448482.570440] EXT4-fs error (device vdb): ext4_put_super:803:
Couldn't clean up the journal 

Nov  4 18:21:31 [457294.270301] EXT4-fs error (device vdb):
ext4_mb_generate_buddy:758: group 86089, block bitmap and bg descriptor
inconsistent: 13143 vs 13141 free clusters
Nov  4 18:21:31 [457294.333046] EXT4-fs (vdb): Remounting filesystem read-only
Nov  4 18:21:31 [457294.333211] EXT4-fs error (device vdb) in
ext4_writepages:2520: IO failure

Nov  4 21:22:53 [ 7546.252366] EXT4-fs (vdb): pa ffff8800062eabc8: logic 64708,
phys. 2822632644, len 828
Nov  4 21:22:53 [ 7546.252475] EXT4-fs error (device vdb):
ext4_mb_release_inode_pa:3788: group 86139, free 42, pa_free 40 
Nov  4 21:22:53 [ 7546.317200] EXT4-fs (vdb): Remounting filesystem read-only
Nov  4 21:22:53 [ 7546.317529] EXT4-fs error (device vdb) in
ext4_writepages:2520: IO failure
Nov  4 21:22:53 [ 7546.374769] EXT4-fs (vdb): ext4_writepages: jbd2_start:
9223372036854774720 pages, ino 310215559; err -30


After this last incident at 21:22:53 CET, i've reconfigured the VM to use
'default' values for 'Cache Mode' and 'IO Mode' in libvirt/qemu. It was set to
'Cache Mode: None', 'IO Mode: Native'. It still uses the VirtIO disk bus.

The problem must be triggered by large spikes of random IO (non-sequential
reads & writes) to sparse files on the FS. I will try to re-create this in a
test-VM.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
