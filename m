From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 11/30] libext2fs: handle inline data in dir iterator
 function
Date: Mon, 3 Mar 2014 15:31:54 -0800
Message-ID: <20140303233154.GB9875@birch.djwong.org>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
 <1386323897-2354-12-git-send-email-wenqing.lz@taobao.com>
 <20140303221653.GA4452@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49480 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbaCCXcI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Mar 2014 18:32:08 -0500
Content-Disposition: inline
In-Reply-To: <20140303221653.GA4452@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 03, 2014 at 05:16:53PM -0500, Theodore Ts'o wrote:
> As I mentioend on today's call, there are some pretty serious issues
> with ext2fs_inline_data_dir_iterate().  In some places, it is
> returning an errcode_t, and in some cases, it was returning the
> BLOCK_ABORT, et. al flags (which would be an int).

Sorry I missed this week's call, I wasn't feeling well.

> Also, all of the callers of ext2fs_inline_data_dir_iterate() pass in
> ext2fs_process_dir_block(), and given that
> ext2fs_inline-data_dir_iterate() is a non-public function, it makes
> the code simpler and more maintable to call ext2fs_process_dir_block()
> directly.  I think we would be better having a
> ext2fs_process_dir_buffer() function, instead of complicating the
> ext2fs_process_dir_block() interface, but that's a cleanup that we can
> do in a different commit.
> 
> Here are the diffs that I had to apply to make everything be
> consistent.  It was a pretty significant change, so I'd appreciate a
> second pair of eyes to sanity check what I changed.  This diff is
> versus the state of the tree after applying your PATCH v3 11/30 diff.
> 
>        	   	    	     	   	    	 - Ted
> 
> diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
> index 6bdfae5..8afccbe 100644
> --- a/lib/ext2fs/dir_iterate.c
> +++ b/lib/ext2fs/dir_iterate.c
> @@ -129,9 +129,7 @@ errcode_t ext2fs_dir_iterate2(ext2_filsys fs,
>  		ext2fs_free_mem(&ctx.buf);
>  	if (retval == EXT2_ET_INLINE_DATA_CANT_ITERATE) {
>  		ctx.flags |= DIRENT_FLAG_INCLUDE_INLINE_DATA;
> -		retval = ext2fs_inline_data_dir_iterate(fs, dir,
> -						ext2fs_process_dir_block,
> -						&ctx);
> +		(void) ext2fs_inline_data_dir_iterate(fs, dir, &ctx);
>  	}
>  	if (retval)
>  		return retval;

Hmm.  In order to get into ext2fs_inline_data_dir_iterate(), it has to be the
case that retval == EXT2_ET_INLINE_DATA_CANT_ITERATE.  But then we immediately
return that error code, which means that anything interesting in ctx.errcode
will be lost.  I /think/ you want to set retval = 0 in that if clause?

> diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
> index d910f42..b2afd15 100644
> --- a/lib/ext2fs/ext2fsP.h
> +++ b/lib/ext2fs/ext2fsP.h
> @@ -88,15 +88,9 @@ extern int ext2fs_process_dir_block(ext2_filsys  	fs,
>  				    int			ref_offset,
>  				    void		*priv_data);
>  
> -extern errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
> -				      ext2_ino_t ino,
> -				      int (*func)(ext2_filsys fs,
> -						  blk64_t     *blocknr,
> -						  e2_blkcnt_t blockcnt,
> -						  blk64_t     ref_blk,
> -						  int	      ref_offset,
> -						  void	      *priv_data),
> -				      void *priv_data);
> +extern int ext2fs_inline_data_dir_iterate(ext2_filsys fs,
> +					  ext2_ino_t ino,
> +					  void *priv_data);
>  
>  /* Generic numeric progress meter */
>  
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index b768b9a..db1bc03 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -78,36 +78,32 @@ err:
>  }
>  
>  
> -errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
> -			       ext2_ino_t ino,
> -			       int (*func)(ext2_filsys fs,
> -					   blk64_t     *blocknr,
> -					   e2_blkcnt_t blockcnt,
> -					   blk64_t     ref_blk,
> -					   int         ref_offset,
> -					   void        *priv_data),
> -			       void *priv_data)
> +int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
> +				   void *priv_data)
>  {
>  	struct dir_context *ctx;
>  	struct ext2_inode inode;
>  	struct ext2_dir_entry dirent;
>  	struct ext2_inline_data data;
> -	errcode_t retval = 0;
> +	int ret = BLOCK_ABORT;
>  	e2_blkcnt_t blockcnt = 0;
>  
>  	ctx = (struct dir_context *)priv_data;
>  
> -	retval = ext2fs_read_inode(fs, ino, &inode);
> -	if (retval)
> +	ctx->errcode = ext2fs_read_inode(fs, ino, &inode);
> +	if (ctx->errcode)
>  		goto out;
>  
> -	if (!(inode.i_flags & EXT4_INLINE_DATA_FL))
> -		return EXT2_ET_NO_INLINE_DATA;
> +	if (!(inode.i_flags & EXT4_INLINE_DATA_FL)) {
> +		ctx->errcode = EXT2_ET_NO_INLINE_DATA;
> +		goto out;
> +	}
>  
>  	if (!LINUX_S_ISDIR(inode.i_mode)) {
> -		retval = EXT2_ET_NO_DIRECTORY;
> +		ctx->errcode = EXT2_ET_NO_DIRECTORY;
>  		goto out;
>  	}
> +	ret = 0;
>  
>  	/* we first check '.' and '..' dir */
>  	dirent.inode = ino;
> @@ -117,8 +113,8 @@ errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
>  	dirent.name[1] = '\0';
>  	ctx->buf = (char *)&dirent;
>  	ext2fs_get_rec_len(fs, &dirent, &ctx->buflen);
> -	retval |= (*func)(fs, 0, blockcnt++, 0, 0, priv_data);
> -	if (retval & BLOCK_ABORT)
> +	ret |= ext2fs_process_dir_block(fs, 0, blockcnt++, 0, 0, priv_data);
> +	if (ret & BLOCK_ABORT)
>  		goto out;
>  
>  	dirent.inode = ext2fs_le32_to_cpu(inode.i_block[0]);
> @@ -129,8 +125,8 @@ errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
>  	dirent.name[2] = '\0';
>  	ctx->buf = (char *)&dirent;
>  	ext2fs_get_rec_len(fs, &dirent, &ctx->buflen);
> -	retval |= (*func)(fs, 0, blockcnt++, 0, 0, priv_data);
> -	if (retval & BLOCK_INLINE_DATA_CHANGED) {
> +	ret |= ext2fs_process_dir_block(fs, 0, blockcnt++, 0, 0, priv_data);
> +	if (ret & BLOCK_INLINE_DATA_CHANGED) {
>  		errcode_t err;
>  
>  		inode.i_block[0] = ext2fs_cpu_to_le32(dirent.inode);
> @@ -138,62 +134,68 @@ errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
>  		if (err)
>  			goto out;
>  	}
> -	if (retval & BLOCK_ABORT)
> +	if (ret & BLOCK_ABORT)
>  		goto out;
>  
>  	ctx->buf = (char *)inode.i_block + EXT4_INLINE_DATA_DOTDOT_SIZE;
>  	ctx->buflen = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DATA_DOTDOT_SIZE;
>  #ifdef WORDS_BIGENDIAN
> -	retval = ext2fs_dirent_swab_in2(fs, ctx->buf, ctx->buflen, 0);
> -	if (retval)
> +	ctx->errcode = ext2fs_dirent_swab_in2(fs, ctx->buf, ctx->buflen, 0);
> +	if (ctx->errcode) {
> +		ret |= BLOCK_ABORT;
>  		goto out;
> +	}
>  #endif
> -	retval |= (*func)(fs, 0, blockcnt++, 0, 0, priv_data);
> -	if (retval & BLOCK_INLINE_DATA_CHANGED) {
> -		errcode_t err;
> -
> +	ret |= ext2fs_process_dir_block(fs, 0, blockcnt++, 0, 0, priv_data);
> +	if (ret & BLOCK_INLINE_DATA_CHANGED) {

Was BLOCK_INLINE_DATA_CHANGED ever cleared from retval?  As written, I /think/
that writing either dot or dotdot entries will result in the EA being written
too, even if nothing changes there.

Guess I'll have a look at the other patches too.

--D

>  #ifdef WORDS_BIGENDIAN
> -		err = ext2fs_dirent_swab_out2(fs, ctx->buf, ctx->buflen, 0);
> -		if (err)
> +		ctx->errcode = ext2fs_dirent_swab_out2(fs, ctx->buf,
> +						       ctx->buflen, 0);
> +		if (ctx->errcode) {
> +			ret |= BLOCK_ABORT;
>  			goto out;
> +		}
>  #endif
> -		err = ext2fs_write_inode(fs, ino, &inode);
> -		if (err)
> -			goto out;
> +		ctx->errcode = ext2fs_write_inode(fs, ino, &inode);
> +		if (ctx->errcode)
> +			ret |= BLOCK_ABORT;
>  	}
> -	if (retval & BLOCK_ABORT)
> +	if (ret & BLOCK_ABORT)
>  		goto out;
>  
>  	data.fs = fs;
>  	data.ino = ino;
> -	retval = ext2fs_inline_data_ea_get(&data);
> -	if (retval)
> +	ctx->errcode = ext2fs_inline_data_ea_get(&data);
> +	if (ctx->errcode) {
> +		ret |= BLOCK_ABORT;
>  		goto out;
> +	}
>  	if (data.ea_size <= 0)
>  		goto out;
>  
>  	ctx->buf = data.ea_data;
>  	ctx->buflen = data.ea_size;
>  #ifdef WORDS_BIGENDIAN
> -	retval = ext2fs_dirent_swab_in2(fs, ctx->buf, ctx->buflen, 0);
> -	if (retval)
> +	ctx.errcode = ext2fs_dirent_swab_in2(fs, ctx->buf, ctx->buflen, 0);
> +	if (ctx.errcode) {
> +		ret |= BLOCK_ABORT;
>  		goto out;
> +	}
>  #endif
>  
> -	retval |= (*func)(fs, 0, blockcnt++, 0, 0, priv_data);
> -	if (retval & BLOCK_INLINE_DATA_CHANGED) {
> -		errcode_t err;
> -
> +	ret |= ext2fs_process_dir_block(fs, 0, blockcnt++, 0, 0, priv_data);
> +	if (ret & BLOCK_INLINE_DATA_CHANGED) {
>  #ifdef WORDS_BIGENDIAN
> -		err = ext2fs_dirent_swab_out2(fs, ctx->buf, ctx->buflen, 0);
> -		if (err) {
> -			retval = err;
> +		ctx->errcode = ext2fs_dirent_swab_out2(fs, ctx->buf,
> +						      ctx->buflen, 0);
> +		if (ctx->errcode) {
> +			ret |= BLOCK_ABORT;
>  			goto out1;
>  		}
>  #endif
> -		err = ext2fs_inline_data_ea_set(&data);
> -		if (err)
> -			retval = err;
> +		ctx->errcode = ext2fs_inline_data_ea_set(&data);
> +		if (ctx->errcode)
> +			ret |= BLOCK_ABORT;
>  	}
>  
>  out1:
> @@ -201,6 +203,6 @@ out1:
>  	ctx->buf = 0;
>  
>  out:
> -	retval &= ~(BLOCK_ABORT | BLOCK_INLINE_DATA_CHANGED);
> -	return retval & BLOCK_ERROR ? ctx->errcode : retval;
> +	ret &= ~(BLOCK_ABORT | BLOCK_INLINE_DATA_CHANGED);
> +	return ret;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
