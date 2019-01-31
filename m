Return-Path: <SRS0=L9HK=QH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFF2C169C4
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 11:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 968732087F
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 11:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732150AbfAaLpG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Jan 2019 06:45:06 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3255 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726977AbfAaLpG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 31 Jan 2019 06:45:06 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6B4F4628E7C6CF9A3933;
        Thu, 31 Jan 2019 19:45:03 +0800 (CST)
Received: from [127.0.0.1] (10.177.33.43) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.408.0; Thu, 31 Jan 2019
 19:44:56 +0800
Subject: Re: [PATCH V2 0/4] fix bugs for ioctl EXT4_IOC_SWAP_BOOT
To:     <tytso@mit.edu>, <jack@suse.com>
CC:     <miaoxie@huawei.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
        <linux-ext4@vger.kernel.org>
References: <20190122065823.67957-1-yangerkun@huawei.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <bc123000-d65f-fd04-e1d9-234bd7db0ab8@huawei.com>
Date:   Thu, 31 Jan 2019 19:43:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122065823.67957-1-yangerkun@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.33.43]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Ping?

yangerkun wrote on 2019/1/22 14:58:
> Changelog v1 ==> v2:
> 1.Modify the first patch since it will conflit with
> 8a36397("ext4: avoid declaring fs inconsistent due to invalid file handles").
> 
> 2.Add the explain in each patch.
> 
> 3.Give up using dquot_alloc_space_nofail, since it may exceed hard limit of quota.
> Now we update the quota information when all swap function has been finished and won't
> trigger a 'Revert'.
> 
> The latter program running with a ext3fs or ext4fs with nodealloc
> will trigger a warning show as bellow:
> 
> [  123.644524] EXT4-fs (vdb): mounting ext3 file system using the ext4 subsystem
> [  123.647408] EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts: (null)
> [  138.323196] WARNING: CPU: 1 PID: 1130 at fs/ext4/ext4_jbd2.c:271 __ext4_handle_dirty_metadata+0x103/0x1a0
> [  138.323198] Modules linked in:
> [  138.323203] CPU: 1 PID: 1130 Comm: a.out Not tainted 5.0.0-rc2opt+ #62
> [  138.323205] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
> [  138.323208] RIP: 0010:__ext4_handle_dirty_metadata+0x103/0x1a0
> [  138.323210] Code: 00 48 8b 40 68 48 89 90 d8 01 00 00 48 8b 4b 18 44 89 fa e8 ff c3 04 00 eb 84 48 89 df 45 31 ed e8 52 40 f9 ff e9 74 ff ff ff <0f> 0b 48 c7 c2 c0 88 e4 b1 45 89 e8 48 89 e9 44 89 fe 4c 89 f7 e8
> [  138.323211] RSP: 0018:ffffb997422bfc00 EFLAGS: 00010286
> [  138.323212] RAX: ffff9f0ab10ef800 RBX: ffff9f0a8cc74208 RCX: 0000000000000000
> [  138.323213] RDX: ffff9f0a8cc64000 RSI: ffff9f0a8cc74208 RDI: ffff9f0a8cc64000
> [  138.323214] RBP: ffff9f0a8cc64000 R08: ffff9f0a8cc74208 R09: ffffffffb1375300
> [  138.323215] R10: 0000000000000020 R11: ffff9f0a8cc74208 R12: 0000000000000000
> [  138.323216] R13: 00000000ffffff8b R14: ffffffffb1e496e8 R15: 0000000000000559
> [  138.323217] FS:  00007f878e152440(0000) GS:ffff9f0ab3a40000(0000) knlGS:0000000000000000
> [  138.323218] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  138.323219] CR2: 00007f878dcec395 CR3: 000000041bbc5000 CR4: 00000000000006e0
> [  138.323223] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  138.323223] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  138.323224] Call Trace:
> [  138.323282]  write_end_fn+0x42/0x50
> [  138.323303]  ext4_walk_page_buffers+0x72/0xa0
> [  138.323320]  ? __ext4_expand_extra_isize+0x90/0x90
> [  138.323322]  ext4_journalled_write_end+0xdb/0x510
> [  138.323335]  ? copyin+0x22/0x30
> [  138.323355]  generic_perform_write+0xfd/0x1b0
> [  138.323385]  __generic_file_write_iter+0x196/0x1e0
> [  138.323402]  ? generic_write_checks+0x4c/0xb0
> [  138.323404]  ext4_file_write_iter+0xc7/0x400
> [  138.323439]  ? tty_write+0x1bf/0x2e0
> [  138.323441]  ? n_tty_open+0xa0/0xa0
> [  138.323453]  __vfs_write+0x11e/0x1b0
> [  138.323479]  vfs_write+0xb3/0x1b0
> [  138.323481]  ksys_write+0x52/0xc0
> [  138.323487]  do_syscall_64+0x55/0x170
> [  138.323523]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  138.323555] RIP: 0033:0x7f878dc6b130
> [  138.323556] Code: 73 01 c3 48 8b 0d 58 ed 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d b9 45 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 3e f3 01 00 48 89 04 24
> [  138.323557] RSP: 002b:00007ffe8104ecc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [  138.323559] RAX: ffffffffffffffda RBX: 00007f878dd035b0 RCX: 00007f878dc6b130
> [  138.323560] RDX: 0000000000000020 RSI: 0000000000601080 RDI: 0000000000000003
> [  138.323560] RBP: 00007ffe8104ed10 R08: 0000000000000000 R09: 0000000000000000
> [  138.323561] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000400610
> [  138.323562] R13: 00007ffe8104edf0 R14: 0000000000000000 R15: 0000000000000000
> [  138.323564] ---[ end trace 8c5d15ab55f9bea9 ]---
> [  138.323586] EXT4-fs: write_end_fn:1369: aborting transaction: Corrupt filesystem in __ext4_handle_dirty_metadata
> [  138.326177] EXT4: jbd2_journal_dirty_metadata failed: handle type 2 started at line 1289, credits 19/17, errcode -117
> [  138.326231] EXT4-fs error (device vdb) in ext4_do_update_inode:5362: Readonly filesystem
> [  138.329147] EXT4-fs error (device vdb) in ext4_journalled_write_end:1550: Corrupt filesystem
> 
> 
> And the problem is that swap_inode_data in swap_inode_boot_loader
> will swap inode flags without reset aops. In this scene, ext4_should_journal_data
> in ext4_write_begin will return false and there won't a journal_head append to
> buffer_head, but we will still use ext4_journalled_write_end, this function
> will return false while do 'buffer_jbd' check and trigger the warning.
> 
> We can reset the aops while swapping, but it may better to add a mask to distinguish
> the flags should be swapped or not.
> 
> Also, there is some other fix about this ioctl.
> 
> yangerkun (4):
>    ext4: fix check of inode in swap_inode_boot_loader
>    ext4: cleanup pagecache before swap i_data
>    ext4: update quota information while swapping boot loader inode
>    ext4: add mask of ext4 flags to swap
> 
>   fs/ext4/ext4.h  |   4 +++
>   fs/ext4/ioctl.c | 100 +++++++++++++++++++++++++++++++++++++++++---------------
>   2 files changed, 77 insertions(+), 27 deletions(-)
> 

