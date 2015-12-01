From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: ext4 endless "orphan list check failed!" spew/lockup
Date: Tue, 1 Dec 2015 18:30:54 +0100
Message-ID: <565DD94E.60106@oracle.com>
References: <565DCDFC.3010300@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20388 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbbLARbB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Dec 2015 12:31:01 -0500
In-Reply-To: <565DCDFC.3010300@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/01/2015 05:42 PM, Vegard Nossum wrote:
> Mounting the attached filesystem image (fuzzed) on latest linus/master
> causes an endless stream of the following output on the console:
>
> EXT4-fs (loop0): Inode 5 (ffff8800153ed720): orphan list check failed!

Just wanted to add that on a kernel with linked list debugging I also
see an endless stream of the following warning, which could be related?

WARNING: CPU: 0 PID: 924 at lib/list_debug.c:36 __list_add+0xf9/0x100()
list_add double add: new=00000000dfba0070, prev=00000000dffba970, 
next=00000000dfba0070.
CPU: 0 PID: 924 Comm: mount.exe Tainted: G        W       4.4.0-rc3 #1
Stack:
  df7f59b0 60075642 6071c3ae 00000009
  df7f5a30 600bc4fe df7f59c0 603f1e5f
  df7f5a20 600412cd df7f59e0 6040d859
Call Trace:
  [<60029f9b>] show_stack+0xdb/0x1a0
  [<603f1e5f>] dump_stack+0x2a/0x3b
  [<600412cd>] warn_slowpath_common+0x9d/0xf0
  [<600413f4>] warn_slowpath_fmt+0x94/0xa0
  [<6040d859>] __list_add+0xf9/0x100
  [<601b28d4>] ext4_fill_super+0x3e04/0x4040
  [<601094ce>] mount_bdev+0x1fe/0x230
  [<601a7425>] ext4_mount+0x45/0x50
  [<60109763>] mount_fs+0x33/0x210
  [<60128fc4>] vfs_kern_mount+0x74/0x170
  [<6012a900>] do_mount+0x260/0x1010
  [<6012bb9b>] SyS_mount+0xab/0x120

Unfortunately I don't have the debug info anymore, but I could try to
rebuild and see if it triggers again if necessary.

Thanks,


Vegard
