From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 03/12] ext4: prevent a fs without journal from being resized
Date: Mon, 18 Jul 2011 11:28:10 +0800
Message-ID: <CAGBYx2aVuYu1tDe-_=YWL4xZRpx8b+m3JO4ujdfDbGau+y8Pew@mail.gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
	<1310957555-15617-4-git-send-email-xiaoqiangnk@gmail.com>
	<4E23A5B0.6030700@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47528 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab1GRD2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 23:28:11 -0400
Received: by pvg12 with SMTP id 12so2638700pvg.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 20:28:10 -0700 (PDT)
In-Reply-To: <4E23A5B0.6030700@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 11:17 AM, Tao Ma <tm@tao.ma> wrote:
> On 07/18/2011 10:52 AM, Yongqiang Yang wrote:
>> This patch prevents a fs without journal from being resized, because
>> it is easy to detroy the fs.
> Why you want to do this? =A0You see any corruption?
> At least in our product system, no-journal mode is heavily used and w=
e
> really don't want to disable this feature.
I did not see any corruption.  If there is no journal in a fs, then if
an error happens during online resizing, the filesystem will be
destroyed easily, I thought.  Just my thought:-)  It needs much more
feedbacks.

Thanks,
Yongqiang.
>
> Thanks
> Tao
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/resize.c | =A0 10 ++++++++++
>> =A01 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index 53d9795..33ab40d 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -33,6 +33,16 @@ int ext4_resize_begin(struct super_block *sb)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EPERM;
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* We are not allowed to do online-resizing on a filesys=
tem without
>> + =A0 =A0 =A0* journal, otherwise, it is easy to destroy the filesys=
tem.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (!EXT4_SB(sb)->s_journal) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_warning(sb, "There is no journal for =
the filesystem, "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"so online resi=
zing is not allowed\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EPERM;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 if (test_and_set_bit_lock(EXT4_RESIZING, &EXT4_SB(sb)->s=
_resize_flags))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EBUSY;
>>
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
