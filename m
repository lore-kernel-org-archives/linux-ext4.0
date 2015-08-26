From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 13/19] tune2fs: Add support for changing number of
 reserved inodes
Date: Wed, 26 Aug 2015 18:11:45 +0200
Message-ID: <20150826161145.GF14012@quack.suse.cz>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
 <1438944689-24562-14-git-send-email-jack@suse.com>
 <078D7EF7-202A-48A5-9B16-94C236853D8E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbbHZQLu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:11:50 -0400
Content-Disposition: inline
In-Reply-To: <078D7EF7-202A-48A5-9B16-94C236853D8E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 07-08-15 12:58:49, Andreas Dilger wrote:
> On Aug 7, 2015, at 4:51 AM, Jan Kara <jack@suse.com> wrote:
> > 
> > Signed-off-by: Jan Kara <jack@suse.com>
> > ---
> > misc/tune2fs.8.in |   5 +++
> > misc/tune2fs.c    | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > 2 files changed, 107 insertions(+)
> > 
> > diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
> > index 4373fc49b255..922705329112 100644
> > --- a/misc/tune2fs.8.in
> > +++ b/misc/tune2fs.8.in
> > @@ -236,6 +236,11 @@ program.
> > This superblock setting is only honored in 2.6.35+ kernels;
> > and not at all by the ext2 and ext3 file system drivers.
> > .TP
> > +.BI reserved_inodes= number_of_reserved_inodes
> > +Set the number of inodes reserved for system files. This number must be
> > +at least 10. Currently 10 is enough but future features may require additional
> > +reserved inodes. Reserving more inodes requires full file system scan so it
> > +can take a long time.
> > .B test_fs
> > Set a flag in the filesystem superblock indicating that it may be
> > mounted using experimental kernel code, such as the ext4dev filesystem.
> > diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> > index d6bfad3374d1..d6e75fe00814 100644
> > --- a/misc/tune2fs.c
> > +++ b/misc/tune2fs.c
> > @@ -92,6 +92,7 @@ static char *features_cmd;
> > static char *mntopts_cmd;
> > static int stride, stripe_width;
> > static int stride_set, stripe_width_set;
> > +static unsigned long new_first_ino;
> > static char *extended_cmd;
> > static unsigned long new_inode_size;
> > static char *ext_mount_opts;
> > @@ -2298,6 +2299,34 @@ static int parse_extended_opts(ext2_filsys fs, const char *opts)
> > 				continue;
> > 			}
> > 			ext_mount_opts = strdup(arg);
> > +		} else if (!strcmp(token, "reserved_inodes")) {
> > +			if (!arg) {
> > +				r_usage++;
> > +				continue;
> > +			}
> > +			new_first_ino = strtoul(arg, &p, 0);
> > +			if (*p) {
> > +				fprintf(stderr,
> > +					_("Invalid number of reserved inodes "
> > +					  "%s\n"),
> > +					arg);
> > +				r_usage++;
> > +				continue;
> > +			}
> > +			/* Ino 0 is invalid so bump by 1... */
> > +			new_first_ino++;
> > +			if (new_first_ino < EXT2_GOOD_OLD_FIRST_INO) {
> > +				fprintf(stderr,
> > +					_("Too few reserved inodes "
> > +				          "%s (must be at least %u)\n"),
> > +				        arg, EXT2_GOOD_OLD_FIRST_INO - 1);
> > +				r_usage++;
> > +				continue;
> > +			}
> > +			/*
> > +			 * Here should go further feature tests to disallow
> > +			 * admin to free used system inode
> > +			 */
> 
> Not only should this check that the new_first_ino isn't shrinking too
> small to cover in-use special inodes, it should also verify that it
> isn't growing to cover in-use normal inodes (e.g. lost+found).
> 
> I guess one option might be to reserve "12" for the lost+found inode,
> since virtually all filesystems have it this way (though not all),
> and it would also help e2fsck in the future if it didn't need to
> allocate some other inode for lost+found in case of corruption.

We do take care to move any normal inodes that are in the way. So this
isn't an issue... That's why I had to refactor all the resize code after
all...

								Honza
> 
> Cheers, Andreas
> 
> > 		} else
> > 			r_usage++;
> > 	}
> > @@ -2312,6 +2341,7 @@ static int parse_extended_opts(ext2_filsys fs, const char *opts)
> > 			"\tmount_opts=<extended default mount options>\n"
> > 			"\tstride=<RAID per-disk chunk size in blocks>\n"
> > 			"\tstripe_width=<RAID stride*data disks in blocks>\n"
> > +			"\treserved_inodes=<number of reserved inodes>\n"
> > 			"\ttest_fs\n"
> > 			"\t^test_fs\n"));
> > 		free(buf);
> > @@ -2986,6 +3016,75 @@ fs_update_journal_user(struct ext2_super_block *sb, __u8 old_uuid[UUID_SIZE])
> > 	return 0;
> > }
> > 
> > +/* Zero range of inodes and mark them as free / used */
> > +static errcode_t zero_inodes_range(ext2_filsys fs, ext2_ino_t start,
> > +				   ext2_ino_t end, int inuse)
> > +{
> > +	char *inode;
> > +	int length = EXT2_INODE_SIZE(fs->super);
> > +	ext2_ino_t ino;
> > +	errcode_t retval;
> > +
> > +	retval = ext2fs_get_memzero(length, &inode);
> > +	if (retval)
> > +		return retval;
> > +
> > +	for (ino = start; ino <= end; ino++) {
> > +		ext2fs_inode_alloc_stats(fs, ino, inuse);
> > +		retval = ext2fs_write_inode_full(fs, ino,
> > +						 (struct ext2_inode *)inode,
> > +						 length);
> > +		if (retval)
> > +			break;
> > +	}
> > +	ext2fs_free_mem(inode);
> > +
> > +	return retval;
> > +}
> > +
> > +static errcode_t update_reserved_inodes(ext2_filsys fs)
> > +{
> > +	errcode_t retval = 0;
> > +	ext2fs_inode_bitmap imap;
> > +	ext2_ino_t ino, first_ino = fs->super->s_first_ino;
> > +
> > +	if (new_first_ino == first_ino)
> > +		return 0;
> > +
> > +	/* Group descriptors will need writing as well */
> > +	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
> > +
> > +	/* Freeing reserved inodes is easy */
> > +	if (new_first_ino < first_ino) {
> > +		retval = zero_inodes_range(fs, new_first_ino, first_ino - 1,
> > +					   -1);
> > +		if (retval)
> > +			return retval;
> > +		goto out;
> > +	}
> > +
> > +	retval = ext2fs_allocate_inode_bitmap(fs, "inodes to move", &imap);
> > +	if (retval)
> > +		return retval;
> > +
> > +	for (ino = fs->super->s_first_ino; ino < new_first_ino; ino++)
> > +		ext2fs_mark_inode_bitmap2(imap, ino);
> > +
> > +	retval = ext2fs_move_inodes(fs, imap);
> > +	ext2fs_free_inode_bitmap(imap);
> > +	if (retval)
> > +		return retval;
> > +
> > +	retval = zero_inodes_range(fs, first_ino, new_first_ino - 1, +1);
> > +	if (retval)
> > +		return retval;
> > +out:
> > +	fs->super->s_first_ino = new_first_ino;
> > +	ext2fs_mark_super_dirty(fs);
> > +
> > +	return 0;
> > +}
> > +
> > int main(int argc, char **argv)
> > {
> > 	errcode_t retval;
> > @@ -3404,6 +3503,9 @@ retry_open:
> > 	if (feature_64bit)
> > 		convert_64bit(&fs, feature_64bit);
> > 
> > +	if (new_first_ino)
> > +		update_reserved_inodes(fs);
> > +
> > 	if (rewrite_checksums)
> > 		rewrite_metadata_checksums(fs);
> > 
> > -- 
> > 2.1.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
