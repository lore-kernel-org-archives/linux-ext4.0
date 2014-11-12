From: Dmitry Monakhov <dmonlist@gmail.com>
Subject: Re: [PATCH,RFC] ext4: add lazytime mount option
Date: Wed, 12 Nov 2014 16:47:42 +0300
Message-ID: <87vbmkpm2p.fsf@openvz.org>
References: <1415765227-9561-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Theodore Ts'o <tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35568 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaKLNr5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2014 08:47:57 -0500
Received: by mail-wg0-f45.google.com with SMTP id x12so14381275wgg.18
        for <linux-ext4@vger.kernel.org>; Wed, 12 Nov 2014 05:47:56 -0800 (PST)
In-Reply-To: <1415765227-9561-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> Add a new mount option which enables a new "lazytime" mode.  This mode
> causes atime, mtime, and ctime updates to only be made to the
> in-memory version of the inode.  The on-disk times will only get
> updated when (a) when the inode table block for the inode needs to be
> updated for some non-time related change involving any inode in the
> block, (b) if userspace calls fsync(), or (c) the refcount on an
> undeleted inode goes to zero (in most cases, when the last file
> descriptor assoicated with the inode is closed).
>
> This is legal according to POSIX because there are no guarantees after
> a crash unless userspace explicitly requests via a fsync(2) call.  So
> in fact, this a better way of reducing the disk traffic resulting from
> atime is use lazytime instead of relatime or noatime.  Enabling
> lazytime and disabling the default realtime will result in fewer extra
> disk writes, and has the benefits of being POSIX-compliant --- since
> either noatime and relatime violates POSIX.
Indeed, in fact even current implementation can not guarantee correct
mtime in  case of power-fail for example:
DIO_WRITE_TASK
 ->file_update_time:
        journal_start
        save mtime in journal in tid:B
        journal_stop
 ->direct_IO(): modify files's content which may be flushed to non
                volatile storage.

POWER_FAILURE

NEW_MOUNT: journal replay will find that tid:B has no commit record and
ignore it. As result file has old mtime, but new content
>
> The lazytime mode reduces pressure on the journal spinlocks, since
> time updates resulting from calls to file_update_time() are almost
> always done using separate jbd2 handles.  For allocating writes, the
> inode will need to be updated anyway when i_blocks change, and so the
> mtime updates will be folded into jbd2 handle in the ext4 write path.
>
> In addition, for workloads feature a large number of random write to a
> preallocated file, the lazytime mount option significantly reduces
> writes to the inode table.  The repeated 4k writes to a single block
> will result in undesirable stress on flash devices and SMR disk
> drives.  Even on conventional HDD's, the repeated writes to the inode
> table block will trigger Adjacent Track Interference (ATI) remediation
> latencies, which very negatively impact 99.9 percentile latencies ---
> which is a very big deal for web serving tiers (for example).
Also sync mtime updates is a great pain for AIO submitter
because AIO submission may be blocked for a seconds (up to 5 second in my c=
ase)
if inode is part of current committing transaction see: do_get_write_access
>
> n.b.: because of the many wins of this mode, we may want to enable
> lazytime updates by default in the future.  If you know of use cases
> where having inaccurate mtime values after a crash would be extremely
> problematic, please us know at linux-ext4@vger.kernel.org.
>
> Google-Bug-Id: 18297052
Yeah we also has ticket for that :)
https://jira.sw.ru/browse/PSBM-20411
>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Patch looks good with minor nodes, please see below.
> ---
>  fs/ext4/ext4.h     |  3 +++
>  fs/ext4/file.c     |  1 +
>  fs/ext4/fsync.c    |  3 +++
>  fs/ext4/inode.c    | 62 ++++++++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  fs/ext4/namei.c    |  2 ++
>  fs/ext4/super.c    | 14 ++++++++++++
>  fs/ext4/symlink.c  |  2 ++
>  fs/inode.c         | 36 +++++++++++++++++++++++++++++++
>  include/linux/fs.h |  2 ++
>  9 files changed, 124 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index c55a1fa..494c504 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -970,6 +970,7 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_ERRORS_MASK		0x00070
>  #define EXT4_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
>  #define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
> +#define EXT4_MOUNT_LAZYTIME		0x00200 /* Update the time lazily */
>  #define EXT4_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
>  #define EXT4_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
>  #define EXT4_MOUNT_ORDERED_DATA		0x00800	/* Flush data before commit */
> @@ -1407,6 +1408,7 @@ enum {
>  	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
>  	EXT4_STATE_ORDERED_MODE,	/* data=3Dordered mode */
>  	EXT4_STATE_EXT_PRECACHED,	/* extents have been precached */
> +	EXT4_STATE_DIRTY_TIME,		/* the time needs to be updated */
>  };
>=20=20
>  #define EXT4_INODE_BIT_FNS(name, field, offset)				\
> @@ -2114,6 +2116,7 @@ extern int  ext4_write_inode(struct inode *, struct=
 writeback_control *);
>  extern int  ext4_setattr(struct dentry *, struct iattr *);
>  extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
>  				struct kstat *stat);
> +extern int ext4_update_time(struct inode *, struct timespec *, int);
>  extern void ext4_evict_inode(struct inode *);
>  extern void ext4_clear_inode(struct inode *);
>  extern int  ext4_sync_inode(handle_t *, struct inode *);
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 8131be8..2cf6aaf 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -603,6 +603,7 @@ const struct file_operations ext4_file_operations =3D=
 {
>  const struct inode_operations ext4_file_inode_operations =3D {
>  	.setattr	=3D ext4_setattr,
>  	.getattr	=3D ext4_getattr,
> +	.update_time	=3D ext4_update_time,
>  	.setxattr	=3D generic_setxattr,
>  	.getxattr	=3D generic_getxattr,
>  	.listxattr	=3D ext4_listxattr,
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index a8bc47f..ba05c83 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -116,6 +116,9 @@ int ext4_sync_file(struct file *file, loff_t start, l=
off_t end, int datasync)
>  	ret =3D filemap_write_and_wait_range(inode->i_mapping, start, end);
>  	if (ret)
>  		return ret;
> +
> +	if (!datasync && ext4_test_inode_state(inode, EXT4_STATE_DIRTY_TIME))
> +		ext4_dirty_inode(inode, 0);
>  	/*
>  	 * data=3Dwriteback,ordered:
>  	 *  The caller's filemap_fdatawrite()/wait will sync the data.
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3356ab5..1b5e4bd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4163,6 +4163,46 @@ static int ext4_inode_blocks_set(handle_t *handle,
>  }
>=20=20
>  /*
> + * Opportunistically update the other time fields for other inodes in
> + * the same inode table block.
> + */
> +static void ext4_update_other_inodes_time(struct super_block *sb,
> +					  unsigned long orig_ino, char *buf)
> +{
> +	struct ext4_inode_info	*ei;
> +	struct ext4_inode	*raw_inode;
> +	unsigned long		ino;
> +	struct inode		*inode;
> +	int		i, inodes_per_block =3D EXT4_SB(sb)->s_inodes_per_block;
> +	int		inode_size =3D EXT4_INODE_SIZE(sb);
> +
> +	ino =3D orig_ino & ~(inodes_per_block - 1);
> +	for (i =3D 0; i < inodes_per_block; i++, ino++, buf +=3D inode_size) {
> +		if (ino =3D=3D orig_ino)
> +			continue;
> +		inode =3D find_active_inode_nowait(sb, ino);
> +		if (!inode ||
> +		    !ext4_test_inode_state(inode, EXT4_STATE_DIRTY_TIME)) {
> +			iput(inode);
> +			continue;
> +		}
> +		raw_inode =3D (struct ext4_inode *) buf;
> +		ei =3D EXT4_I(inode);
> +
> +		smp_mb__before_spinlock();
> +		spin_lock(&ei->i_raw_lock);
> +		ext4_clear_inode_state(inode, EXT4_STATE_DIRTY_TIME);
> +		EXT4_INODE_GET_XTIME(i_ctime, inode, raw_inode);
> +		EXT4_INODE_GET_XTIME(i_mtime, inode, raw_inode);
> +		EXT4_INODE_GET_XTIME(i_atime, inode, raw_inode);
> +		EXT4_EINODE_GET_XTIME(i_crtime, ei, raw_inode);
> +		ext4_inode_csum_set(inode, raw_inode, ei);
> +		spin_unlock(&ei->i_raw_lock);
> +		iput(inode);
> +	}
> +}
> +
> +/*
>   * Post the struct inode info into an on-disk inode location in the
>   * buffer-cache.  This gobbles the caller's reference to the
>   * buffer_head in the inode location struct.
> @@ -4182,7 +4222,9 @@ static int ext4_do_update_inode(handle_t *handle,
>  	uid_t i_uid;
>  	gid_t i_gid;
>=20=20
> +	smp_mb__before_spinlock();
>  	spin_lock(&ei->i_raw_lock);
> +	ext4_clear_inode_state(inode, EXT4_STATE_DIRTY_TIME);
>=20=20
>  	/* For fields not tracked in the in-memory inode,
>  	 * initialise them to zero for new inodes. */
> @@ -4273,8 +4315,8 @@ static int ext4_do_update_inode(handle_t *handle,
>  	}
>=20=20
>  	ext4_inode_csum_set(inode, raw_inode, ei);
> -
>  	spin_unlock(&ei->i_raw_lock);
> +	ext4_update_other_inodes_time(inode->i_sb, inode->i_ino, bh->b_data);
>=20=20
>  	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
>  	rc =3D ext4_handle_dirty_metadata(handle, NULL, bh);
> @@ -4622,6 +4664,24 @@ int ext4_getattr(struct vfsmount *mnt, struct dent=
ry *dentry,
>  	return 0;
>  }
>=20=20
> +int ext4_update_time(struct inode *inode, struct timespec *time, int fla=
gs)
> +{
> +	if (flags & S_ATIME)
> +		inode->i_atime =3D *time;
> +	if (flags & S_VERSION)
> +		inode_inc_iversion(inode);
> +	if (flags & S_CTIME)
> +		inode->i_ctime =3D *time;
> +	if (flags & S_MTIME)
> +		inode->i_mtime =3D *time;
> +	if (test_opt(inode->i_sb, LAZYTIME)) {
> +		smp_wmb();
> +		ext4_set_inode_state(inode, EXT4_STATE_DIRTY_TIME);
Since we want update all in-memory data we also have to explicitly update i=
node->i_version
Which was previously updated implicitly here:
mark_inode_dirty_sync()
=2D>__mark_inode_dirty
  ->ext4_dirty_inode
    ->ext4_mark_inode_dirty
      ->ext4_mark_iloc_dirty
        ->inode_inc_iversion(inode);
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> +	} else
> +		mark_inode_dirty_sync(inode);
> +	return 0;
> +}

> +
>  static int ext4_index_trans_blocks(struct inode *inode, int lblocks,
>  				   int pextents)
>  {
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 4262118..f782040 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3532,6 +3532,7 @@ const struct inode_operations ext4_dir_inode_operat=
ions =3D {
>  	.tmpfile	=3D ext4_tmpfile,
>  	.rename2	=3D ext4_rename2,
>  	.setattr	=3D ext4_setattr,
> +	.update_time	=3D ext4_update_time,
>  	.setxattr	=3D generic_setxattr,
>  	.getxattr	=3D generic_getxattr,
>  	.listxattr	=3D ext4_listxattr,
> @@ -3545,6 +3546,7 @@ const struct inode_operations ext4_special_inode_op=
erations =3D {
>  	.setattr	=3D ext4_setattr,
>  	.setxattr	=3D generic_setxattr,
>  	.getxattr	=3D generic_getxattr,
> +	.update_time	=3D ext4_update_time,
>  	.listxattr	=3D ext4_listxattr,
>  	.removexattr	=3D generic_removexattr,
>  	.get_acl	=3D ext4_get_acl,
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2c9e686..16c9983 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -910,6 +910,14 @@ static int ext4_drop_inode(struct inode *inode)
>  	int drop =3D generic_drop_inode(inode);
>=20=20
>  	trace_ext4_drop_inode(inode, drop);
> +	if (!drop && ext4_test_inode_state(inode, EXT4_STATE_DIRTY_TIME)) {
> +		atomic_inc(&inode->i_count);
> +		spin_unlock(&inode->i_lock);
> +		ext4_dirty_inode(inode, 0);
> +		spin_lock(&inode->i_lock);
> +		if (atomic_dec_and_test(&inode->i_count))
> +			drop =3D generic_drop_inode(inode);
> +	}
>  	return drop;
>  }
>=20=20
> @@ -1142,6 +1150,7 @@ enum {
>  	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
>  	Opt_usrquota, Opt_grpquota, Opt_i_version,
>  	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
> +	Opt_lazytime, Opt_nolazytime,
>  	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
>  	Opt_inode_readahead_blks, Opt_journal_ioprio,
>  	Opt_dioread_nolock, Opt_dioread_lock,
> @@ -1204,6 +1213,8 @@ static const match_table_t tokens =3D {
>  	{Opt_i_version, "i_version"},
>  	{Opt_stripe, "stripe=3D%u"},
>  	{Opt_delalloc, "delalloc"},
> +	{Opt_lazytime, "lazytime"},
> +	{Opt_nolazytime, "nolazytime"},
>  	{Opt_nodelalloc, "nodelalloc"},
>  	{Opt_removed, "mblk_io_submit"},
>  	{Opt_removed, "nomblk_io_submit"},
> @@ -1361,6 +1372,8 @@ static const struct mount_opts {
>  	 MOPT_EXT4_ONLY | MOPT_SET | MOPT_EXPLICIT},
>  	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC,
>  	 MOPT_EXT4_ONLY | MOPT_CLEAR},
> +	{Opt_lazytime, EXT4_MOUNT_LAZYTIME, MOPT_SET},
> +	{Opt_nolazytime, EXT4_MOUNT_LAZYTIME, MOPT_CLEAR},
>  	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
>  	 MOPT_EXT4_ONLY | MOPT_SET},
>  	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
> @@ -3514,6 +3527,7 @@ static int ext4_fill_super(struct super_block *sb, =
void *data, int silent)
>=20=20
>  	/* Set defaults before we parse the mount options */
>  	def_mount_opts =3D le32_to_cpu(es->s_default_mount_opts);
> +	set_opt(sb, LAZYTIME);
>  	set_opt(sb, INIT_INODE_TABLE);
>  	if (def_mount_opts & EXT4_DEFM_DEBUG)
>  		set_opt(sb, DEBUG);
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index ff37119..7c92b93 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -35,6 +35,7 @@ const struct inode_operations ext4_symlink_inode_operat=
ions =3D {
>  	.follow_link	=3D page_follow_link_light,
>  	.put_link	=3D page_put_link,
>  	.setattr	=3D ext4_setattr,
> +	.update_time	=3D ext4_update_time,
>  	.setxattr	=3D generic_setxattr,
>  	.getxattr	=3D generic_getxattr,
>  	.listxattr	=3D ext4_listxattr,
> @@ -45,6 +46,7 @@ const struct inode_operations ext4_fast_symlink_inode_o=
perations =3D {
>  	.readlink	=3D generic_readlink,
>  	.follow_link	=3D ext4_follow_link,
>  	.setattr	=3D ext4_setattr,
> +	.update_time	=3D ext4_update_time,
>  	.setxattr	=3D generic_setxattr,
>  	.getxattr	=3D generic_getxattr,
>  	.listxattr	=3D ext4_listxattr,
> diff --git a/fs/inode.c b/fs/inode.c
> index 26753ba..cde073a 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1280,6 +1280,42 @@ struct inode *ilookup(struct super_block *sb, unsi=
gned long ino)
>  }
>  EXPORT_SYMBOL(ilookup);
>=20=20
> +/**
> + * find_active_inode_nowait - find an active inode in the inode cache
> + * @sb:		super block of file system to search
> + * @ino:	inode number to search for
> + *
> + * Search for an active inode @ino in the inode cache, and if the
> + * inode is in the cache, the inode is returned with an incremented
> + * reference count.  If the inode is being freed or is newly
> + * initialized, return nothing instead of trying to wait for the inode
> + * initialization or destruction to be complete.
> + */
> +struct inode *find_active_inode_nowait(struct super_block *sb,
> +				       unsigned long ino)
> +{
> +	struct hlist_head *head =3D inode_hashtable + hash(sb, ino);
> +	struct inode *inode, *ret_inode =3D NULL;
> +
> +	spin_lock(&inode_hash_lock);
> +	hlist_for_each_entry(inode, head, i_hash) {
> +		if ((inode->i_ino !=3D ino) ||
> +		    (inode->i_sb !=3D sb))
> +			continue;
> +		spin_lock(&inode->i_lock);
> +		if ((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) =3D=3D 0) {
> +			__iget(inode);
> +			ret_inode =3D inode;
> +		}
> +		spin_unlock(&inode->i_lock);
> +		goto out;
> +	}
> +out:
> +	spin_unlock(&inode_hash_lock);
> +	return ret_inode;
> +}
> +EXPORT_SYMBOL(find_active_inode_nowait);
> +
>  int insert_inode_locked(struct inode *inode)
>  {
>  	struct super_block *sb =3D inode->i_sb;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9ab779e..b5e6b6b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2410,6 +2410,8 @@ extern struct inode *ilookup(struct super_block *sb=
, unsigned long ino);
>=20=20
>  extern struct inode * iget5_locked(struct super_block *, unsigned long, =
int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), vo=
id *);
>  extern struct inode * iget_locked(struct super_block *, unsigned long);
> +extern struct inode *find_active_inode_nowait(struct super_block *,
> +					      unsigned long);
>  extern int insert_inode_locked4(struct inode *, unsigned long, int (*tes=
t)(struct inode *, void *), void *);
>  extern int insert_inode_locked(struct inode *);
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> --=20
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUY2T+AAoJELhyPTmIL6kB1XgH/AzvWOEXvA8V6I+THsWLZQYB
NasW027pnb0OFbM0Zq+5ujIWozWNNfz15rhyh8tG6EvHmEsaWurgE16Olz3njuPg
LKxoM57m0eSuDl5Hkq9fNHmYsebDwVmOx29xPdsqwJB3Vraq9vagNJHWvHpxqaIO
sZyWq/uG+FvPGBfkOSrzBgvVbcOaTthNftl7DFNoWl8ZNSQmOXmr8lxTbuGOAqxs
IvWxrgj2NPEanC/uVDwhwY5pI3DhhlpTkEpEk8Zu+5cADErO+GprhS4IbcCpYLOA
+Q4MbG8F1L62KCae9mS5sqzAIuvarQ3hdTYYcQ0sNQHbcRxU46dxCq43McR74Gk=
=DCwc
-----END PGP SIGNATURE-----
--=-=-=--
