From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] Null Pointer when make_indexed_dir returns -ENOSPC
Date: Mon, 9 May 2011 13:03:29 +0200
Message-ID: <20110509110329.GF4122@quack.suse.cz>
References: <4DC5DBB3.9030207@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1EILDg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 07:03:36 -0400
Content-Disposition: inline
In-Reply-To: <4DC5DBB3.9030207@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 07-05-11 16:54:27, Allison Henderson wrote:
> Fix for a null pointer bug found while running punch hole tests
> 
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> ---
> :100644 100644 3c7a06e... 3302a6c... M	fs/ext4/namei.c
>  fs/ext4/namei.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3c7a06e..3302a6c 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1422,7 +1422,8 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
>  		 */
>  		ext4_mark_inode_dirty(handle, dir);
>  		ext4_handle_dirty_metadata(handle, dir, frame->bh);
> -		ext4_handle_dirty_metadata(handle, dir, bh);
> +		if (bh)
> +			ext4_handle_dirty_metadata(handle, dir, bh);
  I'm puzzled - bh here is bh2 from the beginning of the function and we
check it for being NULL after we ext4_append() it. So how can this happen?

									Honza
>  		dx_release(frames);
>  		return retval;
>  	}
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
