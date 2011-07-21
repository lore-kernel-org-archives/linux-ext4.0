From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] ext4: remove ext4_free_blocks_after_init()
Date: Thu, 21 Jul 2011 09:37:17 +0800
Message-ID: <CAGBYx2Yd4_V0hnFSA=DRE2gtmAuWn96AdoJXvFa+yg-vZoUibA@mail.gmail.com>
References: <1311168774-26378-1-git-send-email-xiaoqiangnk@gmail.com>
	<1311168774-26378-3-git-send-email-xiaoqiangnk@gmail.com>
	<B18ADA2A-CB14-4D30-A091-E4ACB1C9E280@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60697 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab1GUBhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 21:37:18 -0400
Received: by pvg12 with SMTP id 12so643561pvg.19
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 18:37:17 -0700 (PDT)
In-Reply-To: <B18ADA2A-CB14-4D30-A091-E4ACB1C9E280@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 20, 2011 at 11:41 PM, Andreas Dilger <aedilger@gmail.com> w=
rote:
> On 2011-07-20, at 7:32 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wro=
te:
>> This patch removes ext4_free_blocks_after_init() and simplifies
>> ext4_init_block_bitmap() a lot.
>
> Why not use the ext4_set_bits() function, exported in another patch, =
to set multiple bits?
That patch has not been merged.  After it is merged, I will post
another patch doing this, this can easy Ted's work.  That patch is a
part of resize, but this patch has nothing to do with it logically.


Thank you,

Yongqiang.
>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> fs/ext4/balloc.c | =A0122 ++++++++++++++++++------------------------=
-----------
>> fs/ext4/ext4.h =A0 | =A0 =A04 +-
>> 2 files changed, 43 insertions(+), 83 deletions(-)
>>
>> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
>> index f8224ad..2dd9820 100644
>> --- a/fs/ext4/balloc.c
>> +++ b/fs/ext4/balloc.c
>> @@ -55,60 +55,31 @@ static int ext4_block_in_group(struct super_bloc=
k *sb, ext4_fsblk_t block,
>> =A0 =A0return 0;
>> }
>>
>> -static int ext4_group_used_meta_blocks(struct super_block *sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_group_t block_gro=
up,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_group_desc=
 *gdp)
>> -{
>> - =A0 =A0ext4_fsblk_t tmp;
>> - =A0 =A0struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>> - =A0 =A0/* block bitmap, inode bitmap, and inode table blocks */
>> - =A0 =A0int used_blocks =3D sbi->s_itb_per_group + 2;
>> -
>> - =A0 =A0if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLE=
X_BG)) {
>> - =A0 =A0 =A0 =A0if (!ext4_block_in_group(sb, ext4_block_bitmap(sb, =
gdp),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block_group))
>> - =A0 =A0 =A0 =A0 =A0 =A0used_blocks--;
>> -
>> - =A0 =A0 =A0 =A0if (!ext4_block_in_group(sb, ext4_inode_bitmap(sb, =
gdp),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block_group))
>> - =A0 =A0 =A0 =A0 =A0 =A0used_blocks--;
>> -
>> - =A0 =A0 =A0 =A0tmp =3D ext4_inode_table(sb, gdp);
>> - =A0 =A0 =A0 =A0for (; tmp < ext4_inode_table(sb, gdp) +
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sbi->s_itb_per_group; tmp++) {
>> - =A0 =A0 =A0 =A0 =A0 =A0if (!ext4_block_in_group(sb, tmp, block_gro=
up))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0used_blocks -=3D 1;
>> - =A0 =A0 =A0 =A0}
>> - =A0 =A0}
>> - =A0 =A0return used_blocks;
>> -}
>> -
>> -/* Initializes an uninitialized block bitmap if given, and returns =
the
>> - * number of blocks free in the group. */
>> -unsigned ext4_init_block_bitmap(struct super_block *sb, struct buff=
er_head *bh,
>> +/* Initializes an uninitialized block bitmap */
>> +void ext4_init_block_bitmap(struct super_block *sb, struct buffer_h=
ead *bh,
>> =A0 =A0 =A0 =A0 ext4_group_t block_group, struct ext4_group_desc *gd=
p)
>> {
>> + =A0 =A0ext4_fsblk_t start, tmp;
>> =A0 =A0int bit, bit_max;
>> =A0 =A0ext4_group_t ngroups =3D ext4_get_groups_count(sb);
>> - =A0 =A0unsigned free_blocks, group_blocks;
>> + =A0 =A0unsigned group_blocks;
>> =A0 =A0struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>> -
>> - =A0 =A0if (bh) {
>> - =A0 =A0 =A0 =A0J_ASSERT_BH(bh, buffer_locked(bh));
>> -
>> - =A0 =A0 =A0 =A0/* If checksum is bad mark all blocks used to preve=
nt allocation
>> - =A0 =A0 =A0 =A0 * essentially implementing a per-group read-only f=
lag. */
>> - =A0 =A0 =A0 =A0if (!ext4_group_desc_csum_verify(sbi, block_group, =
gdp)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0ext4_error(sb, "Checksum bad for group %u",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block_group);
>> - =A0 =A0 =A0 =A0 =A0 =A0ext4_free_blks_set(sb, gdp, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0ext4_free_inodes_set(sb, gdp, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0ext4_itable_unused_set(sb, gdp, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0memset(bh->b_data, 0xff, sb->s_blocksize);
>> - =A0 =A0 =A0 =A0 =A0 =A0return 0;
>> - =A0 =A0 =A0 =A0}
>> - =A0 =A0 =A0 =A0memset(bh->b_data, 0, sb->s_blocksize);
>> + =A0 =A0int flex_bg =3D 0;
>> +
>> + =A0 =A0J_ASSERT_BH(bh, bh && buffer_locked(bh));
>> +
>> + =A0 =A0/* If checksum is bad mark all blocks used to prevent alloc=
ation
>> + =A0 =A0 * essentially implementing a per-group read-only flag. */
>> + =A0 =A0if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
>> + =A0 =A0 =A0 =A0ext4_error(sb, "Checksum bad for group %u",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block_group);
>> + =A0 =A0 =A0 =A0ext4_free_blks_set(sb, gdp, 0);
>> + =A0 =A0 =A0 =A0ext4_free_inodes_set(sb, gdp, 0);
>> + =A0 =A0 =A0 =A0ext4_itable_unused_set(sb, gdp, 0);
>> + =A0 =A0 =A0 =A0memset(bh->b_data, 0xff, sb->s_blocksize);
>> + =A0 =A0 =A0 =A0return;
>> =A0 =A0}
>> + =A0 =A0memset(bh->b_data, 0, sb->s_blocksize);
>>
>> =A0 =A0/* Check for superblock and gdt backups in this group */
>> =A0 =A0bit_max =3D ext4_bg_has_super(sb, block_group);
>> @@ -137,46 +108,37 @@ unsigned ext4_init_block_bitmap(struct super_b=
lock *sb, struct buffer_head *bh,
>> =A0 =A0 =A0 =A0group_blocks =3D EXT4_BLOCKS_PER_GROUP(sb);
>> =A0 =A0}
>>
>> - =A0 =A0free_blocks =3D group_blocks - bit_max;
>>
>> - =A0 =A0if (bh) {
>> - =A0 =A0 =A0 =A0ext4_fsblk_t start, tmp;
>> - =A0 =A0 =A0 =A0int flex_bg =3D 0;
>> + =A0 =A0for (bit =3D 0; bit < bit_max; bit++)
>> + =A0 =A0 =A0 =A0ext4_set_bit(bit, bh->b_data);
>>
>> - =A0 =A0 =A0 =A0for (bit =3D 0; bit < bit_max; bit++)
>> - =A0 =A0 =A0 =A0 =A0 =A0ext4_set_bit(bit, bh->b_data);
>> + =A0 =A0start =3D ext4_group_first_block_no(sb, block_group);
>>
>> - =A0 =A0 =A0 =A0start =3D ext4_group_first_block_no(sb, block_group=
);
>> + =A0 =A0flex_bg =3D EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCO=
MPAT_FLEX_BG);
>>
>> - =A0 =A0 =A0 =A0if (EXT4_HAS_INCOMPAT_FEATURE(sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_FEATURE_IN=
COMPAT_FLEX_BG))
>> - =A0 =A0 =A0 =A0 =A0 =A0flex_bg =3D 1;
>> + =A0 =A0/* Set bits for block and inode bitmaps, and inode table */
>> + =A0 =A0tmp =3D ext4_block_bitmap(sb, gdp);
>> + =A0 =A0if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
>> + =A0 =A0 =A0 =A0ext4_set_bit(tmp - start, bh->b_data);
>>
>> - =A0 =A0 =A0 =A0/* Set bits for block and inode bitmaps, and inode =
table */
>> - =A0 =A0 =A0 =A0tmp =3D ext4_block_bitmap(sb, gdp);
>> - =A0 =A0 =A0 =A0if (!flex_bg || ext4_block_in_group(sb, tmp, block_=
group))
>> - =A0 =A0 =A0 =A0 =A0 =A0ext4_set_bit(tmp - start, bh->b_data);
>> + =A0 =A0tmp =3D ext4_inode_bitmap(sb, gdp);
>> + =A0 =A0if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
>> + =A0 =A0 =A0 =A0ext4_set_bit(tmp - start, bh->b_data);
>>
>> - =A0 =A0 =A0 =A0tmp =3D ext4_inode_bitmap(sb, gdp);
>> - =A0 =A0 =A0 =A0if (!flex_bg || ext4_block_in_group(sb, tmp, block_=
group))
>> + =A0 =A0tmp =3D ext4_inode_table(sb, gdp);
>> + =A0 =A0for (; tmp < ext4_inode_table(sb, gdp) +
>> + =A0 =A0 =A0 =A0 =A0 =A0sbi->s_itb_per_group; tmp++) {
>> + =A0 =A0 =A0 =A0if (!flex_bg ||
>> + =A0 =A0 =A0 =A0 =A0 =A0ext4_block_in_group(sb, tmp, block_group))
>> =A0 =A0 =A0 =A0 =A0 =A0ext4_set_bit(tmp - start, bh->b_data);
>> -
>> - =A0 =A0 =A0 =A0tmp =3D ext4_inode_table(sb, gdp);
>> - =A0 =A0 =A0 =A0for (; tmp < ext4_inode_table(sb, gdp) +
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sbi->s_itb_per_group; tmp++) {
>> - =A0 =A0 =A0 =A0 =A0 =A0if (!flex_bg ||
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_block_in_group(sb, tmp, block_=
group))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_set_bit(tmp - start, bh->b_dat=
a);
>> - =A0 =A0 =A0 =A0}
>> - =A0 =A0 =A0 =A0/*
>> - =A0 =A0 =A0 =A0 * Also if the number of blocks within the group is
>> - =A0 =A0 =A0 =A0 * less than the blocksize * 8 ( which is the size
>> - =A0 =A0 =A0 =A0 * of bitmap ), set rest of the block bitmap to 1
>> - =A0 =A0 =A0 =A0 */
>> - =A0 =A0 =A0 =A0ext4_mark_bitmap_end(group_blocks, sb->s_blocksize =
* 8,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh->b_data);
>> =A0 =A0}
>> - =A0 =A0return free_blocks - ext4_group_used_meta_blocks(sb, block_=
group, gdp);
>> + =A0 =A0/*
>> + =A0 =A0 * Also if the number of blocks within the group is
>> + =A0 =A0 * less than the blocksize * 8 ( which is the size
>> + =A0 =A0 * of bitmap ), set rest of the block bitmap to 1
>> + =A0 =A0 */
>> + =A0 =A0ext4_mark_bitmap_end(group_blocks, sb->s_blocksize * 8,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh->b_data);
>> }
>>
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 62cee2b..eacaad2 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1741,12 +1741,10 @@ extern struct ext4_group_desc * ext4_get_gro=
up_desc(struct super_block * sb,
>> extern int ext4_should_retry_alloc(struct super_block *sb, int *retr=
ies);
>> struct buffer_head *ext4_read_block_bitmap(struct super_block *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_group_t block_group)=
;
>> -extern unsigned ext4_init_block_bitmap(struct super_block *sb,
>> +extern void ext4_init_block_bitmap(struct super_block *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *bh,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_group_t group,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_group_desc *=
desc);
>> -#define ext4_free_blocks_after_init(sb, group, desc) =A0 =A0 =A0 =A0=
 =A0 =A0\
>> - =A0 =A0 =A0 =A0ext4_init_block_bitmap(sb, NULL, group, desc)
>> ext4_fsblk_t ext4_inode_to_goal_block(struct inode *);
>>
>> /* dir.c */
>> --
>> 1.7.5.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
