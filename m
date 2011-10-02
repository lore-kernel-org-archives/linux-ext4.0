From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [BUG] copy file result with zero
Date: Sun, 2 Oct 2011 16:46:29 +0800
Message-ID: <CABqxG0dP5JX+AD2pw=Oq2s+2qzb9LVWxYj0QRc6CxhoK9xQ8FQ@mail.gmail.com>
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com>
	<20111001143900.GH28234@thunk.org>
	<CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com>
	<A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com>
	<89E75765-AC24-4EF4-9547-6EE7A1A38B5A@dilger.ca>
	<FF2CAA91-5467-497A-AEEF-891785739193@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <aedilger@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Jeff liu <jeff.liu@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35089 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1JBIqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 04:46:30 -0400
In-Reply-To: <FF2CAA91-5467-497A-AEEF-891785739193@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/10/2 Jeff liu <jeff.liu@oracle.com>:
>
> =E5=9C=A8 2011-10-2=EF=BC=8C=E4=B8=8B=E5=8D=883:59=EF=BC=8C Andreas D=
ilger =E5=86=99=E9=81=93=EF=BC=9A
>
>> On 2011-10-01, at 11:41 PM, Jeff liu wrote:
>>>> On Sat, Oct 1, 2011 at 10:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
>>>>> On Sat, Oct 01, 2011 at 10:01:35PM +0800, Dave Young wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Weird problem, when I build app from source,
>>>>>> make; make install
>>>>>> run the command, but got "cannot execute binary file"
>>>>>>
>>>>>> hexdump shows the installed binary is full of zero
>>>>>>
>>>>>> Is it related to ext4 fiemap problem described below?
>>>>>> http://lwn.net/Articles/429349/
>>>>>
>>>>> There is general agreement that /bin/cp should not have been rely=
ing
>>>>> on FIEMAP, and I believe the more recent versions of /bin/cp have
>>>>> removed that code by default pending implementation of
>>>>> SEEK_HOLE/SEEK_DATA. =C2=A0That being said, ext4 had a workaround=
 to its
>>>>> FIEMAP implementation that landed in 2.6.39, and you're using
>>>>> 3.1.0-rc6.
>>>
>>> Actually, upstream cp(1) using FIEMAP only if the source file is sp=
arse, =C2=A0or else, it will do normal copy, i.e, block based.
>>
>> My understanding is that cp uses the blocks count to determine wheth=
er the file is sparse or not.
> Yes, it based on blocks count to determine that.
>
>> In the case of delayed allocation (where blocks are not yet allocate=
d, if they are not reflected in the i_blocks count) it might mistakenly=
 think that the file is sparse.

I think this might be my case

> Thanks for pointing this out, I missed this case.
> So for Dave's issue, even if he updated to the upstream Coreutils, th=
is issue will still exists occasionally for delayed allocation, if not =
=C2=A0run sync in between times.

Not occasionally, I can easily reproduce it recently.

>
>>
>> Given the danger of this bug, it is important to ensure ext4 returns=
 DELALLOC extents for pages in the page cache. =C2=A0I think Yongqiang =
Yang just submitted a patch series to do this for ext4, so it would be =
important to verify it fixes this problem.
>
>
> Thanks,
> -Jeff
>>
>>>> Do you means It should work in 3.1.0-rc6 even with cp which depend=
s fiemap?
>>>>
>>>>>
>>>>>> I finally managed to find the way to reproduce this:
>>>>>> just cp a elf binary A =C2=A0to file B, then cp B to file C, =C2=
=A0then you will get:
>>>>>> A =3D=3D B !=3D C
>>>>>>
>>>>>> ie.
>>>>>> cp /bin/ls ls1
>>>>>> cp ls1 ls2
>>>>>>
>>>>>> ls2 will be filled with zero
>>>>>
>>>>> If you add a "sync" between the two copies, does that work around=
 the
>>>>> problem? =C2=A0I bet it will...
>>>>
>>>> Yes, it works
>>>>
>>>>>
>>>>> My suggestion is to upgrade to a newer version of coreutils that
>>>>> doesn't try to use FIEMAP.
>>>>
>>>> Thanks, will try
>>>>
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- Ted
>>>>>
>>>>
>>>>
>>>>
>>>> --
>>>> Regards
>>>> Dave
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>
>>
>> Cheers, Andreas
>>
>>
>>
>>
>>
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
