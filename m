From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 04/25] libext2fs: reject 64bit badblocks numbers
Date: Thu, 24 Oct 2013 13:40:42 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310241322020.1922@localhost.localdomain>
References: <20131018044854.7339.48457.stgit@birch.djwong.org> <20131018044922.7339.17110.stgit@birch.djwong.org> <alpine.LFD.2.00.1310231715500.1918@localhost.localdomain> <20131023235810.GD31400@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1372771977-1382614845=:1922"
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab3JXLkt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Oct 2013 07:40:49 -0400
In-Reply-To: <20131023235810.GD31400@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1372771977-1382614845=:1922
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 23 Oct 2013, Theodore Ts'o wrote:

> Date: Wed, 23 Oct 2013 19:58:10 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Darrick J. Wong <darrick.wong@oracle.com>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 04/25] libext2fs: reject 64bit badblocks numbers
> 
> On Wed, Oct 23, 2013 at 05:24:00PM +0200, Lukáš Czerner wrote:
> > 
> > 1ULL << 32 is not 32bit number. You need
> > 
> > 	if (blockno >= 1ULL << 32)
> 
> I fixed up this patch like this (which should also be easier for the
> compiler to optimize).

I've just noticed something bellow...

> 
> 						- Ted
> 
> From d87f198ca3250c9dff6a4002cd2bbbb5ab6f113a Mon Sep 17 00:00:00 2001
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> Date: Wed, 23 Oct 2013 19:43:32 -0400
> Subject: [PATCH] libext2fs: reject 64bit badblocks numbers
> 
> Don't accept block numbers larger than 2^32 for the badblocks list,
> and don't run badblocks on them either.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  lib/ext2fs/read_bb_file.c |  7 +++++--
>  misc/badblocks.c          | 21 ++++++++++++++++++---
>  2 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/ext2fs/read_bb_file.c b/lib/ext2fs/read_bb_file.c
> index 7d7bb7a..8d1ad1a 100644
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
> +		if (blockno >> 32)
> +			return EOVERFLOW;
>  		if (fs &&
>  		    ((blockno < fs->super->s_first_data_block) ||
>  		     (blockno >= ext2fs_blocks_count(fs->super)))) {
> diff --git a/misc/badblocks.c b/misc/badblocks.c
> index c9e47c7..432c17b 100644
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
> @@ -1200,10 +1201,17 @@ int main (int argc, char ** argv)
>  		first_block = parse_uint(argv[optind], _("first block"));
>  	} else first_block = 0;
>  	if (first_block >= last_block) {
> -	    com_err (program_name, 0, _("invalid starting block (%lu): must be less than %lu"),
> -		     (unsigned long) first_block, (unsigned long) last_block);
> +	    com_err (program_name, 0, _("invalid starting block (%llu): must be less than %llu"),
> +		     first_block, last_block);
>  	    exit (1);
>  	}
> +	/* ext2 badblocks file can't handle large values */
> +	if (last_block >> 32) {

last_block can be obtained using ext2fs_get_device_size2() so it's
not really a "last block" but rather "number of blocks" in which
case we might potentially run into a problem with file systems
exactly 16TB long where it should theoretically be possible to use
badblocks.

Thanks!
-Lukas


> +		com_err(program_name, EOVERFLOW,
> +			_("invalid end block (%llu): must be 32-bit value"),
> +			last_block);
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
> +					if (inblk >> 32) {
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
--8323328-1372771977-1382614845=:1922--
