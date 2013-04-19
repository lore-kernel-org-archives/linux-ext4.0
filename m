From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v3] ext4: move quota initialization out of inode
 allocation transaction
Date: Fri, 19 Apr 2013 16:30:28 +0200
Message-ID: <20130419143028.GA26647@quack.suse.cz>
References: <20130418214631.GA19244@quack.suse.cz>
 <1366327444-6123-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030473Ab3DSOab (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 10:30:31 -0400
Content-Disposition: inline
In-Reply-To: <1366327444-6123-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Still not quite...

On Thu 18-04-13 19:24:04, Ted Tso wrote:
> @@ -951,24 +971,17 @@ got:
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
> -	inode->i_flags |= S_NOQUOTA;
>  	clear_nlink(inode);
>  	unlock_new_inode(inode);
> +out:
> +	inode->i_flags |= S_NOQUOTA;
> +	dquot_drop(inode);
  The above two lines have to be swapped to preserve original ordering
which is actually important. Thanks.

									Honza
>  	iput(inode);
>  	brelse(inode_bitmap_bh);
>  	return ERR_PTR(err);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
