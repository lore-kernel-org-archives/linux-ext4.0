From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 19/31] badblocks: Use the new badblocks APIs for 64-bit
 block numbers
Date: Thu, 10 Oct 2013 17:01:12 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310101651350.1925@localhost.localdomain>
References: <20131001012642.28415.89353.stgit@birch.djwong.org> <20131001012844.28415.98200.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3JJPBS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Oct 2013 11:01:18 -0400
In-Reply-To: <20131001012844.28415.98200.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 30 Sep 2013, Darrick J. Wong wrote:

> Date: Mon, 30 Sep 2013 18:28:44 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 19/31] badblocks: Use the new badblocks APIs for 64-bit block
>     numbers
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  misc/badblocks.c |   76 ++++++++++++++++++++++++++++--------------------------
>  1 file changed, 40 insertions(+), 36 deletions(-)
> 
> 
> diff --git a/misc/badblocks.c b/misc/badblocks.c
> index c9e47c7..660248e 100644
> --- a/misc/badblocks.c
> +++ b/misc/badblocks.c
> @@ -105,14 +105,14 @@ static void exclusive_usage(void)
>  	exit(1);
>  }
>  
> -static blk_t currently_testing = 0;
> -static blk_t num_blocks = 0;
> -static blk_t num_read_errors = 0;
> -static blk_t num_write_errors = 0;
> -static blk_t num_corruption_errors = 0;
> +static blk64_t currently_testing = 0;
> +static blk64_t num_blocks = 0;
> +static blk64_t num_read_errors = 0;
> +static blk64_t num_write_errors = 0;
> +static blk64_t num_corruption_errors = 0;
>  static ext2_badblocks_list bb_list = NULL;
>  static FILE *out;
> -static blk_t next_bad = 0;
> +static blk64_t next_bad = 0;
>  static ext2_badblocks_iterate bb_iter = NULL;
>  
>  enum error_types { READ_ERROR, WRITE_ERROR, CORRUPTION_ERROR };
> @@ -144,17 +144,17 @@ static void *allocate_buffer(size_t size)
>   * This routine reports a new bad block.  If the bad block has already
>   * been seen before, then it returns 0; otherwise it returns 1.
>   */
> -static int bb_output (blk_t bad, enum error_types error_type)
> +static int bb_output(blk64_t bad, enum error_types error_type)
>  {
>  	errcode_t errcode;
>  
> -	if (ext2fs_badblocks_list_test(bb_list, bad))
> +	if (ext2fs_badblocks_list_test2(bb_list, bad))
>  		return 0;
>  
>  	fprintf(out, "%lu\n", (unsigned long) bad);
>  	fflush(out);
>  
> -	errcode = ext2fs_badblocks_list_add (bb_list, bad);
> +	errcode = ext2fs_badblocks_list_add2(bb_list, bad);
>  	if (errcode) {
>  		com_err (program_name, errcode, "adding to in-memory bad block list");
>  		exit (1);
> @@ -165,7 +165,7 @@ static int bb_output (blk_t bad, enum error_types error_type)
>  	   an element was just added before the current iteration
>  	   position.  This should not cause next_bad to change. */
>  	if (bb_iter && bad < next_bad)
> -		ext2fs_badblocks_list_iterate (bb_iter, &next_bad);
> +		ext2fs_badblocks_list_iterate2(bb_iter, &next_bad);
>  
>  	if (error_type == READ_ERROR) {
>  	  num_read_errors++;
> @@ -216,7 +216,7 @@ static void print_status(void)
>  	gettimeofday(&time_end, 0);
>  	len = snprintf(line_buf, sizeof(line_buf), 
>  		       _("%6.2f%% done, %s elapsed. "
> -		         "(%d/%d/%d errors)"),
> +			 "(%llu/%llu/%llu errors)"),
>  		       calc_percent((unsigned long) currently_testing,
>  				    (unsigned long) num_blocks), 
>  		       time_diff_format(&time_end, &time_start, diff_buf),
> @@ -350,7 +350,7 @@ static void pattern_fill(unsigned char *buffer, unsigned int pattern,
>   *    successfully sequentially read.
>   */
>  static int do_read (int dev, unsigned char * buffer, int try, int block_size,
> -		    blk_t current_block)
> +		    blk64_t current_block)
>  {
>  	long got;
>  	struct timeval tv1, tv2;
> @@ -469,16 +469,16 @@ static void flush_bufs(void)
>  		com_err(program_name, retval, _("during ext2fs_sync_device"));
>  }
>  
> -static unsigned int test_ro (int dev, blk_t last_block,
> -			     int block_size, blk_t first_block,
> -			     unsigned int blocks_at_once)
> +static unsigned int test_ro(int dev, blk64_t last_block,
> +			    int block_size, blk64_t first_block,
> +			    unsigned int blocks_at_once)
>  {
>  	unsigned char * blkbuf;
>  	int try;

So blocks_at_once can be unsigned int, but try is int. Later on we
store blocks_at_once in try which can cause problems.

>  	int got;

same here, even though do_read() returns int. However the actual
variable 'got' is long (and try is yet again int) it is really mess
;)

Thanks!
-Lukas

>  	unsigned int bb_count = 0;
>  	errcode_t errcode;
> -	blk_t recover_block = ~0;
> +	blk64_t recover_block = ~0;
>  
>  	/* set up abend handler */
>  	capture_terminate(NULL);
> @@ -490,7 +490,7 @@ static unsigned int test_ro (int dev, blk_t last_block,
>  		exit (1);
>  	}
>  	do {
> -		ext2fs_badblocks_list_iterate (bb_iter, &next_bad);
> +		ext2fs_badblocks_list_iterate2(bb_iter, &next_bad);
>  	} while (next_bad && next_bad < first_block);
>  
>  	if (t_flag) {
> @@ -532,7 +532,8 @@ static unsigned int test_ro (int dev, blk_t last_block,
>  		if (next_bad) {
>  			if (currently_testing == next_bad) {
>  				/* fprintf (out, "%lu\n", nextbad); */
> -				ext2fs_badblocks_list_iterate (bb_iter, &next_bad);
> +				ext2fs_badblocks_list_iterate2(bb_iter,
> +						&next_bad);
>  				currently_testing++;
>  				continue;
>  			}
> @@ -581,16 +582,16 @@ static unsigned int test_ro (int dev, blk_t last_block,
>  	return bb_count;
>  }
>  
> -static unsigned int test_rw (int dev, blk_t last_block,
> -			     int block_size, blk_t first_block,
> -			     unsigned int blocks_at_once)
> +static unsigned int test_rw(int dev, blk64_t last_block,
> +			    int block_size, blk64_t first_block,
> +			    unsigned int blocks_at_once)
>  {
>  	unsigned char *buffer, *read_buffer;
>  	const unsigned int patterns[] = {0xaa, 0x55, 0xff, 0x00};
>  	const unsigned int *pattern;
>  	int i, try, got, nr_pattern, pat_idx;
>  	unsigned int bb_count = 0;
> -	blk_t recover_block = ~0;
> +	blk64_t recover_block = ~0;
>  
>  	/* set up abend handler */
>  	capture_terminate(NULL);
> @@ -716,13 +717,13 @@ static unsigned int test_rw (int dev, blk_t last_block,
>  }
>  
>  struct saved_blk_record {
> -	blk_t	block;
> +	blk64_t	block;
>  	int	num;
>  };
>  
> -static unsigned int test_nd (int dev, blk_t last_block,
> -			     int block_size, blk_t first_block,
> -			     unsigned int blocks_at_once)
> +static unsigned int test_nd(int dev, blk64_t last_block,
> +			    int block_size, blk64_t first_block,
> +			    unsigned int blocks_at_once)
>  {
>  	unsigned char *blkbuf, *save_ptr, *test_ptr, *read_ptr;
>  	unsigned char *test_base, *save_base, *read_base;
> @@ -731,7 +732,7 @@ static unsigned int test_nd (int dev, blk_t last_block,
>  	const unsigned int *pattern;
>  	int nr_pattern, pat_idx;
>  	int got, used2, written;
> -	blk_t save_currently_testing;
> +	blk64_t save_currently_testing;
>  	struct saved_blk_record *test_record;
>  	/* This is static to prevent being clobbered by the longjmp */
>  	static int num_saved;
> @@ -740,7 +741,7 @@ static unsigned int test_nd (int dev, blk_t last_block,
>  	unsigned long buf_used;
>  	static unsigned int bb_count;
>  	unsigned int granularity = blocks_at_once;
> -	blk_t recover_block = ~0U;
> +	blk64_t recover_block = ~0ULL;
>  
>  	bb_count = 0;
>  	errcode = ext2fs_badblocks_list_iterate_begin(bb_list,&bb_iter);
> @@ -750,7 +751,7 @@ static unsigned int test_nd (int dev, blk_t last_block,
>  		exit (1);
>  	}
>  	do {
> -		ext2fs_badblocks_list_iterate (bb_iter, &next_bad);
> +		ext2fs_badblocks_list_iterate2(bb_iter, &next_bad);
>  	} while (next_bad && next_bad < first_block);
>  
>  	blkbuf = allocate_buffer(3 * blocks_at_once * block_size);
> @@ -827,7 +828,8 @@ static unsigned int test_nd (int dev, blk_t last_block,
>  			if (next_bad) {
>  				if (currently_testing == next_bad) {
>  					/* fprintf (out, "%lu\n", nextbad); */
> -					ext2fs_badblocks_list_iterate (bb_iter, &next_bad);
> +					ext2fs_badblocks_list_iterate2(bb_iter,
> +							&next_bad);
>  					currently_testing++;
>  					goto check_for_more;
>  				}
> @@ -1042,8 +1044,8 @@ int main (int argc, char ** argv)
>  	int dev;
>  	errcode_t errcode;
>  	unsigned int pattern;
> -	unsigned int (*test_func)(int, blk_t,
> -				  int, blk_t,
> +	unsigned int (*test_func)(int, blk64_t,
> +				  int, blk64_t,
>  				  unsigned int);
>  	int open_flag;
>  	long sysval;
> @@ -1262,14 +1264,14 @@ int main (int argc, char ** argv)
>  
>  	if (in) {
>  		for(;;) {
> -			switch(fscanf (in, "%u\n", &next_bad)) {
> +			switch (fscanf(in, "%lluu\n", &next_bad)) {
>  				case 0:
>  					com_err (program_name, 0, "input file - bad format");
>  					exit (1);
>  				case EOF:
>  					break;
>  				default:
> -					errcode = ext2fs_badblocks_list_add(bb_list,next_bad);
> +					errcode = ext2fs_badblocks_list_add2(bb_list, next_bad);
>  					if (errcode) {
>  						com_err (program_name, errcode, _("while adding to in-memory bad block list"));
>  						exit (1);
> @@ -1295,8 +1297,10 @@ int main (int argc, char ** argv)
>  
>  		if (v_flag)
>  			fprintf(stderr,
> -				_("Pass completed, %u bad blocks found. (%d/%d/%d errors)\n"),
> -				bb_count, num_read_errors, num_write_errors, num_corruption_errors);
> +				_("Pass completed, %u bad blocks found. "
> +				  "(%llu/%llu/%llu errors)\n"),
> +				bb_count, num_read_errors, num_write_errors,
> +				num_corruption_errors);
>  
>  	} while (passes_clean < num_passes);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
