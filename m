From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42763] directory access hangs without error
Date: Mon, 13 Feb 2012 18:30:28 GMT
Message-ID: <201202131830.q1DIUSQv024633@bugzilla.kernel.org>
References: <bug-42763-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:54946 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab2BMSa3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2012 13:30:29 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1DIUSp1024634
	for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2012 18:30:28 GMT
In-Reply-To: <bug-42763-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42763





--- Comment #6 from Eric Buddington <ebuddington@wesleyan.edu>  2012-02-13 18:30:27 ---
The stuck threads look like this:

edu             D c023a2f4     0  9912      1 0x00000004
f50b2b80 00000086 00000000 c023a2f4 f7b2b400 d5350000 c09f6d80 00000000
c09f6d80 c1c5f500 0000000a c33dbee0 c023f172 00000000 d53515cc c33dbee0
000015cc d5352000 c8c4b4a4 c33dbee0 c1c5f500 f0e05dac c01558a1 00000246
Call Trace:
[<c023a2f4>] ? ext4_getblk+0x8b/0x13d
[<c023f172>] ? search_dirblock+0x76/0xaf
[<c01558a1>] ? arch_local_irq_save+0xf/0x14
[<c0651740>] ? _raw_spin_lock_irqsave+0x8/0x2c
[<c01c2cc3>] ? inode_wait+0x5/0x8
[<c0650c36>] ? __wait_on_bit+0x2f/0x54
[<c01c2cbe>] ? inode_owner_or_capable+0x30/0x30
[<c0650cba>] ? out_of_line_wait_on_bit+0x5f/0x67
[<c01c2cbe>] ? inode_owner_or_capable+0x30/0x30
[<c014532b>] ? autoremove_wake_function+0x2f/0x2f
[<c01c3610>] ? wait_on_bit.constprop.13+0x22/0x25
[<c01c3c8b>] ? iget_locked+0x42/0xc5
[<c023aad8>] ? ext4_iget+0x24/0x5be
[<c01bad90>] ? do_lookup+0x1e4/0x224
[<c01243a6>] ? should_resched+0x5/0x1e
[<c06506de>] ? _cond_resched+0x5/0x18
[<c01a61c9>] ? slab_pre_alloc_hook.isra.62+0x20/0x23
[<c01a6d76>] ? kmem_cache_alloc+0x1c/0xb1
[<c0240b61>] ? ext4_lookup.part.29+0x50/0xc6
[<c01c1cfc>] ? __d_alloc+0xec/0xfb
[<c01ba3b0>] ? d_alloc_and_lookup+0x2c/0x49
[<c01bacf9>] ? do_lookup+0x14d/0x224
[<c01bae26>] ? walk_component+0x56/0x10c
[<c01baf15>] ? lookup_last+0x39/0x3f
[<c01bb9c3>] ? path_lookupat+0x74/0x238
[<c01243a6>] ? should_resched+0x5/0x1e
[<c06506de>] ? _cond_resched+0x5/0x18
[<c01bbba1>] ? do_path_lookup+0x1a/0x4f
[<c01bcd77>] ? user_path_at_empty+0x3d/0x69
[<c01b6065>] ? cp_new_stat64+0xec/0xfe
[<c01bcdbb>] ? user_path_at+0x18/0x1d
[<c01b6410>] ? vfs_fstatat+0x3f/0x67
[<c01b644e>] ? vfs_lstat+0x16/0x18
[<c01b6645>] ? sys_lstat64+0xe/0x21
[<c01b81a4>] ? flush_old_exec+0x29/0x81
[<c0655f63>] ? sysenter_do_call+0x12/0x2c

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
