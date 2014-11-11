From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] e2fsprogs/libext2fs: replace
 ext2fs_free_inode_cache() argument
Date: Tue, 11 Nov 2014 00:14:51 -0800
Message-ID: <20141111081451.GD10043@birch.djwong.org>
References: <1415689169-19393-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28642 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaKKIPC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Nov 2014 03:15:02 -0500
Content-Disposition: inline
In-Reply-To: <1415689169-19393-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 11, 2014 at 02:59:26PM +0800, Xiaoguang Wang wrote:
> When we call ext2fs_free_inode_cache(fs->icache) to free the inode
> cache, indeed it will not make fs->icache be 0, it just makes the
> local argument icache be 0, after this call, we need another
> 'fs->icache = 0' statement. So here we pass the 'ext2_filsys fs' as
> arguments directly, to make the free inode cache operation more natural.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> ---
>  lib/ext2fs/ext2fs.h |  2 +-
>  lib/ext2fs/freefs.c |  2 +-
>  lib/ext2fs/inode.c  | 10 ++++++----
>  3 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 506d43b..580440f 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1403,7 +1403,7 @@ extern errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
>  /* inode.c */
>  extern errcode_t ext2fs_create_inode_cache(ext2_filsys fs,
>  					   unsigned int cache_size);
> -extern void ext2fs_free_inode_cache(struct ext2_inode_cache *icache);
> +extern void ext2fs_free_inode_cache(ext2_filsys fs);

This change breaks the libext2fs ABI.  If you want to change the pointer type
of the parameter, please declare a new function:

extern void ext2fs_free_inode_cache2(ext2_filsys fs);

Ideally you'd change the old function to return an error code, but it returns
void... sigh.  I guess client programs are on their own.

Really, free_inode_cache is a poor interface since the ctor doesn't return a
struct ext2_inode_cache * directly, preferring to attach it to fs->icache
instead.  Why are the inode cache ctor/dtor exported in ext2fs.h anyway?
Nobody seems to use them.  Ted?

</rant>

Otherwise, the patch looks reasonable.

--D

>  extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
>  extern errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan,
>  					    ext2_ino_t *ino,
> diff --git a/lib/ext2fs/freefs.c b/lib/ext2fs/freefs.c
> index ea9742e..9c40c34 100644
> --- a/lib/ext2fs/freefs.c
> +++ b/lib/ext2fs/freefs.c
> @@ -52,7 +52,7 @@ void ext2fs_free(ext2_filsys fs)
>  		ext2fs_free_dblist(fs->dblist);
>  
>  	if (fs->icache)
> -		ext2fs_free_inode_cache(fs->icache);
> +		ext2fs_free_inode_cache(fs);
>  
>  	if (fs->mmp_buf)
>  		ext2fs_free_mem(&fs->mmp_buf);
> diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
> index 4310b82..f938c37 100644
> --- a/lib/ext2fs/inode.c
> +++ b/lib/ext2fs/inode.c
> @@ -79,10 +79,13 @@ errcode_t ext2fs_flush_icache(ext2_filsys fs)
>  /*
>   * Free the inode cache structure
>   */
> -void ext2fs_free_inode_cache(struct ext2_inode_cache *icache)
> +void ext2fs_free_inode_cache(ext2_filsys fs)
>  {
>  	int i;
> +	struct ext2_inode_cache *icache = fs->icache;
>  
> +	if (!icache)
> +		return;
>  	if (--icache->refcount)
>  		return;
>  	if (icache->buffer)
> @@ -92,7 +95,7 @@ void ext2fs_free_inode_cache(struct ext2_inode_cache *icache)
>  	if (icache->cache)
>  		ext2fs_free_mem(&icache->cache);
>  	icache->buffer_blk = 0;
> -	ext2fs_free_mem(&icache);
> +	ext2fs_free_mem(&fs->icache);
>  }
>  
>  errcode_t ext2fs_create_inode_cache(ext2_filsys fs, unsigned int cache_size)
> @@ -131,8 +134,7 @@ errcode_t ext2fs_create_inode_cache(ext2_filsys fs, unsigned int cache_size)
>  	ext2fs_flush_icache(fs);
>  	return 0;
>  errout:
> -	ext2fs_free_inode_cache(fs->icache);
> -	fs->icache = 0;
> +	ext2fs_free_inode_cache(fs);
>  	return retval;
>  }
>  
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
