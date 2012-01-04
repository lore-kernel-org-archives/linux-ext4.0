From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] mke2fs: correct help text for option -G of mke2fs
Date: Wed, 4 Jan 2012 15:47:31 +0800
Message-ID: <CAGBYx2Yc+NnEMw1rNAbH-GNq6xZ+ZJ8Z7iYBqoWc+7Cas6eD4g@mail.gmail.com>
References: <1325647785-8672-1-git-send-email-xiaoqiangnk@gmail.com>
	<65F5DCD8-3B25-4F40-8966-2C23700E0CDA@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36816 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837Ab2ADHrb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 02:47:31 -0500
Received: by obcwo16 with SMTP id wo16so13366609obc.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jan 2012 23:47:31 -0800 (PST)
In-Reply-To: <65F5DCD8-3B25-4F40-8966-2C23700E0CDA@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 4, 2012 at 3:22 PM, Andreas Dilger <aedilger@gmail.com> wro=
te:
> Probably "flex_group_size" or "flex_group_factor" is as clear and a l=
ot shorter.
I will resend a patch using flex_group_factor.

Thanks,
Yongqiang.
>
> Cheers, Andreas
>
> On 2012-01-03, at 20:29, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote=
:
>
>> The option '-G' is used to pass number of groups in a flex_bg, the
>> previous help text - 'meta-group-size' - could confuse users with
>> meta_bg.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> misc/mke2fs.c | =A0 =A02 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>> index 0ef2531..52746fe 100644
>> --- a/misc/mke2fs.c
>> +++ b/misc/mke2fs.c
>> @@ -116,7 +116,7 @@ static void usage(void)
>> =A0 =A0fprintf(stderr, _("Usage: %s [-c|-l filename] [-b block-size]=
 "
>> =A0 =A0"[-C cluster-size]\n\t[-i bytes-per-inode] [-I inode-size] "
>> =A0 =A0"[-J journal-options]\n"
>> - =A0 =A0"\t[-G meta group size] [-N number-of-inodes]\n"
>> + =A0 =A0"\t[-G number-of-groups-per-flex_bg] [-N number-of-inodes]\=
n"
>> =A0 =A0"\t[-m reserved-blocks-percentage] [-o creator-os]\n"
>> =A0 =A0"\t[-g blocks-per-group] [-L volume-label] "
>> =A0 =A0"[-M last-mounted-directory]\n\t[-O feature[,...]] "
>> --
>> 1.7.5.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
