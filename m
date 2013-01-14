From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] mke2fs: reduce the range of cluster-size
Date: Mon, 14 Jan 2013 16:03:49 -0500
Message-ID: <20130114210349.GB8049@thunk.org>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
 <1358068095-9034-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43337 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab3ANVDy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 16:03:54 -0500
Content-Disposition: inline
In-Reply-To: <1358068095-9034-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 13, 2013 at 05:08:14PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> There are two bugs need to be fixed, which are about cluster-size.
> Now the range of cluster-size is from 1024 to 512M bytes.  Although
> with '-C 1024', the cluster-size will be 4096 after making a
> filesystem because in ext2fs_initialize() set_field() needs to check
> 'param->s_log_cluster_size' and s_log_cluster_size is 0 as
> cluster-size is 1024.  Then s_log_cluster_size will be assigned to
> s_log_block_size+4.  So we never set cluster-size to 1024.
> 
> Another bug is that when cluster-size is 512M EXT2FS_C2B will return
> 0.  So s_blocks_per_group will be assigned to zero and we will meet
> a 'division by zero' error.

There are a couple of things going on here.  The first is that it
makes no senes when the cluster size is less than or equal to the
block size.  (Actually, nothing bad should happen in the case when the
cluster size == block size, but if the user specified the bigalloc
feature, that's something which they almost certainly don't want.)

So the more general check is we should be complaining if the cluster
size is <= the block size.  That is, the combination of -b 4096 and -C
2048 makes no sense, either.

Also, there's technically nothing wrong with a cluster size of 512MB.
The problem is in how we calculate the default number of clusters per
group --- if it translates to a number of blocks per group which
overals 2**32, that's when we run into problems.

Which leads to another bug in the current mke2fs command.  The range
checking for the -g (which allows you to specify the number of blocks
per group is bogus in the case when the bigalloc feature is enabled).
I think the best way of fixing this is to document that the -g option
specifies the number of clusters per block if the bigalloc feature is
enabled.

						- Ted
