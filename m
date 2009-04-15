From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [PATCH 4/5][64-BIT] debugfs.c extents display.
Date: Wed, 15 Apr 2009 16:50:59 -0400
Message-ID: <20090415205059.GH1668@shell>
References: <11655.1239227229@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZDOUvD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 16:51:03 -0400
Content-Disposition: inline
In-Reply-To: <11655.1239227229@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2009 at 05:47:09PM -0400, Nick Dokos wrote:
> Change the first and last block numbers in the list_blocks_struct
> from blk_t to blk64_t.
> 
> Change the list_blocks_proc() to take a blk64_t *blocknr and use
> ext2fs_block_iterate3(), instead of ...iterate2().
> 
> Change fprintf formats to use %llu, instead of %u.
> 
> With these changes, it seems to produce the right block numbers: I
> spot-checked against the extents that my python script reported, but I
> have not done an exhaustive comparison.
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
> ---
>  debugfs/debugfs.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index a71da89..6b75410 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -378,7 +378,7 @@ void do_dirty_filesys(int argc EXT2FS_ATTR((unused)),
>  struct list_blocks_struct {
>  	FILE		*f;
>  	e2_blkcnt_t	total;
> -	blk_t		first_block, last_block;
> +	blk64_t		first_block, last_block;
>  	e2_blkcnt_t	first_bcnt, last_bcnt;
>  	e2_blkcnt_t	first;
>  };
> @@ -392,17 +392,17 @@ static void finish_range(struct list_blocks_struct *lb)
>  	else
>  		fprintf(lb->f, ", ");
>  	if (lb->first_block == lb->last_block)
> -		fprintf(lb->f, "(%lld):%u",
> +		fprintf(lb->f, "(%lld):%llu",
>  			(long long)lb->first_bcnt, lb->first_block);
>  	else
> -		fprintf(lb->f, "(%lld-%lld):%u-%u",
> +		fprintf(lb->f, "(%lld-%lld):%llu-%llu",
>  			(long long)lb->first_bcnt, (long long)lb->last_bcnt,
>  			lb->first_block, lb->last_block);
>  	lb->first_block = 0;
>  }
>  
>  static int list_blocks_proc(ext2_filsys fs EXT2FS_ATTR((unused)),
> -			    blk_t *blocknr, e2_blkcnt_t blockcnt,
> +			    blk64_t *blocknr, e2_blkcnt_t blockcnt,
>  			    blk_t ref_block EXT2FS_ATTR((unused)),
>  			    int ref_offset EXT2FS_ATTR((unused)),
>  			    void *private)

Minor correction: ref_block should also be blk64_t.  Pushed.

-VAL

> @@ -523,7 +523,7 @@ static void dump_blocks(FILE *f, const char *prefix, ext2_ino_t inode)
>  	lb.first_block = 0;
>  	lb.f = f;
>  	lb.first = 1;
> -	ext2fs_block_iterate2(current_fs, inode, BLOCK_FLAG_READ_ONLY, NULL,
> +	ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY, NULL,
>  			      list_blocks_proc, (void *)&lb);
>  	finish_range(&lb);
>  	if (lb.total)
> -- 
> 1.6.0.6
> 
