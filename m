From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext4: don't keep using page if inline conversion
 fails
Date: Thu, 11 Sep 2014 15:17:53 +0200
Message-ID: <20140911131753.GB30901@quack.suse.cz>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
 <20140911002845.10109.10558.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbaIKNR5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 09:17:57 -0400
Content-Disposition: inline
In-Reply-To: <20140911002845.10109.10558.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 10-09-14 17:28:45, Darrick J. Wong wrote:
> If inline->extent conversion fails (most probably due to ENOSPC) and
> we release the temporary page that we allocated to transfer the file
> contents, don't keep using the page pointer after releasing the page.
> This occasionally leads to complaints about evicting locked pages or
> hangs when blocksize > pagesize, because it's possible for the page to
> get reallocated elsewhere in the meantime.
  Good catch! You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: Tao Ma <tm@tao.ma>
> ---
>  fs/ext4/inline.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index bea662b..378aadf 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -594,6 +594,7 @@ retry:
>  	if (ret) {
>  		unlock_page(page);
>  		page_cache_release(page);
> +		page = NULL;
>  		ext4_orphan_add(handle, inode);
>  		up_write(&EXT4_I(inode)->xattr_sem);
>  		sem_held = 0;
> @@ -613,7 +614,8 @@ retry:
>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>  		goto retry;
>  
> -	block_commit_write(page, from, to);
> +	if (page)
> +		block_commit_write(page, from, to);
>  out:
>  	if (page) {
>  		unlock_page(page);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
