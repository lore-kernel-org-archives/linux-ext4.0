From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 09/47] libext2fs: use a dynamically sized (or caller-provided) block zeroing buffer
Date: Mon, 15 Dec 2014 09:09:37 -0700
Message-ID: <3D9939C9-5B2A-4337-AD3D-7BE2043F8CD5@dilger.ca>
References: <20141107215042.883.49888.stgit@birch.djwong.org> <20141107215146.883.18254.stgit@birch.djwong.org> <20141212023756.GA10189@thunk.org> <20141212050249.GA27096@birch.djwong.org> <20141213162403.GF17783@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46660 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaLOQJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Dec 2014 11:09:40 -0500
Received: by mail-pa0-f46.google.com with SMTP id lf10so11498504pab.33
        for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2014 08:09:39 -0800 (PST)
In-Reply-To: <20141213162403.GF17783@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 13, 2014, at 09:24, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> This is my replacement patch.
> 
>                    - Ted
> 
> commit 0a92af260da381e2581074871707e487728373ad
> Author: Darrick J. Wong <darrick.wong@oracle.com>
> Date:   Fri Dec 12 18:27:12 2014 -0500
> 
>    libext2fs: use a dynamically sized block zeroing buffer
> 
>    Dynamically grow the block zeroing buffer to a maximum of 4MB, and
>    allow callers to provide their own zeroed buffer in
>    ext2fs_zero_blocks2().
> 
>    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index e8f8b30..fcc6741 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -148,12 +148,13 @@ errfree:
>  * attempt to free the static zeroizing buffer.  (This is to keep
>  * programs that check for memory leaks happy.)
>  */
> -#define STRIDE_LENGTH (4194304 / fs->blocksize)
> +#define MAX_STRIDE_LENGTH (4194304 / (int) fs->blocksize)
> errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
>                  blk64_t *ret_blk, int *ret_count)
> {
>    int        j, count;
> -    static char    *buf;
> +    static void    *buf;
> +    static int    stride_length;
>    errcode_t    retval;
> 
>    /* If fs is null, clean up the static buffer and return */
> @@ -164,24 +165,36 @@ errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
>        }
>        return 0;
>    }
> +
> +    /* Deal with zeroing less than 1 block */
> +    if (num <= 0)
> +        return 0;
> +
>    /* Allocate the zeroizing buffer if necessary */
> -    if (!buf) {
> -        buf = malloc(fs->blocksize * STRIDE_LENGTH);
> -        if (!buf)
> -            return ENOMEM;
> -        memset(buf, 0, fs->blocksize * STRIDE_LENGTH);
> +    if (num > stride_length && stride_length < MAX_STRIDE_LENGTH) {
> +        void *p;
> +        int new_stride = num;
> +
> +        if (new_stride > MAX_STRIDE_LENGTH)
> +            new_stride = MAX_STRIDE_LENGTH;
> +        p = realloc(buf, fs->blocksize * new_stride);
> +        if (!p)
> +            return EXT2_ET_NO_MEMORY;

Shouldn't this continue using the original buf/num if this realloc fails?

Cheers, Andreas

> +        buf = p;
> +        stride_length = new_stride;
> +        memset(buf, 0, fs->blocksize * stride_length);
>    }
>    /* OK, do the write loop */
>    j=0;
>    while (j < num) {
> -        if (blk % STRIDE_LENGTH) {
> -            count = STRIDE_LENGTH - (blk % STRIDE_LENGTH);
> +        if (blk % stride_length) {
> +            count = stride_length - (blk % stride_length);
>            if (count > (num - j))
>                count = num - j;
>        } else {
>            count = num - j;
> -            if (count > STRIDE_LENGTH)
> -                count = STRIDE_LENGTH;
> +            if (count > stride_length)
> +                count = stride_length;
>        }
>        retval = io_channel_write_blk64(fs->io, blk, count, buf);
>        if (retval) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
