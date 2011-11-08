From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH V3 01/15] ext4: add a function which extends a group
 without checking parameters
Date: Tue, 8 Nov 2011 16:37:02 +0800
Message-ID: <CAGBYx2ZTvyJbPyeEPx9fpHUS_O4xSL+QzewEfAyD5XHet0AaBg@mail.gmail.com>
References: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
	<1320707608-14246-2-git-send-email-xiaoqiangnk@gmail.com>
	<E849D75B-FA54-4426-9B01-9672931221B1@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51812 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1KHIhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Nov 2011 03:37:03 -0500
Received: by qao25 with SMTP id 25so128023qao.19
        for <linux-ext4@vger.kernel.org>; Tue, 08 Nov 2011 00:37:03 -0800 (PST)
In-Reply-To: <E849D75B-FA54-4426-9B01-9672931221B1@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 8, 2011 at 3:12 PM, Andreas Dilger <adilger@dilger.ca> wrot=
e:
> On 2011-11-07, at 4:13 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wro=
te:
>> This patch added a function named __ext4_group_extend() whose code
>> is copied from ext4_group_extend(). =A0__ext4_group_extend() assumes
>> the parameter is valid and has been checked by caller.
>
> To be honest, I don't like the use of underscores to rename such func=
tions, since they convey no meaning to the reader, or perhaps only "the=
se functions are similar but not the same, in some unspecified way".
>
> I'd much prefer something like ext4_group_extend_nocheck() or similar=
 that indicates how it is different from ext4_group_extend().
>
>> __ext4_group_extend() will be used by new resize implementation. It
>> can also be used by ext4_group_extend(), but this patch series does
>> not do this.
>
> If this is intended to replace the old resize functionality, it makes=
 sense to remove the code duplication as part of this series, or in fac=
t as part of this patch.
Sorry, I forgot to remove the old commit log.  The duplicated code is
removed in last 2 patches(14th and 15th).

Yongqiang.
>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> ---
>> fs/ext4/resize.c | =A0 53 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++++
>> 1 files changed, 53 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index 996780a..ff77512 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -969,6 +969,59 @@ exit_put:
>> } /* ext4_group_add */
>>
>> /*
>> + * extend a group without checking assuming that checking has been =
done.
>> + */
>> +static int __ext4_group_extend(struct super_block *sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t o_blocks_count, e=
xt4_grpblk_t add)
>> +{
>> + =A0 =A0struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
>> + =A0 =A0handle_t *handle;
>> + =A0 =A0int err =3D 0, err2;
>> +
>> + =A0 =A0/* We will update the superblock, one block bitmap, and
>> + =A0 =A0 * one group descriptor via ext4_group_add_blocks().
>> + =A0 =A0 */
>> + =A0 =A0handle =3D ext4_journal_start_sb(sb, 3);
>> + =A0 =A0if (IS_ERR(handle)) {
>> + =A0 =A0 =A0 =A0err =3D PTR_ERR(handle);
>> + =A0 =A0 =A0 =A0ext4_warning(sb, "error %d on journal start", err);
>> + =A0 =A0 =A0 =A0goto out;
>> + =A0 =A0}
>> +
>> + =A0 =A0err =3D ext4_journal_get_write_access(handle, EXT4_SB(sb)->=
s_sbh);
>> + =A0 =A0if (err) {
>> + =A0 =A0 =A0 =A0ext4_warning(sb, "error %d on journal write access"=
, err);
>> + =A0 =A0 =A0 =A0ext4_journal_stop(handle);
>> + =A0 =A0 =A0 =A0goto out;
>> + =A0 =A0}
>> +
>> + =A0 =A0ext4_blocks_count_set(es, o_blocks_count + add);
>> + =A0 =A0ext4_debug("freeing blocks %llu through %llu\n", o_blocks_c=
ount,
>> + =A0 =A0 =A0 =A0 =A0 o_blocks_count + add);
>> + =A0 =A0/* We add the blocks to the bitmap and set the group need i=
nit bit */
>> + =A0 =A0err =3D ext4_group_add_blocks(handle, sb, o_blocks_count, a=
dd);
>> + =A0 =A0if (err)
>> + =A0 =A0 =A0 =A0goto exit_journal;
>> + =A0 =A0ext4_handle_dirty_super(handle, sb);
>> + =A0 =A0ext4_debug("freed blocks %llu through %llu\n", o_blocks_cou=
nt,
>> + =A0 =A0 =A0 =A0 =A0 o_blocks_count + add);
>> +exit_journal:
>> + =A0 =A0err2 =3D ext4_journal_stop(handle);
>> + =A0 =A0if (err2 && !err)
>> + =A0 =A0 =A0 =A0err =3D err2;
>> +
>> + =A0 =A0if (!err) {
>> + =A0 =A0 =A0 =A0if (test_opt(sb, DEBUG))
>> + =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_DEBUG "EXT4-fs: extended group =
to %llu "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "blocks\n", ext4_blocks_count(=
es));
>> + =A0 =A0 =A0 =A0update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr, (=
char *)es,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ext4_super_block=
));
>> + =A0 =A0}
>> +out:
>> + =A0 =A0return err;
>> +}
>> +
>> +/*
>> =A0* Extend the filesystem to the new number of blocks specified. =A0=
This entry
>> =A0* point is only used to extend the current filesystem to the end =
of the last
>> =A0* existing group. =A0It can be accessed via ioctl, or by "remount=
,resize=3D<size>"
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
