From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 04/25] libext2fs: reject 64bit badblocks numbers
Date: Wed, 23 Oct 2013 17:24:00 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310231715500.1918@localhost.localdomain>
References: <20131018044854.7339.48457.stgit@birch.djwong.org> <20131018044922.7339.17110.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab3JWPYH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 11:24:07 -0400
In-Reply-To: <20131018044922.7339.17110.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Oct 2013, Darrick J. Wong wrote:

> Date: Thu, 17 Oct 2013 21:49:22 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 04/25] libext2fs: reject 64bit badblocks numbers
> 
> Don't accept block numbers larger than 2^32 for the badblocks list,
> and don't run badblocks on them either.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/read_bb_file.c |    7 +++++--
>  misc/badblocks.c          |   17 ++++++++++++++++-
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/lib/ext2fs/read_bb_file.c b/lib/ext2fs/read_bb_file.c
> index 7d7bb7a..4a498d2 100644
> --- a/lib/ext2fs/read_bb_file.c
> +++ b/lib/ext2fs/read_bb_file.c
> @@ -39,7 +39,7 @@ errcode_t ext2fs_read_bb_FILE2(ext2_filsys fs, FILE *f,
>  					       void *priv_data))
>  {
>  	errcode_t	retval;
> -	blk_t		blockno;
> +	blk64_t		blockno;
>  	int		count;
>  	char		buf[128];
>  
> @@ -55,9 +55,12 @@ errcode_t ext2fs_read_bb_FILE2(ext2_filsys fs, FILE *f,
>  	while (!feof (f)) {
>  		if (fgets(buf, sizeof(buf), f) == NULL)
>  			break;
> -		count = sscanf(buf, "%u", &blockno);
> +		count = sscanf(buf, "%llu", &blockno);
>  		if (count <= 0)
>  			continue;
> +		/* Badblocks isn't going to be updated for 64bit */
> +		if (blockno > 1ULL << 32)

1ULL << 32 is not 32bit number. You need

	if (blockno >= 1ULL << 32)

or

	if (blockno > (1ULL << 32) - 1)

or better yet, use UINT32_MAX from stdint.h

> +			return EOVERFLOW;
>  		if (fs &&
>  		    ((blockno < fs->super->s_first_data_block) ||
>  		     (blockno >= ext2fs_blocks_count(fs->super)))) {
> diff --git a/misc/badblocks.c b/misc/badblocks.c
> index c9e47c7..802080c 100644
> --- a/misc/badblocks.c
> +++ b/misc/badblocks.c
> @@ -1047,6 +1047,7 @@ int main (int argc, char ** argv)
>  				  unsigned int);
>  	int open_flag;
>  	long sysval;
> +	blk64_t inblk;
>  
>  	setbuf(stdout, NULL);
>  	setbuf(stderr, NULL);
> @@ -1204,6 +1205,13 @@ int main (int argc, char ** argv)
>  		     (unsigned long) first_block, (unsigned long) last_block);
>  	    exit (1);
>  	}
> +	/* ext2 badblocks file can't handle large values */
> +	if ((blk64_t)last_block >= 1ULL << 32) {
> +		com_err(program_name, EOVERFLOW,
> +			_("invalid end block (%lu): must be less than %llu"),
> +			(unsigned long)last_block, 1ULL << 32);
> +		exit(1);
> +	}
>  	if (w_flag)
>  		check_mount(device_name);
>  
> @@ -1262,13 +1270,20 @@ int main (int argc, char ** argv)
>  
>  	if (in) {
>  		for(;;) {
> -			switch(fscanf (in, "%u\n", &next_bad)) {
> +			switch (fscanf(in, "%llu\n", &inblk)) {
>  				case 0:
>  					com_err (program_name, 0, "input file - bad format");
>  					exit (1);
>  				case EOF:
>  					break;
>  				default:
> +					if (inblk > 1ULL << 32) {

same here

> +						com_err(program_name,
> +							EOVERFLOW,
> +							_("while adding to in-memory bad block list"));
> +						exit(1);
> +					}
> +					next_bad = inblk;
>  					errcode = ext2fs_badblocks_list_add(bb_list,next_bad);
>  					if (errcode) {
>  						com_err (program_name, errcode, _("while adding to in-memory bad block list"));
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
