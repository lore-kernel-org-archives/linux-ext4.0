From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Fri, 08 Apr 2016 10:09:28 +0000
Message-ID: <bug-107301-13602-SiGIzOanyJ@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49568 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443AbcDHKJe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Apr 2016 06:09:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0F5DB20306
	for <linux-ext4@vger.kernel.org>; Fri,  8 Apr 2016 10:09:32 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E47D8202A1
	for <linux-ext4@vger.kernel.org>; Fri,  8 Apr 2016 10:09:29 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

Philipp Matthias Hahn <pmhahn@pmhahn.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |pmhahn@pmhahn.de

--- Comment #24 from Philipp Matthias Hahn <pmhahn@pmhahn.de> ---
Created attachment 212131
  --> https://bugzilla.kernel.org/attachment.cgi?id=212131&action=edit
Multiple NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [smbd:8822]

We have a similar situation with Samba4, which also heavily uses xattr to store
the NTACLs.

>From OCR (may contain errors):

[281537.032878] Call Trace:
[281537.032882]  [<ffffffffa0117c7c>] ? mb_cache_entry_get+0x1ac/0x1f0
[mbcache]
[281537.032883]  [<ffffffff81208f1f>] ? __find_get_block+0xef/0x120
[281537.032889]  [<ffffffffa033de70>] ? ext4_xattr_block_set+0x80/0xa50 [ext4]
[281537.032890]  [<ffffffff81208f1f>] ? __find_get_block+0xef/0x120
[281537.032896]  [<ffffffffa033d1da>] ? ext4_xattr_set_entrg+0x2a/0x350 [ext4]
[281537.032901]  [<ffffffffa033f3e6>] ? ext4_xattr_set_handle+0x376/0x4d0
[ext4]
[281537.032907]  [<ffffffffa033f614>] ? ext4_xattr_set+0xd4/0x130 [ext4]
[281537.032909]  [<ffffffff811f917e>] ? generic_setxattr+0x6e/0xa0
[281537.032910]  [<ffffffff811f9d91>] ? __ufs_setxattr_noperm+0x71/0x1d0
[281537.032912]  [<ffffffff811f9fb4>] ? ufs_setxattr+0xc4/0xd0
[281537.032914]  [<ffffffff811fa0f4>] ? setxattr+0x134/0x1f0
[281537.032916]  [<ffffffff811e1301>] ? filenane_lookup+0x31/0xd0
[281537.032917]  [<ffffffff811e50bc>] ? user_path_at_emptg+0x60/0xc0
[281537.032918]  [<ffffffff811d7473>] ? __sb_start_urite+0x53/0x100
[281537.032919]  [<ffffffff811fa240>] ? path_setxattr+0x90/0xc0
[281537.032921]  [<ffffffff811fa314>] ? SgS_setxattr+0x14/0x20
[281537.032922]  [<ffffffff8159de72>] ? system_call_fast_compare_end+0x0/0x6b
[281537.032933] Code: f0 0f c1 07 89 02 c1 ea 10 66 39 02 75 01 03 0f b7 f2 b8
00 80 00 00 0f b7 0f 41 89 08 41 31 d0 41 81 e0 f
e ff 00 00 74 10 f3 90 <83> e8 01 75 e7 0f 1f 80 00 00 00 00 eb d9 0f b7 f1 e8
08 75 ff

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
