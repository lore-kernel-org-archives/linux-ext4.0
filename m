From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix loss of delalloc extent info in
 ext4_zero_range()
Date: Mon, 23 Mar 2015 11:44:19 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1503231138110.1578@localhost.localdomain>
References: <20150320235350.GA10101@wallace>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbbCWKoZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Mar 2015 06:44:25 -0400
In-Reply-To: <20150320235350.GA10101@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 20 Mar 2015, Eric Whitney wrote:

> Date: Fri, 20 Mar 2015 19:53:50 -0400
> From: Eric Whitney <enwlinux@gmail.com>
> To: linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu
> Subject: [PATCH] ext4: fix loss of delalloc extent info in ext4_zero_range()
> 
> In ext4_zero_range(), removing a file's entire block range from the
> extent status tree removes all records of that file's delalloc extents.
> The delalloc accounting code uses this information, and its loss can
> then lead to accounting errors and kernel warnings at writeback time and
> subsequent file system damage.  This is most noticeable on bigalloc
> file systems where code in ext4_ext_map_blocks() handles cases where
> delalloc extents share clusters with a newly allocated extent.
> 
> Because we're not deleting a block range and are correctly updating the
> status of its associated extent, there is no need to remove anything
> from the extent status tree.
> 
> When this patch is combined with an unrelated bug fix for
> ext4_zero_range(), kernel warnings and e2fsck errors reported during
> xfstests runs on bigalloc filesystems are greatly reduced without
> introducing regressions on other xfstests-bld test scenarios.

Ah, this is my bad sorry. I didn't realize that we're actually
relying on the delayed extent information in the extent status tree
now.

However I remember that I've seen some problems when this extent
removal was not there (see the comment you removed). I am not
entirely sure anymore what it was all about, but I need to retest
with your patch.

Thanks!
-Lukas

> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  fs/ext4/extents.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bed4308..c187cc3 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4847,19 +4847,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  					     flags, mode);
>  		if (ret)
>  			goto out_dio;
> -		/*
> -		 * Remove entire range from the extent status tree.
> -		 *
> -		 * ext4_es_remove_extent(inode, lblk, max_blocks) is
> -		 * NOT sufficient.  I'm not sure why this is the case,
> -		 * but let's be conservative and remove the extent
> -		 * status tree for the entire inode.  There should be
> -		 * no outstanding delalloc extents thanks to the
> -		 * filemap_write_and_wait_range() call above.
> -		 */
> -		ret = ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> -		if (ret)
> -			goto out_dio;
>  	}
>  	if (!partial_begin && !partial_end)
>  		goto out_dio;
> 
