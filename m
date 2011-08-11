From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 bigalloc] e2fsprogs: use s_log_block_size to decide
 s_first_data_block in ext2fs_initialize
Date: Wed, 10 Aug 2011 23:23:43 -0400
Message-ID: <20110811032343.GG3625@thunk.org>
References: <1312518471-30714-1-git-send-email-hao.bigrat@gmail.com>
 <1312518471-30714-2-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44066 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423Ab1HKDXu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 23:23:50 -0400
Content-Disposition: inline
In-Reply-To: <1312518471-30714-2-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 05, 2011 at 12:27:51PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> After mke2fs with 1024 block size:
> 
> #misc/mke2fs -m 0 -O ^resize_inode,extent,meta_bg,bigalloc -b 1024 /dev/sda
> 
> kernel reports:
> 
> [74687.352702] EXT4-fs (loop0): ext4_check_descriptors: Inode bitmap for group 0 not in group (block 524288)!
> [74687.355534] EXT4-fs (loop0): group descriptors corrupted!
> 
> when mount /dev/sda.

Wow, out of curiosity, why are you using a 1k block size?

Actually, the bug here is in the kernel (in complaining), not in
e2fsprogs.  The only time we want s_first_data_block to be 1 is in the
case when block size and cluster is 1024.

In the case where the cluster is greater than 1k, we want to keep the
clusters aligned (for efficiency with 4k blocksize disks if for no
other reason).  Since the superblock is located at a 1k offset,
cluster #0 will always be reserved, so the first 1k is already
reserved for use by the bootloader.

					- Ted
