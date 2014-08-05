From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Tue, 05 Aug 2014 05:06:17 +0000
Message-ID: <bug-42723-13602-ej6RWuhm2F@https.bugzilla.kernel.org/>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50503 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbaHEFGV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Aug 2014 01:06:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6ADBD20173
	for <linux-ext4@vger.kernel.org>; Tue,  5 Aug 2014 05:06:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D70322012F
	for <linux-ext4@vger.kernel.org>; Tue,  5 Aug 2014 05:06:17 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723

Zhiyong Wu <zwu.kernel@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |zwu.kernel@gmail.com

--- Comment #21 from Zhiyong Wu <zwu.kernel@gmail.com> ---
When trying to upgrade my deabian 7.5 box to 7.6 with "apt-get upgrade", i also
met this issue recently. And i checked its source and found that commit
b0dd6b70f0fd had been applied to my box kernel.

[ 35.500785] EXT4-fs (xvda1): re-mounted. Opts: errors=remount-ro,barrier=0
[ 35.526502] loop: module loaded
[ 36.367517] RPC: Registered named UNIX socket transport module.
[ 36.367520] RPC: Registered udp transport module.
[ 36.367521] RPC: Registered tcp transport module.
[ 36.367523] RPC: Registered tcp NFSv4.1 backchannel transport module.
[ 36.378239] FS-Cache: Loaded
[ 36.393865] FS-Cache: Netfs 'nfs' registered for caching
[ 36.405048] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[ 38.196190] EXT4-fs error (device xvda1): ext4_mb_generate_buddy:739: group
33, 9127 clusters in bitmap, 9143 in gd
[ 38.198208] Aborting journal on device xvda1-8.
[ 38.201249] EXT4-fs (xvda1): Remounting filesystem read-only
[ 38.202165] EXT4-fs error (device xvda1) in ext4_reserve_inode_write:4507:
Journal has aborted
[ 38.203509] EXT4-fs error (device xvda1): ext4_journal_start_sb:327: Detected
aborted journal
[ 38.207454] EXT4-fs error (device xvda1) in ext4_reserve_inode_write:4507:
Journal has aborted
[ 38.210148] EXT4-fs error (device xvda1) in ext4_ext_remove_space:2779:
Journal has aborted
[ 38.212614] EXT4-fs error (device xvda1) in ext4_reserve_inode_write:4507:
Journal has aborted
[ 38.215156] EXT4-fs error (device xvda1) in ext4_ext_truncate:4420: Journal
has aborted
[ 38.217590] EXT4-fs error (device xvda1) in ext4_reserve_inode_write:4507:
Journal has aborted
[ 38.220327] EXT4-fs error (device xvda1) in ext4_orphan_del:2110: Journal has
aborted
[ 38.227881] EXT4-fs error (device xvda1) in ext4_reserve_inode_write:4507:
Journal has aborted

# uname -a
Linux AY140708130459758e83Z 3.2.0-4-amd64 #1 SMP Debian 3.2.60-1+deb7u3 x86_64
GNU/Linux

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
