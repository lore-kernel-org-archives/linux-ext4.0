From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] mke2fs: reduce the range of cluster-size
Date: Mon, 14 Jan 2013 14:07:43 -0700
Message-ID: <74DCD2E2-28B9-4AA0-AE23-177202C49686@dilger.ca>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com> <1358068095-9034-2-git-send-email-wenqing.lz@taobao.com> <20130114210349.GB8049@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:42644 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab3ANVIy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2013 16:08:54 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so1999193dak.39
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jan 2013 13:08:53 -0800 (PST)
In-Reply-To: <20130114210349.GB8049@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-01-14, at 2:03 PM, Theodore Ts'o wrote:
> On Sun, Jan 13, 2013 at 05:08:14PM +0800, Zheng Liu wrote:
>> From: Zheng Liu <wenqing.lz@taobao.com>
>> 
>> There are two bugs need to be fixed, which are about cluster-size.
>> Now the range of cluster-size is from 1024 to 512M bytes.  Although
>> with '-C 1024', the cluster-size will be 4096 after making a
>> filesystem because in ext2fs_initialize() set_field() needs to check
>> 'param->s_log_cluster_size' and s_log_cluster_size is 0 as
>> cluster-size is 1024.  Then s_log_cluster_size will be assigned to
>> s_log_block_size+4.  So we never set cluster-size to 1024.
>> 
>> Another bug is that when cluster-size is 512M EXT2FS_C2B will return
>> 0.  So s_blocks_per_group will be assigned to zero and we will meet
>> a 'division by zero' error.
> 
> There are a couple of things going on here.  The first is that it
> makes no senes when the cluster size is less than or equal to the
> block size.  (Actually, nothing bad should happen in the case when
> cluster size == block size, but if the user specified the bigalloc
> feature, that's something which they almost certainly don't want.)
> 
> So the more general check is we should be complaining if the cluster
> size is <= the block size.  That is, the combination of -b 4096 and
> -C 2048 makes no sense, either.
> 
> Also, there's technically nothing wrong with a cluster size of 512MB.
> The problem is in how we calculate the default number of clusters per
> group --- if it translates to a number of blocks per group which
> overals 2**32, that's when we run into problems.
> 
> Which leads to another bug in the current mke2fs command.  The range
> checking for the -g (which allows you to specify the number of blocks
> per group is bogus in the case when the bigalloc feature is enabled).
> I think the best way of fixing this is to document that the -g option
> specifies the number of clusters per block if the bigalloc feature is
> enabled.

Presumably you mean "the -g option specifies the number of clusters
_per_group_ if the bigalloc feature is enabled"?

Cheers, Andreas





