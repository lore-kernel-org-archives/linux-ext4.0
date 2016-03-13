From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] ext4: fix NULL pointer dereference in
 ext4_mark_inode_dirty()
Date: Sun, 13 Mar 2016 15:07:45 +0800
Message-ID: <20160313070744.GH4672@eguan.usersys.redhat.com>
References: <1457710733-10192-1-git-send-email-guaneryu@gmail.com>
 <20160313023922.GA29218@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34598 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbcCMHHw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Mar 2016 03:07:52 -0400
Received: by mail-pa0-f67.google.com with SMTP id hj7so11782499pac.1
        for <linux-ext4@vger.kernel.org>; Sat, 12 Mar 2016 23:07:51 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160313023922.GA29218@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 12, 2016 at 09:39:22PM -0500, Theodore Ts'o wrote:
> On Fri, Mar 11, 2016 at 11:38:53PM +0800, Eryu Guan wrote:
> > ext4_reserve_inode_write() in ext4_mark_inode_dirty() could fail on
> > error (e.g. EIO) and iloc.bh can be NULL in this case. But the error is
> > ignored in the following "if" condition and ext4_expand_extra_isize()
> > might be called with NULL iloc.bh set, which triggers NULL pointer
> > dereference.
> 
> Nice catch!  I'm going fix this slightly differently (although I'll
> keep your description).  The patch is a wee bit bigger, but the end
> result is simpler to read.

Yes, it's more easier to read. Thanks!

Eryu

> 
> Thanks,
> 
> 						- Ted
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce2c4c6..b41432e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5312,6 +5312,8 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
>  	might_sleep();
>  	trace_ext4_mark_inode_dirty(inode, _RET_IP_);
>  	err = ext4_reserve_inode_write(handle, inode, &iloc);
> +	if (err)
> +		return err;
>  	if (ext4_handle_valid(handle) &&
>  	    EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
>  	    !ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
> @@ -5342,9 +5344,7 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
>  			}
>  		}
>  	}
> -	if (!err)
> -		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
> -	return err;
> +	return ext4_mark_iloc_dirty(handle, inode, &iloc);
>  }
>  
>  /*
