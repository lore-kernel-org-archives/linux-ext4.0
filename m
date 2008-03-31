From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, E2FSPROGS] ext2fs_set_gdt_csum(): Force the last block
	group to have a valid block bitmap
Date: Mon, 31 Mar 2008 19:52:04 -0400
Message-ID: <20080331235204.GD11828@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int> <1207006592-13980-1-git-send-email-tytso@mit.edu> <1207006592-13980-2-git-send-email-tytso@mit.edu> <1207006592-13980-3-git-send-email-tytso@mit.edu> <1207006592-13980-4-git-send-email-tytso@mit.edu> <1207006592-13980-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33129 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbYCaX76 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:59:58 -0400
Content-Disposition: inline
In-Reply-To: <1207006592-13980-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 31, 2008 at 07:36:26PM -0400, Theodore Ts'o wrote:
> From: Andreas Dilger <adilger@dilger.ca>
> 
> Never set the UNINIT_BLOCKS flag for the last group since the kernel
> doesn't handle the case graefully if there is a full set of blocks in
> each blockgroup marked UNINIT_BLOCKS.  The kernel should be fixed up,
> but in the meantime this avoids hitting the problem, and is more
> consistent with lazy_bg not marking the last group UNINIT.

This is technically not necessary since we will only set UNINIT_BLOCKS
if the number of free blocks is equal to blocks_per_group minus
superblock_overhead.  So there was no danger in the existing codepath.
I think you did this because you were enforcing no UNINIT_BLOCKS in
the last group in e2fsck, instead of just checking to make sure the
free blocks equals the return value from ext2fs_super_and_bgd_loc().

     	    	       	      	    	 - Ted
