From: MaoXiaoyun <tinnycloud@hotmail.com>
Subject: ext4 BUG in dom0 Kernel 2.6.32.36
Date: Tue, 6 Sep 2011 15:24:14 +0800
Message-ID: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit
Cc: jeremy@goop.org, konrad.wilk@oracle.com
To: <linux-ext4@vger.kernel.org>, xen devel <xen-devel@lists.xensource.com>
Return-path: <xen-devel-bounces@lists.xensource.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
List-Id: linux-ext4.vger.kernel.org



Hi:

I've met an ext4 Bug in dom0 kernel 2.6.32.36. (See kernel stack below)
32.36 kernel commit: http://git.kernel.org/?p=linux/kernel/git/jeremy/xen.git;a=commit;h=ae333e97552c81ab10395ad1ffc6d6daaadb144a

The bug only show up in our cluster environments which includes 300 physical machines, one server will run into this bug per day.
Running ontop of every server, there are about 30 VMS, each of which has heavy IO workload inside.(we are doing some kinds of stress tests)
 
We have our own distribute file system as the storage of cluster, every VM'image file will be spilt into several files with equal size in 
physical disk, and every creation of file use ext4 fallocation(fallocation size 1MB). So I believe there will be quite a lot of uninitialized
extent to be initialized during the test.
 
After go through the src code. Call routinue is 
ext4_da_sritepages->mpage_da_map_blocks->ext4_get_blocks->ext4_ext_get_blocks->
ext4_ext_handle_uninitialized_extents->ext4_ext_convert_to_initialized->ext4_ext_insert_extent
 
 
if ext4_ext_handle_uninitialized_extents is called, then line 3306 must be satisfied.
that is we have in_range(iblock, ee_block, ee_len) = true.
so iblock >= ee_block
 
fs/ext4/extents.c
3306 <+++<+++if (in_range(iblock, ee_block, ee_len)) {                                                                                                          
3307 <+++<+++<+++newblock = iblock - ee_block + ee_start;
3308 <+++<+++<+++/* number of remaining blocks in the extent */
3309 <+++<+++<+++allocated = ee_len - (iblock - ee_block);
3310 <+++<+++<+++ext_debug("%u fit into %u:%d -> %llu\n", iblock,
3311 <+++<+++<+++<+++<+++ee_block, ee_len, newblock);
3312 
3313 <+++<+++<+++/* Do not put uninitialized extent in the cache */
3314 <+++<+++<+++if (!ext4_ext_is_uninitialized(ex)) {
3315 <+++<+++<+++<+++ext4_ext_put_in_cache(inode, ee_block,
3316 <+++<+++<+++<+++<+++<+++<+++ee_len, ee_start,
3317 <+++<+++<+++<+++<+++<+++<+++EXT4_EXT_CACHE_EXTENT);
3318 <+++<+++<+++<+++goto out;
3319 <+++<+++<+++}
3320 <+++<+++<+++ret = ext4_ext_handle_uninitialized_extents(handle,
3321 <+++<+++<+++<+++<+++inode, iblock, max_blocks, path,
3322 <+++<+++<+++<+++<+++flags, allocated, bh_result, newblock);
3323 <+++<+++<+++return ret;
3324 <+++<+++}
 
 
the newext is from line 2678, its ee_block is iblock + max_blocks
the nearex is path[depth].p_ext(line 1683) 
 
BUG_ON 1716 means iblock + max_blocks = ee_block.
So maybe that means we have iblock = ee_block and max_blocks = 0.
 
 
1716 <+++<+++BUG_ON(newext->ee_block == nearex->ee_block);                                                                                                      
1717 <+++<+++len = (EXT_MAX_EXTENT(eh) - nearex) * sizeof(struct ext4_extent);
1718 <+++<+++len = len < 0 ? 0 : len;
1719 <+++<+++ext_debug("insert %d:%llu:[%d]%d before: nearest 0x%p, "
1720 <+++<+++<+++<+++"move %d from 0x%p to 0x%p\n",
1721 <+++<+++<+++<+++le32_to_cpu(newext->ee_block),
1722 <+++<+++<+++<+++ext_pblock(newext),
1723 <+++<+++<+++<+++ext4_ext_is_uninitialized(newext),
1724 <+++<+++<+++<+++ext4_ext_get_actual_len(newext),
1725 <+++<+++<+++<+++nearex, len, nearex + 1, nearex + 2);
1726 <+++<+++memmove(nearex + 1, nearex, len);
1727 <+++<+++path[depth].p_ext = nearex;
1728 <+++}
 
 
2678 <+++<+++ex3 = &newex;                                                                                                                                      
2679 <+++<+++ex3->ee_block = cpu_to_le32(iblock + max_blocks);
2680 <+++<+++ext4_ext_store_pblock(ex3, newblock + max_blocks);
2681 <+++<+++ex3->ee_len = cpu_to_le16(allocated - max_blocks);
2682 <+++<+++ext4_ext_mark_uninitialized(ex3);
2683 <+++<+++err = ext4_ext_insert_extent(handle, inode, path, ex3, 0);
2684 <+++<+++if (err == -ENOSPC && may_zeroout) {
2685 <+++<+++<+++err =  ext4_ext_zeroout(inode, &orig_ex);
 
 
if max_blocks = 0; it means 2225, mpd->b_size >> mpd->inode->i_blkbits is 0.
 
fs/ext4/inode.c
2220 static int mpage_da_map_blocks(struct mpage_da_data *mpd)
2221 {
2222 <+++int err, blks, get_blocks_flags;
2223 <+++struct buffer_head new;
2224 <+++sector_t next = mpd->b_blocknr;
2225 <+++unsigned max_blocks = mpd->b_size >> mpd->inode->i_blkbits;                                                                                            
2226 <+++loff_t disksize = EXT4_I(mpd->inode)->i_disksize;
2227 <+++handle_t *handle = NULL;
2228 
 
 
Could it be possilbe, right now I am tring to reproduce this problem in a much
easiler way, any suggestion? 
 
Many thanks.
 
 
------------[ cut here ]------------
kernel BUG at fs/ext4/extents.c:1716!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/block/tapdevk/stat
CPU 3 
Modules linked in: xt_iprange xt_mac arptable_filter arp_tables xt_physdev nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack 
iptable_filter ip_tables bridge autofs4 ipmi_devintf ipmi_si ipmi_msghandler lockd sunrpc bonding ipv6 8021q garp stp llc xenfs 
dm_multipath fuse xen_netback xen_blkback blktap blkback_pagemap loop nbd video output sbs sbshc parport_pc lp parport joydev ses 
enclosure snd_seq_dummy snd_seq_oss bnx2 snd_seq_midi_event snd_seq snd_seq_device dcdbas snd_pcm_oss snd_mixer_oss serio_raw snd_pcm 
snd_timer snd soundcore snd_page_alloc iTCO_wdt iTCO_vendor_support pcspkr shpchp [last unloaded: freq_table]
Pid: 9073, comm: flush-8:16 Not tainted 2.6.32.36xen #1 PowerEdge R710
RIP: e030:[<ffffffff811a6184>] [<ffffffff811a6184>] ext4_ext_insert_extent+0xac1/0xbe0
RSP: e02b:ffff8801499cd580 EFLAGS: 00010246
RAX: 0000000000002948 RBX: 0000000000000000 RCX: ffff8801499cd780
RDX: ffff8801499cd360 RSI: ffff88007dedb310 RDI: 0000000000000017
RBP: ffff8801499cd650 R08: ffff8801499cd340 R09: ffff880063488930
R10: 000000018100f8bf R11: dead000000200200 R12: ffff88005a29700c
R13: ffff88005a297000 R14: ffff8801158198c0 R15: ffff88003e9ea1b0
FS: 00007fd3cc4bf6e0(0000) GS:ffff88002808f000(0000) knlGS:0000000000000000
CS: e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000042a09e CR3: 00000000bf3bd000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-8:16 (pid: 9073, threadinfo ffff8801499cc000, task ffff880149ad5b40)
Stack:
ffff8801499cd780 ffff88003e9ea180 ffff8801c5b47300 01ffffff81103c0c
<0> ffff88003e9ea180 000000017dedb2a0 ffff880115819800 ffff88007dedb2a0
<0> ffff8801499cd5d0 ffffffff811c12ea ffff8801499cd5f0 ffffffff811c16ea
Call Trace:
[<ffffffff811c12ea>] ? jbd_unlock_bh_journal_head+0x16/0x18
[<ffffffff811c16ea>] ? jbd2_journal_put_journal_head+0x4d/0x52
[<ffffffff811bb7d6>] ? jbd2_journal_get_write_access+0x31/0x38
[<ffffffff811a88e9>] ? __ext4_journal_get_write_access+0x4c/0x5f
[<ffffffff811a6ce3>] ext4_ext_handle_uninitialized_extents+0xa40/0xef5
[<ffffffff8100f175>] ? xen_force_evtchn_callback+0xd/0xf
[<ffffffff8100f8d2>] ? check_events+0x12/0x20
[<ffffffff81042fcf>] ? need_resched+0x23/0x2d
[<ffffffff811a74e1>] ext4_ext_get_blocks+0x265/0x6eb
[<ffffffff81042fcf>] ? need_resched+0x23/0x2d
[<ffffffff81188b55>] ext4_get_blocks+0x140/0x204
[<ffffffff81188d2f>] mpage_da_map_blocks+0xb7/0x681
[<ffffffff810d3b29>] ? find_get_pages_tag+0x48/0xcc
[<ffffffff8100f8d2>] ? check_events+0x12/0x20
[<ffffffff810da8df>] ? pagevec_lookup_tag+0x27/0x30
[<ffffffff810d87cc>] ? write_cache_pages+0x175/0x35e
[<ffffffff811893f0>] ? __mpage_da_writepage+0x0/0x164
[<ffffffff81103c0c>] ? kmem_cache_alloc+0x94/0xf6
[<ffffffff811bbc40>] ? jbd2_journal_start+0xa1/0xcd
[<ffffffff8119957f>] ? ext4_journal_start_sb+0xdc/0x111
[<ffffffff81186852>] ? ext4_meta_trans_blocks+0x74/0xce
[<ffffffff8118bc42>] ext4_da_writepages+0x47a/0x6a7
[<ffffffff810d8a00>] do_writepages+0x21/0x2a
[<ffffffff8112cdb8>] writeback_single_inode+0xc8/0x1e3
[<ffffffff8112d5e4>] writeback_inodes_wb+0x30b/0x37e
[<ffffffff8102f82d>] ? paravirt_end_context_switch+0x17/0x31
[<ffffffff8100b459>] ? xen_end_context_switch+0x1e/0x22
[<ffffffff8112d788>] wb_writeback+0x131/0x1bb
[<ffffffff81064029>] ? try_to_del_timer_sync+0x73/0x81
[<ffffffff8112d9ef>] wb_do_writeback+0x13c/0x153
[<ffffffff8106425b>] ? process_timeout+0x0/0x10
[<ffffffff810e78d1>] ? bdi_start_fn+0x0/0xd0
[<ffffffff8112da32>] bdi_writeback_task+0x2c/0xb3
[<ffffffff810e793b>] bdi_start_fn+0x6a/0xd0
[<ffffffff810754b7>] kthread+0x6e/0x76
[<ffffffff81013daa>] child_rip+0xa/0x20
[<ffffffff81012f91>] ? int_ret_from_sys_call+0x7/0x1b
[<ffffffff8101371d>] ? retint_restore_args+0x5/0x6
[<ffffffff81013da0>] ? child_rip+0x0/0x20
Code: 8d 04 85 f4 ff ff ff 85 c0 0f 49 d8 48 63 d3 e8 47 c7 07 00 49 8d 44 24 0c 49 89 47 10 eb 3a bb f4 ff ff ff e9 c2 00 00 00 75 04 
<0f> 0b eb fe 41 0f b7 45 04 49 8d 7c 24 0c 48 6b c0 0c 4c 89 e6 
RIP [<ffffffff811a6184>] ext4_ext_insert_extent+0xac1/0xbe0
RSP <ffff8801499cd580>
---[ end trace 035c7d09ed95fb32 ]--- 		 	   		  
