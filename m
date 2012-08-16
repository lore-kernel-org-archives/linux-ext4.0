From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Thu, 16 Aug 2012 19:10:51 +0800
Message-ID: <20120816111051.GA16036@localhost>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab2HPLgZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Aug 2012 07:36:25 -0400
Content-Disposition: inline
In-Reply-To: <20120816024654.GB3781@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2432,6 +2432,10 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>  
>  	/* the header must be checked already in ext4_ext_remove_space() */
>  	ext_debug("truncate since %u in leaf to %u\n", start, end);
> +	if (!path[depth].p_hdr && !path[depth].p_bh) {
> +		EXT4_ERROR_INODE(inode, "depth %d", depth);
> +		BUG_ON(1);
> +	}
>  	if (!path[depth].p_hdr)
>  		path[depth].p_hdr = ext_block_hdr(path[depth].p_bh);
>  	eh = path[depth].p_hdr;
> @@ -2730,6 +2734,10 @@ cont:
>  		/* this is index block */
>  		if (!path[i].p_hdr) {
>  			ext_debug("initialize header\n");
> +			if (!path[i].p_hdr && !path[i].p_bh) {
> +				EXT4_ERROR_INODE(inode, "i=%d", i);
> +				BUG_ON(1);
> +			}
>  			path[i].p_hdr = ext_block_hdr(path[i].p_bh);
>  		}
>  

Here is the dmesg. BTW, it seems 3.5.0 don't have this issue.

[  640.266836] EXT4-fs error (device md0): ext4_ext_remove_space:2694: inode #12: comm rm: i=1
[  640.275701] ------------[ cut here ]------------
[  640.276684] kernel BUG at /c/wfg/tip/fs/ext4/extents.c:2695!
[  640.276684] invalid opcode: 0000 [#1] SMP
[  640.276684] Modules linked in:
[  640.276684] CPU 7
[  640.276684] Pid: 4079, comm: rm Not tainted 3.6.0-rc1+ #3 Supermicro X7DW3/X7DWN
[  640.276684] RIP: 0010:[<ffffffff811f8980>]  [<ffffffff811f8980>] ext4_ext_remove_space+0x86e/0xbee
[  640.276684] RSP: 0018:ffff88021e749cb8  EFLAGS: 00010287
[  640.276684] RAX: ffff880221072000 RBX: ffff88020fc680d0 RCX: 0000000000000092
[  640.276684] RDX: 0000000000003c3c RSI: 0000000000000092 RDI: ffff880221073800
[  640.276684] RBP: ffff88021e749d98 R08: ffffffff81f6ea88 R09: 0000000000000000
[  640.276684] R10: ffffffff81f19a30 R11: 0000000000000647 R12: ffff880222385840
[  640.276684] R13: 0000000000000001 R14: 0000000000000001 R15: ffff880222385870
[  640.276684] FS:  00007f4461203700(0000) GS:ffff88022f5c0000(0000) knlGS:0000000000000000
[  640.276684] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  640.276684] CR2: 00007f4460cf761d CR3: 000000022115c000 CR4: 00000000000007e0
[  640.276684] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  640.276684] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  640.276684] Process rm (pid: 4079, threadinfo ffff88021e748000, task ffff8802236d2e80)
[  640.276684] Stack:
[  640.276684]  ffffffff819caec0 ffff880220901390 ffff88020fc680d0 ffff880220901390
[  640.276684]  ffff88020fc25750 0000000000790000 ffff88021e749d38 ffffffff811d6b05
[  640.276684]  8000880200000000 ffff88020fc68000 ffff880221072000 ffff8802223858a0
[  640.276684] Call Trace:
[  640.276684]  [<ffffffff811d6b05>] ? ext4_mark_iloc_dirty+0x47a/0x557
[  640.276684]  [<ffffffff811fa6ab>] ext4_ext_truncate+0xd8/0x176
[  640.276684]  [<ffffffff811d6de8>] ? ext4_mark_inode_dirty+0x17e/0x1c0
[  640.276684]  [<ffffffff811d4934>] ext4_truncate+0x7a/0xca
[  640.276684]  [<ffffffff811d8aa2>] ext4_evict_inode+0x2e9/0x422
[  640.276684]  [<ffffffff81163e17>] evict+0xae/0x163
[  640.276684]  [<ffffffff811640c4>] iput+0x1bb/0x1c3
[  640.276684]  [<ffffffff8115a2ca>] do_unlinkat+0x102/0x157
[  640.276684]  [<ffffffff813d550e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[  640.276684]  [<ffffffff8115bf97>] sys_unlinkat+0x22/0x2d
[  640.276684]  [<ffffffff81985229>] system_call_fastpath+0x16/0x1b
[  640.276684] Code: 75 33 49 8b 47 28 48 85 c0 75 22 45 89 e9 49 c7 c0 ce e8 d2 81 31 c9 ba 86 0a 00 00 48 c7 c6 80 fb 9c 81 48 89 df e8 eb 6c ff ff <0f> 0b 48 8b 40 28 49 89 47 20 49 8b 47 18 48 85 c0 75 1f 49 8b
[  640.276684] RIP  [<ffffffff811f8980>] ext4_ext_remove_space+0x86e/0xbee
[  640.276684]  RSP <ffff88021e749cb8>
[  640.530999] ---[ end trace e00762202fd8e8a0 ]---

Thanks,
Fengguang
