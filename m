From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 bigalloc] e2fsprogs: remove wrong EXT2FS_C2B in
 check_block_end
Date: Wed, 10 Aug 2011 22:49:33 -0400
Message-ID: <20110811024933.GC3625@thunk.org>
References: <1312429682-16970-1-git-send-email-hao.bigrat@gmail.com>
 <1312429682-16970-2-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37690 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab1HKCtf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 22:49:35 -0400
Content-Disposition: inline
In-Reply-To: <1312429682-16970-2-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 04, 2011 at 11:48:02AM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> The argument "save_blocks_count" and the block bitmap has the unit of cluster,
> so it don't need EXT2FS_C2B to convert argument "i".
> 
> This patch is based on "next" branch of e2fsprogs.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Cc: Ted Ts'o <tytso@mit.edu>

No, I don't think this is right.  Regardless of whether the unit of
the block bitmap is cluster- or block- (only while mke2fs is running,
and only initially) based, the argument to
ext2fs_{test,mark,unmark}_block_bitmap is always in blocks.

That's why the EXT2FS_C2B is necessary.

					- Ted
