From: =?utf-8?B?0JHQu9Cw0LPQvtC00LDRgNC10L3QutC+INCQ0YDRgtGR0Lw=?=
        <artem.blagodarenko@gmail.com>
Subject: Re: [PATCH v3 2/4] e2fsprogs: add support for 3-level htree
Date: Wed, 12 Apr 2017 12:12:08 +0300
Message-ID: <2716C539-8479-4213-B76E-392E595B183D@gmail.com>
References: <20170215054247.GA6804@birch.djwong.org>
 <1487180595-900-1-git-send-email-artem.blagodarenko@gmail.com>
 <5EA450CA-91D0-4D57-A130-426D33953B1D@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: adilger.kernel@dilger.ca, darrick.wong@oracle.com,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34796 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753708AbdDLJMR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Apr 2017 05:12:17 -0400
Received: by mail-lf0-f66.google.com with SMTP id x72so2330699lfb.1
        for <linux-ext4@vger.kernel.org>; Wed, 12 Apr 2017 02:12:16 -0700 (PDT)
In-Reply-To: <5EA450CA-91D0-4D57-A130-426D33953B1D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Ted, have you had a chance to look at these patches yet?

Best regards,
Artem Blagodarenko


> On 17 Feb 2017, at 06:55, Andreas Dilger <adilger@dilger.ca> wrote:
>=20
>>=20
>> On Feb 15, 2017, at 10:43 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>>=20
>> From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>>=20
>> The INCOMPAT_LARGEDIR feature allows larger directories to
>> be created, both with directory sizes over 2GB and and a
>> maximum htree depth of 3 instead of the current limit of 2.
>> These features are needed in order to exceed the currently
>> limit of approximately 10M entries in a single directory
>> for 4KB blocksize (~100k for 1KB).
>>=20
>> debugfs, e2fsck, ext2fs, mke2fs and tune2fs support is
>> added.
>>=20
>> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
>> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>=20
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
>=20
>> ---
>> e2fsck/pass1.c       |    5 +++--
>> e2fsck/pass2.c       |    5 +++--
>> lib/ext2fs/ext2_fs.h |    3 ++-
>> lib/ext2fs/ext2fs.h  |   15 ++++++++++++++-
>> misc/mke2fs.c        |    3 ++-
>> misc/tune2fs.c       |    3 ++-
>> 6 files changed, 26 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
>> index ce37176..11546d7 100644
>> --- a/e2fsck/pass1.c
>> +++ b/e2fsck/pass1.c
>> @@ -1716,7 +1716,8 @@ void e2fsck_pass1(e2fsck_t ctx)
>> 		}
>>=20
>> 		if (inode->i_faddr || frag || fsize ||
>> -		    (LINUX_S_ISDIR(inode->i_mode) && =
inode->i_size_high))
>> +		    (!ext2fs_has_feature_largedir(fs->super) &&
>> +		    (LINUX_S_ISDIR(inode->i_mode) && =
inode->i_size_high)))
>> 			mark_inode_bad(ctx, ino);
>> 		if ((fs->super->s_creator_os !=3D EXT2_OS_HURD) &&
>> 		    !ext2fs_has_feature_64bit(fs->super) &&
>> @@ -2469,7 +2470,7 @@ static int handle_htree(e2fsck_t ctx, struct =
problem_context *pctx,
>> 		return 1;
>>=20
>> 	pctx->num =3D root->indirect_levels;
>> -	if ((root->indirect_levels > 1) &&
>> +	if ((root->indirect_levels > ext2_dir_htree_level(fs)) &&
>> 	    fix_problem(ctx, PR_1_HTREE_DEPTH, pctx))
>> 		return 1;
>>=20
>> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
>> index b89ebc9..2f41fc4 100644
>> --- a/e2fsck/pass2.c
>> +++ b/e2fsck/pass2.c
>> @@ -1058,7 +1058,8 @@ inline_read_fail:
>> 			dx_db->flags |=3D DX_FLAG_FIRST | DX_FLAG_LAST;
>> 			if ((root->reserved_zero ||
>> 			     root->info_length < 8 ||
>> -			     root->indirect_levels > 1) &&
>> +			     root->indirect_levels >=3D
>> +			     ext2_dir_htree_level(fs)) &&
>> 			    fix_problem(ctx, PR_2_HTREE_BAD_ROOT, =
&cd->pctx)) {
>> 				clear_htree(ctx, ino);
>> 				dx_dir->numblocks =3D 0;
>> @@ -1811,7 +1812,7 @@ int e2fsck_process_bad_inode(e2fsck_t ctx, =
ext2_ino_t dir,
>> 		} else
>> 			not_fixed++;
>> 	}
>> -	if (inode.i_size_high &&
>> +	if (inode.i_size_high && !ext2fs_has_feature_largedir(fs->super) =
&&
>> 	    LINUX_S_ISDIR(inode.i_mode)) {
>> 		if (fix_problem(ctx, PR_2_DIR_SIZE_HIGH_ZERO, &pctx)) {
>> 			inode.i_size_high =3D 0;
>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> index 195e366..66b7058 100644
>> --- a/lib/ext2fs/ext2_fs.h
>> +++ b/lib/ext2fs/ext2_fs.h
>> @@ -921,7 +921,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		=
4, ENCRYPT)
>>=20
>> #define EXT2_FEATURE_COMPAT_SUPP	0
>> #define EXT2_FEATURE_INCOMPAT_SUPP    =
(EXT2_FEATURE_INCOMPAT_FILETYPE| \
>> -				       EXT4_FEATURE_INCOMPAT_MMP)
>> +				       EXT4_FEATURE_INCOMPAT_MMP| \
>> +				       EXT4_FEATURE_INCOMPAT_LARGEDIR)
>> #define EXT2_FEATURE_RO_COMPAT_SUPP	=
(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
>> 					 =
EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
>> 					 =
EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
>> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
>> index 786ded8..c68be50 100644
>> --- a/lib/ext2fs/ext2fs.h
>> +++ b/lib/ext2fs/ext2fs.h
>> @@ -588,7 +588,8 @@ typedef struct ext2_icount *ext2_icount_t;
>> 					 EXT4_FEATURE_INCOMPAT_64BIT|\
>> 					 =
EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
>> 					 EXT4_FEATURE_INCOMPAT_ENCRYPT|\
>> -					 =
EXT4_FEATURE_INCOMPAT_CSUM_SEED)
>> +					 =
EXT4_FEATURE_INCOMPAT_CSUM_SEED|\
>> +					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
>>=20
>> #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	=
(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
>> 					 =
EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
>> @@ -1924,6 +1925,18 @@ _INLINE_ blk_t =
ext2fs_inode_data_blocks(ext2_filsys fs,
>> 	return (blk_t) ext2fs_inode_data_blocks2(fs, inode);
>> }
>>=20
>> +/* htree levels for ext4 */
>> +#define EXT4_HTREE_LEVEL_COMPAT 2
>> +#define EXT4_HTREE_LEVEL	3
>> +
>> +static inline unsigned int ext2_dir_htree_level(ext2_filsys fs)
>> +{
>> +	if (ext2fs_has_feature_largedir(fs->super))
>> +		return EXT4_HTREE_LEVEL;
>> +
>> +	return EXT4_HTREE_LEVEL_COMPAT;
>> +}
>> +
>> /*
>> * This is an efficient, overflow safe way of calculating ceil((1.0 * =
a) / b)
>> */
>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>> index 9f18c83..b2bf461 100644
>> --- a/misc/mke2fs.c
>> +++ b/misc/mke2fs.c
>> @@ -1081,7 +1081,8 @@ static __u32 ok_features[3] =3D {
>> 		EXT4_FEATURE_INCOMPAT_64BIT|
>> 		EXT4_FEATURE_INCOMPAT_INLINE_DATA|
>> 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
>> -		EXT4_FEATURE_INCOMPAT_CSUM_SEED,
>> +		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
>> +		EXT4_FEATURE_INCOMPAT_LARGEDIR,
>> 	/* R/O compat */
>> 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
>> 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
>> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
>> index 6239577..f78d105 100644
>> --- a/misc/tune2fs.c
>> +++ b/misc/tune2fs.c
>> @@ -156,7 +156,8 @@ static __u32 ok_features[3] =3D {
>> 		EXT4_FEATURE_INCOMPAT_MMP |
>> 		EXT4_FEATURE_INCOMPAT_64BIT |
>> 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
>> -		EXT4_FEATURE_INCOMPAT_CSUM_SEED,
>> +		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
>> +		EXT4_FEATURE_INCOMPAT_LARGEDIR,
>> 	/* R/O compat */
>> 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
>> 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
>> --
>> 1.7.1
>>=20
>=20
>=20
> Cheers, Andreas
