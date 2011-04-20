From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Date: Wed, 20 Apr 2011 15:54:16 -0700
Message-ID: <20110420225416.GA22210@tux1.beaverton.ibm.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <m2zknkstx1.fsf@firstfloor.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34680 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab1DTWyT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Apr 2011 18:54:19 -0400
Content-Disposition: inline
In-Reply-To: <m2zknkstx1.fsf@firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 20, 2011 at 10:40:26AM -0700, Andi Kleen wrote:
> "Darrick J. Wong" <djwong@us.ibm.com> writes:
> 
> FWIW I had a similar idea quite some time ago and implemented checksums for
> superblocks and inodes. I never posted it because I didn't get around
> to write the e2fsprogs support and do a lot of performance testing. 
> There was one result that showed a slow down in quick tests, but 
> I suspect it was a fluke and probably needs to be redone. In other
> tests it was neutral.

I've also seen comparable results between having inode checksums and not having
them.  Unfortunately, like you said, modifying e2fsprogs is really what's
slowing this down right now-- there are a lot of places that assume inode_size
= 128 and therefore only read/write that much.

> Anyways here's the old patch if anyone is interested (against a ~.35ish kernel)
> I can forward port it if there's interest.
> 
> IMHO it's a good idea but it should be done for the super blocks too
> (and ideally for all objects, although unfortunately that breaks 
> the disk format)

I think I've seen some proposals for checksumming the bitmaps and the extent
tree nodes.  It might be worth it to save some rocompat bits and combine them
all into one big(ger) rocompat flag.  I guess it wouldn't be too hard to throw
in superblock checksumming too. :)

> The locking for stable buffers is still something that needs to be
> double checked.



> -Andi
> 
> commit 8ece10cfa4b148075dbb93ca65855a7e2aad7b07
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Mon May 31 18:27:29 2010 +0200
> 
>     EXT4: Add checksums to the super block and the inodes
>     
>     Currently when a on-disk structure is corrupted ext4 usually
>     detects it only by some internal inconsistency, but this can happen
>     too late or give confusing error messages.
>     
>     One way to detect corruptions sooner is to use checksums. This
>     means the file system can stop using a corrupted object ASAP, not
>     follow any potentially corrupted pointers to other blocks,
>     and also give a clear message on what happened.
>     
>     Potentially it can also be used to limit read only mounts and
>     forced fscks. When the extent of a corruption can be detected
>     accurately using checksums and only force errors on that
>     particular object (this is right now not enabled though
>     because there are still too many objects with missing checksums)
>     
>     There's a general trend in file systems recently to add metadata
>     checksums, this just makes ext4 catch up a bit (in addition
>     to the already existing transaction and block group checksums)
>     
>     Another advantage is that the checksum can also check for misplaced
>     writes (by including the intended block location) and objects
>     left over from before mkfs (by including the file system UUID).
>     
>     Adding checksums to all metadata in ext4 would likely need some
>     incompatible format changes, but it's relatively straight-forward to add
>     them to inodes and the super block at least. This patch-kit does this.
>     
>     Again it only handles some meta-data objects. This is not a full
>     user-data checksumming feature or not even a "all metadata objects"
>     feature.
>     
>     I didn't do a lot of research into different CRC functions, but simply
>     used the same one as btrfs and iSCSI (crc32c).  ocfs2 uses ECCs
>     that have some self-correcting ability, but that seemed overkill to me.
>     The standard CRC has the advantage that the CRC is accelerated by hardware
>     instructions on newer Intel CPUs and possibly on other platforms too.
>     The CRC32C function is also hard coded, although in theory it could be made
>     configurable per file system. But since that would lead to a multitude of
>     incompatible formats I decided to simply hard code for now.
>     
>     Right now there is no e2fsprogs support, so fsck doesn't know about CRCs.
>     
>     For now the checksums can be enabled with a simple shell script
>     (which is just a wrapper around debugfs):
>     
>     wget ftp://firstfloor.org/pub/ak/shell/e2checksum
>     chmod +x e2checksum
>     
>     To enable:
>     
>     ./e2checksum /dev/device enable
>     
>     To disable:
>     
>     ./e2checksum /dev/device disable
>     
>     This works with the current ext4 e2fsprogs without any changes.
>     
>     The kernel will automatically add checksums to the file system when the
>     feature is turned on, as the inodes are rewritten.
>     
>     WARNING: Note there is no fsck support currently, so before you run fsck better
>     disable the checksums. After disabling/changing/reenabling
>     you may also need to mount with ignore_crc until the checksums
>     are fixed up again.
>     
>     The checksums are implemented as a read-only compat feature: this means
>     the a file system with checksums enabled can be read by a kernel that
>     does not know about checksums, but not written. Of course you can turn
>     off the flag again to make the file system write compatible again (but
>     that will put the checksums into a inconsistent state) or use the
>     ignore_crc mount option.
>     
>     WARNING: the in-kernel upgrader relies on the checksum fields being
>     zero when checksums are enabled. When you turn on the feature, use the
>     file system, turn it off again, use it again and turn it on again the
>     checksums will be in a inconsistent state. Right now this can be
>     fixed by mounting with -o ignore_crc and then doing a find | xargs touch
>     on the file system.
>     
>     I expect real e2fsprogs support can do that better.
>     
>     The code also adds some more sanity checks on inodes to distingush zeroed
>     inodes from inodes with no checksums. This is currently done by enforcing
>     that a/m/ctime are not zero. If there are broken file systems around
>     where that is not true, the sanity check can be turned off (see below)
>     
>     There are two new mount options:
>     
>     ignore_crc	       Ignore the CRCs on reading but still update them
>     noinode_sanity	       Don't do new inode sanity checks

Hm, the usage model of my patch is tune2fs; fsck; mount.  I suspect it's a good
idea to run fsck before/while turning on this feature to correct any other
errors.  Though, that means that the kernel will simply -EIO anything it thinks
is corrupt.

>     The implementation is not particularly optimized: it always recomputes
>     the full CRC on each inode or super block write. Some more optimizations
>     would be possible in this area.
>     
>     BENCHMARKS
>     
>     I ran kernelbench and it didn't show any significant difference between
>     the run with checksums and the run without.
>     
>     I also tried timing fsstress from XFS/LTP, and it gave a 35% slowdown
>     on a disk and 5% slow down on the ramdisk for the system time
>     during the test.  However I'm a bit suspicious of these results.
>     This was on a core 2.

I'll give fsstress a try when I get back to this (Friday skunkworks project).

Either way, thanks for the patch!

--D
>     
>     I also tested on a Nehalem system which has CRC acceleration instructions
>     in the CPU.
>     
>     Anyone has a better inode metadata intensive benchmark to run?
>     
>     This gobbled up the last mount flag bits, but there are still some unused
>     holes in the middle.
>     
>     The patch is definitely still experimental and needs more testing and
>     review and e2fsprogs support. In particular I would appreciate review
>     of my bh locking scheme.
>     
>     Also ext4_abort() now takes the super lock, which implies that the callers
>     shouldn't.  I think I checked all callers that it's safe, but double checking
>     that would be good.
>     
>     Opens:
>     - e2fsprogs support. In this case the zero crc hack could be removed from
>     the super block code at least.
>     - Right now checksum numbers by default lead to a read-only file system remount
>     and are also logged as "IO error". This could be made more gentle, because
>     a checksum catches problems early enough that continuation might be possible.
>     - Incremental checksumming
>     - Checksums for extents and directories
>     - In ignore_crc mode the checksums are only rewritten when the inode is somehow
>     dirtied otherwise. Do this implicitely? Might be better to move this to e2fsprogs
> 
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> index e1def17..e98141a 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -359,6 +359,14 @@ nodiscard(*)		commands to the underlying block device when
>  			and sparse/thinly-provisioned LUNs, but it is off
>  			by default until sufficient testing has been done.
> 
> +nosanity_check		Don't check for zero m/c/a times when reading a inode.
> +			Should not normally be needed.
> +
> +ignore_crc		Ignore checksum failures while reading the super block
> +			or inodes, but still update the checksums on writing
> +			(if you don't want to update the checksums, clear the
> +			checksum feature bit in the super block)
> +
>  Data Mode
>  =========
>  There are 3 different data modes:
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 19a4de5..3a99769 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -611,6 +611,7 @@ struct ext4_inode {
>  	__le32  i_crtime;       /* File Creation time */
>  	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
>  	__le32  i_version_hi;	/* high 32 bits for 64-bit version */
> +	__le32  i_crc;		/* CRC32 for this inode */
>  };
> 
>  struct move_extent {
> @@ -836,6 +837,12 @@ struct ext4_inode_info {
>  	 */
>  	tid_t i_sync_tid;
>  	tid_t i_datasync_tid;
> +
> +	/* 
> +	 * Protect raw inode modifications, mostly to ensure
> +	 * stability for checksumming.
> +	 */
> +	spinlock_t raw_inode_lock;
>  };
> 
>  /*
> @@ -881,10 +888,12 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
>  #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
>  #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
> +#define EXT4_MOUNT_IGNORE_CRC           0x4000000 /* Ignore CRCs on read */
>  #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
>  #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
>  #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
>  #define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
> +#define EXT4_MOUNT_INODE_SANITY         0x80000000 /* Inode sanity check */
> 
>  #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
>  #define set_opt(o, opt)			o |= EXT4_MOUNT_##opt
> @@ -1003,7 +1012,8 @@ struct ext4_super_block {
>  	__u8	s_reserved_char_pad2;
>  	__le16  s_reserved_pad;
>  	__le64	s_kbytes_written;	/* nr of lifetime kilobytes written */
> -	__u32   s_reserved[160];        /* Padding to the end of the block */
> +	__le32  s_crc;			/* CRC32 for this super block */
> +	__u32   s_reserved[159];        /* Padding to the end of the block */
>  };
> 
>  #ifdef __KERNEL__
> @@ -1051,6 +1061,7 @@ struct ext4_sb_info {
>  	u32 s_hash_seed[4];
>  	int s_def_hash_version;
>  	int s_hash_unsigned;	/* 3 if hash should be signed, 0 if not */
> +	u8 s_uuid[16];
>  	struct percpu_counter s_freeblocks_counter;
>  	struct percpu_counter s_freeinodes_counter;
>  	struct percpu_counter s_dirs_counter;
> @@ -1265,6 +1276,7 @@ EXT4_INODE_BIT_FNS(state, state_flags)
>  #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
>  #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
>  #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
> +#define EXT4_FEATURE_RO_COMPAT_SBI_CRC		0x0080 /* sb and inode CRCs */
> 
>  #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
>  #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
> @@ -1291,7 +1303,8 @@ EXT4_INODE_BIT_FNS(state, state_flags)
>  					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK | \
>  					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
>  					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR |\
> -					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
> +					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
> +					 EXT4_FEATURE_RO_COMPAT_SBI_CRC)
> 
>  /*
>   * Default values for user and/or group using reserved blocks
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 42272d6..8ba2f24 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -37,6 +37,7 @@
>  #include <linux/namei.h>
>  #include <linux/uio.h>
>  #include <linux/bio.h>
> +#include <linux/crc32c.h>
>  #include <linux/workqueue.h>
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
> @@ -72,6 +73,141 @@ static int ext4_inode_is_fast_symlink(struct inode *inode)
>  	return (S_ISLNK(inode->i_mode) && inode->i_blocks - ea_blocks == 0);
>  }
> 
> +#define ZERO_MAGIC 1
> +
> +static __le32 inode_crc(struct super_block *sb, struct ext4_inode *raw_inode, long ino)
> +{
> +	struct ext4_csum_header {
> +		__le64 ino;
> +		__le64 pad;
> +		u8     uuid[16];
> +	} __attribute__((aligned)) hdr;
> +	u32 crc;
> +
> +	/*
> +	 * First CRC in the inode number and the file system UUID
> +	 * to detect inodes from before the last mkfs and misplaced inode
> +	 * writes.
> +	 */
> +	hdr.ino = cpu_to_le64(ino);
> +	memcpy(&hdr.uuid, EXT4_SB(sb)->s_uuid, 16);
> +	hdr.pad = 0;
> +
> +	raw_inode->i_crc = 0;
> +	crc = crc32c(~0U, &hdr, sizeof(struct ext4_csum_header));
> +	/* Could CRC precompute the common zero tail? (if it's really common) */
> +	crc = crc32c(crc, raw_inode, EXT4_INODE_SIZE(sb));
> +	if (crc == 0)
> +		crc = ZERO_MAGIC;
> +	return cpu_to_le32(crc);
> +}
> +
> +/*
> + * Update CRC in a inode, including all additional fields after the
> + * standard inode structure.
> + *
> + * This relies on the raw_inode_lock protecting against all writes
> + * to the raw inode state in the bh. Right now the JBD locking
> + * is not good enough for that.
> + *
> + * This always precomputes the full checksum. In principle it would
> + * be possible to be more clever and do incremental changes at least
> + * for some state changes.
> + */
> +static void inode_update_crc(struct super_block *sb, struct ext4_inode *raw_inode,
> +			     long ino)
> +{
> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_SBI_CRC))
> +		return;
> +	raw_inode->i_crc = inode_crc(sb, raw_inode, ino);
> +}
> +
> +/*
> + * This is needed because nfsd might try to access dead inodes
> + * the test is that same one that e2fsck uses
> + * NeilBrown 1999oct15
> + */
> +static int inode_deleted(struct super_block *sb, struct ext4_inode *raw_inode)
> +{
> +	if (raw_inode->i_links_count == 0) {
> +		if (raw_inode->i_mode == 0 ||
> +		    !(EXT4_SB(sb)->s_mount_state & EXT4_ORPHAN_FS))
> +			return -ESTALE;
> +		/*
> +		 * The only unlinked inodes we let through here have
> +		 * valid i_mode and are being read by the orphan
> +		 * recovery code: that's fine, we're about to complete
> +		 * the process of deleting those.
> +		 */
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Does this checksum-less inode look like a valid inode?
> + * Do a few sanity checks.
> + */
> +static int inode_sanity_check(struct super_block *sb, struct ext4_inode *raw_inode, char **msg)
> +{
> +	int err = inode_deleted(sb, raw_inode);
> +	if (err)
> +		return err;
> +	if (!test_opt(sb, INODE_SANITY))
> +		return 0;
> +	if (raw_inode->i_mode == 0 ||
> +	    raw_inode->i_atime == 0 ||
> +	    raw_inode->i_ctime == 0 ||
> +	    raw_inode->i_mtime == 0) {
> +		*msg = "inode has invalid zero times";
> +		return -1;
> +	}
> +	/* More sanity checks? */
> +	return 0;
> +}
> +
> +/*
> + * Check CRC for a newly read inode.
> + */
> +static int inode_check_crc(struct super_block *sb, struct ext4_inode *raw_inode,
> +			   long ino, char **msg)
> +{
> +	__le32 crc, check;
> +
> +	/*
> +	 * Special case: zero CRC.  This is handled like no checksum yet,
> +	 * otherwise tune2fs would need to rewrite all inodes when CRCs
> +	 * are turned on. The CRC will be updated when the inode
> +	 * is written out.
> +	 *
> +	 * This however means that if zeroes are blasted over the inodes
> +	 * we would think the checksum is not there. So instead do
> +	 * some special sanity checks in the other fields when this happens,
> +	 * to catch this case.
> + 	 * This is not 100% fool proof, but should be reasonable.
> +	 * When the checksum function returns a real zero we turn that
> +	 * into a one to avoid ambiguity.
> +	 *
> +	 * The sanity check is done unconditionally even if the checksum passed
> +	 * because it's cheap enough.
> +	 */
> +	crc = raw_inode->i_crc;
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_SBI_CRC) && crc
> +	    && !test_opt(sb, IGNORE_CRC)) {
> + 		check = inode_crc(sb, raw_inode, ino);
> +		if (check != crc) {
> +			*msg = "inode has invalid checksum";
> +			/*
> +			 * Restore bad CRC so that if the inode is reread it'll fail
> +			 * the check again.
> +			 */
> +			raw_inode->i_crc = crc;
> +			return -1;
> +		}
> +	}
> +	return inode_sanity_check(sb, raw_inode, msg);
> +}
> +
>  /*
>   * Work out how many blocks we need to proceed with the next chunk of a
>   * truncate transaction.
> @@ -4996,6 +5132,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  	journal_t *journal = EXT4_SB(sb)->s_journal;
>  	long ret;
>  	int block;
> +	char *msg = NULL;
> 
>  	inode = iget_locked(sb, ino);
>  	if (!inode)
> @@ -5010,6 +5147,26 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  	if (ret < 0)
>  		goto bad_inode;
>  	raw_inode = ext4_raw_inode(&iloc);
> +
> + 	/*
> + 	 * Relies on the inode lock to protect the raw_inode bh contents.
> + 	 */
> + 	ret = inode_check_crc(sb, raw_inode, ino, &msg);
> + 	if (ret < 0) {
> + 		/*
> + 		 * Here would be the place to send a "read other mirror"
> + 		 * retry hint to the block layer.
> + 		 */
> + 		brelse(iloc.bh);
> + 		if (ret != -ESTALE)
> + 			ext4_error(sb,
> + 				   "%s: inode=%lu, block=%llu", msg,
> + 				   ino, 
> +				   (unsigned long long)iloc.bh->b_blocknr);
> + 		goto bad_inode;
> + 	}
> + 	ret = 0;
> +
>  	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
>  	inode->i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
>  	inode->i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
> @@ -5022,23 +5179,6 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  	ei->i_state_flags = 0;
>  	ei->i_dir_start_lookup = 0;
>  	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
> -	/* We now have enough fields to check if the inode was active or not.
> -	 * This is needed because nfsd might try to access dead inodes
> -	 * the test is that same one that e2fsck uses
> -	 * NeilBrown 1999oct15
> -	 */
> -	if (inode->i_nlink == 0) {
> -		if (inode->i_mode == 0 ||
> -		    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) {
> -			/* this inode is deleted */
> -			ret = -ESTALE;
> -			goto bad_inode;
> -		}
> -		/* The only unlinked inodes we let through here have
> -		 * valid i_mode and are being read by the orphan
> -		 * recovery code: that's fine, we're about to complete
> -		 * the process of deleting those. */
> -	}
>  	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
>  	inode->i_blocks = ext4_inode_blocks(raw_inode, ei);
>  	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl_lo);
> @@ -5232,11 +5372,19 @@ static int ext4_do_update_inode(handle_t *handle,
>  				struct inode *inode,
>  				struct ext4_iloc *iloc)
>  {
> +	struct super_block *sb = inode->i_sb;
>  	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct buffer_head *bh = iloc->bh;
>  	int err = 0, rc, block;
> 
> +	/*
> +	 * Protect the on disk inode against parallel modification
> +	 * until we compute the checksum and pass the resulting block
> +	 * to JBD, which protects it then.
> +	 */
> +	spin_lock(&ei->raw_inode_lock);
> +
>  	/* For fields not not tracking in the in-memory inode,
>  	 * initialise them to zero for new inodes. */
>  	if (ext4_test_inode_state(inode, EXT4_STATE_NEW))
> @@ -5291,18 +5439,23 @@ static int ext4_do_update_inode(handle_t *handle,
>  				EXT4_FEATURE_RO_COMPAT_LARGE_FILE) ||
>  				EXT4_SB(sb)->s_es->s_rev_level ==
>  				cpu_to_le32(EXT4_GOOD_OLD_REV)) {
> + 			spin_unlock(&ei->raw_inode_lock);
>  			/* If this is the first large file
>  			 * created, add a flag to the superblock.
>  			 */
>  			err = ext4_journal_get_write_access(handle,
>  					EXT4_SB(sb)->s_sbh);
> -			if (err)
> +			if (err) {
> + 				spin_lock(&ei->raw_inode_lock);
>  				goto out_brelse;
> +			}
>  			ext4_update_dynamic_rev(sb);
>  			EXT4_SET_RO_COMPAT_FEATURE(sb,
>  					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
>  			sb->s_dirt = 1;
>  			ext4_handle_sync(handle);
> + 			spin_lock(&ei->raw_inode_lock);
> + 			inode_update_crc(sb, raw_inode, inode->i_ino);
>  			err = ext4_handle_dirty_metadata(handle, NULL,
>  					EXT4_SB(sb)->s_sbh);
>  		}
> @@ -5330,6 +5483,7 @@ static int ext4_do_update_inode(handle_t *handle,
>  			cpu_to_le32(inode->i_version >> 32);
>  		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
>  	}
> +	inode_update_crc(sb, raw_inode, inode->i_ino);
> 
>  	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
>  	rc = ext4_handle_dirty_metadata(handle, NULL, bh);
> @@ -5339,6 +5493,7 @@ static int ext4_do_update_inode(handle_t *handle,
> 
>  	ext4_update_inode_fsync_trans(handle, inode, 0);
>  out_brelse:
> +	spin_unlock(&ei->raw_inode_lock);
>  	brelse(bh);
>  	ext4_std_error(inode->i_sb, err);
>  	return err;
> @@ -5759,6 +5914,8 @@ static int ext4_expand_extra_isize(struct inode *inode,
>  	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
>  		return 0;
> 
> +	spin_lock(&EXT4_I(inode)->raw_inode_lock);
> +
>  	raw_inode = ext4_raw_inode(&iloc);
> 
>  	header = IHDR(inode, raw_inode);
> @@ -5770,10 +5927,12 @@ static int ext4_expand_extra_isize(struct inode *inode,
>  		memset((void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE, 0,
>  			new_extra_isize);
>  		EXT4_I(inode)->i_extra_isize = new_extra_isize;
> +		spin_unlock(&EXT4_I(inode)->raw_inode_lock);
>  		return 0;
>  	}
> 
>  	/* try to expand with EAs present */
> +	spin_unlock(&EXT4_I(inode)->raw_inode_lock);
>  	return ext4_expand_extra_isize_ea(inode, new_extra_isize,
>  					  raw_inode, handle);
>  }
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4e8983a..4012753 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -39,6 +39,7 @@
>  #include <linux/ctype.h>
>  #include <linux/log2.h>
>  #include <linux/crc16.h>
> +#include <linux/crc32c.h>
>  #include <asm/uaccess.h>
> 
>  #include "ext4.h"
> @@ -70,6 +71,8 @@ static void ext4_write_super(struct super_block *sb);
>  static int ext4_freeze(struct super_block *sb);
>  static int ext4_get_sb(struct file_system_type *fs_type, int flags,
>  		       const char *dev_name, void *data, struct vfsmount *mnt);
> +static void ext4_super_update_crc(struct super_block *sb,
> +				  struct ext4_super_block *es);
> 
>  #if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
>  static struct file_system_type ext3_fs_type = {
> @@ -342,7 +345,14 @@ static void ext4_handle_error(struct super_block *sb)
>  		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
>  		sb->s_flags |= MS_RDONLY;
>  	}
> +	/*
> +	 * Unfortunately must take the lock here, to make sure there
> +	 * is consistent super state for the checksum. This is very easy to get
> +	 * wrong in the caller.
> +	 */
> +	lock_super(sb);
>  	ext4_commit_super(sb, 1);
> +	unlock_super(sb);
>  	if (test_opt(sb, ERRORS_PANIC))
>  		panic("EXT4-fs (device %s): panic forced after error\n",
>  			sb->s_id);
> @@ -531,7 +541,9 @@ __acquires(bitlock)
>  	if (test_opt(sb, ERRORS_CONT)) {
>  		EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
>  		es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
> +		lock_super(sb);
>  		ext4_commit_super(sb, 0);
> +		unlock_super(sb);
>  		return;
>  	}
>  	ext4_unlock_group(sb, grp);
> @@ -659,9 +671,12 @@ static void ext4_put_super(struct super_block *sb)
>  	if (sbi->s_journal) {
>  		err = jbd2_journal_destroy(sbi->s_journal);
>  		sbi->s_journal = NULL;
> -		if (err < 0)
> +		if (err < 0) {
> +			unlock_super(sb);
>  			ext4_abort(sb, __func__,
>  				   "Couldn't clean up the journal");
> +			lock_super(sb);
> +		}
>  	}
> 
>  	ext4_release_system_zone(sb);
> @@ -758,6 +773,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	ei->i_da_metadata_calc_len = 0;
>  	ei->i_delalloc_reserved_flag = 0;
>  	spin_lock_init(&(ei->i_block_reservation_lock));
> +	spin_lock_init(&(ei->raw_inode_lock));
>  #ifdef CONFIG_QUOTA
>  	ei->i_reserved_quota = 0;
>  #endif
> @@ -1161,6 +1177,7 @@ enum {
>  	Opt_inode_readahead_blks, Opt_journal_ioprio,
>  	Opt_dioread_nolock, Opt_dioread_lock,
>  	Opt_discard, Opt_nodiscard,
> + 	Opt_noinode_sanity, Opt_ignore_crc,
>  };
> 
>  static const match_table_t tokens = {
> @@ -1231,6 +1248,8 @@ static const match_table_t tokens = {
>  	{Opt_dioread_lock, "dioread_lock"},
>  	{Opt_discard, "discard"},
>  	{Opt_nodiscard, "nodiscard"},
> + 	{Opt_noinode_sanity, "noinode_sanity"},
> + 	{Opt_ignore_crc, "ignore_crc"},
>  	{Opt_err, NULL},
>  };
> 
> @@ -1408,6 +1427,12 @@ static int parse_options(char *options, struct super_block *sb,
>  		case Opt_orlov:
>  			clear_opt(sbi->s_mount_opt, OLDALLOC);
>  			break;
> +		case Opt_noinode_sanity:
> +			clear_opt(sbi->s_mount_opt, INODE_SANITY);
> +			break;
> +		case Opt_ignore_crc:
> +			set_opt(sbi->s_mount_opt, IGNORE_CRC);
> +			break;
>  #ifdef CONFIG_EXT4_FS_XATTR
>  		case Opt_user_xattr:
>  			set_opt(sbi->s_mount_opt, XATTR_USER);
> @@ -1946,6 +1971,7 @@ static int ext4_check_descriptors(struct super_block *sb)
>  	}
> 
>  	ext4_free_blocks_count_set(sbi->s_es, ext4_count_free_blocks(sb));
> + 	ext4_super_update_crc(sb, sbi->s_es);
>  	sbi->s_es->s_free_inodes_count =cpu_to_le32(ext4_count_free_inodes(sb));
>  	return 1;
>  }
> @@ -2431,6 +2457,50 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
>  	return 1;
>  }
> 
> +/* could be removed for SBs once e2fsutils are fixed to always compute
> +   the CRC when the feature is turned on. */
> +#define ZERO_MAGIC 1
> +
> +/*
> + * Manage CRC32 for the superblock.
> + */
> +static int ext4_super_check_crc(struct super_block *sb,
> +				struct ext4_super_block *es)
> +{
> +	u32 crc, check;
> +
> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_SBI_CRC))
> +		return 0;
> +	crc = le32_to_cpu(es->s_crc);
> +	if (crc == 0 || test_opt(sb, IGNORE_CRC)) {
> +		ext4_msg(sb, KERN_INFO, "super block checksum ignored");
> +		return 0;
> +	}
> +	es->s_crc = 0;
> +	check = crc32c(~0U, es, sizeof(struct ext4_super_block));
> +	if (check == 0)
> +		check = ZERO_MAGIC;
> +	if (check != crc)
> +		return -1;
> +	/* Remove me */
> +	ext4_msg(sb, KERN_INFO, "super block checksum passed");
> +	return 0;
> +}
> +
> +static void ext4_super_update_crc(struct super_block *sb,
> +				  struct ext4_super_block *es)
> +{
> +	u32 crc;
> +
> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_SBI_CRC))
> +		return;
> +	es->s_crc = 0;
> +        crc = crc32c(~0U, es, sizeof(struct ext4_super_block));
> +	if (crc == 0)
> +		crc = ZERO_MAGIC;
> +	es->s_crc = cpu_to_le32(crc);
> +}
> +
>  static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  				__releases(kernel_lock)
>  				__acquires(kernel_lock)
> @@ -2554,6 +2624,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	sbi->s_max_batch_time = EXT4_DEF_MAX_BATCH_TIME;
> 
>  	set_opt(sbi->s_mount_opt, BARRIER);
> +	set_opt(sbi->s_mount_opt, INODE_SANITY);
> 
>  	/*
>  	 * enable delayed allocation by default
> @@ -2585,6 +2656,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!ext4_feature_set_ok(sb, (sb->s_flags & MS_RDONLY)))
>  		goto failed_mount;
> 
> +	if (ext4_super_check_crc(sb, es) < 0) {
> +		ext4_msg(sb, KERN_ERR, "Invalid checksum in super block");
> +		goto failed_mount;
> +	}
> +
>  	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
> 
>  	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
> @@ -2675,6 +2751,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> 
>  	for (i = 0; i < 4; i++)
>  		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
> +	memcpy(sbi->s_uuid, es->s_uuid, 16);
>  	sbi->s_def_hash_version = es->s_def_hash_version;
>  	i = le32_to_cpu(es->s_flags);
>  	if (i & EXT2_FLAGS_UNSIGNED_HASH)
> @@ -3393,6 +3470,9 @@ static int ext4_commit_super(struct super_block *sb, int sync)
>  	es->s_free_inodes_count = cpu_to_le32(percpu_counter_sum_positive(
>  					&EXT4_SB(sb)->s_freeinodes_counter));
>  	sb->s_dirt = 0;
> +	/* can be removed if this is properly journaled, see
> +         * http://bugzilla.kernel.org/show_bug.cgi?id=14354 */
> +	ext4_super_update_crc(sb, es);
>  	BUFFER_TRACE(sbh, "marking dirty");
>  	mark_buffer_dirty(sbh);
>  	if (sync) {
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 0433800..fbba95a 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1171,6 +1171,7 @@ retry:
> 
>  	free = ext4_xattr_free_space(last, &min_offs, base, &total_ino);
>  	if (free >= new_extra_isize) {
> +		spin_lock(&EXT4_I(inode)->raw_inode_lock);
>  		entry = IFIRST(header);
>  		ext4_xattr_shift_entries(entry,	EXT4_I(inode)->i_extra_isize
>  				- new_extra_isize, (void *)raw_inode +
> @@ -1179,6 +1180,7 @@ retry:
>  				inode->i_sb->s_blocksize);
>  		EXT4_I(inode)->i_extra_isize = new_extra_isize;
>  		error = 0;
> +		spin_unlock(&EXT4_I(inode)->raw_inode_lock);
>  		goto cleanup;
>  	}
> 
> @@ -1301,6 +1303,7 @@ retry:
>  		if (error)
>  			goto cleanup;
> 
> +		spin_lock(&EXT4_I(inode)->raw_inode_lock);
>  		entry = IFIRST(header);
>  		if (entry_size + EXT4_XATTR_SIZE(size) >= new_extra_isize)
>  			shift_bytes = new_extra_isize;
> @@ -1312,6 +1315,7 @@ retry:
>  			EXT4_GOOD_OLD_INODE_SIZE + extra_isize + shift_bytes,
>  			(void *)header, total_ino - entry_size,
>  			inode->i_sb->s_blocksize);
> +		spin_unlock(&EXT4_I(inode)->raw_inode_lock);
> 
>  		extra_isize += shift_bytes;
>  		new_extra_isize -= shift_bytes;
> 
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
