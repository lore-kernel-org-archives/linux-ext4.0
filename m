From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 3/3] e2fsprogs: Support for large inode migration.
Date: Wed, 25 Jul 2007 13:49:08 -0600
Message-ID: <20070725194908.GS5992@schatzie.adilger.int>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:50576 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbXGYTtL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jul 2007 15:49:11 -0400
Content-Disposition: inline
In-Reply-To: <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 25, 2007  11:06 +0530, Aneesh Kumar K.V wrote:
> This helps in reverting the changes if end results
> are not correct.The environment variable TUNE2FS_SCRATCH_DIR
> is used to indicate the  directory within which the tdb
> file need to be created. The file will be named tune2fs-XXXXXX

> @@ -702,6 +705,23 @@ static void parse_tune2fs_options(int argc, char **argv)
>  				break;
> +			case 'I':
> +				new_inode_size = strtoul (optarg, &tmp, 0);
> +				if (!((new_inode_size & (new_inode_size - 1)) == 0)) {
> +					com_err (program_name, 0,
> +							_("bad Inode size - %s"),
> +							optarg);
> +					usage();
> +				}

Please print a more useful message like "inode size must be a power of two",
as "bad inode size - 200" isn't very useful to the user to figure out what
a good inode size is.

> +static void *ext2fs_read_next_inode(ext2_filsys fs,
> +				void *inode, void *inode_table,
> +				int *retval)
> +{
> +	blk = fs->group_desc[group].bg_inode_table;
> +	*retval = io_channel_read_blk(fs->io, blk,
> +			fs->inode_blocks_per_group, inode_table);

This isn't doing swabbing of the inodes?

> +}
> +
> +static int ext2fs_write_itb(ext2_filsys fs, int group,
> +				void *inode_table_block, int free_inodes_count)
> +{
> +	int retval;
> +	int blk = fs->group_desc[group].bg_inode_table;
> +	retval = io_channel_write_blk(fs->io, blk,
> +				fs->inode_blocks_per_group, inode_table_block);

This isn't doing swabbing either?

> +static int resize_inode(ext2_filsys fs, unsigned long int new_inode_size)
> +{
> +	ext2_ino_t inode_num;
> +	int itable_size, retval;
> +	int new_inode_per_group, new_max_inode;
> +	int copied_inode_count = 0;
> +	void *inode, *buf, *tmp_buf, *inode_table;
> +	int free_inodes_count = 0, group_count = 0;
> +	int old_size = EXT2_INODE_SIZE(fs->super);
> +	int max_group = fs->super->s_inodes_count/fs->super->s_inodes_per_group;
> +
> +	if (new_inode_size <= fs->super->s_inode_size ) {
> +		fprintf(stderr, _("New Inode size too small\n"));
> +		return EXT2_ET_INVALID_ARGUMENT;
> +	}

Shouldn't this be verified when the inode size is parsed instead of down here?

> +	if (I_flag) {
> +		if (mount_flags & EXT2_MF_MOUNTED) {
> +			fputs(_("The Inode size may only be "
> +				"changed when the filesystem is "
> +				"unmounted.\n"), stderr);

Why do you capitalize "Inode" in all of the messages?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
