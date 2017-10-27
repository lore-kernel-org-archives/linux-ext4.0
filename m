From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC][PATCH 2/2] ext4: Add 64-bit inode number support
Date: Fri, 27 Oct 2017 16:02:20 -0600
Message-ID: <8B3E538E-071D-4A48-963A-B3314C76CB35@dilger.ca>
References: <20171027172221.14072-1-artem.blagodarenko@gmail.com>
 <20171027172221.14072-3-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_B98A8C47-1320-4B20-A8FA-E4C15A0E1502";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:49462 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932190AbdJ0WC1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Oct 2017 18:02:27 -0400
Received: by mail-io0-f193.google.com with SMTP id n137so15675241iod.6
        for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2017 15:02:27 -0700 (PDT)
In-Reply-To: <20171027172221.14072-3-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_B98A8C47-1320-4B20-A8FA-E4C15A0E1502
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 27, 2017, at 11:22 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> Use dirdata to store high bits of 64bit inode
> number.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
> ---
> fs/ext4/dir.c    |  4 +--
> fs/ext4/ext4.h   | 77 =
+++++++++++++++++++++++++++++++++++++++++++++-----------
> fs/ext4/ialloc.c |  8 +++---
> fs/ext4/namei.c  | 29 ++++++++++++++++++---
> fs/ext4/super.c  |  8 +++---
> 5 files changed, 97 insertions(+), 29 deletions(-)
>=20
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 282279b66385..d2a17af0185d 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -381,7 +381,7 @@ struct fname {
> 	__u32		minor_hash;
> 	struct rb_node	rb_hash;
> 	struct fname	*next;
> -	__u32		inode;
> +	__u64		inode;
> 	__u8		name_len;
> 	__u8		file_type;
> 	char		name[0];

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index aaaed29caa67..5965c54976e3 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1331,8 +1331,13 @@ struct ext4_super_block {
> 	__le32	s_lpf_ino;		/* Location of the lost+found =
inode */
> 	__le32	s_prj_quota_inum;	/* inode for tracking project =
quota */
> 	__le32	s_checksum_seed;	/* crc32c(uuid) if csum_seed set =
*/
> -	__le32	s_reserved[98];		/* Padding to the end of the =
block */
> -	__le32	s_checksum;		/* crc32c(superblock) */
> +	__u32	s_inodes_count_hi;	/* higth part of inode count */
> +	__u32	s_free_inodes_count_hi;	/* Free inodes count */
> +	__u32	s_usr_quota_inum_hi;
> +	__u32	s_grp_quota_inum_hi;
> +	__u32	s_prj_quota_inum_hi;
> +	__u32	s_reserved[93];		/* Padding to the end of the =
block */
> +	__u32	s_checksum;		/* crc32c(superblock) */

Why use "__u32" instead of "__le32" like the other fields?  __le32 helps =
ensure
that the fields are swabbed properly upon access.

> @@ -1805,6 +1799,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		=
ENCRYPT)
> 					 =
EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
> 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | =
\
> 					 EXT4_FEATURE_INCOMPAT_CSUM_SEED =
| \
> +					 EXT4_FEATURE_INCOMPAT_64INODE | =
\
> 					 EXT4_FEATURE_INCOMPAT_LARGEDIR =
| \
> 					 EXT4_FEATURE_INCOMPAT_DIRDATA)

IMHO, this feature would be better named "INCOMPAT_INODE64" so that the =
helper
function is named ext4_feature_inode64() instead of =
ext4_feature_64inode().

> @@ -2889,6 +2884,58 @@ static inline unsigned int =
ext4_flex_bg_size(struct ext4_sb_info *sbi)
> 	return 1 << sbi->s_log_groups_per_flex;
> }
>=20
> +static inline unsigned long ext4_get_inodes_count(struct =
ext4_super_block *sb)
> +{
> +        unsigned long inodes_count =3D sb->s_inodes_count;

This needs to be u64 instead of "unsigned long", or it will break on =
32-bit CPUs.

> +        if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64INODE)

This should use ext4_has_feature_inode64(sb), as with all these other =
helpers.

> +                inodes_count |=3D (unsigned =
long)sb->s_inodes_count_hi << 32;
> +        return inodes_count;


Also, these functions need to swab s_inodes_count and s_inodes_count_hi
before combining them into the unsigned long, since it isn't possible to
do it correctly in the caller:

static inline unsigned long ext4_get_inodes_count(struct =
ext4_super_block *sb)
{
	unsigned long inodes_count =3D le32_to_cpu(sb->s_inodes_count);

	if (ext4_has_feature_inode64(sb))
		inodes_count |=3D
			(unsigned =
long)le32_to_cpu(sb->s_inodes_count_hi) << 32;
	return inodes_count;
}

> +static inline void ext4_set_inodes_count(struct ext4_super_block *sb, =
unsigned long val)

Also needs to be u64 instead of "unsigned long", and wrap at 80 columns.

Hmm, I see struct inode "i_ino" is declared as unsigned long, which is a =
bit
of a problem.  Does that mean we just refuse to mount ext4 filesystems =
with
64-bit inode numbers on 32-bit systems?  It wouldn't be the end of the =
world.

> +{
> +        if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64INODE)


> +                sb->s_inodes_count_hi =3D  val >> 32;
> +
> +        sb->s_inodes_count =3D val;
> +}
> +
> +static inline unsigned long ext4_get_free_inodes_count(struct =
ext4_super_block *sb)
> +{
> +        unsigned long inodes_count =3D sb->s_free_inodes_count;
> +
> +        if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64INODE);
> +                inodes_count |=3D (unsigned =
long)sb->s_free_inodes_count_hi << 32;
> +        return inodes_count;
> +}
> +
> +static inline void ext4_set_free_inodes_count(struct ext4_super_block =
*sb, unsigned long val)
> +{
> +        if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64INODE)
> +                sb->s_free_inodes_count_hi =3D  (__u32)(val >> 32);
> +
> +        sb->s_free_inodes_count =3D val;
> +}
> +
> +static inline void ext4_inc_free_inodes_count(struct ext4_super_block =
*sb)
> +{
> +        __u64 val =3D ext4_get_free_inodes_count(sb);
> +
> +        ext4_set_free_inodes_count(sb, val);

This isn't actually incrementing the free inodes count?  Also, rather =
than
having separate inc/dec operations it is probably better to just pass an
argument with +/-1 (or +/- N).

> +static inline int ext4_valid_inum(struct super_block *sb, unsigned =
long ino)
> +{
> +	return ino =3D=3D EXT4_ROOT_INO ||
> +		ino =3D=3D EXT4_USR_QUOTA_INO ||
> +		ino =3D=3D EXT4_GRP_QUOTA_INO ||
> +		ino =3D=3D EXT4_JOURNAL_INO ||
> +		ino =3D=3D EXT4_RESIZE_INO ||
> +		(ino >=3D EXT4_FIRST_INO(sb) &&
> +		 ino <=3D =
le64_to_cpu(ext4_get_inodes_count(EXT4_SB(sb)->s_es)));

(defect) swabbing should not be done here.

> +}
> +
> #define ext4_std_error(sb, errno)				\
> do {								\
> 	if ((errno))						\
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index ee823022aa34..99bcced744c8 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -303,7 +303,7 @@ void ext4_free_inode(handle_t *handle, struct =
inode *inode)
> 	ext4_clear_inode(inode);
>=20
> 	es =3D EXT4_SB(sb)->s_es;
> -	if (ino < EXT4_FIRST_INO(sb) || ino > =
le32_to_cpu(es->s_inodes_count)) {
> +	if (ino < EXT4_FIRST_INO(sb) || ino > =
le32_to_cpu(ext4_get_inodes_count(es))) {

Swabbing needs to be done inside ext4_get_inodes_count() before =
returning it to
the caller.  Also, le32_to_cpu() would be wrong, since it is a 64-bit =
value.

> 		ext4_error(sb, "reserved or nonexistent inode %lu", =
ino);
> 		goto error_return;
> 	}
> @@ -770,7 +770,7 @@ static int find_inode_bit(struct super_block *sb, =
ext4_group_t group,
>  */
> struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
> 			       umode_t mode, const struct qstr *qstr,
> -			       __u32 goal, uid_t *owner, __u32 i_flags,
> +			       __u64 goal, uid_t *owner, __u32 i_flags,
> 			       int handle_type, unsigned int line_no,
> 			       int nblocks)
> {
> @@ -887,7 +887,7 @@ struct inode *__ext4_new_inode(handle_t *handle, =
struct inode *dir,
> 	if (!goal)
> 		goal =3D sbi->s_inode_goal;
>=20
> -	if (goal && goal <=3D le32_to_cpu(sbi->s_es->s_inodes_count)) {
> +	if (goal && goal <=3D =
le32_to_cpu(ext4_get_inodes_count(sbi->s_es))) {
> 		group =3D (goal - 1) / EXT4_INODES_PER_GROUP(sb);
> 		ino =3D (goal - 1) % EXT4_INODES_PER_GROUP(sb);
> 		ret2 =3D 0;

There also needs to be a change to the metadata checksum code.  It is =
using
only i_ino (low 32-bit value) to compute the checksum seed, but that =
means
the seed is the same for all inode numbers mod 2^32.  If there is a bug =
in
the code somewhere that drops the high bits of the inode number then it =
may
write it to the wrong location on disk, but it would have a "valid" =
checksum.

It would be better to use the full 64-bit inode number for the checksum =
seed
so that this does not happen:

        /* Precompute checksum seed for inode metadata */
        if (ext4_has_metadata_csum(sb)) {
		__u32 csum;
                __le32 inum =3D cpu_to_le32(inode->i_ino);
                __le32 gen =3D cpu_to_le32(inode->i_generation);

                csum =3D ext4_chksum(sbi, sbi->s_csum_seed, (__u8 =
*)&inum,
				   sizeof(inum));
		if (inode->i_ino >> 32) {
			inum =3D cpu_to_le32(inode->i_ino >> 32);
			csum =3D ext4_chksum(sbi, sbi->s_csum_seed, =
(__u8 *)&inum,
					   sizeof(inum));
		}
                ei->i_csum_seed =3D ext4_chksum(sbi, csum, (__u8 *)&gen,
					      sizeof(gen));

> @@ -1226,7 +1226,7 @@ struct inode *__ext4_new_inode(handle_t *handle, =
struct inode *dir,
> /* Verify that we are loading a valid orphan from disk */
> struct inode *ext4_orphan_get(struct super_block *sb, unsigned long =
ino)
> {
> -	unsigned long max_ino =3D =
le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
> +	unsigned long max_ino =3D =
le32_to_cpu(ext4_get_inodes_count(EXT4_SB(sb)->s_es));

Swabbing needs to be done in ext4_get_inodes_count().

> 	ext4_group_t block_group;
> 	int bit;
> 	struct buffer_head *bitmap_bh =3D NULL;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index ccb6ca477bab..fbcfb8b193ad 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1573,11 +1573,22 @@ static struct dentry *ext4_lookup(struct inode =
*dir, struct dentry *dentry, unsi
> 		return (struct dentry *) bh;
> 	inode =3D NULL;
> 	if (bh) {
> -		__u32 ino =3D le32_to_cpu(de->inode);
> +		__u32 ino_hi;
> +		__u32 ino_lo;
> +		unsigned long ino;
> +		unsigned char *data;
> +		data =3D ext4_dentry_get_data(dir->i_sb, (struct =
ext4_dentry_param *)dentry->d_fsdata);
> +
> +		if (data) {
> +			ino_hi =3D =
le32_to_cpu(de->name[dentry->d_name.len + 1 + *data + 1]);

(style) Need to run this through checkpatch.pl to catch issues like =
80-char wrap.

That said, I don't think this is correct.  This should be getting the =
high
32 bits of the inode number from "de", and it shouldn't have anything to =
do
with "dentry->d_fsdata".  This should be something like:


		ino =3D le32_to_cpu(de->inode);
		if (de->file_type & EXT4_DIRENT_INODE) {
			/* XXX also check if FEATURE_INODE64 is set? */
			/* skip LUFID record if present */
			char *data =3D de->name[de->name_len];

			if (de->file_type & EXT4_DIRENT_LUFID) {
				/* first byte is record length */
				data +=3D *(char *)data;
				/* XXX verify we are still inside =
rec_len? */
			}

			if (*(char *)data) =3D=3D sizeof(__u32)) {
				__le32 ino_hi;

				memcpy(ino_hi, data, sizeof(__u32));
				ino |=3D (u64)le32_to_cpu(ino_hi) << 32;
			} /* XXX else error? */
		}

> +			ino_lo =3D le32_to_cpu(de->inode);
> +			ino =3D (__u64)ino_hi << 32 & ino_lo;
> +		} else
> +			ino =3D le32_to_cpu(de->inode);

(style) braces around both parts of if/else block.

> @@ -1890,9 +1901,10 @@ static int add_dirent_to_buf(handle_t *handle,
> 	unsigned int	blocksize =3D dir->i_sb->s_blocksize;
> 	int		csum_size =3D 0;
> 	unsigned short	reclen, dotdot_reclen =3D 0;
> -	int		 err, dlen =3D 0;
> +	int		 err, dlen =3D 0, data_offset =3D 0;
> 	bool		is_dotdot =3D false, write_short_dotdot =3D =
false;
> 	unsigned char	*data;
> +	__u32		*i_ino_hi;

This can be declared local to the the "if (inode) {" block.

> 	int namelen =3D dentry->d_name.len;
>=20
> 	if (ext4_has_metadata_csum(inode->i_sb))
> @@ -1937,6 +1949,15 @@ static int add_dirent_to_buf(handle_t *handle,
> 		de->name[namelen] =3D 0;
> 		memcpy(&de->name[namelen + 1], data, *(char *) data);
> 		de->file_type |=3D EXT4_DIRENT_LUFID;
> +		data_offset =3D *data;
> +	}
> +
> +	if (inode) {
> +		de->name[namelen + 1 + data_offset] =3D 3;

"3" is what, the length of the extra data?  I'd think to store the high =
32 bits
this should be "5" (length byte + sizeof(__u32)).

> +		i_ino_hi =3D (__u32 *)&de->name[namelen + 1 + =
data_offset + 1];

This unaligned __u32 access may cause problems on some architectures.  =
Better
to use memcpy() to copy the value rather than direct assignment.

That said, since this is the same as in ext4_lookup() it might make =
sense to
have a helper function like "ext4_dirent_get_inode(de)" or similar that
returns the inode number (including 64-bit value if present).

> +		*i_ino_hi =3D cpu_to_le32((__u32)(inode->i_ino >> 32));
> +		de->file_type |=3D EXT4_DIRENT_INODE;
> +		de->inode =3D cpu_to_le32(inode->i_ino & 0x0fffffff);

(defect) this is only storing the low 2^28 bits of the inode number?

> 	}
>=20
> 	/*
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ead9406d9cff..bcea0b84b668 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4248,7 +4248,7 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 				  GFP_KERNEL);
> 	if (!err) {
> 		unsigned long freei =3D ext4_count_free_inodes(sb);
> -		sbi->s_es->s_free_inodes_count =3D cpu_to_le32(freei);
> +		ext4_set_free_inodes_count(sbi->s_es, =
cpu_to_le64(freei));
> 		err =3D percpu_counter_init(&sbi->s_freeinodes_counter, =
freei,
> 					  GFP_KERNEL);
> 	}

At a minimum, there needs to be a mount-time check to prevent mounting a
filesystem with 64-bit inodes on a 32-bit kernel.

Better would be to fix the code to handle this even on 32-bit kernels,
but the support for this looks patchy.  The VFS i_ino is unsigned long,
so we'd need to store the high bits in ext4_inode_info for 32-bit =
kernels
to use in ext4_getattr().  This would need a wrapper function for all
i_ino uses to get i_ino_hi from ext4_inode_info, like =
ext4_get_ino(inode)
or similar (it would just return i_ino for 64-bit kernels).

The struct linux_dirent also has unsigned long for d_ino, but that looks
like it is only for 32-bit syscalls, there is also linux_dirent64 that =
has
u64 for d_ino.

> @@ -4705,9 +4705,9 @@ static int ext4_commit_super(struct super_block =
*sb, int sync)
> 			EXT4_C2B(EXT4_SB(sb), =
percpu_counter_sum_positive(
> 				&EXT4_SB(sb)->s_freeclusters_counter)));
> 	if =
(percpu_counter_initialized(&EXT4_SB(sb)->s_freeinodes_counter))
> -		es->s_free_inodes_count =3D
> -			cpu_to_le32(percpu_counter_sum_positive(
> -				&EXT4_SB(sb)->s_freeinodes_counter));
> +		ext4_set_free_inodes_count(es,
> +				cpu_to_le32(percpu_counter_sum_positive(
> +				&EXT4_SB(sb)->s_freeinodes_counter)));
> 	BUFFER_TRACE(sbh, "marking dirty");
> 	ext4_superblock_csum_set(sb);
> 	if (sync)
> --
> 2.13.5 (Apple Git-94)
>=20


Cheers, Andreas






--Apple-Mail=_B98A8C47-1320-4B20-A8FA-E4C15A0E1502
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ86ztpIg59Q01vtYRAnHhAKCggN3oSKe077n9liX6jQd2o+e1BQCfTVE/
aQucWpSzX2r5gOYp+fxlab4=
=UKbZ
-----END PGP SIGNATURE-----

--Apple-Mail=_B98A8C47-1320-4B20-A8FA-E4C15A0E1502--
