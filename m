From: Meelis Roos <mroos@linux.ee>
Subject: UBSAN warning from fs/ext4/mballoc.c:1281:11 - shift exponent -1 is
 negative
Date: Wed, 13 Apr 2016 10:57:39 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1604131053580.12114@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:46784 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934232AbcDMIUm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Apr 2016 04:20:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I turned on UBSAN on most of my test machines and found this recurring 
pattern: shift exponent -1 from ext4_mb_init_cache().

This happens in both 4.5 and 4.6-rc2. gcc version 5.3.1 20160409 (Debian 5.3.1-14) 


[   43.297258] ================================================================================
[   43.297442] UBSAN: Undefined behaviour in fs/ext4/mballoc.c:1281:11
[   43.297542] shift exponent -1 is negative
[   43.297637] CPU: 1 PID: 1001 Comm: mv Not tainted 4.6.0-rc2 #20
[   43.297731] Hardware name: Unknown Unknown/S2462 THUNDER K7, BIOS Guinness-8    04/07/2003
[   43.297891]  00000000 c134bb3c 00000046 f45eb944 00000001 c1381c4b f45eb938 ffffffff
[   43.298251]  c13821d6 c16ff14c f45eb948 00000005 f6055770 00000202 f600312d f442f000
[   43.298604]  00000000 00008000 00001800 f6627800 0000001f f4695000 00008000 00001789
[   43.298960] Call Trace:
[   43.299065]  [<c134bb3c>] ? dump_stack+0x45/0x69
[   43.299162]  [<c1381c4b>] ? ubsan_epilogue+0xb/0x40
[   43.299258]  [<c13821d6>] ? __ubsan_handle_shift_out_of_bounds+0xd6/0x120
[   43.299361]  [<c12953eb>] ? ext4_mb_init_cache+0x4cb/0xc20
[   43.299457]  [<c1290509>] ? mb_find_order_for_block+0xd9/0x110
[   43.299552]  [<c1290cef>] ? mb_find_extent+0x9f/0x3d0
[   43.299648]  [<c1293d98>] ? ext4_mb_complex_scan_group+0xf8/0x4c0
[   43.299751]  [<c113ca8f>] ? pagecache_get_page+0x1cf/0x3c0
[   43.299847]  [<c129a5d2>] ? ext4_mb_regular_allocator+0x292/0x620
[   43.299945]  [<c129000c>] ? ext4_mb_free_metadata+0x41c/0x840
[   43.300043]  [<c129d7e6>] ? ext4_mb_new_blocks+0x376/0x8a0
[   43.300141]  [<c128108f>] ? ext4_find_extent+0x2ff/0x480
[   43.300240]  [<c1463c4b>] ? scsi_dispatch_cmd+0xfb/0x250
[   43.300335]  [<c12873e3>] ? ext4_ext_map_blocks+0xa43/0x1430
[   43.300436]  [<c131f66c>] ? blk_rq_map_sg+0x21c/0x800
[   43.300532]  [<c132a11f>] ? __bt_get+0x12f/0x400
[   43.300630]  [<c1490001>] ? ata_scsi_cmd_error_handler+0x191/0x270
[   43.300732]  [<c1250f59>] ? ext4_map_blocks+0x139/0x5a0
[   43.300827]  [<c148ae6b>] ? ata_scsi_translate+0xbb/0x1f0
[   43.300922]  [<c148a410>] ? ata_scsi_invalid_field+0x50/0x50
[   43.301019]  [<c1256013>] ? mpage_map_and_submit_extent+0xe3/0xce0
[   43.301121]  [<c1152254>] ? release_pages+0xe4/0x430
[   43.301169]  [<c1153b56>] ? __pagevec_release+0x26/0x40
[   43.301169]  [<c12ba968>] ? jbd2__journal_start+0xc8/0x1f0
[   43.301169]  [<c128c17d>] ? __ext4_journal_start_sb+0x4d/0xd0
[   43.301169]  [<c125700f>] ? ext4_writepages+0x3ff/0x7d0
[   43.301169]  [<c12642a0>] ? ext4_find_entry+0x730/0xb60
[   43.301169]  [<c1150289>] ? do_writepages+0x29/0x80
[   43.301169]  [<c113ddc5>] ? __filemap_fdatawrite_range+0x75/0xc0
[   43.301169]  [<c113ded3>] ? filemap_flush+0x23/0x30
[   43.301169]  [<c1268a21>] ? ext4_rename2+0x971/0x1680
[   43.301169]  [<c11ba2a8>] ? unlazy_walk+0x88/0x2a0
[   43.301169]  [<c11b9e2e>] ? terminate_walk+0x6e/0x190
[   43.301169]  [<c12680b0>] ? ext4_tmpfile+0x190/0x190
[   43.301169]  [<c11c10e0>] ? vfs_rename+0x6e0/0xaf0
[   43.301169]  [<c12680b0>] ? ext4_tmpfile+0x190/0x190
[   43.301169]  [<c11c44d3>] ? SyS_rename+0x353/0x3f0
[   43.301169]  [<c1002076>] ? do_fast_syscall_32+0xb6/0x1d0
[   43.301169]  [<c164cedb>] ? sysenter_past_esp+0x40/0x6a
[   43.301169] 
================================================================================

-- 
Meelis Roos (mroos@linux.ee)
