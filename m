From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V2] ext3: allow specifying external journal by pathname
 mount option
Date: Wed, 31 Jul 2013 22:10:36 +0200
Message-ID: <20130731201036.GA29593@quack.suse.cz>
References: <51F83D90.5080708@redhat.com>
 <51F9666C.1050603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Leonardo Menezes Vaz <lvaz@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760619Ab3GaUKj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jul 2013 16:10:39 -0400
Content-Disposition: inline
In-Reply-To: <51F9666C.1050603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 31-07-13 14:33:00, Eric Sandeen wrote:
> It's always been a hassle that if an external journal's
> device number changes, the filesystem won't mount.
> And since boot-time enumeration can change, device number
> changes aren't unusual.
> 
> The current mechanism to update the journal location is by
> passing in a mount option w/ a new devnum, but that's a hassle;
> it's a manual approach, fixing things after the fact.
> 
> Adding a mount option, "-o journal_path=/dev/$DEVICE" would
> help, since then we can do i.e.
> 
> # mount -o journal_path=/dev/disk/by-label/$JOURNAL_LABEL ...
> 
> and it'll mount even if the devnum has changed, as shown here:
> 
> # losetup /dev/loop0 journalfile
> # mke2fs -L mylabel-journal -O journal_dev /dev/loop0 
> # mkfs.ext3 -L mylabel -J device=/dev/loop0 /dev/sdb1
> 
> Change the journal device number:
> 
> # losetup -d /dev/loop0
> # losetup /dev/loop1 journalfile 
> 
> And today it will fail:
> 
> # mount /dev/sdb1 /mnt/test
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> # dmesg | tail -n 1
> [17343.240702] EXT3-fs (sdb1): error: couldn't read superblock of external journal
> 
> But with this new mount option, we can specify the new path:
> 
> # mount -o journal_path=/dev/loop1 /dev/sdb1 /mnt/test
> #
> 
> (which does update the encoded device number, incidentally):
> 
> # umount /dev/sdb1
> # dumpe2fs -h /dev/sdb1 | grep "Journal device"
> dumpe2fs 1.41.12 (17-May-2010)
> Journal device:	          0x0701
> 
> But best of all we can just always mount by journal-path, and
> it'll always work:
> 
> # mount -o journal_path=/dev/disk/by-label/mylabel-journal /dev/sdb1 /mnt/test
> #
> 
> So the journal_path option can be specified in fstab, and as long as
> the disk is available somewhere, and findable by label (or by UUID),
> we can mount.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
  Thanks! I've merged the patch to my tree.

								Honza

> ---
> 
> V2: get device out of bdev's inode, rather than grabbing bdev & releasing it
> 
> diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
> index 293855e..7ed0d17 100644
> --- a/Documentation/filesystems/ext3.txt
> +++ b/Documentation/filesystems/ext3.txt
> @@ -26,11 +26,12 @@ journal=inum		When a journal already exists, this option is ignored.
>  			Otherwise, it specifies the number of the inode which
>  			will represent the ext3 file system's journal file.
>  
> +journal_path=path
>  journal_dev=devnum	When the external journal device's major/minor numbers
> -			have changed, this option allows the user to specify
> +			have changed, these options allow the user to specify
>  			the new journal location.  The journal device is
> -			identified through its new major/minor numbers encoded
> -			in devnum.
> +			identified through either its new major/minor numbers
> +			encoded in devnum, or via a path to the device.
>  
>  norecovery		Don't load the journal on mounting. Note that this forces
>  noload			mount of inconsistent filesystem, which can lead to
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index c47f147..c50c761 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -27,6 +27,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/log2.h>
>  #include <linux/cleancache.h>
> +#include <linux/namei.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -819,6 +820,7 @@ enum {
>  	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
>  	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
>  	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
> +	Opt_journal_path,
>  	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
>  	Opt_data_err_abort, Opt_data_err_ignore,
>  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
> @@ -860,6 +862,7 @@ static const match_table_t tokens = {
>  	{Opt_journal_update, "journal=update"},
>  	{Opt_journal_inum, "journal=%u"},
>  	{Opt_journal_dev, "journal_dev=%u"},
> +	{Opt_journal_path, "journal_path=%s"},
>  	{Opt_abort, "abort"},
>  	{Opt_data_journal, "data=journal"},
>  	{Opt_data_ordered, "data=ordered"},
> @@ -975,6 +978,11 @@ static int parse_options (char *options, struct super_block *sb,
>  	int option;
>  	kuid_t uid;
>  	kgid_t gid;
> +	char *journal_path;
> +	struct inode *journal_inode;
> +	struct path path;
> +	int error;
> +
>  #ifdef CONFIG_QUOTA
>  	int qfmt;
>  #endif
> @@ -1129,6 +1137,41 @@ static int parse_options (char *options, struct super_block *sb,
>  				return 0;
>  			*journal_devnum = option;
>  			break;
> +		case Opt_journal_path:
> +			if (is_remount) {
> +				ext3_msg(sb, KERN_ERR, "error: cannot specify "
> +				       "journal on remount");
> +				return 0;
> +			}
> +
> +			journal_path = match_strdup(&args[0]);
> +			if (!journal_path) {
> +				ext3_msg(sb, KERN_ERR, "error: could not dup "
> +					"journal device string");
> +				return 0;
> +			}
> +
> +			error = kern_path(journal_path, LOOKUP_FOLLOW, &path);
> +			if (error) {
> +				ext3_msg(sb, KERN_ERR, "error: could not find "
> +					"journal device path: error %d", error);
> +				kfree(journal_path);
> +				return 0;
> +			}
> +
> +			journal_inode = path.dentry->d_inode;
> +			if (!S_ISBLK(journal_inode->i_mode)) {
> +				ext3_msg(sb, KERN_ERR, "error: journal path %s "
> +					"is not a block device", journal_path);
> +				path_put(&path);
> +				kfree(journal_path);
> +				return 0;
> +			}
> +
> +			*journal_devnum = new_encode_dev(journal_inode->i_rdev);
> +			path_put(&path);
> +			kfree(journal_path);
> +			break;
>  		case Opt_noload:
>  			set_opt (sbi->s_mount_opt, NOLOAD);
>  			break;
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
