From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [BUG] copy file result with zero
Date: Sun, 2 Oct 2011 16:43:19 +0800
Message-ID: <CABqxG0eMarBn_8xHCOZPq3pae4K01C51Rmxdox7uZr0gWOHGGw@mail.gmail.com>
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com>
	<20111001143900.GH28234@thunk.org>
	<CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com>
	<A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com>
	<CA140AD1-B715-46BF-81B3-EA2069CBC131@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff liu <jeff.liu@oracle.com>, "Ted Ts'o" <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59334 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1JBInU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 04:43:20 -0400
In-Reply-To: <CA140AD1-B715-46BF-81B3-EA2069CBC131@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 2, 2011 at 4:02 PM, Andreas Dilger <aedilger@gmail.com> wro=
te:
> On 2011-10-01, at 11:41 PM, Jeff liu wrote:
>>> On Sat, Oct 1, 2011 at 10:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
>>>> On Sat, Oct 01, 2011 at 10:01:35PM +0800, Dave Young wrote:
>>>>> Weird problem, when I build app from source,
>>>>> make; make install
>>>>> run the command, but got "cannot execute binary file"
>>>>>
>>>>> hexdump shows the installed binary is full of zero
>>>>>
>>>>> Is it related to ext4 fiemap problem described below?
>>>>> http://lwn.net/Articles/429349/
>>>>
>>>> There is general agreement that /bin/cp should not have been relyi=
ng
>>>> on FIEMAP, and I believe the more recent versions of /bin/cp have
>>>> removed that code by default pending implementation of
>>>> SEEK_HOLE/SEEK_DATA. =C2=A0That being said, ext4 had a workaround =
to its
>>>> FIEMAP implementation that landed in 2.6.39, and you're using
>>>> 3.1.0-rc6.
>>
>> Actually, upstream cp(1) using FIEMAP only if the source file is spa=
rse, =C2=A0or else, it will do normal copy, i.e, block based.
>
> Are there any distros that are shipping with a version of cp that dep=
ends on FIEMAP? =C2=A0That would dramatically increase the severity of =
this problem, since orders of magnitude more users will hit the problem=
=2E

I'm not sure if it depends on FIEMAP, I think it should be not so old.

>
> Dave, what distro were you seeing this problem on, and had you instal=
led/upgraded your coreutils and/or kernel yourself?

Slackware 13.37, coreutils 8.11
kernel is always built from linus's git by myself

>
>>> Do you means It should work in 3.1.0-rc6 even with cp which depends=
 fiemap?
>>>
>>>>
>>>>> I finally managed to find the way to reproduce this:
>>>>> just cp a elf binary A =C2=A0to file B, then cp B to file C, =C2=A0=
then you will get:
>>>>> A =3D=3D B !=3D C
>>>>>
>>>>> ie.
>>>>> cp /bin/ls ls1
>>>>> cp ls1 ls2
>>>>>
>>>>> ls2 will be filled with zero
>>>>
>>>> If you add a "sync" between the two copies, does that work around =
the
>>>> problem? =C2=A0I bet it will...
>>>
>>> Yes, it works
>>>
>>>>
>>>> My suggestion is to upgrade to a newer version of coreutils that
>>>> doesn't try to use FIEMAP.
>>>
>>> Thanks, will try
>>>
>>>>
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - Te=
d
>>>>
>>>
>>>
>>>
>>> --
>>> Regards
>>> Dave
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
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
Regards
Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
