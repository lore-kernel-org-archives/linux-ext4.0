From: Nikolay Borisov <kernel@kyup.com>
Subject: sleeping function called in atomic
Date: Tue, 18 Oct 2016 15:33:19 +0300
Message-ID: <5806168F.2010708@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:33966 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753541AbcJRMdX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Oct 2016 08:33:23 -0400
Received: by mail-qk0-f169.google.com with SMTP id f128so277074556qkb.1
        for <linux-ext4@vger.kernel.org>; Tue, 18 Oct 2016 05:33:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, 

I've been seeing the following splat ever since 4.8-rc1: 

[    2.795057] BUG: sleeping function called from invalid context at ./include/linux/buffer_head.h:358
[    2.796742] in_atomic(): 1, irqs_disabled(): 0, pid: 993, name: mount
[    2.797966] CPU: 0 PID: 993 Comm: mount Not tainted 4.9.0-rc1-clouder1 #62
[    2.798952] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
[    2.798952]  ffff880006423548 ffffffff81318c89 ffffffff819ecdd0 0000000000000166
[    2.798952]  ffff880006423558 ffffffff810810b0 ffff880006423580 ffffffff81081153
[    2.798952]  ffff880006e5a1a0 ffff88000690e400 0000000000000000 ffff8800064235c0
[    2.798952] Call Trace:
[    2.798952]  [<ffffffff81318c89>] dump_stack+0x67/0x9e
[    2.798952]  [<ffffffff810810b0>] ___might_sleep+0xf0/0x140
[    2.798952]  [<ffffffff81081153>] __might_sleep+0x53/0xb0
[    2.798952]  [<ffffffff8126c1dc>] ext4_commit_super+0x19c/0x290
[    2.798952]  [<ffffffff8126e61a>] __ext4_grp_locked_error+0x14a/0x230
[    2.798952]  [<ffffffff81081153>] ? __might_sleep+0x53/0xb0
[    2.798952]  [<ffffffff812822be>] ext4_mb_generate_buddy+0x1de/0x320
[    2.798952]  [<ffffffff812828ca>] ext4_mb_init_cache+0x3aa/0x740
[    2.798952]  [<ffffffff81282e15>] ext4_mb_init_group+0x1b5/0x240
[    2.798952]  [<ffffffff8128300f>] ext4_mb_good_group+0x16f/0x190
[    2.798952]  [<ffffffff81285c68>] ext4_mb_regular_allocator+0x288/0x450
[    2.798952]  [<ffffffff812877d8>] ext4_mb_new_blocks+0x508/0xb40
[    2.798952]  [<ffffffff81277fe1>] ? ext4_find_extent+0x1f1/0x2f0
[    2.798952]  [<ffffffff81277fe1>] ? ext4_find_extent+0x1f1/0x2f0
[    2.798952]  [<ffffffff8127c294>] ext4_ext_map_blocks+0x964/0x1ca0
[    2.798952]  [<ffffffff8114bb56>] ? release_pages+0x2a6/0x330
[    2.798952]  [<ffffffff8113af4e>] ? find_get_pages_tag+0x11e/0x280
[    2.798952]  [<ffffffff8124d50e>] ext4_map_blocks+0x10e/0x640
[    2.798952]  [<ffffffff81250d86>] ? ext4_writepages+0x436/0xd90
[    2.798952]  [<ffffffff8125101a>] ext4_writepages+0x6ca/0xd90
[    2.798952]  [<ffffffff81081153>] ? __might_sleep+0x53/0xb0
[    2.798952]  [<ffffffff81259ccc>] ? ext4_find_entry+0x24c/0x6a0
[    2.798952]  [<ffffffff81149f1e>] do_writepages+0x1e/0x30
[    2.798952]  [<ffffffff8113c31a>] __filemap_fdatawrite_range+0xaa/0xf0
[    2.798952]  [<ffffffff8113c40c>] filemap_flush+0x1c/0x20
[    2.798952]  [<ffffffff8124e68c>] ext4_alloc_da_blocks+0x2c/0x80
[    2.798952]  [<ffffffff8125d68d>] ext4_rename+0x62d/0x8a0
[    2.798952]  [<ffffffff811c2ffd>] ? terminate_walk+0x6d/0xe0
[    2.798952]  [<ffffffff8125d91d>] ext4_rename2+0x1d/0x30
[    2.798952]  [<ffffffff811c5d3e>] vfs_rename+0x5de/0x840
[    2.798952]  [<ffffffff811cae68>] SyS_rename+0x398/0x3b0
[    2.798952]  [<ffffffff8166bb6e>] entry_SYSCALL_64_fastpath+0x1c/0xac


This complains due to the lock_buffer(sbh); being called in ext4_commit_super.
This happens while booting on a KVM instance.

