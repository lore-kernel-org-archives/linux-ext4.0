From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] ext4: Replace open coded mdata csum feature to helper function v2
Date: Mon, 13 Oct 2014 21:02:36 +0400
Message-ID: <8761fnrjgz.fsf@openvz.org>
References: <1413147967-30487-1-git-send-email-dmonakhov@openvz.org> <20141013164319.GB12009@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36918 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbaJMRCr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2014 13:02:47 -0400
Received: by mail-wi0-f174.google.com with SMTP id h11so4351641wiw.13
        for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2014 10:02:45 -0700 (PDT)
In-Reply-To: <20141013164319.GB12009@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> On Mon, Oct 13, 2014 at 01:06:06AM +0400, Dmitry Monakhov wrote:
>> Besides the fact that this replacement improves code readability
>> it also protects from errors caused direct EXT4_S(sb)->s_es manipulation
>> which may result attempt to use uninitialized  csum machinery.
>>=20
>> #Testcase_BEGIN
>> IMG=3D/dev/ram0
>> MNT=3D/mnt
>> mkfs.ext4 $IMG
>> mount $IMG $MNT
>> #Enable feature directly on disk, on mounted fs
>> tune2fs -O metadata_csum  $IMG
>> # Provoke metadata update, likey result in OOPS
>> touch $MNT/test
>> umount $MNT
>> #Testcase_END
>>=20
>> # Replacement script
>> @@
>> expression E;
>> @@
>> - EXT4_HAS_RO_COMPAT_FEATURE(E, EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
>> + ext4_has_metadata_csum(E)
>>=20
>> Changes v1->v2
>>  - fix early ext_fill_super stage
>>=20
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D82201
>>=20
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  fs/ext4/bitmap.c  |   12 ++++--------
>>  fs/ext4/ext4.h    |    8 ++++++++
>>  fs/ext4/extents.c |    6 ++----
>>  fs/ext4/ialloc.c  |    3 +--
>>  fs/ext4/inline.c  |    3 +--
>>  fs/ext4/inode.c   |    9 +++------
>>  fs/ext4/ioctl.c   |    3 +--
>>  fs/ext4/mmp.c     |    6 ++----
>>  fs/ext4/namei.c   |   39 +++++++++++++--------------------------
>>  fs/ext4/resize.c  |    3 +--
>>  fs/ext4/super.c   |   15 +++++----------
>>  fs/ext4/xattr.c   |    6 ++----
>>  12 files changed, 43 insertions(+), 70 deletions(-)
>>=20
>> diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
>> index 3285aa5..b610779 100644
>> --- a/fs/ext4/bitmap.c
>> +++ b/fs/ext4/bitmap.c
>> @@ -24,8 +24,7 @@ int ext4_inode_bitmap_csum_verify(struct super_block *=
sb, ext4_group_t group,
>>  	__u32 provided, calculated;
>>  	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(sb))
>>  		return 1;
>>=20=20
>>  	provided =3D le16_to_cpu(gdp->bg_inode_bitmap_csum_lo);
>> @@ -46,8 +45,7 @@ void ext4_inode_bitmap_csum_set(struct super_block *sb=
, ext4_group_t group,
>>  	__u32 csum;
>>  	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(sb))
>>  		return;
>>=20=20
>>  	csum =3D ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
>> @@ -65,8 +63,7 @@ int ext4_block_bitmap_csum_verify(struct super_block *=
sb, ext4_group_t group,
>>  	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>>  	int sz =3D EXT4_CLUSTERS_PER_GROUP(sb) / 8;
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(sb))
>>  		return 1;
>>=20=20
>>  	provided =3D le16_to_cpu(gdp->bg_block_bitmap_csum_lo);
>> @@ -91,8 +88,7 @@ void ext4_block_bitmap_csum_set(struct super_block *sb=
, ext4_group_t group,
>>  	__u32 csum;
>>  	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(sb))
>>  		return;
>>=20=20
>>  	csum =3D ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 012e89b..1483d9c 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -2337,6 +2337,14 @@ static inline int ext4_has_group_desc_csum(struct=
 super_block *sb)
>>  					  EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
>
> Please change the raw metadata_csum flag check in ext4_has_group_desc_csu=
m(),
> otherwise we'll still suffer from this bug.
No, this one is safe because ext4_group_desc_csum() will check
ext4_has_metadata_csum() internally. Other stuff should be safe.
So you'll see csum corruption messages which is expected and correct.
>
>>  }
>>=20=20
>> +static inline int ext4_has_metadata_csum(struct super_block *sb)
>> +{
>> +	WARN_ON_ONCE(EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> +			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
>> +		     !EXT4_SB(sb)->s_chksum_driver);
>
> I was about to protest about not checking the flag and s_chksum_driver...
>
> Then I realized that tune2fs can set and clear the metadata_csum flag on a
> mounted FS.  Oh crap.
>
> So maybe it would be a good idea to check both the driver pointer and the
> feature flag just to make sure the user really wants checksumming, though=
 in
> the meantime I have a e2fsprogs bug to fix.
>
> --D
>
>> +
>> +	return (EXT4_SB(sb)->s_chksum_driver !=3D NULL);
>> +}
>>  static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *e=
s)
>>  {
>>  	return ((ext4_fsblk_t)le32_to_cpu(es->s_blocks_count_hi) << 32) |
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index c3ed9af..37043d0 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -73,8 +73,7 @@ static int ext4_extent_block_csum_verify(struct inode =
*inode,
>>  {
>>  	struct ext4_extent_tail *et;
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(inode->i_sb))
>>  		return 1;
>>=20=20
>>  	et =3D find_ext4_extent_tail(eh);
>> @@ -88,8 +87,7 @@ static void ext4_extent_block_csum_set(struct inode *i=
node,
>>  {
>>  	struct ext4_extent_tail *et;
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(inode->i_sb))
>>  		return;
>>=20=20
>>  	et =3D find_ext4_extent_tail(eh);
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index 5b87fc3..8012a5d 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -1011,8 +1011,7 @@ got:
>>  	spin_unlock(&sbi->s_next_gen_lock);
>>=20=20
>>  	/* Precompute checksum seed for inode metadata */
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
>> +	if (ext4_has_metadata_csum(sb)) {
>>  		__u32 csum;
>>  		__le32 inum =3D cpu_to_le32(inode->i_ino);
>>  		__le32 gen =3D cpu_to_le32(inode->i_generation);
>> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
>> index 378aadf..3ea6269 100644
>> --- a/fs/ext4/inline.c
>> +++ b/fs/ext4/inline.c
>> @@ -1128,8 +1128,7 @@ static int ext4_finish_convert_inline_dir(handle_t=
 *handle,
>>  	memcpy((void *)de, buf + EXT4_INLINE_DOTDOT_SIZE,
>>  		inline_size - EXT4_INLINE_DOTDOT_SIZE);
>>=20=20
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (ext4_has_metadata_csum(inode->i_sb))
>>  		csum_size =3D sizeof(struct ext4_dir_entry_tail);
>>=20=20
>>  	inode->i_size =3D inode->i_sb->s_blocksize;
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 0dd9150..e9777f9 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -83,8 +83,7 @@ static int ext4_inode_csum_verify(struct inode *inode,=
 struct ext4_inode *raw,
>>=20=20
>>  	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=3D
>>  	    cpu_to_le32(EXT4_OS_LINUX) ||
>> -	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	    !ext4_has_metadata_csum(inode->i_sb))
>>  		return 1;
>>=20=20
>>  	provided =3D le16_to_cpu(raw->i_checksum_lo);
>> @@ -105,8 +104,7 @@ static void ext4_inode_csum_set(struct inode *inode,=
 struct ext4_inode *raw,
>>=20=20
>>  	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=3D
>>  	    cpu_to_le32(EXT4_OS_LINUX) ||
>> -	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	    !ext4_has_metadata_csum(inode->i_sb))
>>  		return;
>>=20=20
>>  	csum =3D ext4_inode_csum(inode, raw, ei);
>> @@ -3928,8 +3926,7 @@ struct inode *ext4_iget(struct super_block *sb, un=
signed long ino)
>>  		ei->i_extra_isize =3D 0;
>>=20=20
>>  	/* Precompute checksum seed for inode metadata */
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
>> +	if (ext4_has_metadata_csum(sb)) {
>>  		struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
>>  		__u32 csum;
>>  		__le32 inum =3D cpu_to_le32(inode->i_ino);
>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>> index 3d5de16..bfda18a 100644
>> --- a/fs/ext4/ioctl.c
>> +++ b/fs/ext4/ioctl.c
>> @@ -331,8 +331,7 @@ flags_out:
>>  		if (!inode_owner_or_capable(inode))
>>  			return -EPERM;
>>=20=20
>> -		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
>> +		if (ext4_has_metadata_csum(inode->i_sb)) {
>>  			ext4_warning(sb, "Setting inode version is not "
>>  				     "supported with metadata_csum enabled.");
>>  			return -ENOTTY;
>> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
>> index 32bce84..8313ca3 100644
>> --- a/fs/ext4/mmp.c
>> +++ b/fs/ext4/mmp.c
>> @@ -20,8 +20,7 @@ static __le32 ext4_mmp_csum(struct super_block *sb, st=
ruct mmp_struct *mmp)
>>=20=20
>>  static int ext4_mmp_csum_verify(struct super_block *sb, struct mmp_stru=
ct *mmp)
>>  {
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(sb))
>>  		return 1;
>>=20=20
>>  	return mmp->mmp_checksum =3D=3D ext4_mmp_csum(sb, mmp);
>> @@ -29,8 +28,7 @@ static int ext4_mmp_csum_verify(struct super_block *sb=
, struct mmp_struct *mmp)
>>=20=20
>>  static void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct=
 *mmp)
>>  {
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(sb))
>>  		return;
>>=20=20
>>  	mmp->mmp_checksum =3D ext4_mmp_csum(sb, mmp);
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index 7037ecf..61756f9 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -124,8 +124,7 @@ static struct buffer_head *__ext4_read_dirblock(stru=
ct inode *inode,
>>  		       "directory leaf block found instead of index block");
>>  		return ERR_PTR(-EIO);
>>  	}
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) ||
>> +	if (!ext4_has_metadata_csum(inode->i_sb) ||
>>  	    buffer_verified(bh))
>>  		return bh;
>>=20=20
>> @@ -338,8 +337,7 @@ int ext4_dirent_csum_verify(struct inode *inode, str=
uct ext4_dir_entry *dirent)
>>  {
>>  	struct ext4_dir_entry_tail *t;
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(inode->i_sb))
>>  		return 1;
>>=20=20
>>  	t =3D get_dirent_tail(inode, dirent);
>> @@ -360,8 +358,7 @@ static void ext4_dirent_csum_set(struct inode *inode,
>>  {
>>  	struct ext4_dir_entry_tail *t;
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(inode->i_sb))
>>  		return;
>>=20=20
>>  	t =3D get_dirent_tail(inode, dirent);
>> @@ -436,8 +433,7 @@ static int ext4_dx_csum_verify(struct inode *inode,
>>  	struct dx_tail *t;
>>  	int count_offset, limit, count;
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(inode->i_sb))
>>  		return 1;
>>=20=20
>>  	c =3D get_dx_countlimit(inode, dirent, &count_offset);
>> @@ -466,8 +462,7 @@ static void ext4_dx_csum_set(struct inode *inode, st=
ruct ext4_dir_entry *dirent)
>>  	struct dx_tail *t;
>>  	int count_offset, limit, count;
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(inode->i_sb))
>>  		return;
>>=20=20
>>  	c =3D get_dx_countlimit(inode, dirent, &count_offset);
>> @@ -555,8 +550,7 @@ static inline unsigned dx_root_limit(struct inode *d=
ir, unsigned infosize)
>>  	unsigned entry_space =3D dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(1) -
>>  		EXT4_DIR_REC_LEN(2) - infosize;
>>=20=20
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (ext4_has_metadata_csum(dir->i_sb))
>>  		entry_space -=3D sizeof(struct dx_tail);
>>  	return entry_space / sizeof(struct dx_entry);
>>  }
>> @@ -565,8 +559,7 @@ static inline unsigned dx_node_limit(struct inode *d=
ir)
>>  {
>>  	unsigned entry_space =3D dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(0);
>>=20=20
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (ext4_has_metadata_csum(dir->i_sb))
>>  		entry_space -=3D sizeof(struct dx_tail);
>>  	return entry_space / sizeof(struct dx_entry);
>>  }
>> @@ -1524,8 +1517,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t =
*handle, struct inode *dir,
>>  	int	csum_size =3D 0;
>>  	int	err =3D 0, i;
>>=20=20
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (ext4_has_metadata_csum(dir->i_sb))
>>  		csum_size =3D sizeof(struct ext4_dir_entry_tail);
>>=20=20
>>  	bh2 =3D ext4_append(handle, dir, &newblock);
>> @@ -1691,8 +1683,7 @@ static int add_dirent_to_buf(handle_t *handle, str=
uct dentry *dentry,
>>  	int		csum_size =3D 0;
>>  	int		err;
>>=20=20
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (ext4_has_metadata_csum(inode->i_sb))
>>  		csum_size =3D sizeof(struct ext4_dir_entry_tail);
>>=20=20
>>  	if (!de) {
>> @@ -1759,8 +1750,7 @@ static int make_indexed_dir(handle_t *handle, stru=
ct dentry *dentry,
>>  	struct fake_dirent *fde;
>>  	int		csum_size =3D 0;
>>=20=20
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (ext4_has_metadata_csum(inode->i_sb))
>>  		csum_size =3D sizeof(struct ext4_dir_entry_tail);
>>=20=20
>>  	blocksize =3D  dir->i_sb->s_blocksize;
>> @@ -1877,8 +1867,7 @@ static int ext4_add_entry(handle_t *handle, struct=
 dentry *dentry,
>>  	ext4_lblk_t block, blocks;
>>  	int	csum_size =3D 0;
>>=20=20
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (ext4_has_metadata_csum(inode->i_sb))
>>  		csum_size =3D sizeof(struct ext4_dir_entry_tail);
>>=20=20
>>  	sb =3D dir->i_sb;
>> @@ -2142,8 +2131,7 @@ static int ext4_delete_entry(handle_t *handle,
>>  			return err;
>>  	}
>>=20=20
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (ext4_has_metadata_csum(dir->i_sb))
>>  		csum_size =3D sizeof(struct ext4_dir_entry_tail);
>>=20=20
>>  	BUFFER_TRACE(bh, "get_write_access");
>> @@ -2362,8 +2350,7 @@ static int ext4_init_new_dir(handle_t *handle, str=
uct inode *dir,
>>  	int csum_size =3D 0;
>>  	int err;
>>=20=20
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (ext4_has_metadata_csum(dir->i_sb))
>>  		csum_size =3D sizeof(struct ext4_dir_entry_tail);
>>=20=20
>>  	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index bb0e80f..d5afb0a 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -1210,8 +1210,7 @@ static int ext4_set_bitmap_checksums(struct super_=
block *sb,
>>  {
>>  	struct buffer_head *bh;
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(sb))
>>  		return 0;
>>=20=20
>>  	bh =3D ext4_get_bitmap(sb, group_data->inode_bitmap);
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index a0811cc..5afe42d 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -140,8 +140,7 @@ static __le32 ext4_superblock_csum(struct super_bloc=
k *sb,
>>  static int ext4_superblock_csum_verify(struct super_block *sb,
>>  				       struct ext4_super_block *es)
>>  {
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(sb))
>>  		return 1;
>>=20=20
>>  	return es->s_checksum =3D=3D ext4_superblock_csum(sb, es);
>> @@ -151,8 +150,7 @@ void ext4_superblock_csum_set(struct super_block *sb)
>>  {
>>  	struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
>>=20=20
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(sb))
>>  		return;
>>=20=20
>>  	es->s_checksum =3D ext4_superblock_csum(sb, es);
>> @@ -1989,8 +1987,7 @@ static __le16 ext4_group_desc_csum(struct ext4_sb_=
info *sbi, __u32 block_group,
>>  	__u16 crc =3D 0;
>>  	__le32 le_group =3D cpu_to_le32(block_group);
>>=20=20
>> -	if ((sbi->s_es->s_feature_ro_compat &
>> -	     cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))) {
>> +	if (ext4_has_metadata_csum(sbi->s_sb)) {
>>  		/* Use new metadata_csum algorithm */
>>  		__le16 save_csum;
>>  		__u32 csum32;
>> @@ -3199,8 +3196,7 @@ static int set_journal_csum_feature_set(struct sup=
er_block *sb)
>>  	int compat, incompat;
>>  	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>>=20=20
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
>> +	if (ext4_has_metadata_csum(sb)) {
>>  		/* journal checksum v3 */
>>  		compat =3D 0;
>>  		incompat =3D JBD2_FEATURE_INCOMPAT_CSUM_V3;
>> @@ -3508,8 +3504,7 @@ static int ext4_fill_super(struct super_block *sb,=
 void *data, int silent)
>>  	}
>>=20=20
>>  	/* Precompute checksum seed for all metadata */
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> -			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (ext4_has_metadata_csum(sb))
>>  		sbi->s_csum_seed =3D ext4_chksum(sbi, ~0, es->s_uuid,
>>  					       sizeof(es->s_uuid));
>>=20=20
>> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
>> index 42823ab..1e09fc7 100644
>> --- a/fs/ext4/xattr.c
>> +++ b/fs/ext4/xattr.c
>> @@ -142,8 +142,7 @@ static int ext4_xattr_block_csum_verify(struct inode=
 *inode,
>>  					sector_t block_nr,
>>  					struct ext4_xattr_header *hdr)
>>  {
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
>> +	if (ext4_has_metadata_csum(inode->i_sb) &&
>>  	    (hdr->h_checksum !=3D ext4_xattr_block_csum(inode, block_nr, hdr)))
>>  		return 0;
>>  	return 1;
>> @@ -153,8 +152,7 @@ static void ext4_xattr_block_csum_set(struct inode *=
inode,
>>  				      sector_t block_nr,
>>  				      struct ext4_xattr_header *hdr)
>>  {
>> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> -		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +	if (!ext4_has_metadata_csum(inode->i_sb))
>>  		return;
>>=20=20
>>  	hdr->h_checksum =3D ext4_xattr_block_csum(inode, block_nr, hdr);
>> --=20
>> 1.7.1
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPAWsAAoJEFzOBSYIXfvezCsP/1/GLGGDNEBdbA/olidF25ZW
1vQaJdOwgkuaomuTO8muxjZpbbfV3VYcQgAcCgHgS6vhveLBPwYWdfFqvH6hXjbu
qHsuGaYbIoB0R5RiqwAlmcyMs7vu6uy+J8odPLBmoCk/0AINrZQmj39i3XsKcAmR
hjCrZSeEOJBu61Wq5NYbzr+UHhWvO280rh79gdlPgpVvrudOGWsl+xm/tztbdgvb
tFUYI7cWt0ZGzVN9cRnzzsL0X9Y5b8Kaz/jXPgy1Ynloo4okuwK3WS4sjIapXYGI
//mpWLKao8ZqgdoONvfhGnFiIQzuvSSPl+UtlQLue6trupB+nBa5xo0Do7dzRYZI
5ctw/OfZGCeECqknkZzzehzjmfpfs0ZTEHrKKl0MwgLvwSyRPL7no955P/itGX3b
YfQD6QeNyh2oadEMAljn5+AdkvFkllewxlfR6tGtbdck3rFnPI38QzcZFAsY5vR7
C9pVaZxk6mq02Zg3dSwJV4t8oYzNFX1WIL9LAtlQSKIvXpof7yS39lPEX975peCD
Q4Dvcx0KSr9+10sO3V23ZMv2pW+99mH9OOeT0OU1w+VFQGkw/ei5FUslf7uFrjDc
7mi0QtHotIA038n5dQx+h2sraqHRE+MLqkUQZ6gyB/54MjC9Wdfrym6F+GxAw/IW
JwIQNhL0cFag+K17+nia
=ErAj
-----END PGP SIGNATURE-----
--=-=-=--
