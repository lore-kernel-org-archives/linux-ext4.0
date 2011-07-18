From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 05/12] ext4: let ext4_group_add_blocks return an error code
Date: Mon, 18 Jul 2011 20:55:35 +0800
Message-ID: <CAGBYx2bDMncq-vQjTneM2mwwuwg9fscYy2N+FpTsi8u0askuHg@mail.gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
	<1310957555-15617-6-git-send-email-xiaoqiangnk@gmail.com>
	<CAOQ4uxjq-10_yZFhP1A=N6tTbdotVsyLm5=_GSK+UwpyS0GL0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, aedilger@gmail.com
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34953 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1GRMzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 08:55:36 -0400
Received: by pvg12 with SMTP id 12so2955919pvg.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 05:55:35 -0700 (PDT)
In-Reply-To: <CAOQ4uxjq-10_yZFhP1A=N6tTbdotVsyLm5=_GSK+UwpyS0GL0w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 2:48 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> On Mon, Jul 18, 2011 at 5:52 AM, Yongqiang Yang <xiaoqiangnk@gmail.co=
m> wrote:
>> This patch lets ext4_group_add_blocks() return an error code if it f=
ails,
>> so that upper functions can handle error correctly.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =C2=A0fs/ext4/ext4.h =C2=A0 =C2=A0| =C2=A0 =C2=A02 +-
>> =C2=A0fs/ext4/mballoc.c | =C2=A0 19 +++++++++++++------
>> =C2=A0fs/ext4/resize.c =C2=A0| =C2=A0 10 +++++++---
>> =C2=A03 files changed, 21 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index bbe81db..da7ab48 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1799,7 +1799,7 @@ extern void ext4_free_blocks(handle_t *handle,=
 struct inode *inode,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long count, int flags);
>> =C2=A0extern int ext4_mb_add_groupinfo(struct super_block *sb,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_group_t =
i, struct ext4_group_desc *desc);
>> -extern void ext4_group_add_blocks(handle_t *handle, struct super_bl=
ock *sb,
>> +extern int ext4_group_add_blocks(handle_t *handle, struct super_blo=
ck *sb,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_fsblk_t block, unsigned =
long count);
>> =C2=A0extern int ext4_trim_fs(struct super_block *, struct fstrim_ra=
nge *);
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index ea80c0b..33c41e6 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -4664,7 +4664,7 @@ error_return:
>> =C2=A0*
>> =C2=A0* This marks the blocks as free in the bitmap and buddy.
>> =C2=A0*/
>> -void ext4_group_add_blocks(handle_t *handle, struct super_block *sb=
,
>> +int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 ext4_fsblk_t block, unsigned long count)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct buffer_head *bitmap_bh =3D NULL;
>> @@ -4685,15 +4685,21 @@ void ext4_group_add_blocks(handle_t *handle,=
 struct super_block *sb,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Check to see if we are freeing blocks =
across a group
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * boundary.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
>> - =C2=A0 =C2=A0 =C2=A0 if (bit + count > EXT4_BLOCKS_PER_GROUP(sb))
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto error_return=
;
>> + =C2=A0 =C2=A0 =C2=A0 if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) =
{
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_warning(sb, =
"too much blocks added to group %u\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0block_group);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
>> + =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0bitmap_bh =3D ext4_read_block_bitmap(sb, =
block_group);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!bitmap_bh)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto error_return=
;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EIO;
>
> Any reason you are skipping the goto in the 2 error cases above and
> missing the ext4_std_error()?

Resizing is very different from normal freeing before the block bitmap
are modified,  because the added blocks in super block are marked
used, thus they could not be used, for a mounted fs, it can continue
working, and the wrong block count could be fixed easily by e2fsck.
So I think we'd better not report an error to the fs.   Just my humble
opinion.

What about your opinions=EF=BC=9F

Yongqiang.
>
>> +
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0desc =3D ext4_get_group_desc(sb, block_gr=
oup, &gd_bh);
>> - =C2=A0 =C2=A0 =C2=A0 if (!desc)
>> + =C2=A0 =C2=A0 =C2=A0 if (!desc) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EIO;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto error_re=
turn;
>> + =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (in_range(ext4_block_bitmap(sb, desc),=
 block, count) ||
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in_range(ext4_inode_bitmap(=
sb, desc), block, count) ||
>> @@ -4703,6 +4709,7 @@ void ext4_group_add_blocks(handle_t *handle, s=
truct super_block *sb,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_error(sb=
, "Adding blocks in system zones - "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 "Block =3D %llu, count =3D %lu",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 block, count);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EINVAL;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto error_re=
turn;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>
>> @@ -4771,7 +4778,7 @@ void ext4_group_add_blocks(handle_t *handle, s=
truct super_block *sb,
>> =C2=A0error_return:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0brelse(bitmap_bh);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_std_error(sb, err);
>> - =C2=A0 =C2=A0 =C2=A0 return;
>> + =C2=A0 =C2=A0 =C2=A0 return err;
>> =C2=A0}
>>
>> =C2=A0/**
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index 374fd1c..2e63376 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -990,7 +990,7 @@ int ext4_group_extend(struct super_block *sb, st=
ruct ext4_super_block *es,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_grpblk_t add;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct buffer_head *bh;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0handle_t *handle;
>> - =C2=A0 =C2=A0 =C2=A0 int err;
>> + =C2=A0 =C2=A0 =C2=A0 int err, err2;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_group_t group;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0o_blocks_count =3D ext4_blocks_count(es);
>> @@ -1066,11 +1066,15 @@ int ext4_group_extend(struct super_block *sb=
, struct ext4_super_block *es,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_debug("freeing blocks %llu through %=
llu\n", o_blocks_count,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 o_blo=
cks_count + add);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* We add the blocks to the bitmap and se=
t the group need init bit */
>> - =C2=A0 =C2=A0 =C2=A0 ext4_group_add_blocks(handle, sb, o_blocks_co=
unt, add);
>> + =C2=A0 =C2=A0 =C2=A0 err =3D ext4_group_add_blocks(handle, sb, o_b=
locks_count, add);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_handle_dirty_super(handle, sb);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_debug("freed blocks %llu through %ll=
u\n", o_blocks_count,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 o_blo=
cks_count + add);
>> - =C2=A0 =C2=A0 =C2=A0 if ((err =3D ext4_journal_stop(handle)))
>> + =C2=A0 =C2=A0 =C2=A0 err2 =3D ext4_journal_stop(handle);
>> + =C2=A0 =C2=A0 =C2=A0 if (!err && err2)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D err2;
>> +
>> + =C2=A0 =C2=A0 =C2=A0 if (err)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto exit_put=
;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (test_opt(sb, DEBUG))
>> --
>> 1.7.5.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
