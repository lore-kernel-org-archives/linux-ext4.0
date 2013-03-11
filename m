From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [REGRESSION] allocated N with only M reserved metadata blocks
Date: Mon, 11 Mar 2013 17:02:01 -0400
Message-ID: <20130311210201.GA940@wallace>
References: <20130311185423.GA15478@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:56970 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab3CKVCG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Mar 2013 17:02:06 -0400
Received: by mail-qe0-f42.google.com with SMTP id f6so2594528qej.29
        for <linux-ext4@vger.kernel.org>; Mon, 11 Mar 2013 14:02:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130311185423.GA15478@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o <tytso@mit.edu>:
> We discussed this regression on today's conference call, and I noted
> that that I thought it was something that had been introduced in new
> bug/regresion fix commits that are in the dev branch but not yet in
> Linus's tree.
> 
> This turns out to be incorrect.  I went back through my testing logs,
> and from what I can tell, the warning message in question[1] was not
> present in 3.8, but was present in the xfstests auto run which I did
> (using the standard mount options and 4k block size on test #127) with
> a commit which corresponds to the upstream commit id 1231b3a1eb5
> 
> So it is a regression, but it's not a regression caused by the most
> recent set of changes which we have been testing/validating.
> 
> I missed it because my get-results scripts doesn't show me warning
> messages (something which I need to fix for the next development
> cycle).
> 
>   	       		      	  	   - Ted
> 
> [1] 127 2431s ...[12774.037351] EXT4-fs warning (device vdb): ext4_da_update_reserve_space:360: ino 1133, allocated 1 with only 0 reserved metadata blocks (releasing 1 blocks with reserved 16 data blocks)
> [12774.041006] ------------[ cut here ]------------
> [12774.042175] WARNING: at /tyt/linux/ext4/fs/ext4/inode.c:361 ext4_da_update_reserve_space+0xdf/0x1e0()
> [12774.044166] Hardware name: Bochs
> [12774.044882] Modules linked in:
> [12774.045685] Pid: 24352, comm: fsx Tainted: G        W    3.8.0-rc3-00064-ge759417 #35
> [12774.047371] Call Trace:
> [12774.047914]  [<c015c534>] warn_slowpath_common+0x68/0x7d
> [12774.049138]  [<c02759c2>] ? ext4_da_update_reserve_space+0xdf/0x1e0
> [12774.050360]  [<c015c55d>] warn_slowpath_null+0x14/0x18
> [12774.051022]  [<c02759c2>] ext4_da_update_reserve_space+0xdf/0x1e0
> [12774.051807]  [<c0297edb>] ext4_ext_map_blocks+0x12b4/0x13a9
> [12774.052581]  [<c0199693>] ? trace_hardirqs_off+0xb/0xd
> [12774.053233]  [<c019ba23>] ? __lock_acquire+0x534/0xc07
> [12774.053893]  [<c0182bc3>] ? sched_clock_cpu+0x112/0x122
> [12774.054570]  [<c0199693>] ? trace_hardirqs_off+0xb/0xd
> [12774.055236]  [<c019a8b3>] ? lock_acquired+0x1d2/0x1da
> [12774.055944]  [<c0275cd5>] ext4_map_blocks+0x212/0x344
> [12774.056589]  [<c0278bef>] mpage_da_map_and_submit+0x94/0x3eb
> [12774.057323]  [<c01e0c8f>] ? rcu_read_unlock+0x17/0x19
> [12774.057972]  [<c01e0d5f>] ? find_get_pages_tag+0xce/0xed
> [12774.058658]  [<c027903a>] write_cache_pages_da+0xf4/0x31f
> [12774.059412]  [<c02794c0>] ext4_da_writepages+0x25b/0x3c3
> [12774.060140]  [<c01e85d4>] do_writepages+0x23/0x2d
> [12774.060754]  [<c01e1d85>] __filemap_fdatawrite_range+0x5a/0x62
> [12774.061506]  [<c01e1db8>] filemap_write_and_wait_range+0x2b/0x58
> [12774.062346]  [<c0272027>] ext4_sync_file+0x7f/0x2c0
> [12774.062975]  [<c0182c05>] ? local_clock+0x32/0x49
> [12774.063593]  [<c022d756>] vfs_fsync_range+0x36/0x41
> [12774.064228]  [<c0271fa8>] ? ext4_file_write+0x42c/0x42c
> [12774.064902]  [<c022d77a>] vfs_fsync+0x19/0x1b
> [12774.065526]  [<c01ffb20>] sys_msync+0xec/0x154
> [12774.066093]  [<c080e1d0>] ? __do_page_fault+0x346/0x346
> [12774.066767]  [<c080b6c8>] syscall_call+0x7/0xb
> [12774.067348]  [<c0800000>] ? acpi_processor_add+0x182/0x3e8
> [12774.068059] ---[ end trace c26cb86224ce73de ]---
> --

FWIW, this might not be a regression.  I believe I've got this warning in my
testing logs from both 3.8 and 3.8-rc7 (commit 01a523eb51 in 3.9-rc1 affects
message format and line numbering) on both x86 and ARM.  I didn't run xfstest
127 prior to 3.8-rc7, so I don't know how far back the warning may have
occurred for that particular test.

For 3.8 on x86, 127 triggered the warning in the 4k block, no journal,
metadata_csum, dioread_nolock, and bigalloc test cases.

For 3.8 on ARM/Pandaboard, 127 triggered the warning on metadata_csum.

The 3.8-rc7 results are a little different with respect to number of warnings
and test cases, so I'm thinking this one isn't completely deterministic,
testing-wise.  Multiple test runs may be required to see it.

x86 trace from 3.8 follows.

Regards,
Eric


[ 2918.672138] EXT4-fs (vdb): ext4_da_update_reserve_space: ino 18944, allocated 1 with only 0 reserved metadata blocks
[ 2918.672138] 
[ 2918.672144] ------------[ cut here ]------------
[ 2918.676682] WARNING: at fs/ext4/inode.c:362 ext4_da_update_reserve_space+0x249/0x260()
[ 2918.677882] Hardware name: Bochs
[ 2918.678812] Modules linked in: kvm_intel kvm snd_hda_intel snd_hda_codec snd_hwdep microcode snd_pcm snd_timer psmouse snd serio_raw soundcore snd_page_alloc i2c_piix4 virtio_balloon mac_hid lp parport floppy
[ 2918.681396] Pid: 13118, comm: fsx Not tainted 3.8.0-ext4testing #1
[ 2918.682268] Call Trace:
[ 2918.683129]  [<ffffffff81058d5f>] warn_slowpath_common+0x7f/0xc0
[ 2918.684045]  [<ffffffff81058dba>] warn_slowpath_null+0x1a/0x20
[ 2918.684922]  [<ffffffff8123d469>] ext4_da_update_reserve_space+0x249/0x260
[ 2918.685821]  [<ffffffff8126d36b>] ext4_ext_map_blocks+0x119b/0x16e0
[ 2918.686715]  [<ffffffff8123d6a5>] ext4_map_blocks+0x225/0x2c0
[ 2918.687591]  [<ffffffff81241f2d>] mpage_da_map_and_submit+0x15d/0x420
[ 2918.688485]  [<ffffffff8124272e>] write_cache_pages_da+0x45e/0x4b0
[ 2918.689327]  [<ffffffff81242ac9>] ext4_da_writepages+0x349/0x600
[ 2918.690170]  [<ffffffff811494f1>] do_writepages+0x21/0x50
[ 2918.690989]  [<ffffffff8113e8c9>] __filemap_fdatawrite_range+0x59/0x60
[ 2918.691794]  [<ffffffff8113e920>] filemap_write_and_wait_range+0x50/0x70
[ 2918.692633]  [<ffffffff81238671>] ext4_sync_file+0x71/0x350
[ 2918.693440]  [<ffffffff811ca7eb>] vfs_fsync+0x2b/0x40
[ 2918.694233]  [<ffffffff81170835>] sys_msync+0x145/0x1c0
[ 2918.695013]  [<ffffffff816f27d9>] system_call_fastpath+0x16/0x1b
[ 2918.695792] ---[ end trace a322ff0e61019890 ]---



