From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 01/13] ext4: add a function which extends a group without
 checking parameters
Date: Thu, 11 Aug 2011 14:27:41 +0800
Message-ID: <CAGBYx2b3fCkReC4hy-K7jO35oM3thUHO9ST8xEkhVtkZSAqzgQ@mail.gmail.com>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
	<1313033308-882-2-git-send-email-xiaoqiangnk@gmail.com>
	<4B3266BE-B083-41DE-BD85-BA1497D9EF51@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47476 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1HKG1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 02:27:42 -0400
Received: by pzk37 with SMTP id 37so3138322pzk.1
        for <linux-ext4@vger.kernel.org>; Wed, 10 Aug 2011 23:27:41 -0700 (PDT)
In-Reply-To: <4B3266BE-B083-41DE-BD85-BA1497D9EF51@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 11, 2011 at 1:47 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-08-10, at 9:28 PM, Yongqiang Yang wrote:
>> This patch added a function named __ext4_group_extend() whose code
>> is copied from ext4_group_extend(). =A0__ext4_group_extend() assumes
>> the parameter is valid and has been checked by caller.
>>
>> __ext4_group_extend() will be used by new resize implementation. It
>> can also be used by ext4_group_extend(), but this patch series does
>> not do this.
>
> Since this is duplicating a lot of code from ext4_group_extend(), thi=
s
> patch should be written in such a way that this new function is added=
,
> and the duplicate code is removed from ext4_group_extend() and calls
> the new function instead.
>
> It looks like all of these patches are adding a completely duplicate =
set
> of functions for doing the resizing, even though they are largely the
> same as the existing code, and it will mean duplicate efforts to main=
tain
> both copies of the code.
YES!  This needs some feedbacks, I thought the old resize interface
will be removed after the new resize interface goes into upstream.  So
I did not touch
old interface.  If we will remain the old interface, I can make some
patches which let old resize use common code instead.

Thank you for your review.
Yongqiang.
>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> fs/ext4/resize.c | =A0 53 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++++
>> 1 files changed, 53 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index 707d3f1..6ffbdb6 100644
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_fsblk_=
t o_blocks_count, ext4_grpblk_t add)
>> +{
>> + =A0 =A0 struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
>> + =A0 =A0 handle_t *handle;
>> + =A0 =A0 int err =3D 0, err2;
>> +
>> + =A0 =A0 /* We will update the superblock, one block bitmap, and
>> + =A0 =A0 =A0* one group descriptor via ext4_ext4_group_add_blocks()=
=2E
>
> Typo here: "ext4_ext4"
>
>> + =A0 =A0 =A0*/
>> + =A0 =A0 handle =3D ext4_journal_start_sb(sb, 3);
>> + =A0 =A0 if (IS_ERR(handle)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(handle);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_warning(sb, "error %d on journal star=
t", err);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 err =3D ext4_journal_get_write_access(handle, EXT4_SB(sb)-=
>s_sbh);
>> + =A0 =A0 if (err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_warning(sb, "error %d on journal writ=
e access", err);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_journal_stop(handle);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 ext4_blocks_count_set(es, o_blocks_count + add);
>> + =A0 =A0 ext4_debug("freeing blocks %llu through %llu\n", o_blocks_=
count,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0o_blocks_count + add);
>> + =A0 =A0 /* We add the blocks to the bitmap and set the group need =
init bit */
>> + =A0 =A0 err =3D ext4_group_add_blocks(handle, sb, o_blocks_count, =
add);
>> + =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
>> + =A0 =A0 ext4_handle_dirty_super(handle, sb);
>> + =A0 =A0 ext4_debug("freed blocks %llu through %llu\n", o_blocks_co=
unt,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0o_blocks_count + add);
>> +exit_journal:
>> + =A0 =A0 err2 =3D ext4_journal_stop(handle);
>> + =A0 =A0 if (err2 && !err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D err2;
>> +
>> + =A0 =A0 if (!err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (test_opt(sb, DEBUG))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBUG "EXT4-fs=
: extended group to %llu "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"blocks\n",=
 ext4_blocks_count(es));
>> + =A0 =A0 =A0 =A0 =A0 =A0 update_backups(sb, EXT4_SB(sb)->s_sbh->b_b=
locknr, (char *)es,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(stru=
ct ext4_super_block));
>> + =A0 =A0 }
>> +out:
>> + =A0 =A0 return err;
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
>
>
> Cheers, Andreas
>
>
>
>
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
