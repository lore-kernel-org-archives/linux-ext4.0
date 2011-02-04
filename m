From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Adjust trim start with first_data_block.
Date: Fri, 4 Feb 2011 00:40:12 -0500
Message-ID: <20110204054012.GD2623@thunk.org>
References: <1295618707-3677-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48261 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab1BDFkR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Feb 2011 00:40:17 -0500
Content-Disposition: inline
In-Reply-To: <1295618707-3677-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 21, 2011 at 10:05:07PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> As we have make the consense in the e-mail[1], the trim start should
> be added with first_data_block. So this patch fulfill it and remove
> the check for start < first_data_block.

> 
> [1] http://www.spinics.net/lists/linux-ext4/msg22737.html
> 

Sorry, I was away at Linux.conf.au and didn't have a chance to respond
this.

Fundamentally I think we need to understand what the arguments to the
trim ioctl is supposed to *mean*.  Are they supposed to be physical
block numbers, or some thing else?  If we just bump everything by the
first_data_block, (which is non-zero only for the 1k case), that will
screw up the length argument, because the userspace program isn't
going to know that (a) the file system is using 1k blocks, and (b) on
ext2/3/4 that means that first_data_block is 1.

So instead of saying that the arguments to trim mean "the data blocks"
--- which is a concept that doesn't really have any meaning to the
caller of the trim ioctl, without forcing it to know a lot more about
the physical layout of filesystems, I think the argument to trim
should be the physical block numbers.

And just as we don't trim blocks that contain data that should be
saved, we should just simply not trim block #0 (the boot block) and
and block #1 (the superblock) on 1k block filesystems, and not trim
block #0 (the boot block as well as the superblock) on 4k block
filesystems.  But we shouldn't be doing this by taking block number
passed to trim and just adding first_data_block to it.

I know a patch to do that has already merged into ext3, but with the
indulgence of the folks on linux-ext4, could we reopen this question?

Thanks,

						- Ted
