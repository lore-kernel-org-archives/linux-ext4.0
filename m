From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 13/74] debugfs: handle 64bit block numbers
Date: Tue, 17 Dec 2013 11:01:56 -0600
Message-ID: <52B08384.1080302@redhat.com>
References: <20131211011813.30655.39624.stgit@birch.djwong.org> <20131211011948.30655.17965.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab3LQRCB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Dec 2013 12:02:01 -0500
In-Reply-To: <20131211011948.30655.17965.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/10/13, 7:19 PM, Darrick J. Wong wrote:
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
> index c5f8a1f..578d577 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -181,8 +181,7 @@ void do_open_filesys(int argc, char **argv)
>  				return;
>  			break;
>  		case 's':
> -			superblock = parse_ulong(optarg, argv[0],
> -						 "superblock number", &err);
> +			err = strtoblk(argv[0], optarg, &superblock);
>  			if (err)
>  				return;
>  			break;
> @@ -278,14 +277,17 @@ void do_init_filesys(int argc, char **argv)
>  	struct ext2_super_block param;
>  	errcode_t	retval;
>  	int		err;
> +	blk64_t		blocks;
>  
>  	if (common_args_process(argc, argv, 3, 3, "initialize",
>  				"<device> <blocks>", CHECK_FS_NOTOPEN))
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

err cannot be true here, is the 2nd "if (err)" extraneous?

CID 1138573

Thanks,
-Eric
