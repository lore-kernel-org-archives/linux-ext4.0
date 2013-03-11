From: Theodore Ts'o <tytso@mit.edu>
Subject: [REGRESSION] allocated N with only M reserved metadata blocks
Date: Mon, 11 Mar 2013 14:54:23 -0400
Message-ID: <20130311185423.GA15478@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52602 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3CKSyZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 14:54:25 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We discussed this regression on today's conference call, and I noted
that that I thought it was something that had been introduced in new
bug/regresion fix commits that are in the dev branch but not yet in
Linus's tree.

This turns out to be incorrect.  I went back through my testing logs,
and from what I can tell, the warning message in question[1] was not
present in 3.8, but was present in the xfstests auto run which I did
(using the standard mount options and 4k block size on test #127) with
a commit which corresponds to the upstream commit id 1231b3a1eb5

So it is a regression, but it's not a regression caused by the most
recent set of changes which we have been testing/validating.

I missed it because my get-results scripts doesn't show me warning
messages (something which I need to fix for the next development
cycle).

  	       		      	  	   - Ted

[1] 127 2431s ...[12774.037351] EXT4-fs warning (device vdb): ext4_da_update_reserve_space:360: ino 1133, allocated 1 with only 0 reserved metadata blocks (releasing 1 blocks with reserved 16 data blocks)
[12774.041006] ------------[ cut here ]------------
[12774.042175] WARNING: at /tyt/linux/ext4/fs/ext4/inode.c:361 ext4_da_update_reserve_space+0xdf/0x1e0()
[12774.044166] Hardware name: Bochs
[12774.044882] Modules linked in:
[12774.045685] Pid: 24352, comm: fsx Tainted: G        W    3.8.0-rc3-00064-ge759417 #35
[12774.047371] Call Trace:
[12774.047914]  [<c015c534>] warn_slowpath_common+0x68/0x7d
[12774.049138]  [<c02759c2>] ? ext4_da_update_reserve_space+0xdf/0x1e0
[12774.050360]  [<c015c55d>] warn_slowpath_null+0x14/0x18
[12774.051022]  [<c02759c2>] ext4_da_update_reserve_space+0xdf/0x1e0
[12774.051807]  [<c0297edb>] ext4_ext_map_blocks+0x12b4/0x13a9
[12774.052581]  [<c0199693>] ? trace_hardirqs_off+0xb/0xd
[12774.053233]  [<c019ba23>] ? __lock_acquire+0x534/0xc07
[12774.053893]  [<c0182bc3>] ? sched_clock_cpu+0x112/0x122
[12774.054570]  [<c0199693>] ? trace_hardirqs_off+0xb/0xd
[12774.055236]  [<c019a8b3>] ? lock_acquired+0x1d2/0x1da
[12774.055944]  [<c0275cd5>] ext4_map_blocks+0x212/0x344
[12774.056589]  [<c0278bef>] mpage_da_map_and_submit+0x94/0x3eb
[12774.057323]  [<c01e0c8f>] ? rcu_read_unlock+0x17/0x19
[12774.057972]  [<c01e0d5f>] ? find_get_pages_tag+0xce/0xed
[12774.058658]  [<c027903a>] write_cache_pages_da+0xf4/0x31f
[12774.059412]  [<c02794c0>] ext4_da_writepages+0x25b/0x3c3
[12774.060140]  [<c01e85d4>] do_writepages+0x23/0x2d
[12774.060754]  [<c01e1d85>] __filemap_fdatawrite_range+0x5a/0x62
[12774.061506]  [<c01e1db8>] filemap_write_and_wait_range+0x2b/0x58
[12774.062346]  [<c0272027>] ext4_sync_file+0x7f/0x2c0
[12774.062975]  [<c0182c05>] ? local_clock+0x32/0x49
[12774.063593]  [<c022d756>] vfs_fsync_range+0x36/0x41
[12774.064228]  [<c0271fa8>] ? ext4_file_write+0x42c/0x42c
[12774.064902]  [<c022d77a>] vfs_fsync+0x19/0x1b
[12774.065526]  [<c01ffb20>] sys_msync+0xec/0x154
[12774.066093]  [<c080e1d0>] ? __do_page_fault+0x346/0x346
[12774.066767]  [<c080b6c8>] syscall_call+0x7/0xb
[12774.067348]  [<c0800000>] ? acpi_processor_add+0x182/0x3e8
[12774.068059] ---[ end trace c26cb86224ce73de ]---
