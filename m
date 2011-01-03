From: Ted Ts'o <tytso@mit.edu>
Subject: Re: AW: Questions concerning ext2 filesystem:  ext2_statfs
Date: Mon, 3 Jan 2011 17:24:51 -0500
Message-ID: <20110103222451.GA2959@thunk.org>
References: <F6FD8E03-CEEF-4551-8164-C03492D25275@dilger.ca>
 <FPEIIEKCABPOOBGGCOCHOEMNDHAA.bjoern.slotkowski@imc-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Bjoern Slotkowski <bjoern.slotkowski@imc-berlin.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46963 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab1ACWYy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jan 2011 17:24:54 -0500
Content-Disposition: inline
In-Reply-To: <FPEIIEKCABPOOBGGCOCHOEMNDHAA.bjoern.slotkowski@imc-berlin.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 03, 2011 at 02:12:04PM +0100, Bjoern Slotkowski wrote:
> 
> But there is still one thing also in the newer kernel:
> f_bfree and f_ffree are determined by functions "ext2_count_free_blocks" and
> "ext2_count_free_inodes"
> which iterate through s_groups_count which needs a lot of time.
> 
> When I look at ext3/super.c and ext4/super.c the member variables
> s_freeblocks_counter and s_freeinodes_counter are used directly in functions
> *_statfs.
> 
> Probably there is potential for an optimization.

Perhaps, but note that ext4 is fully backwards compatible with ext2.
That is, you can mount ext2 file systems using the ext4 file system
driver.  (You can also mount ext2 file systems using the ext3 file
system, although you will have to add a journal to the file system
first.)

Ext2 is primarily useful as an working, example file system which
shows how to interface a file system to Linux.  As such piling in too
many optimizations isn't necessarily consistent with its current role.
No one is really actively maintaining ext2, except to update it work
with the latest kernel interfaces, so it's not clear who would do the
optimization.

If you want a faster, more efficient file system, there are plenty of
alternatives, including ext3 and ext4.

						- Ted
