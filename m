From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] e4defrag : Open the source file for e4defrag in read
	write mode to avoid failures from EXT4_IOC_EXT_MOVE
Date: Tue, 19 Jan 2010 10:10:54 +0530
Message-ID: <ea11fea31001182040o855c362j1da8fcdc24c5dfe9@mail.gmail.com>
References: <ea11fea31001182021m66f82afei1750a9e92b53e047@mail.gmail.com>
	<4B55370B.4060801@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:39134 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0ASElP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2010 23:41:15 -0500
Received: by iwn35 with SMTP id 35so2603560iwn.4
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 20:41:14 -0800 (PST)
In-Reply-To: <4B55370B.4060801@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/1/19 Akira Fujita <a-fujita@rs.jp.nec.com>:
>
> Hi Manish,
>
> (2010/01/19 13:21), Manish Katiyar wrote:
>> Hi Akira,
>>
>> I am consistently getting -EBADF while trying out e4defrag and it
>> fails with below error.
>>
>> /home/mkatiyar/e2fs-git/e2fsprogs/misc> =A0./e4defrag -v /tmp/ohsm/m=
ntdir/f1
>> ext4 defragmentation for /tmp/ohsm/mntdir/f1
>> [1/1]/tmp/ohsm/mntdir/f1: =A0 =A0 =A0 0%
>> =A0 =A0 =A0 Failed to defrag:Bad file descriptor =A0 =A0[ NG ]
>> =A0 Success: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[0/1]
>>
>> Below patch fixes the issue for me, though I am not sure if this is
>> the right fix to open the source file in readwrite mode or fix the
>> ext4 ioctl part.
>>
>
> Patch looks good to me.
> # I send same patch to Ted last month, but it is not on linux-ext4, s=
orry.
>
> By commit 4a58579b9e4e2a35d57e6c9c8483e52f6f1b7fd6 of Linus' kernel t=
ree,
> rw mode check was added to EXT4_IOC_MOVE_EXTENT.
> But command patch which corresponds to this change
> has not been merged into e2fsprogs.
> So this change is needed to run e4defrag command on current Linux ker=
nel.

Ohh okie... Thanks a lot for the prompt response :-)

Thanks -
Manish

>
> Regards,
> Akira Fujita
>
>
>> Open the source file in read write mode to avoid failures from EXT4_=
IOC_EXT_MOVE
>>
>> Signed-off-by: Manish Katiyar<mkatiyar@gmail.com>
>> ---
>> =A0 misc/e4defrag.c | =A0 =A02 +-
>> =A0 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
>> index 82e3868..424e0ca 100644
>> --- a/misc/e4defrag.c
>> +++ b/misc/e4defrag.c
>> @@ -1605,7 +1605,7 @@ static int file_defrag(const char *file, const
>> struct stat64 *buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 fd =3D open64(file, O_RDONLY);
>> + =A0 =A0 fd =3D open64(file, O_RDWR);
>> =A0 =A0 =A0 if (fd< =A00) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mode_flag& =A0DETAIL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PRINT_FILE_NAME(file);
>
>
>



--=20
Thanks -
Manish
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[$\*.^ -- I miss being one of them
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
