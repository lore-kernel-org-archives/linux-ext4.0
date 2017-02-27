From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: create an ioctl report fs geometry
Date: Mon, 27 Feb 2017 13:43:37 -0700
Message-ID: <134398F8-21DF-4CE6-9F05-0E586A5F13A4@dilger.ca>
References: <20170218012012.GB6804@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_1529B614-861B-4188-B08A-A2DBBF235A9F";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33631 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbdB0VSM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Feb 2017 16:18:12 -0500
Received: by mail-io0-f193.google.com with SMTP id f84so5180915ioj.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Feb 2017 13:17:19 -0800 (PST)
In-Reply-To: <20170218012012.GB6804@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_1529B614-861B-4188-B08A-A2DBBF235A9F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Feb 17, 2017, at 6:20 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Add an ioctl to report the geometry of a mounted filesystem.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> fs/ext4/ext4.h  |   36 ++++++++++++++++++++++++++++++++++
> fs/ext4/ioctl.c |   58 =
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 94 insertions(+)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2163c1e..bee511d 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -614,6 +614,41 @@ enum {
> #define EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER	0x0010
> #define EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER	0x0020
>=20
> +/* ext4 fs geometry. */
> +struct ext4_fsop_geom {
> +	__u32		blocksize;	/* filesystem (data) block size =
*/
> +	__u32		inodecount;	/* inode count			=
*/

Should this be a __u64, even though we don't currently support 64-bit =
inode
numbers today?  Easy to change the struct now, much harder to do later.  =
Would
need to align it properly though.

> +	__u32		agblocks;	/* fsblocks in an AG		=
*/
> +	__u32		agcount;	/* number of allocation groups	=
*/

Please don't introduce XFS terminology into ext4.  In ext4 these are =
called
"block groups", and use "bg" as the prefix.

(style) please add a unique prefix to the struct names, like "efg_" or =
similar
("fg_" if this is being hoisted to the VFS at some point, to avoid =
churn).

> +	__u32		logblocks;	/* fsblocks in the log		=
*/
> +	__u32		resvblocks;	/* number of reserved blocks	=
*/
> +	__u32		inodesize;	/* inode size in bytes		=
*/
> +	__u32		agiblocks;	/* inode blocks per AG		=
*/

Similarly, "bgi_blocks      /* inode blocks per block group */

> +	__u64		datablocks;	/* fsblocks in data subvolume	=
*/
> +	unsigned char	uuid[16];	/* unique id of the filesystem	=
*/
> +	__u32		sunit;		/* stripe unit, fsblocks	=
*/
> +	__u32		swidth;		/* stripe width, fsblocks	=
*/
> +	__s32		version;	/* structure version		=
*/

Why would you want to allow a negative version?  Also, feature flags are =
so
much better than version numbers, let's just stick with flags.

> +	__u32		flags;		/* superblock version flags	=
*/

s/version/feature/?

> +	__u32		clustersize;	/* fs cluster size		=
*/
> +	__u32		flexbgsize;	/* number of bg's in a flexbg	=
*/
> +	__u64		resv[6];
> +};
> +
> +#define EXT4_FSOP_GEOM_VERSION	0
> +
> +#define EXT4_FSOP_GEOM_FLAGS_ATTR	0x00001	/* attributes in use	 =
*/

Sorry, it isn't clear what this means?

> +#define EXT4_FSOP_GEOM_FLAGS_NLINK	0x00002	/* 32-bit nlink values	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_QUOTA	0x00004	/* quotas enabled	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_PROJQ	0x00008	/* project quotas	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_METACRC	0x00010	/* metadata checksums	 =
*/

"METACKSUM" would be better?

> +#define EXT4_FSOP_GEOM_FLAGS_FTYPE	0x00020	/* inode directory types =
*/

Are there any filesystems in existence that don't have this feature?

> +#define EXT4_FSOP_GEOM_FLAGS_64BIT	0x00040	/* 64-bit support	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_INLINEDATA	0x00080	/* inline data		=
 */
> +#define EXT4_FSOP_GEOM_FLAGS_ENCRYPT	0x00100	/* encrypted files	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_LARGEDIR	0x00200	/* large =
directories	 */
> +#define EXT4_FSOP_GEOM_FLAGS_EXTENTS	0x00400	/* extents		 =
*/

Sigh, this isn't quite the same as the existing feature flags, but =
doesn't
actually encompass all of the available features, nor could it ever fit =
all
three __u32 into one __u32.  It isn't clear why this duplicate =
information
is needed in this struct?  If needed, why not return all three feature =
flags?

> +
> /*
>  * ioctl commands
>  */
> @@ -638,6 +673,7 @@ enum {
> #define EXT4_IOC_SET_ENCRYPTION_POLICY	=
FS_IOC_SET_ENCRYPTION_POLICY
> #define EXT4_IOC_GET_ENCRYPTION_PWSALT	=
FS_IOC_GET_ENCRYPTION_PWSALT
> #define EXT4_IOC_GET_ENCRYPTION_POLICY	=
FS_IOC_GET_ENCRYPTION_POLICY
> +#define EXT4_IOC_FSGEOMETRY		_IOR ('f', 19, struct =
ext4_fsop_geom)
>=20
> #ifndef FS_IOC_FSGETXATTR
> /* Until the uapi changes get merged for project quota... */
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index ed62465..e0b695b 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -547,6 +547,62 @@ ext4_ioc_getfsmap(
> 	return 0;
> }
>=20
> +static int
> +ext4_ioc_fsgeometry(
> +	struct super_block	*sb,
> +	void			__user *arg)

Should pack arguments on the declaration line like:

static int ext4_ioc_fsgeometry(struct super_block *sb, void __user *arg)

> +{
> +	struct ext4_sb_info	*sbi =3D EXT4_SB(sb);
> +	journal_t		*journal =3D sbi->s_journal;
> +	struct ext4_fsop_geom	geom;

I thought kernel style frowned upon aligning local variable declarations
(at least we were told that for the Lustre code and have had to remove =
it).

> +
> +	memset(&geom, 0, sizeof(geom));

You could avoid the explicit memset by initializing the struct at =
declaration.

> +	geom.version =3D EXT4_FSOP_GEOM_VERSION;
> +	geom.blocksize =3D EXT4_BLOCK_SIZE(sb);
> +	geom.inodecount =3D le32_to_cpu(sbi->s_es->s_inodes_count);
> +	geom.agblocks =3D EXT4_BLOCKS_PER_GROUP(sb);
> +	geom.agcount =3D sbi->s_groups_count;
> +	geom.logblocks =3D journal ? journal->j_maxlen : 0;
> +	geom.resvblocks =3D ext4_r_blocks_count(sbi->s_es);
> +	geom.inodesize =3D EXT4_INODE_SIZE(sb);
> +	geom.agiblocks =3D sbi->s_itb_per_group;
> +	geom.datablocks =3D ext4_blocks_count(sbi->s_es);
> +	memcpy(geom.uuid, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
> +	geom.sunit =3D le16_to_cpu(sbi->s_es->s_raid_stride);
> +	geom.swidth =3D le16_to_cpu(sbi->s_es->s_raid_stripe_width);
> +	geom.flags =3D 0;
> +	if (ext4_has_feature_xattr(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_ATTR;
> +	if (ext4_has_feature_dir_nlink(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_NLINK;
> +	if (ext4_has_feature_quota(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_QUOTA;
> +	if (ext4_has_feature_project(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_PROJQ;
> +	if (ext4_has_metadata_csum(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_METACRC;
> +	if (ext4_has_feature_filetype(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_FTYPE;
> +	if (ext4_has_feature_64bit(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_64BIT;
> +	if (ext4_has_feature_inline_data(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_INLINEDATA;
> +	if (ext4_has_feature_encrypt(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_ENCRYPT;
> +	if (ext4_has_feature_largedir(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_LARGEDIR;
> +	if (ext4_has_feature_extents(sb))
> +		geom.flags |=3D EXT4_FSOP_GEOM_FLAGS_EXTENTS;
> +	if (ext4_has_feature_bigalloc(sb))
> +		geom.clustersize =3D EXT4_C2B(sbi, 1);
> +	if (ext4_has_feature_flex_bg(sb))
> +		geom.flexbgsize =3D ext4_flex_bg_size(sbi);
> +
> +	if (copy_to_user(arg, &geom, sizeof(geom)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long =
arg)
> {
> 	struct inode *inode =3D file_inode(filp);
> @@ -557,6 +613,8 @@ long ext4_ioctl(struct file *filp, unsigned int =
cmd, unsigned long arg)
> 	ext4_debug("cmd =3D %u, arg =3D %lu\n", cmd, arg);
>=20
> 	switch (cmd) {
> +	case EXT4_IOC_FSGEOMETRY:
> +		return ext4_ioc_fsgeometry(sb, (void __user *)arg);

> 	case FS_IOC_GETFSMAP:
> 		return ext4_ioc_getfsmap(sb, (void __user *)arg);
> 	case EXT4_IOC_GETFLAGS:


Cheers, Andreas






--Apple-Mail=_1529B614-861B-4188-B08A-A2DBBF235A9F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYtI95pIg59Q01vtYRAslRAJ9XGJuYiFF5SH87GbccLC6SWGo83ACggGLZ
ouCRWHXqJR3eHPqRL5ox6z0=
=aziP
-----END PGP SIGNATURE-----

--Apple-Mail=_1529B614-861B-4188-B08A-A2DBBF235A9F--
