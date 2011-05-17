From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] NULL pointer when make_indexed_dir returns -ENOSPC
Date: Tue, 17 May 2011 19:44:49 +0200
Message-ID: <20110517174449.GB30519@quack.suse.cz>
References: <4DCC1FF8.6040103@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48432 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab1EQRpN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 13:45:13 -0400
Content-Disposition: inline
In-Reply-To: <4DCC1FF8.6040103@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 12-05-11 10:59:20, Allison Henderson wrote:
> I wasnt sure if people were expecting a v2 for this one, but I
> noticed the modified version of v1 was removed from the tree, so I
> am assuming we needed v2?  This one handles marking the buffer dirty
> before calling do split to avoid the null pointer.  It introduces a
> little overhead, but the only other option would be to introduce a
> new flag set to do_split.  But if there's any one that would prefer
> the flags to this solution, please let me know.  Thx! :)
  The patch looks OK. Just please CC me next time - a) because ext3 needs a
similar fix (added now) and b) because I was involved with the previous
patch version. Thanks!

								Honza
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> 
> ---
> :100644 100644 3c7a06e... b754b77... M	fs/ext4/namei.c
>  fs/ext4/namei.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3c7a06e..b754b77 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1413,6 +1413,10 @@ static int make_indexed_dir(handle_t *handle,
> struct dentry *dentry,
>  	frame->at = entries;
>  	frame->bh = bh;
>  	bh = bh2;
> +
> +	ext4_handle_dirty_metadata(handle, dir, frame->bh);
> +	ext4_handle_dirty_metadata(handle, dir, bh);
> +
>  	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
>  	if (!de) {
>  		/*
> @@ -1421,8 +1425,6 @@ static int make_indexed_dir(handle_t *handle,
> struct dentry *dentry,
>  		 * with corrupted filesystem.
>  		 */
>  		ext4_mark_inode_dirty(handle, dir);
> -		ext4_handle_dirty_metadata(handle, dir, frame->bh);
> -		ext4_handle_dirty_metadata(handle, dir, bh);
>  		dx_release(frames);
>  		return retval;
>  	}
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
