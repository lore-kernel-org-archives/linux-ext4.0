From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: return non-zero st_blocks for inline data
Date: Thu, 7 Nov 2013 22:45:04 -0500
Message-ID: <20131108034504.GC11668@thunk.org>
References: <1383734552-12991-1-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55546 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab3KHDpI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Nov 2013 22:45:08 -0500
Content-Disposition: inline
In-Reply-To: <1383734552-12991-1-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 06, 2013 at 03:42:32AM -0700, Andreas Dilger wrote:
> @@ -4542,9 +4551,9 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
>  	 * blocks for this file.
>  	 */
>  	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
> -				EXT4_I(inode)->i_reserved_data_blocks);
> +				   EXT4_I(inode)->i_reserved_data_blocks);
> +	stat->blocks += delalloc_blocks << (inode->i_sb->s_blocksize_bits - 9);
>  
> -	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;

Why this change to the calculation to stat->blocks?

    	 	       		      - Ted
