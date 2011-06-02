From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 1/2] ext4: arrange ext4_*_bit() macros
Date: Thu, 2 Jun 2011 11:50:49 +0300
Message-ID: <BANLkTikSKyKuseG+iehh=-wfDCu46sinZw@mail.gmail.com>
References: <1306939009-11283-1-git-send-email-akinobu.mita@gmail.com>
	<46950A08-9300-4649-A38D-88829035DFC2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1FBIuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 04:50:51 -0400
In-Reply-To: <46950A08-9300-4649-A38D-88829035DFC2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 1, 2011 at 11:49 PM, Andreas Dilger
<adilger.kernel@dilger.ca> wrote:
> On 2011-06-01, at 8:36 AM, Akinobu Mita wrote:
>> - remove unused ext4_{set,clear}_bit_atomic and ext4_find_first_zero=
_bit

=46YI, one of the snapshot patches (snapshot_exclude_bitmap.patch)
uses ext4_set_bit_atomic() to set bits in the exclude bitmap when
moving blocks to snapshot file.
Since moving blocks is not done in allocation context, there is no
buddy/group lock held while manipulating the exclude bitmap.
So I would appreciate if this specific macro will not be removed.

Thanks, Yongqiang , for pointing that out.

>> - rename ext4_{set,clear}_bit to ext4_test_and_{set,clear}_bit
>> - reintroduce ext4_{set,clear}_bit for __{set,clear}_bit_le
>>
>> This changes ext4_{set,clear}_bit safely, because if someone uses
>> these macros without noticing the change, new ext4_{set,clear}_bit
>> don't have return value and causes compiler errors where the return
>> value is used.
>
> I don't think it makes sense to change all of the ext4_set_bit() call=
s that
> don't check the return code to use ext4_test_and_set_bit(), just to r=
eturn
> them back to ext4_set_bit() in the next patch.
>
> If you want to do this in separate steps, and maintain git bisect wor=
king,
> then it would be more clear to have two patches:
>
> Patch #1: Add new ext4_test_and_set_bit() macro
> #define ext4_test_and_set_bit =A0 =A0 =A0 =A0 =A0 __test_and_set_bit_=
le
> {change ext4_set_bit() calls that check return to =A0ext4_test_and_se=
t_bit()}
>
> Patch #2: Change ext4_set_bit() to not return old bit
> #define ext4_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__set_bit=
_le
> {nothing else changes}
>
> Alternately, you could just leave the calls that do not check the ret=
urn
> value as ext4_set_bit() and have only a single patch.
>
>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
>> Cc: linux-ext4@vger.kernel.org
>> ---
>> v2: rewritten to keep ext4_*_bit() macros
>>
>> fs/ext4/balloc.c =A0| =A0 =A08 ++++----
>> fs/ext4/ext4.h =A0 =A0| =A0 =A09 ++++-----
>> fs/ext4/ialloc.c =A0| =A0 =A09 ++++-----
>> fs/ext4/mballoc.c | =A0 =A04 ++--
>> fs/ext4/resize.c =A0| =A0 12 ++++++------
>> 5 files changed, 20 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
>> index 264f694..b6747e4 100644
>> --- a/fs/ext4/balloc.c
>> +++ b/fs/ext4/balloc.c
>> @@ -144,7 +144,7 @@ unsigned ext4_init_block_bitmap(struct super_blo=
ck *sb, struct buffer_head *bh,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int flex_bg =3D 0;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (bit =3D 0; bit < bit_max; bit++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(bit, bh->b_da=
ta);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_test_and_set_bit(bit,=
 bh->b_data);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D ext4_group_first_block_no(sb, =
block_group);
>>
>> @@ -155,18 +155,18 @@ unsigned ext4_init_block_bitmap(struct super_b=
lock *sb, struct buffer_head *bh,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Set bits for block and inode bitmaps,=
 and inode table */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D ext4_block_bitmap(sb, gdp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!flex_bg || ext4_block_in_group(sb, =
tmp, block_group))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(tmp - start, =
bh->b_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_test_and_set_bit(tmp =
- start, bh->b_data);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D ext4_inode_bitmap(sb, gdp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!flex_bg || ext4_block_in_group(sb, =
tmp, block_group))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(tmp - start, =
bh->b_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_test_and_set_bit(tmp =
- start, bh->b_data);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D ext4_inode_table(sb, gdp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; tmp < ext4_inode_table(sb, gdp) +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sbi->s_i=
tb_per_group; tmp++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!flex_bg ||
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_blo=
ck_in_group(sb, tmp, block_group))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_b=
it(tmp - start, bh->b_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_test_=
and_set_bit(tmp - start, bh->b_data);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Also if the number of blocks within=
 the group is
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 1921392..04db84f 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -930,12 +930,11 @@ struct ext4_inode_info {
>> #define test_opt2(sb, opt) =A0 =A0 =A0 =A0 =A0 =A0(EXT4_SB(sb)->s_mo=
unt_opt2 & \
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0EXT4_MOUNT2_##opt)
>>
>> -#define ext4_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __test_and_set=
_bit_le
>> -#define ext4_set_bit_atomic =A0 =A0 =A0 =A0 =A0ext2_set_bit_atomic
>> -#define ext4_clear_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
__test_and_clear_bit_le
>> -#define ext4_clear_bit_atomic =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2_c=
lear_bit_atomic
>> +#define ext4_test_and_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__test=
_and_set_bit_le
>> +#define ext4_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __set_bit_le
>> +#define ext4_test_and_clear_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0__test_a=
nd_clear_bit_le
>> +#define ext4_clear_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
__clear_bit_le
>> #define ext4_test_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 test_bit_le
>> -#define ext4_find_first_zero_bit =A0 =A0 find_first_zero_bit_le
>> #define ext4_find_next_zero_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 find_nex=
t_zero_bit_le
>> #define ext4_find_next_bit =A0 =A0 =A0 =A0 =A0 =A0find_next_bit_le
>>
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index 21bb2f6..90bef6b 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -59,7 +59,7 @@ void ext4_mark_bitmap_end(int start_bit, int end_b=
it, char *bitmap)
>>
>> =A0 =A0 =A0 ext4_debug("mark end bits +%d through +%d used\n", start=
_bit, end_bit);
>> =A0 =A0 =A0 for (i =3D start_bit; i < ((start_bit + 7) & ~7UL); i++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(i, bitmap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_test_and_set_bit(i, bitmap);
>> =A0 =A0 =A0 if (i < end_bit)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(bitmap + (i >> 3), 0xff, (end_bit=
 - i) >> 3);
>> }
>> @@ -252,7 +252,7 @@ void ext4_free_inode(handle_t *handle, struct in=
ode *inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fatal =3D ext4_journal_get_write_access(=
handle, bh2);
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 ext4_lock_group(sb, block_group);
>> - =A0 =A0 cleared =3D ext4_clear_bit(bit, bitmap_bh->b_data);
>> + =A0 =A0 cleared =3D ext4_test_and_clear_bit(bit, bitmap_bh->b_data=
);
>> =A0 =A0 =A0 if (fatal || !cleared) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_unlock_group(sb, block_group);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> @@ -729,7 +729,7 @@ static int ext4_claim_inode(struct super_block *=
sb,
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 down_read(&grp->alloc_sem);
>> =A0 =A0 =A0 ext4_lock_group(sb, group);
>> - =A0 =A0 if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
>> + =A0 =A0 if (ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* not a free inode */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_ret;
>> @@ -884,8 +884,7 @@ got_group:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
>>
>> repeat_in_this_group:
>> - =A0 =A0 =A0 =A0 =A0 =A0 ino =3D ext4_find_next_zero_bit((unsigned =
long *)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 inode_bitmap_bh->b_data,
>> + =A0 =A0 =A0 =A0 =A0 =A0 ino =3D ext4_find_next_zero_bit(inode_bitm=
ap_bh->b_data,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 EXT4_INODES_PER_GROUP(sb), ino);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ino < EXT4_INODES_PER_GROUP(sb)) {
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 859f2ae..b423adf 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -384,13 +384,13 @@ static inline int mb_test_bit(int bit, void *a=
ddr)
>> static inline void mb_set_bit(int bit, void *addr)
>> {
>> =A0 =A0 =A0 addr =3D mb_correct_addr_and_bit(&bit, addr);
>> - =A0 =A0 ext4_set_bit(bit, addr);
>> + =A0 =A0 ext4_test_and_set_bit(bit, addr);
>> }
>>
>> static inline void mb_clear_bit(int bit, void *addr)
>> {
>> =A0 =A0 =A0 addr =3D mb_correct_addr_and_bit(&bit, addr);
>> - =A0 =A0 ext4_clear_bit(bit, addr);
>> + =A0 =A0 ext4_test_and_clear_bit(bit, addr);
>> }
>>
>> static inline int mb_find_next_zero_bit(void *addr, int max, int sta=
rt)
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index 80bbc9c..cc40963 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -194,7 +194,7 @@ static int setup_new_group_blocks(struct super_b=
lock *sb,
>>
>> =A0 =A0 =A0 if (ext4_bg_has_super(sb, input->group)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_debug("mark backup superblock %#04l=
lx (+0)\n", start);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(0, bh->b_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_test_and_set_bit(0, bh->b_data);
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 /* Copy all of the GDT blocks into the backup in this gr=
oup */
>> @@ -225,7 +225,7 @@ static int setup_new_group_blocks(struct super_b=
lock *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(gdb);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(bit, bh->b_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_test_and_set_bit(bit, bh->b_data);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(gdb);
>> =A0 =A0 =A0 }
>>
>> @@ -237,14 +237,14 @@ static int setup_new_group_blocks(struct super=
_block *sb,
>> =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>> =A0 =A0 =A0 for (i =3D 0, bit =3D gdblocks + 1; i < reserved_gdb; i+=
+, bit++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(bit, bh->b_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_test_and_set_bit(bit, bh->b_data);
>>
>> =A0 =A0 =A0 ext4_debug("mark block bitmap %#04llx (+%llu)\n", input-=
>block_bitmap,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0input->block_bitmap - start);
>> - =A0 =A0 ext4_set_bit(input->block_bitmap - start, bh->b_data);
>> + =A0 =A0 ext4_test_and_set_bit(input->block_bitmap - start, bh->b_d=
ata);
>> =A0 =A0 =A0 ext4_debug("mark inode bitmap %#04llx (+%llu)\n", input-=
>inode_bitmap,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0input->inode_bitmap - start);
>> - =A0 =A0 ext4_set_bit(input->inode_bitmap - start, bh->b_data);
>> + =A0 =A0 ext4_test_and_set_bit(input->inode_bitmap - start, bh->b_d=
ata);
>>
>> =A0 =A0 =A0 /* Zero out all of the inode table blocks */
>> =A0 =A0 =A0 block =3D input->inode_table;
>> @@ -255,7 +255,7 @@ static int setup_new_group_blocks(struct super_b=
lock *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>> =A0 =A0 =A0 for (i =3D 0, bit =3D input->inode_table - start;
>> =A0 =A0 =A0 =A0 =A0 =A0i < sbi->s_itb_per_group; i++, bit++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(bit, bh->b_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_test_and_set_bit(bit, bh->b_data);
>>
>> =A0 =A0 =A0 if ((err =3D extend_or_restart_transaction(handle, 2, bh=
)))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>> --
>> 1.7.4.4
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
