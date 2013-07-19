From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: Remove extent tree purging from
 ext4_da_page_release_reservation()
Date: Fri, 19 Jul 2013 08:44:39 +0800
Message-ID: <20130719004439.GA21615@gmail.com>
References: <1374099015-6829-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54183 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759208Ab3GSAZs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Jul 2013 20:25:48 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa11so3814783pad.33
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jul 2013 17:25:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1374099015-6829-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

Sorry for the late reply.

On Thu, Jul 18, 2013 at 12:10:15AM +0200, Jan Kara wrote:
> ext4_da_page_release_reservation() gets called from
> ext4_da_invalidatepage(). This function is used when we are truncating
> page cache for punch hole or truncate operations. In either case these
> operations take care of removing extents from the extent tree. This is
> more efficient and the code in ext4_da_page_release_reservation() is
> actually buggy anyway. So just remove it.

I remember that I try to remove the entry from extent status tree here
because at the end of this function it tries to relase the reserved
space for delalloc.  For 4k block we can simply release it because
->s_cluster_ratio == 1.  But when bigalloc is enabled, we need to
determine whether we can release the reserved space according to the
result of ext4_find_delalloc_cluster() as the comment described.  If we
don't remove the entry from extent status tree here, we could lost some
spaces that could be reused by other files.  If I remember correctly, I
have hitted a warning message when I run xfstests to test it.  These
days I try to trigger it using xfstests but I failed.  Have you seen a
prblem that is caused by this code?  Maybe we need to refactor out the
code and release the reserved space outside this function.

                                                - Zheng

> 
> CC: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0188e65..98a9972 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1388,11 +1388,6 @@ static void ext4_da_page_release_reservation(struct page *page,
>  		curr_off = next_off;
>  	} while ((bh = bh->b_this_page) != head);
>  
> -	if (to_release) {
> -		lblk = page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
> -		ext4_es_remove_extent(inode, lblk, to_release);
> -	}
> -
>  	/* If we have released all the blocks belonging to a cluster, then we
>  	 * need to release the reserved space for that cluster. */
>  	num_clusters = EXT4_NUM_B2C(sbi, to_release);
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
