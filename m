From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 5/6] ext4: Drop i_state_flags on architectures with 64-bit longs
Date: Wed, 5 Jan 2011 11:43:08 -0700
Message-ID: <5A9C7BCF-AA25-494F-9C64-8A6553B44395@dilger.ca>
References: <1294189270-16733-1-git-send-email-tytso@mit.edu> <1294189270-16733-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:47378 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab1AESnK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jan 2011 13:43:10 -0500
In-Reply-To: <1294189270-16733-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-01-04, at 18:01, Theodore Ts'o wrote:
> +#if (BITS_PER_LONG < 64)
> +EXT4_INODE_BIT_FNS(state, state_flags, 0)
> +#define EXT4_CLEAR_STATE_FLAGS(ei)	(ei)->i_state_flags = 0
> +#else
> +EXT4_INODE_BIT_FNS(state, flags, 32)
> +#define EXT4_CLEAR_STATE_FLAGS(ei)	(ei)->i_flags = 0

This looks like it will clear all of the i_flags values, instead of just the
state flags.  It should probably be something like:

#define EXT4_CLEAR_STATE_FLAGS(ei)	(ei)->i_flags &= 0xffffffffULL;

> @@ -1009,6 +1009,7 @@ got:
> 	 * extent flag on newly created directory and file only if -o extent
> 	 * mount option is specified
> 	 */
> +	EXT4_CLEAR_STATE_FLAGS(ei);
> 	ei->i_flags =
> 		ext4_mask_flags(mode, EXT4_I(dir)->i_flags & EXT4_FL_INHERITED);
> 	ei->i_file_acl = 0;
> @@ -1027,7 +1028,6 @@ got:
> 	inode->i_generation = sbi->s_next_generation++;
> 	spin_unlock(&sbi->s_next_gen_lock);
> 
> -	ei->i_state_flags = 0;

It looks like you have compensated for the above by changing the
code here, but I think it is risky/confusing if clearing the state
flags has a side-effect on 64-bit arches, that doesn't exist on
32-bit arches.  It looks like a bug waiting to happen...

Cheers, Andreas





