From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Checksum the block bitmap properly with bigalloc
 enabled.
Date: Mon, 22 Oct 2012 00:33:28 -0400
Message-ID: <20121022043328.GC4768@thunk.org>
References: <1350306093-2995-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56746 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab2JVEdf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2012 00:33:35 -0400
Content-Disposition: inline
In-Reply-To: <1350306093-2995-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2012 at 09:01:33PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In mke2fs, we only checksum the whole bitmap block and it is right.
> While in the kernel, we use EXT4_BLOCKS_PER_GROUP to indicate the
> size of the checksumed bitmap which is wrong when we enable bigalloc.
> The right size should be EXT4_CLUSTERS_PER_GROUP and this patch fixes
> it.
> 
> Also as every caller of ext4_block_bitmap_csum_set and
> ext4_block_bitmap_csum_verify pass in EXT4_BLOCKS_PER_GROUP(sb)/8,
> we'd better removes this parameter and sets it in the function itself.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, applied!

						- Ted
