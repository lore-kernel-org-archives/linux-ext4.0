From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, E2FSPROGS] ext2fs_set_gdt_csum(): Return an error code
	on errors instead of void
Date: Mon, 31 Mar 2008 19:53:49 -0400
Message-ID: <20080331235349.GE11828@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int> <1207006592-13980-1-git-send-email-tytso@mit.edu> <1207006592-13980-2-git-send-email-tytso@mit.edu> <1207006592-13980-3-git-send-email-tytso@mit.edu> <1207006592-13980-4-git-send-email-tytso@mit.edu> <1207006592-13980-5-git-send-email-tytso@mit.edu> <1207006592-13980-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33684 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbYDAACj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 20:02:39 -0400
Content-Disposition: inline
In-Reply-To: <1207006592-13980-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 31, 2008 at 07:36:27PM -0400, Theodore Ts'o wrote:
> From: Andreas Dilger <adilger@dilger.ca>
> 
> Change the function signature so that ext2fs_set_gdt_csum() returns an
> error code.
> 
> If the inode bitmap hasn't been loaded return EXT2_ET_NO_INODE_BITMAP.

This was a much safer way of handling the case where the inode bitmap
isn't loaded, instead of just forcing bg_itable_uninit to 0.

      	      	      	      	      		       	  - Ted
