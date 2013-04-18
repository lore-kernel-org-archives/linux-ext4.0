From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Move quota initialization out of inode
 allocation transaction
Date: Thu, 18 Apr 2013 23:46:31 +0200
Message-ID: <20130418214631.GA19244@quack.suse.cz>
References: <1365496448-9907-1-git-send-email-jack@suse.cz>
 <1365496448-9907-2-git-send-email-jack@suse.cz>
 <20130409164237.GC5980@thunk.org>
 <20130418190738.GB5588@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936039Ab3DRVqk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Apr 2013 17:46:40 -0400
Content-Disposition: inline
In-Reply-To: <20130418190738.GB5588@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-04-13 15:07:38, Ted Tso wrote:
> On Tue, Apr 09, 2013 at 12:42:37PM -0400, Theodore Ts'o wrote:
> > 
> > Thanks, added to the dev branch for testing.
> > 
> 
> This patch was causing a reliable failure for xfstests generic/083
> using bigalloc.  I bisected down this patch, and then localized the
> failure down to the insert_inode_locked() call in __ext4_new_inode()
> failing (which means that there is an old inode in the inode hash
> lists with the same inode number)
> 
> The error seems to be caused by the error handling code paths.  I
> believe the problem was caused by clear_nlink() and unlock_new_inode()
> getting called in some error cleanup paths when the inode that hadn't
> yet been inserted into inode hash lists.
> 
> Here is a revamped patch which has a cleaned up set of error paths.
> The only change is in the cleanup paths, and this causes the
> generic/083 test for bigalloc to pass where it was previously failing.
  Thanks for catching this. But there's a bug in the new error handling as
well:

> @@ -733,13 +750,17 @@ repeat_in_this_group:
>  							 handle_type, nblocks);
>  			if (IS_ERR(handle)) {
>  				err = PTR_ERR(handle);
> -				goto fail;
> +				ext4_std_error(sb, err);
> +				goto out;
>  			}
> +
  Extra empty line...

> @@ -951,24 +972,17 @@ got:
>  
>  	ext4_debug("allocating inode %lu\n", inode->i_ino);
>  	trace_ext4_allocate_inode(inode, dir, mode);
> -	goto really_out;
> -fail:
> -	ext4_std_error(sb, err);
> -out:
> -	iput(inode);
> -	ret = ERR_PTR(err);
> -really_out:
>  	brelse(inode_bitmap_bh);
>  	return ret;
>  
>  fail_free_drop:
>  	dquot_free_inode(inode);
> -
>  fail_drop:
> -	dquot_drop(inode);
>  	inode->i_flags |= S_NOQUOTA;
>  	clear_nlink(inode);
>  	unlock_new_inode(inode);
> +out:
> +	dquot_drop(inode);
>  	iput(inode);
>  	brelse(inode_bitmap_bh);
>  	return ERR_PTR(err);
  You need to move
  	inode->i_flags |= S_NOQUOTA;
  along with dquot_drop() call as dquot_drop() will do nothing on an inode
marked with S_NOQUOTA so we leak dquot references...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
