From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [3/3] libext2fs: pick out UNINIT-EXTENT block
Date: Tue, 31 May 2011 19:56:41 -0400
Message-ID: <20110531235641.GA2864@thunk.org>
References: <1296368914-14079-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@google.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36905 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161012Ab1FACW1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 May 2011 22:22:27 -0400
Content-Disposition: inline
In-Reply-To: <1296368914-14079-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 29, 2011 at 08:28:34PM -0000, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> for display UNINIT-EXTENT block usage in dumpe2fs, modify 
> ext2fs_block_iterate3 to distinguish between uninitial extent
> block and normal extent block
> 
> Signed-off-by: Robing Dong <sanbai@taobao.com>
> 
> ---
> lib/ext2fs/block.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
> index 0e4ec77..c7a60da 100644
> --- a/lib/ext2fs/block.c
> +++ b/lib/ext2fs/block.c
> @@ -458,7 +458,7 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
>  			     blk++, blockcnt++, j++) {
>  				new_blk = blk;
>  				r = (*ctx.func)(fs, &new_blk, blockcnt,
> -						0, 0, priv_data);
> +						extent.e_flags, 0, priv_data);

Apologies for not getting back to this earlier, but I don't want to
overload the ref_blk field, since it will have a very different
meaning for extent-mapped and files mapped using the traditional
indirect block scheme.  This could potentially confuse callers who
don't know about extents.

Programs that want to find out about the uninitialized extent flag,
should use the extent iterator functions.

As far as the other patches in this series, I'm concerned that
dumpe2fs -s is going to confuse users more than anything else.

	       	     		      	   - Ted
