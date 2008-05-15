From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.26-rc2-mm1: sloooow mkfs.ext2
Date: Thu, 15 May 2008 23:41:00 +0200
Message-ID: <482CADEC.9000104@gmail.com>
References: <20080514010129.4f672378.akpm@linux-foundation.org> <20080514211600.GA4748@martell.zuzino.mipt.ru> <20080514213352.GA6523@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>,
	linux-fsdevel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:11719 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYEOVla (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 May 2008 17:41:30 -0400
Received: by mu-out-0910.google.com with SMTP id w8so315093mue.1
        for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 14:41:27 -0700 (PDT)
In-Reply-To: <20080514213352.GA6523@martell.zuzino.mipt.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/14/2008 11:33 PM, Alexey Dobriyan wrote:
> On Thu, May 15, 2008 at 01:16:00AM +0400, Alexey Dobriyan wrote:
>> mkfs.ext2 became kick-ass slow:
>>
>> + sudo mkfs.ext2 -F 
>> mke2fs 1.40.6 (09-Feb-2008)
>> Warning: 256-byte inodes not usable on older systems
>> Filesystem label=
>> OS type: Linux
>> Block size=4096 (log=2)
>> Fragment size=4096 (log=2)
>> 9773056 inodes, 39072726 blocks
>> 1953636 blocks (5.00%) reserved for the super user
>> First data block=0
>> Maximum filesystem blocks=4294967296
>> 1193 block groups
>> 32768 blocks per group, 32768 fragments per group
>> 8192 inodes per group
>> Superblock backups stored on blocks:
>> 	...
>>
>> Writing inode tables:  193/1193
>> 		       ^^^^
>> 		       counter moves slowly,
>> 		       occasional counting at what seems to be normal
>> 		       speed occur.
>>
>> 160 GB SATA disk, no partitions.
>> According to sysfs, CFQ is in use, the rest is compiled out.
>> 2.6.26-rc2 is fine, mkfs takes ~1 min.
>>
>> Slowdown is totally reproducible.
>>
>>
>> CONFIG_ATA=y
>> CONFIG_ATA_ACPI=y
>> CONFIG_SATA_AHCI=y
>> CONFIG_ATA_SFF=y
>> CONFIG_ATA_PIIX=y
>> CONFIG_PATA_JMICRON=y
>>
>>
>> /sys/block/sdb/queue/iosched/back_seek_max
>> 16384
>> /sys/block/sdb/queue/iosched/back_seek_penalty
>> 2
>> /sys/block/sdb/queue/iosched/fifo_expire_async
>> 250
>> /sys/block/sdb/queue/iosched/fifo_expire_sync
>> 120
>> /sys/block/sdb/queue/iosched/quantum
>> 4
>> /sys/block/sdb/queue/iosched/slice_async
>> 40
>> /sys/block/sdb/queue/iosched/slice_async_rq
>> 2
>> /sys/block/sdb/queue/iosched/slice_idle
>> 10
>> /sys/block/sdb/queue/iosched/slice_sync
>> 100
> 
> Here is where it spends time (seems to be always the same):
> 
> mkfs.ext2     D 0000000000000000     0  4760   4759
>  ffff81017ce93a58 0000000000000046 0000000000000000 0000000000000282
>  ffff81017e14d640 ffffffff8056f4c0 ffff81017e14d880 ffffffff804679a2
>  00000000ffffb5c4 000000007ce93a68 0000000000000003 ffffffff8023d504
> Call Trace:
>  [<ffffffff804679a2>] ? _spin_unlock_irqrestore+0x42/0x80
>  [<ffffffff8023d504>] ? __mod_timer+0xc4/0x110
>  [<ffffffff80465012>] schedule_timeout+0x62/0xe0
>  [<ffffffff8023cee0>] ? process_timeout+0x0/0x10
>  [<ffffffff80464ef8>] io_schedule_timeout+0x28/0x40
>  [<ffffffff8027663a>] congestion_wait+0x8a/0xb0
>  [<ffffffff80248720>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff8026fe31>] balance_dirty_pages_ratelimited_nr+0x1a1/0x3f0
>  [<ffffffff8026915f>] generic_file_buffered_write+0x1ff/0x740
>  [<ffffffff80467870>] ? _spin_unlock+0x30/0x60
>  [<ffffffff802acafb>] ? mnt_drop_write+0x7b/0x160
>  [<ffffffff80269b30>] __generic_file_aio_write_nolock+0x2a0/0x460
>  [<ffffffff802548ed>] ? trace_hardirqs_off+0xd/0x10
>  [<ffffffff80269df7>] generic_file_aio_write_nolock+0x37/0xa0
>  [<ffffffff80292be1>] do_sync_write+0xf1/0x130
>  [<ffffffff80256485>] ? trace_hardirqs_on_caller+0xd5/0x160
>  [<ffffffff80248720>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff80256485>] ? trace_hardirqs_on_caller+0xd5/0x160
>  [<ffffffff8025651d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8029339a>] vfs_write+0xaa/0xe0
>  [<ffffffff80293940>] sys_write+0x50/0x90
>  [<ffffffff8020b69b>] system_call_after_swapgs+0x7b/0x80

And not only mkfs, ld took ages to link vmlinux.o:
ld            D 0000000000000000     0 17340  17339
  ffff8100681819c8 0000000000000082 0000000000000000 ffff81006818198c
  ffffffff806c90c0 ffff81006b50d2e0 ffffffff80636360 ffff81006b50d558
  0000000068181978 0000000100a7523e ffff81006b50d558 0000000100a75269
Call Trace:
  [<ffffffff805056b2>] schedule_timeout+0x62/0xd0
  [<ffffffff802403b0>] ? process_timeout+0x0/0x10
  [<ffffffff805056ad>] ? schedule_timeout+0x5d/0xd0
  [<ffffffff80504956>] io_schedule_timeout+0x76/0xd0
  [<ffffffff80282cac>] congestion_wait+0x6c/0x90
  [<ffffffff8024c2c0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff8027c82f>] balance_dirty_pages_ratelimited_nr+0x13f/0x330
  [<ffffffff80275a3d>] generic_file_buffered_write+0x1dd/0x6d0
  [<ffffffff8027d0e7>] ? __do_page_cache_readahead+0x167/0x220
  [<ffffffff802763ae>] __generic_file_aio_write_nolock+0x25e/0x450
  [<ffffffff80276c75>] ? generic_file_aio_read+0x565/0x640
  [<ffffffff80276607>] generic_file_aio_write+0x67/0xd0
  [<ffffffff802f8bd6>] ext3_file_write+0x26/0xc0
  [<ffffffff8029ffa1>] do_sync_write+0xf1/0x140
  [<ffffffff8024c2c0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff80289703>] ? remove_vma+0x53/0x70
  [<ffffffff80505a01>] ? mutex_lock+0x11/0x30
  [<ffffffff802a0a2b>] vfs_write+0xcb/0x190
  [<ffffffff802a0be0>] sys_write+0x50/0x90
  [<ffffffff8020b82b>] system_call_after_swapgs+0x7b/0x80
