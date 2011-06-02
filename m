From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 13/30] ext4: snapshot file - increase maximum file
 size limit to 16TB
Date: Thu, 2 Jun 2011 14:47:19 +0300
Message-ID: <BANLkTi=uHU-LH0QwCvn=5su3ZaVK_7YgnQ@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<1304959308-11122-14-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33678 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1FBLrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 07:47:20 -0400
Received: by wwa36 with SMTP id 36so805074wwa.1
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jun 2011 04:47:19 -0700 (PDT)
In-Reply-To: <1304959308-11122-14-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Let it not be said that my patches don't get reviewed ;-)

Ted,

I have requested the Github support team to change my ext4-snapshots re=
po's
fork parent to your ext4 repo.
When they do that, I can send you a "Pull Request" for the patch
series via Github.
You will then be able to review and comment on the patches inline (and =
online).
Until the time that you merge my patches, you will be able to view the =
request
in your "Pull Requests" inbox, with all comments you made on all the pa=
tches
in the request.
Since you won't be merging the v1 series, you will have the v1 comments
as reference in your inbox when I will send a pull request for a
different v2 branch.

Let try to give that workflow a chance.
Amir.


On Mon, May 9, 2011 at 7:41 PM,  <amir73il@users.sourceforge.net> wrote=
:
> From: Amir Goldstein <amir73il@users.sf.net>
>
> Files larger than 2TB use Ext4 huge_file flag to store i_blocks
> in file system blocks units, so the upper limit on snapshot actual
> size is increased from 512*2^32 =3D 2TB to 4K*2^32 =3D 16TB,
> which is also the upper limit on file system size.
> To map 2^32 logical blocks, 4 triple indirect blocks are used instead
> of just one. =A0The extra 3 triple indirect blocks are stored in-plac=
e
> of direct blocks, which are not in use by snapshot files.
>
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext4/ext4.h =A0| =A0 13 +++++++++++++
> =A0fs/ext4/inode.c | =A0 44 +++++++++++++++++++++++++++++++++++++++++=
+--
> =A0fs/ext4/super.c | =A0 =A05 ++++-
> =A03 files changed, 59 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 4072036..8f59322 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -333,6 +333,19 @@ struct flex_groups {
> =A0#define =A0 =A0 =A0 =A0EXT4_DIND_BLOCK =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 (EXT4_IND_BLOCK + 1)
> =A0#define =A0 =A0 =A0 =A0EXT4_TIND_BLOCK =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 (EXT4_DIND_BLOCK + 1)
> =A0#define =A0 =A0 =A0 =A0EXT4_N_BLOCKS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 (EXT4_TIND_BLOCK + 1)
> +/*
> + * Snapshot files have different indirection mapping that can map up=
 to 2^32
> + * logical blocks, so they can cover the mapped filesystem block add=
ress space.
> + * Ext4 must use either 4K or 8K blocks (depending on PAGE_SIZE).
> + * With 8K blocks, 1 triple indirect block maps 2^33 logical blocks.
> + * With 4K blocks (the system default), each triple indirect block m=
aps 2^30
> + * logical blocks, so 4 triple indirect blocks map 2^32 logical bloc=
ks.
> + * Snapshot files in small filesystems (<=3D 4G), use only 1 double =
indirect
> + * block to map the entire filesystem.
> + */
> +#define =A0 =A0 =A0 =A0EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS 3
> +#define =A0 =A0 =A0 =A0EXT4_SNAPSHOT_N_BLOCKS =A0 =A0 =A0 =A0 =A0(EX=
T4_TIND_BLOCK + 1 + \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS)
>
> =A0/*
> =A0* Inode flags
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index db1706f..425dabb 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -335,6 +335,7 @@ static int ext4_block_to_path(struct inode *inode=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0double_blocks =3D (1 << (ptrs_bits * 2=
));
> =A0 =A0 =A0 =A0int n =3D 0;
> =A0 =A0 =A0 =A0int final =3D 0;
> + =A0 =A0 =A0 int tind;
>
> =A0 =A0 =A0 =A0if (i_block < direct_blocks) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offsets[n++] =3D i_block;
> @@ -354,6 +355,18 @@ static int ext4_block_to_path(struct inode *inod=
e,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offsets[n++] =3D (i_block >> ptrs_bits=
) & (ptrs - 1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offsets[n++] =3D i_block & (ptrs - 1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0final =3D ptrs;
> + =A0 =A0 =A0 } else if (ext4_snapshot_file(inode) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (i_block >> (ptrs_bits =
* 3)) <
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_SNAPSHOT_EXTRA_TIN=
D_BLOCKS + 1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tind =3D i_block >> (ptrs_bits * 3);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(tind =3D=3D 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* use up to 4 triple indirect blocks t=
o map 2^32 blocks */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_block -=3D (tind << (ptrs_bits * 3));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offsets[n++] =3D (EXT4_TIND_BLOCK + tin=
d) % EXT4_NDIR_BLOCKS;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offsets[n++] =3D i_block >> (ptrs_bits =
* 2);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offsets[n++] =3D (i_block >> ptrs_bits)=
 & (ptrs - 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offsets[n++] =3D i_block & (ptrs - 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 final =3D ptrs;
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_warning(inode->i_sb, "block %lu >=
 max in inode %lu",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_block + dir=
ect_blocks +
> @@ -4748,6 +4761,13 @@ void ext4_truncate(struct inode *inode)
> =A0 =A0 =A0 =A0ext4_lblk_t last_block, max_block;
> =A0 =A0 =A0 =A0unsigned blocksize =3D inode->i_sb->s_blocksize;
>
> + =A0 =A0 =A0 /* prevent partial truncate of snapshot files */
> + =A0 =A0 =A0 if (ext4_snapshot_file(inode) && inode->i_size !=3D 0) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 snapshot_debug(1, "snapshot file (%lu) =
cannot be partly "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "trunca=
ted!\n", inode->i_ino);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0/* prevent truncate of files on snapshot list */
> =A0 =A0 =A0 =A0if (ext4_snapshot_list(inode)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0snapshot_debug(1, "snapshot (%u) canno=
t be truncated!\n",
> @@ -4861,6 +4881,10 @@ do_indirects:
> =A0 =A0 =A0 =A0/* Kill the remaining (whole) subtrees */
> =A0 =A0 =A0 =A0switch (offsets[0]) {
> =A0 =A0 =A0 =A0default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext4_snapshot_file(inode) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offsets=
[0] < EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Freeing snapshot ext=
ra tind branches */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr =3D i_data[EXT4_IND_BLOCK];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (nr) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_free_branches(han=
dle, inode, NULL, &nr, &nr+1, 1);
> @@ -4882,6 +4906,19 @@ do_indirects:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 if (ext4_snapshot_file(inode)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Kill the remaining snapshot file tri=
ple indirect trees */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < EXT4_SNAPSHOT_EXTRA_T=
IND_BLOCKS; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr =3D i_data[i];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!nr)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continu=
e;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_branches(hand=
le, inode, NULL, &nr, &nr+1, 3);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_data[i] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> =A0out_unlock:
> =A0 =A0 =A0 =A0up_write(&ei->i_data_sem);
> =A0 =A0 =A0 =A0inode->i_mtime =3D inode->i_ctime =3D ext4_current_tim=
e(inode);
> @@ -5114,7 +5151,8 @@ static blkcnt_t ext4_inode_blocks(struct ext4_i=
node *raw_inode,
> =A0 =A0 =A0 =A0struct super_block *sb =3D inode->i_sb;
>
> =A0 =A0 =A0 =A0if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_FE=
ATURE_RO_COMPAT_HUGE_FILE)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_FE=
ATURE_RO_COMPAT_HUGE_FILE) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_snapshot_file(inod=
e)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we are using combined 48 bit field =
*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i_blocks =3D ((u64)le16_to_cpu(raw_ino=
de->i_blocks_high)) << 32 |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0le32_to_cpu(raw_inode->i_blocks_lo);
> @@ -5353,7 +5391,9 @@ static int ext4_inode_blocks_set(handle_t *hand=
le,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_clear_inode_flag(inode, EXT4_INOD=
E_HUGE_FILE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COM=
PAT_HUGE_FILE))
> + =A0 =A0 =A0 /* snapshot files may be represented as huge files */
> + =A0 =A0 =A0 if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COM=
PAT_HUGE_FILE) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !ext4_snapshot_file(ino=
de))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EFBIG;
>
> =A0 =A0 =A0 =A0if (i_blocks <=3D 0xffffffffffffULL) {
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e3ebd7d..d26831a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2316,7 +2316,7 @@ static loff_t ext4_max_bitmap_size(int bits, in=
t has_huge_files)
>
> =A0 =A0 =A0 =A0res +=3D 1LL << (bits-2);
> =A0 =A0 =A0 =A0res +=3D 1LL << (2*(bits-2));
> - =A0 =A0 =A0 res +=3D 1LL << (3*(bits-2));
> + =A0 =A0 =A0 res +=3D (1LL + EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS) << (3*=
(bits-2));

This is plain wrong.
s_bitmap_maxbytes should not be affected by snapshots.
Instead, snapshot files maximum size should be enforced by s_maxbytes
and not by s_bitmap_maxbytes.

> =A0 =A0 =A0 =A0res <<=3D bits;
> =A0 =A0 =A0 =A0if (res > upper_limit)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0res =3D upper_limit;
> @@ -3259,6 +3259,9 @@ static int ext4_fill_super(struct super_block *=
sb, void *data, int silent)
>
> =A0 =A0 =A0 =A0has_huge_files =3D EXT4_HAS_RO_COMPAT_FEATURE(sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_F=
EATURE_RO_COMPAT_HUGE_FILE);
> + =A0 =A0 =A0 if (EXT4_SNAPSHOTS(sb))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Snapshot files are huge files */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 has_huge_files =3D 1;

This should be moved under sbi->s_bitmap_maxbytes =3D , so it will only
affect s_maxbytes.

> =A0 =A0 =A0 =A0sbi->s_bitmap_maxbytes =3D ext4_max_bitmap_size(sb->s_=
blocksize_bits,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0has_huge_files);
> =A0 =A0 =A0 =A0sb->s_maxbytes =3D ext4_max_size(sb->s_blocksize_bits,=
 has_huge_files);
> --
> 1.7.0.4
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
