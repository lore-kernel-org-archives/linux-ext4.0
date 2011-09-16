From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix the range validation in bitmap_range2
 funcs
Date: Thu, 15 Sep 2011 22:23:59 -0400
Message-ID: <20110916022359.GO28181@thunk.org>
References: <1308064592-29935-1-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: amir73il@users.sourceforge.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45023 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab1IPCYB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 22:24:01 -0400
Content-Disposition: inline
In-Reply-To: <1308064592-29935-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 14, 2011 at 06:16:32PM +0300, amir73il@users.sourceforge.net wrote:
> From: Amir Goldstein <amir73il@users.sf.net>
> 
> The condition ((start+num) & ~0xffffffffULL) in bitmap_ragne2
> and generic_bmap_range funcs in get_bitmap64.c was wrong and
> inconsistent with the condition (start+num-1 > bmap->real_end)
> in generic_bitmap_range funcs in get_bitmap.c.
> 
> I got the following error from tune2fs on a 16TB fs:
> Illegal block number passed to ext2fs_unmark_block_bitmap #4294967295
> for block bitmap for 16TB.img
> tune2fs: Invalid argument while reading bitmaps
> 
> Fix to condition to ((start+num-1) & ~0xffffffffULL), because
> the bit (start+num) is not going to be changed by the funcs.
> 
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

Applied, thanks.

						- Ted
