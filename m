From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] ext4: add error handling when discarding is fail in
 FITRIM ioctl
Date: Thu, 9 Feb 2012 13:26:11 +0900
Message-ID: <CAKYAXd8UoTzDraz1UHaiooDGnVr-zGD5Cwer2v4=VAStKyrQQA@mail.gmail.com>
References: <1327132572-11841-1-git-send-email-linkinjeon@gmail.com>
	<20120124141332.GD18136@quack.suse.cz>
	<CAKYAXd_uskOwun-cieNhsr=SQae0Qm7sh9=UTh0ahSOsGamyUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60424 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab2BIE0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Feb 2012 23:26:13 -0500
In-Reply-To: <CAKYAXd_uskOwun-cieNhsr=SQae0Qm7sh9=UTh0ahSOsGamyUQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi. Ted.

Would you check this patch ? maybe, this patch was posted during your v=
acation.

Thanks.

2012/1/25 Namjae Jeon <linkinjeon@gmail.com>:
> 2012/1/24 Jan Kara <jack@suse.cz>:
>> On Sat 21-01-12 02:56:12, Namjae Jeon wrote:
>>> Although free extents is proper not trimmed(mmc driver return error=
 code while sending trim command), currently FITRIM ioctl return succes=
s.
>>> I tried to add exception routine to inform user error code.
>>>
>>> #> ./fitrim_test
>>> end_request: I/O error, dev mmcblk0, sector 27232
>>> EXT4-fs warning (device mmcblk0): ext4_trim_all_free:4857: Discard =
command returned error -5
>>> #>
>>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>>> ---
>>> =C2=A0fs/ext4/mballoc.c | =C2=A0 22 +++++++++++++++-------
>>> =C2=A01 files changed, 15 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>>> index cb990b2..09cc09a 100644
>>> --- a/fs/ext4/mballoc.c
>>> +++ b/fs/ext4/mballoc.c
>>> @@ -4901,10 +4901,11 @@ error_return:
>>> =C2=A0 * one will allocate those blocks, mark it as used in buddy b=
itmap. This must
>>> =C2=A0 * be called with under the group lock.
>>> =C2=A0 */
>>> -static void ext4_trim_extent(struct super_block *sb, int start, in=
t count,
>>> +static int ext4_trim_extent(struct super_block *sb, int start, int=
 count,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_group_t group, struct ext4_buddy *e4b)
>>> =C2=A0{
>>> =C2=A0 =C2=A0 =C2=A0 struct ext4_free_extent ex;
>>> + =C2=A0 =C2=A0 int err;
>>>
>>> =C2=A0 =C2=A0 =C2=A0 trace_ext4_trim_extent(sb, group, start, count=
);
>>>
>>> @@ -4920,9 +4921,10 @@ static void ext4_trim_extent(struct super_bl=
ock *sb, int start, int count,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>>> =C2=A0 =C2=A0 =C2=A0 mb_mark_used(e4b, &ex);
>>> =C2=A0 =C2=A0 =C2=A0 ext4_unlock_group(sb, group);
>>> - =C2=A0 =C2=A0 ext4_issue_discard(sb, group, start, count);
>>> + =C2=A0 =C2=A0 err =3D ext4_issue_discard(sb, group, start, count)=
;
>>> =C2=A0 =C2=A0 =C2=A0 ext4_lock_group(sb, group);
>>> =C2=A0 =C2=A0 =C2=A0 mb_free_blocks(NULL, e4b, start, ex.fe_len);
>>> + =C2=A0 =C2=A0 return err;
>>> =C2=A0}
>>>
>>> =C2=A0/**
>>> @@ -4978,15 +4980,21 @@ ext4_trim_all_free(struct super_block *sb, =
ext4_group_t group,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 next =3D mb_find_n=
ext_bit(bitmap, max, start);
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((next - start)=
 >=3D minblocks) {
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ext4_trim_extent(sb, start,
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0next =
- start, group, &e4b);
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 count +=3D next - start;
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ret =3D ext4_trim_extent(sb, start,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 next - start, group, &e4b);
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (ret < 0) {
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret !=3D -EOPNOTSUPP)
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_warnin=
g(sb, "Discard command "
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0"returned error %d\n", ret);
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 } else
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 count +=3D next - start;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_count +=3D ne=
xt - start;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 start =3D next + 1=
;
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (fatal_signal_p=
ending(current)) {
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 count =3D -ERESTARTSYS;
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ret =3D -ERESTARTSYS;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>>
>>> @@ -5009,7 +5017,7 @@ out:
>>> =C2=A0 =C2=A0 =C2=A0 ext4_debug("trimmed %d blocks in the group %d\=
n",
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 count, group);
>>>
>>> - =C2=A0 =C2=A0 return count;
>>> + =C2=A0 =C2=A0 return (ret < 0) ? ret : count;
>> =C2=A0I think you need to initialize ret to 0 at the beginning of th=
e function.
>> Otherwise you could use it uninitialized. Otherwise the patch looks =
good to
>> me and makes things consistent with ext3 so after fixing that bug yo=
u can add:
>> =C2=A0Reviewed-by: Jan Kara <jack@suse.cz>
> Hi. Jan.
> Thanks for your review.~
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza
>> --
>> Jan Kara <jack@suse.cz>
>> SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
