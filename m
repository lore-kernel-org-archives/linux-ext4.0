From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] direct-io: fix stale data exposure from concurrent buffered read
Date: Thu, 05 May 2016 15:39:29 -0400
Message-ID: <x49twic5m6m.fsf@segfault.boston.devel.redhat.com>
References: <1462033162-21837-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>, Jan Kara <jack@suse.cz>,
	"Theodore T'so" <tytso@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1462033162-21837-1-git-send-email-guaneryu@gmail.com> (Eryu
	Guan's message of "Sun, 1 May 2016 00:19:22 +0800")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, Eryu,

Thanks for the great description of the problem!  I have some comments
below.

Eryu Guan <guaneryu@gmail.com> writes:

> Direct writes inside i_size on a DIO_SKIP_HOLES filesystem are not
> allowed to allocate blocks(get_more_blocks() sets 'create' to 0 before
> calling get_bkicl() callback), if it's a sparse file, direct writes fall
> back to buffered writes to avoid stale data exposure from concurrent
> buffered read.
>
> But the detection for "writing inside i_size" is not correct, writes can
> be treated as "extending writes" wrongly, which results in block
> allocation for holes and could expose stale data. This is because we're
> checking on the fs blocks not the actual offset and i_size in bytes.
>
> For example, direct write 1FSB to a 1FSB(or smaller) sparse file on
> ext2/3/4, starting from offset 0, in this case it's writing inside
> i_size, but 'create' is non-zero, because 'sdio->block_in_file' and
> '(i_size_read(dio->inode) >> sdio->blkbits' are both zero.
>
> This can be demonstrated by running ltp-aiodio test ADSP045 many times.
> When testing on extN filesystems, I see test failures occasionally,
> buffered read could read non-zero (stale) data.
>
> ADSP045: dio_sparse -a 4k -w 4k -s 2k -n 2
>
> dio_sparse    0  TINFO  :  Dirtying free blocks
> dio_sparse    0  TINFO  :  Starting I/O tests
> non zero buffer at buf[0] => 0xffffffaa,ffffffaa,ffffffaa,ffffffaa
> non-zero read at offset 0
> dio_sparse    0  TINFO  :  Killing childrens(s)
> dio_sparse    1  TFAIL  :  dio_sparse.c:191: 1 children(s) exited abnormally

OK, so in this case, block_in_file is 0, i_size_read(inode) is 2048, and
i_blkbits is 12.

> Fix it by checking on the actual offset and i_size in bytes, not the fs
> blocks where offset and i_size are in, to make sure it's really writing
> into the file.

I think this code operates on blocks for a reason: we're trying to
determine if we'll trigger block allocation, right?  For example,
consider a sparse file with i_size of 2k, and a write to offset 2k into
the file, with a file system block size of 4k.  Should that have create
set or not?

Ted or Jan, can you answer that question?

> Also introduce some local variables to make the code
> easier to read a little bit.

Please don't do this.  You're only making the change harder to review.
Just submit the minimal fix.  You can submit cleanups as a follow-on.

Thanks,
Jeff

> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
>  fs/direct-io.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 4720377..ca0c9bc 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -607,9 +607,12 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
>  	int ret;
>  	sector_t fs_startblk;	/* Into file, in filesystem-sized blocks */
>  	sector_t fs_endblk;	/* Into file, in filesystem-sized blocks */
> +	sector_t block_in_file = sdio->block_in_file;
>  	unsigned long fs_count;	/* Number of filesystem-sized blocks */
>  	int create;
> -	unsigned int i_blkbits = sdio->blkbits + sdio->blkfactor;
> +	unsigned int blkbits = sdio->blkbits;
> +	unsigned int blkfactor = sdio->blkfactor;
> +	unsigned int i_blkbits = blkbits + blkfactor;
>  
>  	/*
>  	 * If there was a memory error and we've overwritten all the
> @@ -617,10 +620,9 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
>  	 */
>  	ret = dio->page_errors;
>  	if (ret == 0) {
> -		BUG_ON(sdio->block_in_file >= sdio->final_block_in_request);
> -		fs_startblk = sdio->block_in_file >> sdio->blkfactor;
> -		fs_endblk = (sdio->final_block_in_request - 1) >>
> -					sdio->blkfactor;
> +		BUG_ON(block_in_file >= sdio->final_block_in_request);
> +		fs_startblk = block_in_file >> blkfactor;
> +		fs_endblk = (sdio->final_block_in_request - 1) >> blkfactor;
>  		fs_count = fs_endblk - fs_startblk + 1;
>  
>  		map_bh->b_state = 0;
> @@ -638,11 +640,9 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
>  		 * buffer head.
>  		 */
>  		create = dio->rw & WRITE;
> -		if (dio->flags & DIO_SKIP_HOLES) {
> -			if (sdio->block_in_file < (i_size_read(dio->inode) >>
> -							sdio->blkbits))
> -				create = 0;
> -		}
> +		if ((dio->flags & DIO_SKIP_HOLES) &&
> +		    ((block_in_file << blkbits) < i_size_read(dio->inode)))
> +			create = 0;
>  
>  		ret = (*sdio->get_block)(dio->inode, fs_startblk,
>  						map_bh, create);
