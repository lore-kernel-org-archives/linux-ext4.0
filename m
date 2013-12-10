From: "George Spelvin" <linux@horizon.com>
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Date: 10 Dec 2013 04:35:28 -0500
Message-ID: <20131210093528.23399.qmail@science.horizon.com>
References: <20131128153420.GA21176@quack.suse.cz>
Cc: linux@horizon.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	tytso@mit.edu, viro@ZenIV.linux.org.uk
To: jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131128153420.GA21176@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

One of those additional WARN_ON tests tripped, hooray!
And it turned out to be in the ext4 metadata checksumming.  To be
precise, ext4_block_bitmap_csum_set() returned with irqs disabled,
and kaboom.

Since I have this experimental feature turned on and most people don't,
this explains why I'm finding it and World+Dog aren't.

I appear to be the designated finder of ext4 metadata_csum bugs, so tytso
notified on general principles.  I dropped the generic linux-fsdevel
list from the Cc: list.

But looking at the code, it just calls into the linux-crypto layer and
Tim Chen's SSE CRC32C implementation which uses kernel_fpu_begin()
and kernel_fpu_end() if the block is large enough.

I was going to add and Herbert Xu and Tim Chen and all those mailing
lists, but looking at the code, it sure *looks* like they're Doing The
right Thing, so I'm holding off for a bit.

I'm not sure quite where to pass th buck on this one.

Relevant platform info:
- Intel i7-2700K processor, with SSE4.2 and thus the CRC32C instruction.
- CONFIG_PREEMPT_VOLUNTARY=y
- # CONFIG_PREEMPT_NONE is not set
- CONFIG_PREEMPT_VOLUNTARY=y
- # CONFIG_PREEMPT is not set
- CONFIG_PREEMPT_COUNT=y
- CONFIG_DEBUG_ATOMIC_SLEEP=y
- CONFIG_DEBUG_BUGVERBOSE=y


[475059.561544] ------------[ cut here ]------------
[475059.561553] WARNING: CPU: 4 PID: 24642 at fs/ext4/mballoc.c:4796 ext4_free_blocks+0xb77/0xc10()
[475059.561554] Modules linked in: fuse pl2303 ftdi_sio usbserial iTCO_wdt
[475059.561560] CPU: 4 PID: 24642 Comm: iceweasel Not tainted 3.11.5-00010-g5626386 #101
[475059.561561] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
[475059.561562]  0000000000000009 ffff880204e99970 ffffffff8156050d 0000000000000000
[475059.561565]  ffff880204e999a8 ffffffff81044103 ffff88021fb9b360 ffff8800a809eb60
[475059.561567]  ffff880168efda20 ffff88021667f000 ffff88021610fec0 ffff880204e999b8
[475059.561569] Call Trace:
[475059.561573]  [<ffffffff8156050d>] dump_stack+0x54/0x74
[475059.561576]  [<ffffffff81044103>] warn_slowpath_common+0x73/0x90
[475059.561578]  [<ffffffff810441d5>] warn_slowpath_null+0x15/0x20
[475059.561580]  [<ffffffff81197da7>] ext4_free_blocks+0xb77/0xc10
[475059.561582]  [<ffffffff8118bfd6>] ext4_ext_remove_space+0x806/0xe20
[475059.561585]  [<ffffffff8119e3c4>] ? ext4_es_free_extent+0x54/0x60
[475059.561587]  [<ffffffff8118e2b8>] ext4_ext_truncate+0xb8/0xe0
[475059.561590]  [<ffffffff81174705>] ext4_truncate+0x2b5/0x300
[475059.561592]  [<ffffffff811751b8>] ext4_evict_inode+0x3f8/0x430
[475059.561596]  [<ffffffff8111aa4a>] evict+0xba/0x1c0
[475059.561598]  [<ffffffff8111b3fb>] iput+0x10b/0x1b0
[475059.561600]  [<ffffffff81117208>] dput+0x278/0x350
[475059.561604]  [<ffffffff8110308a>] __fput+0x16a/0x240
[475059.561606]  [<ffffffff81103199>] ____fput+0x9/0x10
[475059.561609]  [<ffffffff8105e57c>] task_work_run+0x9c/0xd0
[475059.561612]  [<ffffffff810454a7>] do_exit+0x2a7/0x9d0
[475059.561615]  [<ffffffff8104fb6e>] ? __sigqueue_free.part.13+0x2e/0x40
[475059.561618]  [<ffffffff81046a4e>] do_group_exit+0x3e/0xb0
[475059.561620]  [<ffffffff810529e0>] get_signal_to_deliver+0x1b0/0x5f0
[475059.561623]  [<ffffffff81002113>] do_signal+0x43/0x940
[475059.561626]  [<ffffffff81051938>] ? do_send_sig_info+0x58/0x80
[475059.561628]  [<ffffffff81002a6d>] do_notify_resume+0x5d/0x80
[475059.561632]  [<ffffffff81568420>] int_signal+0x12/0x17
[475059.561633] ---[ end trace b093418eaa9338ce ]---
[475059.561635] ------------[ cut here ]------------
[475059.561637] WARNING: CPU: 4 PID: 24642 at fs/ext4/mballoc.c:4798 ext4_free_blocks+0xb61/0xc10()
[475059.561638] Modules linked in: fuse pl2303 ftdi_sio usbserial iTCO_wdt
[475059.561642] CPU: 4 PID: 24642 Comm: iceweasel Tainted: G        W    3.11.5-00010-g5626386 #101
[475059.561644] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
[475059.561644]  0000000000000009 ffff880204e99970 ffffffff8156050d 0000000000000000
[475059.561647]  ffff880204e999a8 ffffffff81044103 ffff88021fb9b360 ffff8800a809eb60
[475059.561649]  ffff880168efda20 ffff88021667f000 ffff88021610fec0 ffff880204e999b8
[475059.561651] Call Trace:
[475059.561654]  [<ffffffff8156050d>] dump_stack+0x54/0x74
[475059.561656]  [<ffffffff81044103>] warn_slowpath_common+0x73/0x90
[475059.561658]  [<ffffffff810441d5>] warn_slowpath_null+0x15/0x20
[475059.561660]  [<ffffffff81197d91>] ext4_free_blocks+0xb61/0xc10
[475059.561662]  [<ffffffff8118bfd6>] ext4_ext_remove_space+0x806/0xe20
[475059.561665]  [<ffffffff8119e3c4>] ? ext4_es_free_extent+0x54/0x60
[475059.561667]  [<ffffffff8118e2b8>] ext4_ext_truncate+0xb8/0xe0
[475059.561669]  [<ffffffff81174705>] ext4_truncate+0x2b5/0x300
[475059.561672]  [<ffffffff811751b8>] ext4_evict_inode+0x3f8/0x430
[475059.561674]  [<ffffffff8111aa4a>] evict+0xba/0x1c0
[475059.561675]  [<ffffffff8111b3fb>] iput+0x10b/0x1b0
[475059.561677]  [<ffffffff81117208>] dput+0x278/0x350
[475059.561679]  [<ffffffff8110308a>] __fput+0x16a/0x240
[475059.561681]  [<ffffffff81103199>] ____fput+0x9/0x10
[475059.561684]  [<ffffffff8105e57c>] task_work_run+0x9c/0xd0
[475059.561686]  [<ffffffff810454a7>] do_exit+0x2a7/0x9d0
[475059.561688]  [<ffffffff8104fb6e>] ? __sigqueue_free.part.13+0x2e/0x40
[475059.561691]  [<ffffffff81046a4e>] do_group_exit+0x3e/0xb0
[475059.561693]  [<ffffffff810529e0>] get_signal_to_deliver+0x1b0/0x5f0
[475059.561695]  [<ffffffff81002113>] do_signal+0x43/0x940
[475059.561697]  [<ffffffff81051938>] ? do_send_sig_info+0x58/0x80
[475059.561700]  [<ffffffff81002a6d>] do_notify_resume+0x5d/0x80
[475059.561702]  [<ffffffff81568420>] int_signal+0x12/0x17
[475059.561704] ---[ end trace b093418eaa9338cf ]---
[475059.561705] ------------[ cut here ]------------
[475059.561708] WARNING: CPU: 4 PID: 24642 at fs/ext4/mballoc.c:4800 ext4_free_blocks+0xad0/0xc10()
[475059.561709] Modules linked in: fuse pl2303 ftdi_sio usbserial iTCO_wdt
[475059.561713] CPU: 4 PID: 24642 Comm: iceweasel Tainted: G        W    3.11.5-00010-g5626386 #101
[475059.561714] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
[475059.561715]  0000000000000009 ffff880204e99970 ffffffff8156050d 0000000000000000
[475059.561717]  ffff880204e999a8 ffffffff81044103 ffff88021fb9b360 ffff8800a809eb60
[475059.561720]  ffff880168efda20 ffff88021667f000 ffff88021610fec0 ffff880204e999b8
[475059.561723] Call Trace:
[475059.561726]  [<ffffffff8156050d>] dump_stack+0x54/0x74
[475059.561728]  [<ffffffff81044103>] warn_slowpath_common+0x73/0x90
[475059.561730]  [<ffffffff810441d5>] warn_slowpath_null+0x15/0x20
[475059.561733]  [<ffffffff81197d00>] ext4_free_blocks+0xad0/0xc10
[475059.561735]  [<ffffffff8118bfd6>] ext4_ext_remove_space+0x806/0xe20
[475059.561738]  [<ffffffff8119e3c4>] ? ext4_es_free_extent+0x54/0x60
[475059.561740]  [<ffffffff8118e2b8>] ext4_ext_truncate+0xb8/0xe0
[475059.561742]  [<ffffffff81174705>] ext4_truncate+0x2b5/0x300
[475059.561745]  [<ffffffff811751b8>] ext4_evict_inode+0x3f8/0x430
[475059.561747]  [<ffffffff8111aa4a>] evict+0xba/0x1c0
[475059.561748]  [<ffffffff8111b3fb>] iput+0x10b/0x1b0
[475059.561750]  [<ffffffff81117208>] dput+0x278/0x350
[475059.561753]  [<ffffffff8110308a>] __fput+0x16a/0x240
[475059.561755]  [<ffffffff81103199>] ____fput+0x9/0x10
[475059.561757]  [<ffffffff8105e57c>] task_work_run+0x9c/0xd0
[475059.561760]  [<ffffffff810454a7>] do_exit+0x2a7/0x9d0
[475059.561762]  [<ffffffff8104fb6e>] ? __sigqueue_free.part.13+0x2e/0x40
[475059.561765]  [<ffffffff81046a4e>] do_group_exit+0x3e/0xb0
[475059.561767]  [<ffffffff810529e0>] get_signal_to_deliver+0x1b0/0x5f0
[475059.561768]  [<ffffffff81002113>] do_signal+0x43/0x940
[475059.561770]  [<ffffffff81051938>] ? do_send_sig_info+0x58/0x80
[475059.561771]  [<ffffffff81002a6d>] do_notify_resume+0x5d/0x80
[475059.561773]  [<ffffffff81568420>] int_signal+0x12/0x17
[475059.561774] ---[ end trace b093418eaa9338d0 ]---
[475059.561775] BUG: sleeping function called from invalid context at fs/ext4/mballoc.c:4802
[475059.561776] in_atomic(): 0, irqs_disabled(): 1, pid: 24642, name: iceweasel
[475059.561778] CPU: 4 PID: 24642 Comm: iceweasel Tainted: G        W    3.11.5-00010-g5626386 #101
[475059.561779] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
[475059.561779]  ffff8800a809eb60 ffff880204e999a8 ffffffff8156050d 0000000000000079
[475059.561781]  ffff880204e999b8 ffffffff81069faf ffff880204e99a90 ffffffff811977c0
[475059.561783]  ffff880131ba3b58 ffff880204e99fd8 0000000104e999f8 00000000008de1f9
[475059.561784] Call Trace:
[475059.561786]  [<ffffffff8156050d>] dump_stack+0x54/0x74
[475059.561789]  [<ffffffff81069faf>] __might_sleep+0xcf/0xf0
[475059.561791]  [<ffffffff811977c0>] ext4_free_blocks+0x590/0xc10
[475059.561793]  [<ffffffff8118bfd6>] ext4_ext_remove_space+0x806/0xe20
[475059.561795]  [<ffffffff8119e3c4>] ? ext4_es_free_extent+0x54/0x60
[475059.561796]  [<ffffffff8118e2b8>] ext4_ext_truncate+0xb8/0xe0
[475059.561798]  [<ffffffff81174705>] ext4_truncate+0x2b5/0x300
[475059.561800]  [<ffffffff811751b8>] ext4_evict_inode+0x3f8/0x430
[475059.561801]  [<ffffffff8111aa4a>] evict+0xba/0x1c0
[475059.561803]  [<ffffffff8111b3fb>] iput+0x10b/0x1b0
[475059.561804]  [<ffffffff81117208>] dput+0x278/0x350
[475059.561806]  [<ffffffff8110308a>] __fput+0x16a/0x240
[475059.561807]  [<ffffffff81103199>] ____fput+0x9/0x10
[475059.561809]  [<ffffffff8105e57c>] task_work_run+0x9c/0xd0
[475059.561811]  [<ffffffff810454a7>] do_exit+0x2a7/0x9d0
[475059.561812]  [<ffffffff8104fb6e>] ? __sigqueue_free.part.13+0x2e/0x40
[475059.561814]  [<ffffffff81046a4e>] do_group_exit+0x3e/0xb0
[475059.561816]  [<ffffffff810529e0>] get_signal_to_deliver+0x1b0/0x5f0
[475059.561818]  [<ffffffff81002113>] do_signal+0x43/0x940
[475059.561821]  [<ffffffff81051938>] ? do_send_sig_info+0x58/0x80
[475059.561823]  [<ffffffff81002a6d>] do_notify_resume+0x5d/0x80
[475059.561825]  [<ffffffff81568420>] int_signal+0x12/0x17
[475059.561830] ------------[ cut here ]------------
[475059.561847] kernel BUG at fs/buffer.c:1268!
[475059.561860] invalid opcode: 0000 [#1] SMP 
[475059.561873] Modules linked in: fuse pl2303 ftdi_sio usbserial iTCO_wdt
[475059.561897] CPU: 4 PID: 24642 Comm: iceweasel Tainted: G        W    3.11.5-00010-g5626386 #101
[475059.561919] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
[475059.561942] task: ffff880216684380 ti: ffff880204e98000 task.ti: ffff880204e98000
[475059.561961] RIP: 0010:[<ffffffff8155fa34>]  [<ffffffff8155fa34>] check_irqs_on.part.16+0x4/0x6
[475059.561987] RSP: 0018:ffff880204e99798  EFLAGS: 00210046
[475059.562001] RAX: 0000000000200082 RBX: ffff880204e99928 RCX: ffff8802160fb000
[475059.562019] RDX: 0000000000001000 RSI: 000000000038005b RDI: ffff8802170f4ac0
[475059.562038] RBP: ffff880204e99798 R08: 0000000000000000 R09: 0000000000000000
[475059.562056] R10: ffff8802160fb000 R11: ffff880204e9951e R12: ffff8802170f4ac0
[475059.562079] R13: 0000000000001000 R14: ffff88021fbdbe00 R15: ffff88021667f000
[475059.562097] FS:  0000000000000000(0000) GS:ffff88021fb00000(0000) knlGS:0000000000000000
[475059.562118] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[475059.562134] CR2: 0000000099d3b000 CR3: 000000000180c000 CR4: 00000000000407e0
[475059.562152] Stack:
[475059.562158]  ffff880204e99808 ffffffff8112e2b7 ffff880204e997b0 0000000000200092
[475059.562181]  ffffffff81568420 ffffffff81732ff4 ffffffff81568420 ffffffff8109861d
[475059.562208]  00000000ff8b8e44 ffff880204e997f0 ffff880204e99928 ffff8802170f4ac0
[475059.562231] Call Trace:
[475059.562241]  [<ffffffff8112e2b7>] __find_get_block+0x1d7/0x1e0
[475059.562257]  [<ffffffff81568420>] ? int_signal+0x12/0x17
[475059.562272]  [<ffffffff81568420>] ? int_signal+0x12/0x17
[475059.562289]  [<ffffffff8109861d>] ? __module_text_address+0xd/0x60
[475059.562306]  [<ffffffff8112e2e0>] __getblk+0x20/0x2f0
[475059.562324]  [<ffffffff8116fbb6>] __ext4_get_inode_loc+0x106/0x410
[475059.562347]  [<ffffffff81171b68>] ext4_get_inode_loc+0x18/0x20
[475059.562363]  [<ffffffff81173311>] ext4_reserve_inode_write+0x21/0x90
[475059.562380]  [<ffffffff811733c9>] ext4_mark_inode_dirty+0x49/0x1a0
[475059.562397]  [<ffffffff81175e4b>] ext4_dirty_inode+0x3b/0x60
[475059.562413]  [<ffffffff81127aad>] __mark_inode_dirty+0x2d/0x230
[475059.562430]  [<ffffffff81197a7c>] ext4_free_blocks+0x84c/0xc10
[475059.562447]  [<ffffffff8118bfd6>] ext4_ext_remove_space+0x806/0xe20
[475059.562464]  [<ffffffff8119e3c4>] ? ext4_es_free_extent+0x54/0x60
[475059.562480]  [<ffffffff8118e2b8>] ext4_ext_truncate+0xb8/0xe0
[475059.562497]  [<ffffffff81174705>] ext4_truncate+0x2b5/0x300
[475059.562512]  [<ffffffff811751b8>] ext4_evict_inode+0x3f8/0x430
[475059.562528]  [<ffffffff8111aa4a>] evict+0xba/0x1c0
[475059.562542]  [<ffffffff8111b3fb>] iput+0x10b/0x1b0
[475059.562555]  [<ffffffff81117208>] dput+0x278/0x350
[475059.562573]  [<ffffffff8110308a>] __fput+0x16a/0x240
[475059.563369]  [<ffffffff81103199>] ____fput+0x9/0x10
[475059.564164]  [<ffffffff8105e57c>] task_work_run+0x9c/0xd0
[475059.564939]  [<ffffffff810454a7>] do_exit+0x2a7/0x9d0
[475059.565728]  [<ffffffff8104fb6e>] ? __sigqueue_free.part.13+0x2e/0x40
[475059.566518]  [<ffffffff81046a4e>] do_group_exit+0x3e/0xb0
[475059.567296]  [<ffffffff810529e0>] get_signal_to_deliver+0x1b0/0x5f0
[475059.568087]  [<ffffffff81002113>] do_signal+0x43/0x940
[475059.568895]  [<ffffffff81051938>] ? do_send_sig_info+0x58/0x80
[475059.569812]  [<ffffffff81002a6d>] do_notify_resume+0x5d/0x80
[475059.570907]  [<ffffffff81568420>] int_signal+0x12/0x17
[475059.572011] Code: 4d 85 e4 74 1d 41 80 44 24 58 01 65 48 8b 04 25 b0 b7 00 00 ff 88 44 e0 ff ff 4c 89 e7 e8 65 75 bb ff 5b 41 5c 5d c3 55 48 89 e5 <0f> 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 
[475059.573325] RIP  [<ffffffff8155fa34>] check_irqs_on.part.16+0x4/0x6
[475059.574581]  RSP <ffff880204e99798>
[475059.583933] ---[ end trace b093418eaa9338d1 ]---
[475059.583936] Fixing recursive fault but reboot is needed!

For a reminder, here's the second debug patch:

commit 5626386a9d37c990977a12f833d6e6fc2e89d8bf
Author: Jan Kara <jack@suse.cz>
Date:   Thu Nov 28 15:36:53 2013 +0100

    Debug irqs
    
    Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e6f0d6b..ece38b4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4760,8 +4760,11 @@ do_more:
 
 		might_sleep();
 		ext4_lock_group(sb, block_group);
+		WARN_ON(irqs_disabled());
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
+		WARN_ON(irqs_disabled());
 		ext4_mb_free_metadata(handle, &e4b, new_entry);
+		WARN_ON(irqs_disabled());
 	} else {
 		/* need to update group_info->bb_free and bitmap
 		 * with group lock held. generate_buddy look at
@@ -4778,15 +4781,23 @@ do_more:
 
 		might_sleep();
 		ext4_lock_group(sb, block_group);
+		WARN_ON(irqs_disabled());
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
+		WARN_ON(irqs_disabled());
 		mb_free_blocks(inode, &e4b, bit, count_clusters);
+		WARN_ON(irqs_disabled());
 	}
 
 	ret = ext4_free_group_clusters(sb, gdp) + count_clusters;
+	WARN_ON(irqs_disabled());
 	ext4_free_group_clusters_set(sb, gdp, ret);
+	WARN_ON(irqs_disabled());
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh);
+	WARN_ON(irqs_disabled());		/***### BUG HERE ###***/
 	ext4_group_desc_csum_set(sb, block_group, gdp);
+	WARN_ON(irqs_disabled());
 	ext4_unlock_group(sb, block_group);
+	WARN_ON(irqs_disabled());
 	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
 	might_sleep();

The problem is metadata_csum enabled on this file system:

Filesystem volume name:   root
Last mounted on:          /
Filesystem UUID:          xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              1049600
Block count:              10485744
Reserved block count:     524287
Free blocks:              6196830
Free inodes:              727373
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1021
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         3280
Inode blocks per group:   205
Flex block group size:    16
Filesystem created:       Mon Oct  7 23:15:31 2013
Last mount time:          Tue Dec 10 01:02:40 2013
Last write time:          Tue Dec 10 01:02:40 2013
Mount count:              2
Maximum mount count:      -1
Last checked:             Wed Dec  4 12:46:49 2013
Check interval:           0 (<none>)
Lifetime writes:          155 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       735089
Default directory hash:   half_md4
Directory Hash Seed:      xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0xfeaba085
Journal features:         journal_incompat_revoke
Journal size:             128M
Journal length:           32768
Journal sequence:         0x0004373b
Journal start:            22384

Looking at what happens where,
ext4_block_bitmap_csum_set() is a simple wrapper around ext4_chksum:

=== fs/ext4/bitmap.c:86 ==
void ext4_block_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
				struct ext4_group_desc *gdp,
				struct buffer_head *bh)
{
	int sz = EXT4_CLUSTERS_PER_GROUP(sb) / 8;
	__u32 csum;
	struct ext4_sb_info *sbi = EXT4_SB(sb);

	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
		return;

	csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
	gdp->bg_block_bitmap_csum_lo = cpu_to_le16(csum & 0xFFFF);
	if (sbi->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_END)
		gdp->bg_block_bitmap_csum_hi = cpu_to_le16(csum >> 16);
}

which in turn calls only crypto_shash_update:
=== fs/ext4/ext4.h:1701 ==
static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
			      const void *address, unsigned int length)
{
	struct {
		struct shash_desc shash;
		char ctx[4];
	} desc;
	int err;

	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));

	desc.shash.tfm = sbi->s_chksum_driver;
	desc.shash.flags = 0;
	*(u32 *)desc.ctx = crc;

	err = crypto_shash_update(&desc.shash, address, length);
	BUG_ON(err);

	return *(u32 *)desc.ctx;
}

=== crypto/shash.c:97 ===
int crypto_shash_update(struct shash_desc *desc, const u8 *data,
			unsigned int len)
{
	struct crypto_shash *tfm = desc->tfm;
	struct shash_alg *shash = crypto_shash_alg(tfm);
	unsigned long alignmask = crypto_shash_alignmask(tfm);

	if ((unsigned long)data & alignmask)
		return shash_update_unaligned(desc, data, len);

	return shash->update(desc, data, len);
}



=== Discussion ===
desc.shash.tfm is filled in from sbi->s_chksum_driver, which is filled in at
ext4_fill_super() time by crypto_alloc_shash("crc32c", 0, 0).

Thus, shash->update should turn into a call to crypto/crc32c.c:chksum_update(),
which calls lib/crc32.c:__crc32c_le().

Now, I happen to be running an i7-2700k which has sse4_2, and thus calls
into the x86 specific code, and apparently for large blocks it uses PCLMULQDQ,
which requires kernel_fpu_begin/end.

At least that makes some degree of sense.  The low level code, though
uses the functions in a very simple way that I can't see how it could fail
to unlock at the end.
