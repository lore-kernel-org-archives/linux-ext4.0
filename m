From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
Date: Thu, 10 May 2012 17:00:24 +0200
Message-ID: <20120510150024.GB8588@quack.suse.cz>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Rob Landley <rob@landley.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 10-05-12 16:42:02, Ludwig Nussel wrote:
> Further development of a patch I sent years ago. I didn't find the
> time to address the concerns raised back then and forgot about the
> patch. Now here it is again.
> 
> When using 'real' file systems on removable storage devices such as
> hard disks or usb sticks people quickly face the problem that their
> Linux users have different uids on different machines. Therefore one
> cannot modify or even read files created on a different machine
> without running chown as root or storing everything with mode 777.
> Simple file systems such as vfat don't have that problem as they
> don't store file ownership information and one can pass the uid
> files should belong to as mount option.
> 
> The following two patches (for 3.4.0-rc4) implement the uid (and
> gid) mount option for ext2, ext3 and ext4 to make them actually
> useful on removable media. If a file system is mounted with the uid
> option all files appear to be owned by the specified uid. Only newly
> created files actually end up with that uid as owner on disk though.
> Ownership of existing files cannot be changed permanently if the uid
> option was specified.
  I've looked at this in more detail now. Although it would be nice to
avoid duplicating the the functionality as others suggested, I agree it's
not that simple and it seems to me we'd end up doing similar amount of work
in the filesystems anyway (mount option parsing, writing to disk, printing
mount options, ...). So I'm ok with the implementation as is and I'd be
willing to take it for ext3 / ext2. But we really want to keep all ext?
filesystems consistent so this also depends on Ted's approval of the change
for ext4.  Ted?

  What I'm missing in the changelog description is what i_diskuid/i_diskgid
is good for. Although I can imagine some use case, I'm not sure I can see
any sufficiently convicing one...

  Also please split the patch in three separate patches for ext2, ext3, and
ext4. Thanks.

								Honza
> 
> Acked-by: Rob Landley <rob@landley.net>
> Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
> ---
>  Documentation/filesystems/ext2.txt |    9 ++++++
>  Documentation/filesystems/ext3.txt |    9 ++++++
>  Documentation/filesystems/ext4.txt |    9 ++++++
>  fs/ext2/ext2.h                     |    8 +++++
>  fs/ext2/inode.c                    |   42 ++++++++++++++++++++------
>  fs/ext2/super.c                    |   57 +++++++++++++++++++++++++++++++++++-
>  fs/ext3/ext3.h                     |    8 +++++
>  fs/ext3/inode.c                    |   50 ++++++++++++++++++++++---------
>  fs/ext3/super.c                    |   57 +++++++++++++++++++++++++++++++++++-
>  fs/ext4/ext4.h                     |    4 ++
>  fs/ext4/inode.c                    |   50 ++++++++++++++++++++++---------
>  fs/ext4/super.c                    |   49 ++++++++++++++++++++++++++++++-
>  12 files changed, 311 insertions(+), 41 deletions(-)
> 
> diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
> index 67639f9..fcc1002 100644
> --- a/Documentation/filesystems/ext2.txt
> +++ b/Documentation/filesystems/ext2.txt
> @@ -42,6 +42,15 @@ orlov			(*)	Use the Orlov block allocator.
>  resuid=n			The user ID which may use the reserved blocks.
>  resgid=n			The group ID which may use the reserved blocks.
>  
> +uid=n[:m]			Make all files appear to belong to uid n.
> +				Useful for e.g. removable media with fstab
> +				options 'user,uid=useruid'. The optional second
> +				uid m is actually written to the file system.
> +
> +gid=n[:m]			Make all files appear to belong to gid n.
> +				The optional second gid m is actually written to
> +				the file system.
> +
>  sb=n				Use alternate superblock at this location.
>  
>  user_xattr			Enable "user." POSIX Extended Attributes
> diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
> index b100adc..b2407a7 100644
> --- a/Documentation/filesystems/ext3.txt
> +++ b/Documentation/filesystems/ext3.txt
> @@ -124,6 +124,15 @@ resgid=n		The group ID which may use the reserved blocks.
>  
>  resuid=n		The user ID which may use the reserved blocks.
>  
> +uid=n[:m]		Make all files appear to belong to uid n.
> +			Useful for e.g. removable media with fstab
> +			options 'user,uid=useruid'. The optional second
> +			uid m is actually written to the file system.
> +
> +gid=n[:m]		Make all files appear to belong to gid n.
> +			The optional second gid m is actually written to
> +			the file system.
> +
>  sb=n			Use alternate superblock at this location.
>  
>  quota			These options are ignored by the filesystem. They
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> index 1b7f9ac..b388ab5 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -245,6 +245,15 @@ resgid=n		The group ID which may use the reserved blocks.
>  
>  resuid=n		The user ID which may use the reserved blocks.
>  
> +uid=n[:m]		Make all files appear to belong to uid n.
> +			Useful for e.g. removable media with fstab
> +			options 'user,uid=useruid'. The optional second
> +			uid m is actually written to the file system.
> +
> +gid=n[:m]		Make all files appear to belong to gid n.
> +			The optional second gid m is actually written to
> +			the file system.
> +
>  sb=n			Use alternate superblock at this location.
>  
>  quota			These options are ignored by the filesystem. They
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 0b2b4db..b584e45 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -84,6 +84,10 @@ struct ext2_sb_info {
>  	unsigned long s_sb_block;
>  	uid_t s_resuid;
>  	gid_t s_resgid;
> +	uid_t s_uid;          /* make all files appear to belong to this uid */
> +	uid_t s_diskuid;      /* write this uid to disk (if s_uid != 0) */
> +	gid_t s_gid;          /* make all files appear to belong to this gid */
> +	gid_t s_diskgid;      /* write this gid to disk (if s_gid != 0) */
>  	unsigned short s_mount_state;
>  	unsigned short s_pad;
>  	int s_addr_per_block_bits;
> @@ -639,6 +643,10 @@ struct ext2_mount_options {
>  	unsigned long s_mount_opt;
>  	uid_t s_resuid;
>  	gid_t s_resgid;
> +	uid_t s_uid;
> +	uid_t s_diskuid;
> +	gid_t s_gid;
> +	gid_t s_diskgid;
>  };
>  
>  /*
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 740cad8..aabcb38 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1316,6 +1316,10 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
>  		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
>  		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
>  	}
> +	if (EXT2_SB(sb)->s_uid)
> +		inode->i_uid = EXT2_SB(sb)->s_uid;
> +	if (EXT2_SB(sb)->s_gid)
> +		inode->i_gid = EXT2_SB(sb)->s_gid;
>  	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>  	inode->i_size = le32_to_cpu(raw_inode->i_size);
>  	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
> @@ -1419,6 +1423,10 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
>  	struct ext2_inode * raw_inode = ext2_get_inode(sb, ino, &bh);
>  	int n;
>  	int err = 0;
> +	__le16 uid_low;
> +	__le16 gid_low;
> +	__le16 uid_high;
> +	__le16 gid_high;
>  
>  	if (IS_ERR(raw_inode))
>   		return -EIO;
> @@ -1430,26 +1438,40 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
>  
>  	ext2_get_inode_flags(ei);
>  	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
> +	if (EXT2_SB(sb)->s_uid)
> +		uid = EXT2_SB(sb)->s_diskuid;
> +	if (EXT2_SB(sb)->s_gid)
> +		gid = EXT2_SB(sb)->s_diskgid;
>  	if (!(test_opt(sb, NO_UID32))) {
> -		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(uid));
> -		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(gid));
> +		uid_low = cpu_to_le16(low_16_bits(uid));
> +		gid_low = cpu_to_le16(low_16_bits(gid));
>  /*
>   * Fix up interoperability with old kernels. Otherwise, old inodes get
>   * re-used with the upper 16 bits of the uid/gid intact
>   */
>  		if (!ei->i_dtime) {
> -			raw_inode->i_uid_high = cpu_to_le16(high_16_bits(uid));
> -			raw_inode->i_gid_high = cpu_to_le16(high_16_bits(gid));
> +			uid_high = cpu_to_le16(high_16_bits(uid));
> +			gid_high = cpu_to_le16(high_16_bits(gid));
>  		} else {
> -			raw_inode->i_uid_high = 0;
> -			raw_inode->i_gid_high = 0;
> +			uid_high = 0;
> +			gid_high = 0;
>  		}
>  	} else {
> -		raw_inode->i_uid_low = cpu_to_le16(fs_high2lowuid(uid));
> -		raw_inode->i_gid_low = cpu_to_le16(fs_high2lowgid(gid));
> -		raw_inode->i_uid_high = 0;
> -		raw_inode->i_gid_high = 0;
> +		uid_low = cpu_to_le16(fs_high2lowuid(uid));
> +		gid_low = cpu_to_le16(fs_high2lowgid(gid));
> +		uid_high = 0;
> +		gid_high = 0;
>  	}
> +	/* don't mangle uid/gid of existing files if override is active */
> +	if (!EXT2_SB(sb)->s_uid || ei->i_state & EXT2_STATE_NEW) {
> +		raw_inode->i_uid_high = uid_high;
> +		raw_inode->i_uid_low = uid_low;
> +	}
> +	if (!EXT2_SB(sb)->s_gid || ei->i_state & EXT2_STATE_NEW) {
> +		raw_inode->i_gid_high = gid_high;
> +		raw_inode->i_gid_low = gid_low;
> +	}
> +
>  	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
>  	raw_inode->i_size = cpu_to_le32(inode->i_size);
>  	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index e1025c7..0661574 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -236,6 +236,20 @@ static int ext2_show_options(struct seq_file *seq, struct dentry *root)
>  	    le16_to_cpu(es->s_def_resgid) != EXT2_DEF_RESGID) {
>  		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
>  	}
> +	if (sbi->s_uid) {
> +		if (sbi->s_uid != sbi->s_diskuid)
> +			seq_printf(seq, ",uid=%u:%u",
> +				sbi->s_uid, sbi->s_diskuid);
> +		else
> +			seq_printf(seq, ",uid=%u", sbi->s_uid);
> +	}
> +	if (sbi->s_gid) {
> +		if (sbi->s_gid != sbi->s_diskgid)
> +			seq_printf(seq, ",gid=%u:%u",
> +				sbi->s_gid, sbi->s_diskgid);
> +		else
> +			seq_printf(seq, ",gid=%u", sbi->s_gid);
> +	}
>  	if (test_opt(sb, ERRORS_RO)) {
>  		int def_errors = le16_to_cpu(es->s_errors);
>  
> @@ -393,7 +407,8 @@ enum {
>  	Opt_err_ro, Opt_nouid32, Opt_nocheck, Opt_debug,
>  	Opt_oldalloc, Opt_orlov, Opt_nobh, Opt_user_xattr, Opt_nouser_xattr,
>  	Opt_acl, Opt_noacl, Opt_xip, Opt_ignore, Opt_err, Opt_quota,
> -	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
> +	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation,
> +	Opt_uid, Opt_diskuid, Opt_gid, Opt_diskgid
>  };
>  
>  static const match_table_t tokens = {
> @@ -427,6 +442,10 @@ static const match_table_t tokens = {
>  	{Opt_usrquota, "usrquota"},
>  	{Opt_reservation, "reservation"},
>  	{Opt_noreservation, "noreservation"},
> +	{Opt_uid, "uid=%u"},
> +	{Opt_diskuid, "uid=%u:%u"},
> +	{Opt_gid, "gid=%u"},
> +	{Opt_diskgid, "gid=%u:%u"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -568,6 +587,34 @@ static int parse_options(char *options, struct super_block *sb)
>  			clear_opt(sbi->s_mount_opt, RESERVATION);
>  			ext2_msg(sb, KERN_INFO, "reservations OFF");
>  			break;
> +		case Opt_uid:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			sbi->s_uid = sbi->s_diskuid = option;
> +			break;
> +		case Opt_diskuid:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			sbi->s_uid = option;
> +
> +			if (match_int(&args[1], &option))
> +				return 0;
> +			sbi->s_diskuid = option;
> +			break;
> +		case Opt_gid:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			sbi->s_gid = sbi->s_diskgid = option;
> +			break;
> +		case Opt_diskgid:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			sbi->s_gid = option;
> +
> +			if (match_int(&args[1], &option))
> +				return 0;
> +			sbi->s_diskgid = option;
> +			break;
>  		case Opt_ignore:
>  			break;
>  		default:
> @@ -1214,6 +1261,10 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
>  	old_opts.s_mount_opt = sbi->s_mount_opt;
>  	old_opts.s_resuid = sbi->s_resuid;
>  	old_opts.s_resgid = sbi->s_resgid;
> +	old_opts.s_uid = sbi->s_uid;
> +	old_opts.s_diskuid = sbi->s_diskuid;
> +	old_opts.s_gid = sbi->s_gid;
> +	old_opts.s_diskgid = sbi->s_diskgid;
>  
>  	/*
>  	 * Allow the "check" option to be passed as a remount option.
> @@ -1300,6 +1351,10 @@ restore_opts:
>  	sbi->s_mount_opt = old_opts.s_mount_opt;
>  	sbi->s_resuid = old_opts.s_resuid;
>  	sbi->s_resgid = old_opts.s_resgid;
> +	sbi->s_uid = old_opts.s_uid;
> +	sbi->s_diskuid = old_opts.s_diskuid;
> +	sbi->s_gid = old_opts.s_gid;
> +	sbi->s_diskgid = old_opts.s_diskgid;
>  	sb->s_flags = old_sb_flags;
>  	spin_unlock(&sbi->s_lock);
>  	return err;
> diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
> index b6515fd..c7c4578 100644
> --- a/fs/ext3/ext3.h
> +++ b/fs/ext3/ext3.h
> @@ -245,6 +245,10 @@ struct ext3_mount_options {
>  	unsigned long s_mount_opt;
>  	uid_t s_resuid;
>  	gid_t s_resgid;
> +	uid_t s_uid;
> +	uid_t s_diskuid;
> +	gid_t s_gid;
> +	gid_t s_diskgid;
>  	unsigned long s_commit_interval;
>  #ifdef CONFIG_QUOTA
>  	int s_jquota_fmt;
> @@ -639,6 +643,10 @@ struct ext3_sb_info {
>  	ext3_fsblk_t s_sb_block;
>  	uid_t s_resuid;
>  	gid_t s_resgid;
> +	uid_t s_uid;          /* make all files appear to belong to this uid */
> +	uid_t s_diskuid;      /* write this uid to disk (if s_uid != 0) */
> +	gid_t s_gid;          /* make all files appear to belong to this gid */
> +	gid_t s_diskgid;      /* write this gid to disk (if s_gid != 0) */
>  	unsigned short s_mount_state;
>  	unsigned short s_pad;
>  	int s_addr_per_block_bits;
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 10d7812..095bd31 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -2913,6 +2913,10 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
>  		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
>  		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
>  	}
> +	if (EXT3_SB(sb)->s_uid)
> +		inode->i_uid = EXT3_SB(sb)->s_uid;
> +	if (EXT3_SB(sb)->s_gid)
> +		inode->i_gid = EXT3_SB(sb)->s_gid;
>  	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>  	inode->i_size = le32_to_cpu(raw_inode->i_size);
>  	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
> @@ -3066,8 +3070,14 @@ static int ext3_do_update_inode(handle_t *handle,
>  {
>  	struct ext3_inode *raw_inode = ext3_raw_inode(iloc);
>  	struct ext3_inode_info *ei = EXT3_I(inode);
> +	uid_t uid = inode->i_uid;
> +	gid_t gid = inode->i_gid;
>  	struct buffer_head *bh = iloc->bh;
>  	int err = 0, rc, block;
> +	__le16 uid_low;
> +	__le16 gid_low;
> +	__le16 uid_high;
> +	__le16 gid_high;
>  
>  again:
>  	/* we can't allow multiple procs in here at once, its a bit racey */
> @@ -3080,30 +3090,42 @@ again:
>  
>  	ext3_get_inode_flags(ei);
>  	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
> +	if (EXT3_SB(inode->i_sb)->s_uid)
> +		uid = EXT3_SB(inode->i_sb)->s_diskuid;
> +	if (EXT3_SB(inode->i_sb)->s_gid)
> +		gid = EXT3_SB(inode->i_sb)->s_diskgid;
>  	if(!(test_opt(inode->i_sb, NO_UID32))) {
> -		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
> -		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(inode->i_gid));
> +		uid_low = cpu_to_le16(low_16_bits(uid));
> +		gid_low = cpu_to_le16(low_16_bits(gid));
>  /*
>   * Fix up interoperability with old kernels. Otherwise, old inodes get
>   * re-used with the upper 16 bits of the uid/gid intact
>   */
>  		if(!ei->i_dtime) {
> -			raw_inode->i_uid_high =
> -				cpu_to_le16(high_16_bits(inode->i_uid));
> -			raw_inode->i_gid_high =
> -				cpu_to_le16(high_16_bits(inode->i_gid));
> +			uid_high = cpu_to_le16(high_16_bits(uid));
> +			gid_high = cpu_to_le16(high_16_bits(gid));
>  		} else {
> -			raw_inode->i_uid_high = 0;
> -			raw_inode->i_gid_high = 0;
> +			uid_high = 0;
> +			gid_high = 0;
>  		}
>  	} else {
> -		raw_inode->i_uid_low =
> -			cpu_to_le16(fs_high2lowuid(inode->i_uid));
> -		raw_inode->i_gid_low =
> -			cpu_to_le16(fs_high2lowgid(inode->i_gid));
> -		raw_inode->i_uid_high = 0;
> -		raw_inode->i_gid_high = 0;
> +		uid_low = cpu_to_le16(fs_high2lowuid(uid));
> +		gid_low = cpu_to_le16(fs_high2lowgid(gid));
> +		uid_high = 0;
> +		gid_high = 0;
>  	}
> +	/* don't mangle uid/gid of existing files if override is active */
> +	if (!EXT3_SB(inode->i_sb)->s_uid ||
> +			ext3_test_inode_state(inode, EXT3_STATE_NEW)) {
> +		raw_inode->i_uid_high = uid_high;
> +		raw_inode->i_uid_low = uid_low;
> +	}
> +	if (!EXT3_SB(inode->i_sb)->s_gid ||
> +			ext3_test_inode_state(inode, EXT3_STATE_NEW)) {
> +		raw_inode->i_gid_high = gid_high;
> +		raw_inode->i_gid_low = gid_low;
> +	}
> +
>  	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
>  	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
>  	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index cf0b592..4dcce09 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -625,6 +625,20 @@ static int ext3_show_options(struct seq_file *seq, struct dentry *root)
>  	    le16_to_cpu(es->s_def_resgid) != EXT3_DEF_RESGID) {
>  		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
>  	}
> +	if (sbi->s_uid) {
> +		if (sbi->s_uid != sbi->s_diskuid)
> +			seq_printf(seq, ",uid=%u:%u",
> +				sbi->s_uid, sbi->s_diskuid);
> +		else
> +			seq_printf(seq, ",uid=%u", sbi->s_uid);
> +	}
> +	if (sbi->s_gid) {
> +		if (sbi->s_gid != sbi->s_diskgid)
> +			seq_printf(seq, ",gid=%u:%u",
> +				sbi->s_gid, sbi->s_diskgid);
> +		else
> +			seq_printf(seq, ",gid=%u", sbi->s_gid);
> +	}
>  	if (test_opt(sb, ERRORS_RO)) {
>  		int def_errors = le16_to_cpu(es->s_errors);
>  
> @@ -820,7 +834,8 @@ enum {
>  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
>  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
>  	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
> -	Opt_resize, Opt_usrquota, Opt_grpquota
> +	Opt_resize, Opt_usrquota, Opt_grpquota,
> +	Opt_uid, Opt_diskuid, Opt_gid, Opt_diskgid
>  };
>  
>  static const match_table_t tokens = {
> @@ -877,6 +892,10 @@ static const match_table_t tokens = {
>  	{Opt_barrier, "barrier"},
>  	{Opt_nobarrier, "nobarrier"},
>  	{Opt_resize, "resize"},
> +	{Opt_uid, "uid=%u"},
> +	{Opt_diskuid, "uid=%u:%u"},
> +	{Opt_gid, "gid=%u"},
> +	{Opt_diskgid, "gid=%u:%u"},
>  	{Opt_err, NULL},
>  };
>  
> @@ -1267,6 +1286,34 @@ set_qf_format:
>  			ext3_msg(sb, KERN_WARNING,
>  				"warning: ignoring deprecated bh option");
>  			break;
> +		case Opt_uid:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			sbi->s_uid = sbi->s_diskuid = option;
> +			break;
> +		case Opt_diskuid:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			sbi->s_uid = option;
> +
> +			if (match_int(&args[1], &option))
> +				return 0;
> +			sbi->s_diskuid = option;
> +			break;
> +		case Opt_gid:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			sbi->s_gid = sbi->s_diskgid = option;
> +			break;
> +		case Opt_diskgid:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			sbi->s_gid = option;
> +
> +			if (match_int(&args[1], &option))
> +				return 0;
> +			sbi->s_diskgid = option;
> +			break;
>  		default:
>  			ext3_msg(sb, KERN_ERR,
>  				"error: unrecognized mount option \"%s\" "
> @@ -2590,6 +2637,10 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
>  	old_opts.s_mount_opt = sbi->s_mount_opt;
>  	old_opts.s_resuid = sbi->s_resuid;
>  	old_opts.s_resgid = sbi->s_resgid;
> +	old_opts.s_uid = sbi->s_uid;
> +	old_opts.s_diskuid = sbi->s_diskuid;
> +	old_opts.s_gid = sbi->s_gid;
> +	old_opts.s_diskgid = sbi->s_diskgid;
>  	old_opts.s_commit_interval = sbi->s_commit_interval;
>  #ifdef CONFIG_QUOTA
>  	old_opts.s_jquota_fmt = sbi->s_jquota_fmt;
> @@ -2701,6 +2752,10 @@ restore_opts:
>  	sbi->s_mount_opt = old_opts.s_mount_opt;
>  	sbi->s_resuid = old_opts.s_resuid;
>  	sbi->s_resgid = old_opts.s_resgid;
> +	sbi->s_uid = old_opts.s_uid;
> +	sbi->s_diskuid = old_opts.s_diskuid;
> +	sbi->s_gid = old_opts.s_gid;
> +	sbi->s_diskgid = old_opts.s_diskgid;
>  	sbi->s_commit_interval = old_opts.s_commit_interval;
>  #ifdef CONFIG_QUOTA
>  	sbi->s_jquota_fmt = old_opts.s_jquota_fmt;
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 0e01e90..7155b2d 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1155,6 +1155,10 @@ struct ext4_sb_info {
>  	ext4_fsblk_t s_sb_block;
>  	uid_t s_resuid;
>  	gid_t s_resgid;
> +	uid_t s_uid;          /* make all files appear to belong to this uid */
> +	uid_t s_diskuid;      /* write this uid to disk (if s_uid != 0) */
> +	gid_t s_gid;          /* make all files appear to belong to this gid */
> +	gid_t s_diskgid;      /* write this gid to disk (if s_gid != 0) */
>  	unsigned short s_mount_state;
>  	unsigned short s_pad;
>  	int s_addr_per_block_bits;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c77b0bd..86ce928 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3651,6 +3651,10 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
>  		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
>  	}
> +	if (EXT4_SB(sb)->s_uid)
> +		inode->i_uid = EXT4_SB(sb)->s_uid;
> +	if (EXT4_SB(sb)->s_gid)
> +		inode->i_gid = EXT4_SB(sb)->s_gid;
>  	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>  
>  	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
> @@ -3868,8 +3872,14 @@ static int ext4_do_update_inode(handle_t *handle,
>  {
>  	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
>  	struct ext4_inode_info *ei = EXT4_I(inode);
> +	uid_t uid = inode->i_uid;
> +	gid_t gid = inode->i_gid;
>  	struct buffer_head *bh = iloc->bh;
>  	int err = 0, rc, block;
> +	__le16 uid_low;
> +	__le16 gid_low;
> +	__le16 uid_high;
> +	__le16 gid_high;
>  
>  	/* For fields not not tracking in the in-memory inode,
>  	 * initialise them to zero for new inodes. */
> @@ -3878,30 +3888,42 @@ static int ext4_do_update_inode(handle_t *handle,
>  
>  	ext4_get_inode_flags(ei);
>  	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
> +	if (EXT4_SB(inode->i_sb)->s_uid)
> +		uid = EXT4_SB(inode->i_sb)->s_diskuid;
> +	if (EXT4_SB(inode->i_sb)->s_gid)
> +		gid = EXT4_SB(inode->i_sb)->s_diskgid;
>  	if (!(test_opt(inode->i_sb, NO_UID32))) {
> -		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
> -		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(inode->i_gid));
> +		uid_low = cpu_to_le16(low_16_bits(uid));
> +		gid_low = cpu_to_le16(low_16_bits(gid));
>  /*
>   * Fix up interoperability with old kernels. Otherwise, old inodes get
>   * re-used with the upper 16 bits of the uid/gid intact
>   */
>  		if (!ei->i_dtime) {
> -			raw_inode->i_uid_high =
> -				cpu_to_le16(high_16_bits(inode->i_uid));
> -			raw_inode->i_gid_high =
> -				cpu_to_le16(high_16_bits(inode->i_gid));
> +			uid_high = cpu_to_le16(high_16_bits(uid));
> +			gid_high = cpu_to_le16(high_16_bits(gid));
>  		} else {
> -			raw_inode->i_uid_high = 0;
> -			raw_inode->i_gid_high = 0;
> +			uid_high = 0;
> +			gid_high = 0;
>  		}
>  	} else {
> -		raw_inode->i_uid_low =
> -			cpu_to_le16(fs_high2lowuid(inode->i_uid));
> -		raw_inode->i_gid_low =
> -			cpu_to_le16(fs_high2lowgid(inode->i_gid));
> -		raw_inode->i_uid_high = 0;
> -		raw_inode->i_gid_high = 0;
> +		uid_low = cpu_to_le16(fs_high2lowuid(uid));
> +		gid_low = cpu_to_le16(fs_high2lowgid(gid));
> +		uid_high = 0;
> +		gid_high = 0;
>  	}
> +	/* don't mangle uid/gid of existing files if override is active */
> +	if (!EXT4_SB(inode->i_sb)->s_uid ||
> +			ext4_test_inode_state(inode, EXT4_STATE_NEW)) {
> +		raw_inode->i_uid_high = uid_high;
> +		raw_inode->i_uid_low = uid_low;
> +	}
> +	if (!EXT4_SB(inode->i_sb)->s_gid ||
> +			ext4_test_inode_state(inode, EXT4_STATE_NEW)) {
> +		raw_inode->i_gid_high = gid_high;
> +		raw_inode->i_gid_low = gid_low;
> +	}
> +
>  	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
>  
>  	EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e1fb1d5..5f121f3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1186,6 +1186,7 @@ enum {
>  	Opt_inode_readahead_blks, Opt_journal_ioprio,
>  	Opt_dioread_nolock, Opt_dioread_lock,
>  	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
> +	Opt_uid, Opt_diskuid, Opt_gid, Opt_diskgid,
>  };
>  
>  static const match_table_t tokens = {
> @@ -1264,6 +1265,10 @@ static const match_table_t tokens = {
>  	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
>  	{Opt_removed, "noreservation"}, /* mount option from ext2/3 */
>  	{Opt_removed, "journal=%u"},	/* mount option from ext2/3 */
> +	{Opt_uid, "uid=%u"},
> +	{Opt_diskuid, "uid=%u:%u"},
> +	{Opt_gid, "gid=%u"},
> +	{Opt_diskgid, "gid=%u:%u"},
>  	{Opt_err, NULL},
>  };
>  
> @@ -1498,6 +1503,24 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  			return -1;
>  		*journal_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, arg);
>  		return 1;
> +	case Opt_uid:
> +		sbi->s_uid = sbi->s_diskuid = arg;
> +		return 1;
> +	case Opt_diskuid:
> +		sbi->s_uid = arg;
> +		if (match_int(&args[1], &arg))
> +			return -1;
> +		sbi->s_diskuid = arg;
> +		return 1;
> +	case Opt_gid:
> +		sbi->s_gid = sbi->s_diskgid = arg;
> +		return 1;
> +	case Opt_diskgid:
> +		sbi->s_gid = arg;
> +		if (match_int(&args[1], &arg))
> +			return -1;
> +		sbi->s_diskgid = arg;
> +		return 1;
>  	}
>  
>  	for (m = ext4_mount_opts; m->token != Opt_err; m++) {
> @@ -1713,7 +1736,7 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
>  	char sep = nodefs ? '\n' : ',';
>  
>  #define SEQ_OPTS_PUTS(str) seq_printf(seq, "%c" str, sep)
> -#define SEQ_OPTS_PRINT(str, arg) seq_printf(seq, "%c" str, sep, arg)
> +#define SEQ_OPTS_PRINT(str, args...) seq_printf(seq, "%c" str, sep, ##args)
>  
>  	if (sbi->s_sb_block != 1)
>  		SEQ_OPTS_PRINT("sb=%llu", sbi->s_sb_block);
> @@ -1738,6 +1761,18 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
>  	if (nodefs || sbi->s_resgid != EXT4_DEF_RESGID ||
>  	    le16_to_cpu(es->s_def_resgid) != EXT4_DEF_RESGID)
>  		SEQ_OPTS_PRINT("resgid=%u", sbi->s_resgid);
> +	if (sbi->s_uid) {
> +		if (sbi->s_uid != sbi->s_diskuid)
> +			SEQ_OPTS_PRINT("uid=%u:%u", sbi->s_uid, sbi->s_diskuid);
> +		else
> +			SEQ_OPTS_PRINT("uid=%u", sbi->s_uid);
> +	}
> +	if (sbi->s_gid) {
> +		if (sbi->s_gid != sbi->s_diskgid)
> +			SEQ_OPTS_PRINT("gid=%u:%u", sbi->s_gid, sbi->s_diskgid);
> +		else
> +			SEQ_OPTS_PRINT("gid=%u", sbi->s_gid);
> +	}
>  	def_errors = nodefs ? -1 : le16_to_cpu(es->s_errors);
>  	if (test_opt(sb, ERRORS_RO) && def_errors != EXT4_ERRORS_RO)
>  		SEQ_OPTS_PUTS("errors=remount-ro");
> @@ -4215,6 +4250,10 @@ struct ext4_mount_options {
>  	unsigned long s_mount_opt2;
>  	uid_t s_resuid;
>  	gid_t s_resgid;
> +	uid_t s_uid;
> +	uid_t s_diskuid;
> +	gid_t s_gid;
> +	gid_t s_diskgid;
>  	unsigned long s_commit_interval;
>  	u32 s_min_batch_time, s_max_batch_time;
>  #ifdef CONFIG_QUOTA
> @@ -4245,6 +4284,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  	old_opts.s_mount_opt2 = sbi->s_mount_opt2;
>  	old_opts.s_resuid = sbi->s_resuid;
>  	old_opts.s_resgid = sbi->s_resgid;
> +	old_opts.s_uid = sbi->s_uid;
> +	old_opts.s_diskuid = sbi->s_diskuid;
> +	old_opts.s_gid = sbi->s_gid;
> +	old_opts.s_diskgid = sbi->s_diskgid;
>  	old_opts.s_commit_interval = sbi->s_commit_interval;
>  	old_opts.s_min_batch_time = sbi->s_min_batch_time;
>  	old_opts.s_max_batch_time = sbi->s_max_batch_time;
> @@ -4402,6 +4445,10 @@ restore_opts:
>  	sbi->s_mount_opt2 = old_opts.s_mount_opt2;
>  	sbi->s_resuid = old_opts.s_resuid;
>  	sbi->s_resgid = old_opts.s_resgid;
> +	sbi->s_uid = old_opts.s_uid;
> +	sbi->s_diskuid = old_opts.s_diskuid;
> +	sbi->s_gid = old_opts.s_gid;
> +	sbi->s_diskgid = old_opts.s_diskgid;
>  	sbi->s_commit_interval = old_opts.s_commit_interval;
>  	sbi->s_min_batch_time = old_opts.s_min_batch_time;
>  	sbi->s_max_batch_time = old_opts.s_max_batch_time;
> -- 
> 1.7.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
