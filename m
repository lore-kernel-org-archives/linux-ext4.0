From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH] ext4: verify extent header depth
Date: Thu, 7 Jul 2016 00:23:44 +0200
Message-ID: <577D84F0.8060700@oracle.com>
References: <1467840431-24550-1-git-send-email-vegard.nossum@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18578 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbcGFWXy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2016 18:23:54 -0400
In-Reply-To: <1467840431-24550-1-git-send-email-vegard.nossum@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/06/2016 11:27 PM, Vegard Nossum wrote:
> According to the wiki [1], eh_depth cannot be larger than 5:
>
>      Depth of this extent node in the extent tree. 0 = this extent node
>      points to data blocks; otherwise, this extent node points to other
>      extent nodes. The extent tree can be at most 5 levels deep: a logical
>      block number can be at most 2^32, and the smallest n that satisfies
>      4*(((blocksize - 12)/12)^n) >= 2^32 is 5.
>
> [1]: https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Extent_Tree
>
> Without this, we can end up trying to reserve too much space for the
> transaction in case of malicious corruption (here, eh_depth = 65280):
>
>      JBD2: ext4.exe wants too many credits credits:195849 rsv_credits:0 max:256
>      ------------[ cut here ]------------
>      WARNING: CPU: 0 PID: 50 at fs/jbd2/transaction.c:293 start_this_handle+0x569/0x580
 >      CPU: 0 PID: 50 Comm: ext4.exe Not tainted 4.7.0-rc5+ #508

I'm guessing this would also fix another warning I saw earlier:

WARNING: CPU: 0 PID: 50 at mm/page_alloc.c:3584 
__alloc_pages_nodemask+0x3c9/0xd20
CPU: 0 PID: 50 Comm: ext4.exe Not tainted 4.7.0-rc3 #1
Stack:
  62629550 6005c7c2 03800000 600801f9
  00000000 600760ce 62629560 601dbff1
  626295c0 6002beb4 800000074786574 900000e00
Call Trace:
  [<6001834b>] show_stack+0xdb/0x1a0
  [<601dbff1>] dump_stack+0x2a/0x39
  [<6002beb4>] __warn+0x114/0x140
  [<6002c02f>] warn_slowpath_null+0x1f/0x30
  [<600801f9>] __alloc_pages_nodemask+0x3c9/0xd20
  [<60080e3c>] alloc_kmem_pages+0x1c/0x20
  [<60096fea>] kmalloc_order+0x1a/0x60
  [<600af518>] __kmalloc+0x1a8/0x1f0
  [<6014dd09>] ext4_find_extent+0x3a9/0x420
  [<60152df3>] ext4_ext_map_blocks+0x73/0x28d0
  [<6011fc22>] ext4_map_blocks+0x612/0x980
  [<6012002c>] _ext4_get_block+0x9c/0x150
  [<60120120>] ext4_get_block+0x40/0x50
  [<600edc2a>] generic_block_bmap+0x3a/0x40
  [<6011bd4f>] ext4_bmap+0xcf/0x190
  [<600d430a>] bmap+0x1a/0x30
  [<6018bd41>] jbd2_journal_bmap+0x31/0xa0
  [<6018c0c5>] jbd2_journal_init_inode+0x135/0x220
  [<60143945>] ext4_fill_super+0x3085/0x4b60
  [<600b794b>] mount_bdev+0x1fb/0x230
  [<6013a865>] ext4_mount+0x45/0x50
  [<600b7bd3>] mount_fs+0x33/0x210
  [<600d9834>] vfs_kern_mount+0x74/0x170
  [<600db34b>] do_mount+0x26b/0x10c0
  [<600dc6a0>] SyS_mount+0xc0/0x130

...since this is ext4_find_extent() doing

depth = ext_depth(inode)
path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 2), GFP_NOFS);


Vegard
