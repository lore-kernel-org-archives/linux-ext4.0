From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 05/12] ext4: let ext4_group_add_blocks return an error code
Date: Mon, 18 Jul 2011 09:47:45 +0300
Message-ID: <CAOQ4uxgjjGuyfTxCGXR4z2hD3_hwFBFduPx31avezQH98UdWvg@mail.gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
	<1310957555-15617-6-git-send-email-xiaoqiangnk@gmail.com>
	<36AA4B27-92AE-4984-8002-3410C6109F15@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53581 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1GRGrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 02:47:46 -0400
Received: by wwe5 with SMTP id 5so2870761wwe.1
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 23:47:45 -0700 (PDT)
In-Reply-To: <36AA4B27-92AE-4984-8002-3410C6109F15@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 9:19 AM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-07-17, at 8:52 PM, Yongqiang Yang wrote:
>> This patch lets ext4_group_add_blocks() return an error code if it f=
ails,
>> so that upper functions can handle error correctly.
>
> This patch is somewhat incorrect, though it seems the existing code i=
s
> also incorrect, which isn't the fault of this patch, but should be
> fixed if this code is being reworked.
>
> When this code was originally written, this code could not fail
> unless the filesystem had been marked read-only or the journal was
> aborted. =A0It only freed blocks using ext3_free_blocks_sb(), which
> only had error paths calling ext3_error().
>
> It was purposely done that way because all of the failure cases
> (e.g. not being able to read the block bitmap) were checked in
> advance, before modifying any of the filesystem metadata.
>
> In the case of this patch, ext4_blocks_count_set() is called to
> add the new blocks to the total in the superblock. =A0If this code
> fails, it doesn't try to reset the total number of blocks in the
> superblock, which can cause e2fsck to be unhappy.
>
> Looking at this code more closely, it seems that ext4_group_add_block=
s()
> (formerly ext4_add_groupblocks()) is now only used by the resize code=
,
> which IMHO is wrong. =A0What it was doing in the past was using exist=
ing
> code to "free" the blocks at the end of the block bitmap, as if a fil=
e
> had just been deleted. =A0As it is now, it seems to be duplicating a =
lot
> of what is in ext4_free_blocks().

This is my (git) blame.
Before I had my way with ext4_add_groupblocks() it was practically usin=
g
old remains of ext3_free_blocks_sb() code (see commit e73a347b).
To make things work better (without a rw_sem) I copied code from
ext4_free_blocks(), not messing with the latter on purpose.
Now that my changes have proven to work (?), the core freeing of
the blocks can be broken out to a helper function.

>
> It probably makes sense to try and get some consolidated helper
> function that includes nearly all of the code in ext4_free_blocks bet=
ween
> "do_more:" and "error_return:" (all of the work of verifying the bloc=
ks
> to be freed, updating the block bitmap and the buddy bitmap, updates =
the
> group descriptors and superblock, and marks the blocks dirty in the
> journal), but not the code that checks the writeback mode, updates qu=
ota,
> or any of that (since this isn't really using an inode).
>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> fs/ext4/ext4.h =A0 =A0| =A0 =A02 +-
>> fs/ext4/mballoc.c | =A0 19 +++++++++++++------
>> fs/ext4/resize.c =A0| =A0 10 +++++++---
>> 3 files changed, 21 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index bbe81db..da7ab48 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1799,7 +1799,7 @@ extern void ext4_free_blocks(handle_t *handle,=
 struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long=
 count, int flags);
>> extern int ext4_mb_add_groupinfo(struct super_block *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_group_t i, struct ext4_group_desc *=
desc);
>> -extern void ext4_group_add_blocks(handle_t *handle, struct super_bl=
ock *sb,
>> +extern int ext4_group_add_blocks(handle_t *handle, struct super_blo=
ck *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsb=
lk_t block, unsigned long count);
>> extern int ext4_trim_fs(struct super_block *, struct fstrim_range *)=
;
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index ea80c0b..33c41e6 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -4664,7 +4664,7 @@ error_return:
>> =A0*
>> =A0* This marks the blocks as free in the bitmap and buddy.
>> =A0*/
>> -void ext4_group_add_blocks(handle_t *handle, struct super_block *sb=
,
>> +int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_fsblk_t block, u=
nsigned long count)
>> {
>> =A0 =A0 =A0 struct buffer_head *bitmap_bh =3D NULL;
>> @@ -4685,15 +4685,21 @@ void ext4_group_add_blocks(handle_t *handle,=
 struct super_block *sb,
>> =A0 =A0 =A0 =A0* Check to see if we are freeing blocks across a grou=
p
>> =A0 =A0 =A0 =A0* boundary.
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 if (bit + count > EXT4_BLOCKS_PER_GROUP(sb))
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto error_return;
>> + =A0 =A0 if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_warning(sb, "too much blocks added to=
 group %u\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block_group);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 bitmap_bh =3D ext4_read_block_bitmap(sb, block_group);
>> =A0 =A0 =A0 if (!bitmap_bh)
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto error_return;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> +
>> =A0 =A0 =A0 desc =3D ext4_get_group_desc(sb, block_group, &gd_bh);
>> - =A0 =A0 if (!desc)
>> + =A0 =A0 if (!desc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EIO;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_return;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 if (in_range(ext4_block_bitmap(sb, desc), block, count) =
||
>> =A0 =A0 =A0 =A0 =A0 in_range(ext4_inode_bitmap(sb, desc), block, cou=
nt) ||
>> @@ -4703,6 +4709,7 @@ void ext4_group_add_blocks(handle_t *handle, s=
truct super_block *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_error(sb, "Adding blocks in system =
zones - "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Block =3D %llu, =
count =3D %lu",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block, count);
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EINVAL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_return;
>> =A0 =A0 =A0 }
>>
>> @@ -4771,7 +4778,7 @@ void ext4_group_add_blocks(handle_t *handle, s=
truct super_block *sb,
>> error_return:
>> =A0 =A0 =A0 brelse(bitmap_bh);
>> =A0 =A0 =A0 ext4_std_error(sb, err);
>> - =A0 =A0 return;
>> + =A0 =A0 return err;
>> }
>>
>> /**
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index 374fd1c..2e63376 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -990,7 +990,7 @@ int ext4_group_extend(struct super_block *sb, st=
ruct ext4_super_block *es,
>> =A0 =A0 =A0 ext4_grpblk_t add;
>> =A0 =A0 =A0 struct buffer_head *bh;
>> =A0 =A0 =A0 handle_t *handle;
>> - =A0 =A0 int err;
>> + =A0 =A0 int err, err2;
>> =A0 =A0 =A0 ext4_group_t group;
>>
>> =A0 =A0 =A0 o_blocks_count =3D ext4_blocks_count(es);
>> @@ -1066,11 +1066,15 @@ int ext4_group_extend(struct super_block *sb=
, struct ext4_super_block *es,
>> =A0 =A0 =A0 ext4_debug("freeing blocks %llu through %llu\n", o_block=
s_count,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0o_blocks_count + add);
>> =A0 =A0 =A0 /* We add the blocks to the bitmap and set the group nee=
d init bit */
>> - =A0 =A0 ext4_group_add_blocks(handle, sb, o_blocks_count, add);
>> + =A0 =A0 err =3D ext4_group_add_blocks(handle, sb, o_blocks_count, =
add);
>> =A0 =A0 =A0 ext4_handle_dirty_super(handle, sb);
>> =A0 =A0 =A0 ext4_debug("freed blocks %llu through %llu\n", o_blocks_=
count,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0o_blocks_count + add);
>> - =A0 =A0 if ((err =3D ext4_journal_stop(handle)))
>> + =A0 =A0 err2 =3D ext4_journal_stop(handle);
>> + =A0 =A0 if (!err && err2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D err2;
>> +
>> + =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_put;
>>
>> =A0 =A0 =A0 if (test_opt(sb, DEBUG))
>> --
>> 1.7.5.1
>>
>
>
> Cheers, Andreas
>
>
>
>
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
