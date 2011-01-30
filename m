From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] ext4: Fix missing iput for root inode in case of all
 failed mount paths.
Date: Sat, 29 Jan 2011 21:40:34 -0800
Message-ID: <AANLkTim0XZe2=3AWw4Ydb8F7BQGCf+=FyjKoyadc+3yw@mail.gmail.com>
References: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com>
 <032DF412-6B37-4EB7-A687-8216CB1E2BAB@dilger.ca> <AANLkTiku46htAypEN7QNN=UZuRETKGnHJQ8cxt3kYPJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>,
	mkatiyar@gmail.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38095 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1A3Fky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 00:40:54 -0500
Received: by mail-qw0-f46.google.com with SMTP id 26so4504907qwa.19
        for <linux-ext4@vger.kernel.org>; Sat, 29 Jan 2011 21:40:54 -0800 (PST)
In-Reply-To: <AANLkTiku46htAypEN7QNN=UZuRETKGnHJQ8cxt3kYPJg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 16, 2011 at 10:05 AM, Manish Katiyar <mkatiyar@gmail.com> w=
rote:
> On Sun, Jan 16, 2011 at 8:20 AM, Andreas Dilger <adilger@dilger.ca> w=
rote:
>> Why not just put the iput() at failed_mount4() instead of spread aro=
und the code?
>
> Thanks Andreas, Here is the updated patch.
>
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
> =A0fs/ext4/super.c | =A0 =A05 +++--
> =A01 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cb10a06..8fa53e9 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3522,17 +3522,16 @@ no_journal:
> =A0 =A0 =A0 =A0if (IS_ERR(root)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR, "get root inode=
 failed");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D PTR_ERR(root);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 root =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root=
->i_size) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(root);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR, "corrupt root i=
node, run e2fsck");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0sb->s_root =3D d_alloc_root(root);
> =A0 =A0 =A0 =A0if (!sb->s_root) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR, "get root dentr=
y failed");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(root);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
> =A0 =A0 =A0 =A0}
> @@ -3648,6 +3647,8 @@ cantfind_ext4:
> =A0 =A0 =A0 =A0goto failed_mount;
>
> =A0failed_mount4:
> + =A0 =A0 =A0 iput(root);
> + =A0 =A0 =A0 sb->s_root =3D NULL;
> =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR, "mount failed");
> =A0 =A0 =A0 =A0destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
> =A0failed_mount_wq:
> --
> 1.7.1
>
>
>
>>
>> Cheers, Andreas
>>
>> On 2011-01-16, at 0:30, Manish Katiyar <mkatiyar@gmail.com> wrote:
>>
>>> Fix missing iput for root inode in case of all failed mount paths.
>>> Fixes bug#26752
>>>
>>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>>>
>>> ---
>>> fs/ext4/super.c | =A0 =A08 +++++++-
>>> 1 files changed, 7 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>>> index cb10a06..9570fcc 100644
>>> --- a/fs/ext4/super.c
>>> +++ b/fs/ext4/super.c
>>> @@ -3587,6 +3587,7 @@ no_journal:
>>> =A0 =A0 =A0 =A0if (err) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR, "failed to in=
itialize system "
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "zone (%d)", err);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(root);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
>>> =A0 =A0 =A0 =A0}
>>>
>>> @@ -3595,12 +3596,15 @@ no_journal:
>>> =A0 =A0 =A0 =A0if (err) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR, "failed to in=
itialize mballoc (%d)",
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(root);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
>>> =A0 =A0 =A0 =A0}
>>>
>>> =A0 =A0 =A0 =A0err =3D ext4_register_li_request(sb, first_not_zeroe=
d);
>>> - =A0 =A0 =A0 if (err)
>>> + =A0 =A0 =A0 if (err) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(root);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
>>> + =A0 =A0 =A0 }
>>>
>>> =A0 =A0 =A0 =A0sbi->s_kobj.kset =3D ext4_kset;
>>> =A0 =A0 =A0 =A0init_completion(&sbi->s_kobj_unregister);
>>> @@ -3609,6 +3613,7 @@ no_journal:
>>> =A0 =A0 =A0 =A0if (err) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_mb_release(sb);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_release(sb);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(root);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
>>> =A0 =A0 =A0 =A0};
>>>
>>> @@ -3648,6 +3653,7 @@ cantfind_ext4:
>>> =A0 =A0 =A0 =A0goto failed_mount;
>>>
>>> failed_mount4:
>>> + =A0 =A0 =A0 sb->s_root =3D NULL;
>>> =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR, "mount failed");
>>> =A0 =A0 =A0 =A0destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
>>> failed_mount_wq:

Hi Ted,

Any feedback on this ?

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
