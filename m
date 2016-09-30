From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: release bh in make_indexed_dir
Date: Thu, 29 Sep 2016 21:45:19 -0400
Message-ID: <20160930014519.gj2guv4pbnt5mz34@thunk.org>
References: <1475170590.1830.13.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz
To: gmail <yngsion@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46950 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932838AbcI3Bp3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Sep 2016 21:45:29 -0400
Content-Disposition: inline
In-Reply-To: <1475170590.1830.13.camel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 30, 2016 at 01:36:30AM +0800, gmail wrote:
> The commit 6050d47adcad
> ("ext4: bail out from make_indexed_dir() on first error")
> miss to release bh in make_indexed_dir.
> 
> Signed-off-by: yangsheng <yngsion@gmail.com>

There's no missing brelse() as far as I can see.  bh is assigned to
frame->bh, and the call to dx_release(frames) will release bh.

	       	   	   		      	   - Ted

> ---
>  fs/ext4/namei.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 38ca0fe..465f960 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2058,19 +2058,18 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
>  		retval = PTR_ERR(de);
>  		goto out_frames;
>  	}
> -	dx_release(frames);
>  
>  	retval = add_dirent_to_buf(handle, fname, dir, inode, de, bh);
> -	brelse(bh);
> -	return retval;
>  out_frames:
>  	/*
>  	 * Even if the block split failed, we have to properly write
>  	 * out all the changes we did so far. Otherwise we can end up
>  	 * with corrupted filesystem.
>  	 */
> -	ext4_mark_inode_dirty(handle, dir);
> +	if (retval)
> +		ext4_mark_inode_dirty(handle, dir);
>  	dx_release(frames);
> +	brelse(bh);
>  	return retval;
>  }
>  
> 
> 
