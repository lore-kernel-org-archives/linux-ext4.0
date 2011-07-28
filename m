From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add missing cast in ext4_fallocate
Date: Wed, 27 Jul 2011 22:12:11 -0400
Message-ID: <20110728021211.GD3133@thunk.org>
References: <4E2D1C5D.6070103@wm.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56200 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1G1CMQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jul 2011 22:12:16 -0400
Content-Disposition: inline
In-Reply-To: <4E2D1C5D.6070103@wm.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 25, 2011 at 04:33:49PM +0900, Utako Kusaka wrote:
> Cast map.m_lblk to loff_t.
> 
> File size is corrupt when we get an ENOSPC.
> Logical block number is __u32, so new_size will be set to overflowed value.
> 
> # df -T /mnt/mp1
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/sda6     ext4     9843276    153056   9190200   2% /mnt/mp1
> # fallocate -o 0 -l 2199023251456 /mnt/mp1/testfile
> fallocate: /mnt/mp1/testfile: fallocate failed: No space left on device
> # stat /mnt/mp1/testfile
>   File: `/mnt/mp1/testfile'
>   Size: 4293656576	Blocks: 19380440   IO Block: 4096   regular file
> Device: 806h/2054d	Inode: 12          Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2011-07-25 13:01:31.414490496 +0900
> Modify: 2011-07-25 13:01:31.414490496 +0900
> Change: 2011-07-25 13:01:31.454490495 +0900
> 
> Signed-off-by: Utako Kusaka <u-kusaka@wm.jp.nec.com>

Thanks, added to the ext4 tree.

						- Ted
