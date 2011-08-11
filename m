From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 bigalloc] ext4: modify offset to cluster in
 ext4_valid_block_bitmap
Date: Wed, 10 Aug 2011 22:51:52 -0400
Message-ID: <20110811025152.GD3625@thunk.org>
References: <1312429682-16970-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37694 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab1HKCvy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 22:51:54 -0400
Content-Disposition: inline
In-Reply-To: <1312429682-16970-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 04, 2011 at 11:48:01AM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> When I run a test application on ext4 of bigalloc, and also a daemon
> which run "echo 3 > /proc/sys/vm/drop_caches" every 2 seconds,
> the kernel report:
> 
> 15319.557145] EXT4-fs error (device sda4): ext4_valid_block_bitmap:324: comm dir_tree: Invalid block bitmap - block_group = 6, block = 3145730
> 
> The reason is ext4_valied_block_bitmap has not be modified for cluster.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Cc: Ted Ts'o <tytso@mit.edu>

Yep, this looks like a bug --- I'm curious, though --- this is
something I don't run into because I use mke2fs -t ext4 which sets the
flex_bg feature.  Is there some reason you're not using flex_bg on
your file systems?

					- Ted
