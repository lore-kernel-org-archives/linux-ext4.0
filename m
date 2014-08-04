From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] ext4: save goal group and offset in struct ext4_allocation_context.ac_g_ex
Date: Mon, 4 Aug 2014 15:00:06 +0800
Message-ID: <53DF2F76.7060307@cn.fujitsu.com>
References: <1406108861-2581-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <20140729135819.GA2256@thunk.org> <20140731153255.GE1566@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <adilger@dilger.ca>,
	<lczerner@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20734 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750883AbaHDHBR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 03:01:17 -0400
In-Reply-To: <20140731153255.GE1566@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On 07/31/2014 11:32 PM, Theodore Ts'o wrote:
> On Tue, Jul 29, 2014 at 09:58:19AM -0400, Theodore Ts'o wrote:
>> On Wed, Jul 23, 2014 at 05:47:41PM +0800, Xiaoguang Wang wrote:
>>> In ext4_mb_normalize_request(), if ac_g_ex.fe_logical is adjacent to the closest logical
>>> allocated block to the left or (ac_g_ex.fe_logical+len) adjacent to the closest logical
>>> allocated block to the right, we'll attach EXT4_MB_HINT_TRY_GOAL flag taking the physical
>>> block (ext4_allocation_request.lleft+1) or (ext4_allocation_request.pright-len) as a goal,
>>> and put this information in ext4_allocation_context.ac_f_ex.
>>>
>>> But look at the ext4_mb_find_by_goal(), indeed it use ac_g_ex to look up, so this is wrong,
>>> we should save goal group and offset in struct ext4_allocation_context.ac_g_ex.
>>>
>>> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
>>
>> Nice catch!
>>
>> Thanks, applied.
> 
> I've had to drop this patch, as it is causing xfstests failures for
> generic/074.

When running xfstests, generic/074 does not fail to me, but generic/027 fails.
Below is the captured panic information:

#################################################################################
generic/027 133s ...[   91.984689] ------------[ cut here ]------------
[   91.985015] kernel BUG at fs/ext4/ext4.h:2398!
[   91.985015] invalid opcode: 0000 [#1] SMP 
[   91.985015] Modules linked in: btrfs xor raid6_pq cfg80211 rfkill ip6t_rpfilter ip6t_REJECT ipt_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg nfsd auth_rpcgss nfs_acl snd_hda_codec_generic lockd snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq dm_mirror dm_region_hash dm_log dm_mod snd_seq_device snd_pcm snd_timer snd ppdev parport_pc parport virtio_console soundcore serio_raw i2c_piix4 pcspkr virtio_balloon sunrpc uinput ext4 mbcache jbd2 sd_mod sr_mod cd
 rom crc_t10dif crct10dif_common ata_generic pata_acpi qxl drm_kms_helper ttm drm virtio_net ata_piix virtio_blk i2c_core libata virtio_pci floppy virtio_ring virtio
[   91.985015] CPU: 2 PID: 63 Comm: kworker/u8:1 Not tainted 3.16.0-rc4+ #2
[   91.985015] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   91.985015] Workqueue: writeback bdi_writeback_workfn (flush-8:0)
[   91.985015] task: ffff880056ff9b60 ti: ffff880035c04000 task.ti: ffff880035c04000
[   91.985015] RIP: 0010:[<ffffffffa01bfe1a>]  [<ffffffffa01bfe1a>] ext4_get_group_info.part.17+0x4/0x6 [ext4]
[   91.985015] RSP: 0018:ffff880035c07818  EFLAGS: 00010246
[   91.985015] RAX: 0000000000000000 RBX: ffff8800351eb000 RCX: 0000000000000000
[   91.985015] RDX: 0000000000000000 RSI: ffff880035c078a8 RDI: ffff880056ba4800
[   91.985015] RBP: ffff880035c07818 R08: ffff8800351eb000 R09: ffff8800351eb028
[   91.985015] R10: ffff8800351eb024 R11: 0000000000000230 R12: ffff880056ba2000
[   91.985015] R13: 0000000000000002 R14: ffff880056ba4800 R15: ffff880035c079d0
[   91.985015] FS:  0000000000000000(0000) GS:ffff88005fd00000(0000) knlGS:0000000000000000
[   91.985015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   91.985015] CR2: 00007fc85c7900a0 CR3: 0000000057312000 CR4: 00000000000006e0
[   91.985015] Stack:
[   91.985015]  ffff880035c07870 ffffffffa01adc05 ffffffff812c89ef ffff880035c07858
[   91.985015]  ffffffff812be19f 00000000f569691c ffff880035c079e0 ffff8800351eb000
[   91.985015]  ffff880056ba4800 ffff880056ba4800 ffff880035c079d0 ffff880035c07910
[   91.985015] Call Trace:
[   91.985015]  [<ffffffffa01adc05>] ext4_mb_find_by_goal+0x2d5/0x300 [ext4]
[   91.985015]  [<ffffffff812c89ef>] ? blk_recount_segments+0x3f/0x50
[   91.985015]  [<ffffffff812be19f>] ? part_round_stats+0x4f/0x60
[   91.985015]  [<ffffffffa01ae443>] ext4_mb_regular_allocator+0x73/0x470 [ext4]
[   91.985015]  [<ffffffff81169ce5>] ? mempool_alloc_slab+0x15/0x20
[   91.985015]  [<ffffffffa01a99c2>] ? ext4_mb_normalize_request+0x402/0x570 [ext4]
[   91.985015]  [<ffffffffa01b01f4>] ext4_mb_new_blocks+0x3f4/0x580 [ext4]
[   91.985015]  [<ffffffffa01a16fd>] ? ext4_ext_find_extent+0x23d/0x2d0 [ext4]
[   91.985015]  [<ffffffffa01a52ba>] ext4_ext_map_blocks+0x6ba/0x1170 [ext4]
[   91.985015]  [<ffffffffa0178d1d>] ext4_map_blocks+0x16d/0x560 [ext4]
[   91.985015]  [<ffffffffa017c00e>] ext4_writepages+0x62e/0xd30 [ext4]
[   91.985015]  [<ffffffff81172fee>] do_writepages+0x1e/0x40
[   91.985015]  [<ffffffff812046e0>] __writeback_single_inode+0x40/0x210
[   91.985015]  [<ffffffff8120514a>] writeback_sb_inodes+0x26a/0x420
[   91.985015]  [<ffffffff81205aaf>] wb_writeback+0xff/0x2f0
[   91.985015]  [<ffffffff810924e6>] ? set_worker_desc+0x86/0xb0
[   91.985015]  [<ffffffff81208105>] bdi_writeback_workfn+0x115/0x460
[   91.985015]  [<ffffffff8108f40b>] process_one_work+0x17b/0x460
[   91.985015]  [<ffffffff8108fbad>] worker_thread+0x11d/0x5a0
[   91.985015]  [<ffffffff8108fa90>] ? rescuer_thread+0x3a0/0x3a0
[   91.985015]  [<ffffffff81096d01>] kthread+0xe1/0x100
[   91.985015]  [<ffffffff81096c20>] ? kthread_create_on_node+0x1a0/0x1a0
[   91.985015]  [<ffffffff8163b17c>] ret_from_fork+0x7c/0xb0
[   91.985015]  [<ffffffff81096c20>] ? kthread_create_on_node+0x1a0/0x1a0
[   91.985015] Code: 89 ea 4c 89 e6 ff 13 48 83 c3 10 48 83 3b 00 75 e4 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 55 48 89 e5 0f 0b 55 48 89 e5 <0f> 0b 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 89 f6 41 55 41 
[   91.985015] RIP  [<ffffffffa01bfe1a>] ext4_get_group_info.part.17+0x4/0x6 [ext4]
[   91.985015]  RSP <ffff880035c07818>
[   92.037654] ---[ end trace 269b9ffabaff7ad0 ]---
[   92.038169] Kernel panic - not syncing: Fatal exception
[   92.038894] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   92.039163] drm_kms_helper: panic occurred, switching back to text console
################################################################################# 

This is a triggered BUG_ON:
--ext4_mb_find_by_goal
-----ext4_get_group_info(group >= EXT4_SB(sb)->s_groups_count)

Look at the code in ext4_mb_normalize_request():
#################################################################################
/* define goal start in order to merge */
        if (ar->pright && (ar->lright == (start + size))) {
                /* merge to the right */
                ext4_get_group_no_and_offset(ac->ac_sb, ar->pright - size,
                                                &ac->ac_f_ex.fe_group,
                                                &ac->ac_f_ex.fe_start);
                ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
        }
        if (ar->pleft && (ar->lleft + 1 == start)) {
                /* merge to the left */
                ext4_get_group_no_and_offset(ac->ac_sb, ar->pleft + 1,
                                                &ac->ac_f_ex.fe_group,
                                                &ac->ac_f_ex.fe_start);
                ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
        }
################################################################################# 
Indeed I think we can not ensure 'ar->pright - size' or 'ar->pleft + 1' must be located in 
a valid group. If not, a BUG_ON is triggered, so we should add some judgment, Later I'll
send a new version patch, thanks!

Regards,
Xiaoguang Wang

> 
> I'm not sure why, and right now I don't have time to investigate.  If
> someone who has time and experience wading into fs/ext4/mballoc.c, it
> would be great if someone could take a closer look.
> 
>       	       	  	  	       - Ted
> .
> 

