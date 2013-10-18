From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/25] debugfs: handle 64bit block numbers
Date: Fri, 18 Oct 2013 11:47:21 -0700
Message-ID: <20131018184721.GD19188@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045001.7339.74218.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33218 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3JRSrv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 14:47:51 -0400
Content-Disposition: inline
In-Reply-To: <20131018045001.7339.74218.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:50:01PM -0700, Darrick J. Wong wrote:
> debugfs should use strtoull wrappers for reading block numbers from
> the command line.  "unsigned long" isn't wide enough to handle block
> numbers on 32bit platforms.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  debugfs/debugfs.c      |   33 ++++++++++++++++++++++-----------
>  debugfs/extent_inode.c |   22 +++++++++-------------
>  debugfs/util.c         |    2 +-
>  3 files changed, 32 insertions(+), 25 deletions(-)
> 
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index d3db356..46fcd07 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -181,8 +181,7 @@ void do_open_filesys(int argc, char **argv)
>  				return;
>  			break;
>  		case 's':
> -			superblock = parse_ulong(optarg, argv[0],
> -						 "superblock number", &err);
> +			err = strtoblk(argv[0], optarg, &superblock);

I converted all of these to strtoblk instead of parse_ulonglong.  Otherwise,
this patch is the same.

--D

>  			if (err)
>  				return;
>  			break;
> @@ -277,14 +276,17 @@ void do_init_filesys(int argc, char **argv)
>  	struct ext2_super_block param;
>  	errcode_t	retval;
>  	int		err;
> +	blk64_t		blocks;
>  
>  	if (common_args_process(argc, argv, 3, 3, "initialize",
>  				"<device> <blocksize>", CHECK_FS_NOTOPEN))
>  		return;
>  
>  	memset(&param, 0, sizeof(struct ext2_super_block));
> -	ext2fs_blocks_count_set(&param, parse_ulong(argv[2], argv[0],
> -						    "blocks count", &err));
> +	err = strtoblk(argv[0], argv[2], &blocks);
> +	if (err)
> +		return;
> +	ext2fs_blocks_count_set(&param, blocks);
>  	if (err)
>  		return;
>  	retval = ext2fs_initialize(argv[1], 0, &param,
> @@ -2109,7 +2111,9 @@ void do_bmap(int argc, char *argv[])
>  	ino = string_to_inode(argv[1]);
>  	if (!ino)
>  		return;
> -	blk = parse_ulong(argv[2], argv[0], "logical_block", &err);
> +	err = strtoblk(argv[0], argv[2], &blk);
> +	if (err)
> +		return;
>  
>  	errcode = ext2fs_bmap2(current_fs, ino, 0, 0, 0, blk, 0, &pblk);
>  	if (errcode) {
> @@ -2254,10 +2258,14 @@ void do_punch(int argc, char *argv[])
>  	ino = string_to_inode(argv[1]);
>  	if (!ino)
>  		return;
> -	start = parse_ulong(argv[2], argv[0], "logical_block", &err);
> -	if (argc == 4)
> -		end = parse_ulong(argv[3], argv[0], "logical_block", &err);
> -	else
> +	err = strtoblk(argv[0], argv[2], &start);
> +	if (err)
> +		return;
> +	if (argc == 4) {
> +		err = strtoblk(argv[0], argv[3], &end);
> +		if (err)
> +			return;
> +	} else
>  		end = ~0;
>  
>  	errcode = ext2fs_punch(current_fs, ino, 0, 0, start, end);
> @@ -2474,8 +2482,11 @@ int main(int argc, char **argv)
>  						"block size", 0);
>  			break;
>  		case 's':
> -			superblock = parse_ulong(optarg, argv[0],
> -						 "superblock number", 0);
> +			retval = strtoblk(argv[0], optarg, &superblock);
> +			if (retval) {
> +				com_err(argv[0], retval, 0, debug_prog_name);
> +				return 1;
> +			}
>  			break;
>  		case 'c':
>  			catastrophic = 1;
> diff --git a/debugfs/extent_inode.c b/debugfs/extent_inode.c
> index 0bbc4c5..75e328c 100644
> --- a/debugfs/extent_inode.c
> +++ b/debugfs/extent_inode.c
> @@ -264,7 +264,7 @@ void do_replace_node(int argc, char *argv[])
>  		return;
>  	}
>  
> -	extent.e_lblk = parse_ulong(argv[1], argv[0], "logical block", &err);
> +	err = strtoblk(argv[0], argv[1], &extent.e_lblk);
>  	if (err)
>  		return;
>  
> @@ -272,7 +272,7 @@ void do_replace_node(int argc, char *argv[])
>  	if (err)
>  		return;
>  
> -	extent.e_pblk = parse_ulong(argv[3], argv[0], "logical block", &err);
> +	err = strtoblk(argv[0], argv[3], &extent.e_pblk);
>  	if (err)
>  		return;
>  
> @@ -338,8 +338,7 @@ void do_insert_node(int argc, char *argv[])
>  		return;
>  	}
>  
> -	extent.e_lblk = parse_ulong(argv[1], cmd,
> -				    "logical block", &err);
> +	err = strtoblk(cmd, argv[1], &extent.e_lblk);
>  	if (err)
>  		return;
>  
> @@ -348,8 +347,7 @@ void do_insert_node(int argc, char *argv[])
>  	if (err)
>  		return;
>  
> -	extent.e_pblk = parse_ulong(argv[3], cmd,
> -				    "pysical block", &err);
> +	err = strtoblk(cmd, argv[3], &extent.e_pblk);
>  	if (err)
>  		return;
>  
> @@ -366,8 +364,8 @@ void do_set_bmap(int argc, char **argv)
>  	const char	*usage = "[--uninit] <lblk> <pblk>";
>  	struct ext2fs_extent extent;
>  	errcode_t	retval;
> -	blk_t		logical;
> -	blk_t		physical;
> +	blk64_t		logical;
> +	blk64_t		physical;
>  	char		*cmd = argv[0];
>  	int		flags = 0;
>  	int		err;
> @@ -387,18 +385,16 @@ void do_set_bmap(int argc, char **argv)
>  		return;
>  	}
>  
> -	logical = parse_ulong(argv[1], cmd,
> -				    "logical block", &err);
> +	err = strtoblk(cmd, argv[1], &logical);
>  	if (err)
>  		return;
>  
> -	physical = parse_ulong(argv[2], cmd,
> -				    "physical block", &err);
> +	err = strtoblk(cmd, argv[2], &physical);
>  	if (err)
>  		return;
>  
>  	retval = ext2fs_extent_set_bmap(current_handle, logical,
> -					(blk64_t) physical, flags);
> +					physical, flags);
>  	if (retval) {
>  		com_err(cmd, retval, 0);
>  		return;
> diff --git a/debugfs/util.c b/debugfs/util.c
> index cf3a6c6..09088e0 100644
> --- a/debugfs/util.c
> +++ b/debugfs/util.c
> @@ -377,7 +377,7 @@ int common_block_args_process(int argc, char *argv[],
>  	}
>  
>  	if (argc > 2) {
> -		*count = parse_ulong(argv[2], argv[0], "count", &err);
> +		err = strtoblk(argv[0], argv[2], count);
>  		if (err)
>  			return 1;
>  	}
> 
