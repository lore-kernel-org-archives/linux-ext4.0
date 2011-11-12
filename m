From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix "Illegal block number" for
 scan_block_bitmap()
Date: Fri, 11 Nov 2011 21:16:13 -0500
Message-ID: <20111112021613.GG4055@thunk.org>
References: <1320927324-3613-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35119 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1KLFQN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Nov 2011 00:16:13 -0500
Content-Disposition: inline
In-Reply-To: <1320927324-3613-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 10, 2011 at 08:15:24PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> After:
> # mke2fs -O ^has_journal,^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,bigalloc /dev/sda
> # e2freefrag /dev/sda
> 
> It will report error message like:
> 
>  Illegal block number passed to ext2fs_test_block_bitmap #1732133 for block bitmap for /dev/sda
>  Illegal block number passed to ext2fs_test_block_bitmap #1732134 for block bitmap for /dev/sda
>  Illegal block number passed to ext2fs_test_block_bitmap #1732135 for block bitmap for /dev/sda
> 
> One bit in bitmap of bigalloc-ext4 means a cluster not a block, therefore ext2fs_fast_test_block_bitmap2
> should check cluster.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Thanks, applied.

						- Ted
