From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix incorrect error-message of ext2
Date: Sat, 23 Apr 2011 09:10:07 -0500
Message-ID: <4DB2DDBF.2060104@redhat.com>
References: <1303565818-19512-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab1DWOKO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Apr 2011 10:10:14 -0400
In-Reply-To: <1303565818-19512-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/23/11 8:36 AM, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> After "mkfs.ext2 -b 8192" on a new partition, I mount it with a error dmesg:
> "error: blocksize is too small"
> That's not correct.

Hi Robin -

Can you write a more descriptive changelog?

Imagine reading through git logs 2 years later, especially with --pretty=oneline.

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx fix incorrect error-message of ext2

would not be a very informative summary.

And the changelog itself says nothing about why the error is incorrect.

What was the device tested?  What is the pagesize of the system used?
Etc...

Maybe something like:

[PATCH] ext2: fix error msg when mounting fs with too-large blocksize

When ext2 mounts a filesystem, it attempts to set the block device
blocksize with a call to sb_set_blocksize, which can fail for
several reasons.  The current failure message in ext2 prints:

   EXT2-fs (loop1): error: blocksize is too small

which is not correct in all cases.  This can be demonstrated
by creating a filesystem with

   # mkfs.ext2 -b 8192

on a 4k page system, and attempting to mount it.

Change the error message to a more generic:

   EXT2-fs (loop1): bad blocksize 8192

to match the error message in ext3.

----

If the extra tests and message about hardware sector size are needed,
they probably should be added to ext3 as well.

In the testcase above, though, we just failed due to block size
vs. page size restrictions.

-Eric


> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  fs/ext2/super.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 0a78dae..f3008c1 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -758,6 +758,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	unsigned long def_mount_opts;
>  	long ret = -EINVAL;
>  	int blocksize = BLOCK_SIZE;
> +	int hblock;
>  	int db_count;
>  	int i, j;
>  	__le32 features;
> @@ -893,12 +894,25 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		goto failed_mount;
>  	}
>  
> +	hblock = bdev_logical_block_size(sb->s_bdev);
>  	/* If the blocksize doesn't match, re-read the thing.. */
>  	if (sb->s_blocksize != blocksize) {
> +		/*
> +		 * Make sure the blocksize for the filesystem is larger
> +		 * than the hardware sectorsize for the machine.
> +		 */
> +		if (blocksize < hblock) {
> +			ext2_msg(sb, KERN_ERR,
> +				"error: fsblocksize %d too small for "
> +				"hardware sectorsize %d", blocksize, hblock);
> +			goto failed_mount;
> +		}
> +
>  		brelse(bh);
>  
>  		if (!sb_set_blocksize(sb, blocksize)) {
> -			ext2_msg(sb, KERN_ERR, "error: blocksize is too small");
> +			ext2_msg(sb, KERN_ERR,
> +				"error: bad blocksize %d", blocksize);


>  			goto failed_sbi;
>  		}
>  

