From: Jeff liu <jeff.liu@oracle.com>
Subject: Re: [BUG] copy file result with zero
Date: Sun, 2 Oct 2011 15:14:58 +0800
Message-ID: <FF2CAA91-5467-497A-AEEF-891785739193@oracle.com>
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com> <20111001143900.GH28234@thunk.org> <CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com> <A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com> <89E75765-AC24-4EF4-9547-6EE7A1A38B5A@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Dave Young <hidave.darkstar@gmail.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44405 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1JBHPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 03:15:30 -0400
In-Reply-To: <89E75765-AC24-4EF4-9547-6EE7A1A38B5A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=D4=DA 2011-10-2=A3=AC=CF=C2=CE=E73:59=A3=AC Andreas Dilger =D0=B4=B5=C0=
=A3=BA

> On 2011-10-01, at 11:41 PM, Jeff liu wrote:
>>> On Sat, Oct 1, 2011 at 10:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
>>>> On Sat, Oct 01, 2011 at 10:01:35PM +0800, Dave Young wrote:
>>>>> Hi,
>>>>>=20
>>>>> Weird problem, when I build app from source,
>>>>> make; make install
>>>>> run the command, but got "cannot execute binary file"
>>>>>=20
>>>>> hexdump shows the installed binary is full of zero
>>>>>=20
>>>>> Is it related to ext4 fiemap problem described below?
>>>>> http://lwn.net/Articles/429349/
>>>>=20
>>>> There is general agreement that /bin/cp should not have been relyi=
ng
>>>> on FIEMAP, and I believe the more recent versions of /bin/cp have
>>>> removed that code by default pending implementation of
>>>> SEEK_HOLE/SEEK_DATA.  That being said, ext4 had a workaround to it=
s
>>>> FIEMAP implementation that landed in 2.6.39, and you're using
>>>> 3.1.0-rc6.
>>=20
>> Actually, upstream cp(1) using FIEMAP only if the source file is spa=
rse,  or else, it will do normal copy, i.e, block based.
>=20
> My understanding is that cp uses the blocks count to determine whethe=
r the file is sparse or not. =20
Yes, it based on blocks count to determine that.

> In the case of delayed allocation (where blocks are not yet allocated=
, if they are not reflected in the i_blocks count) it might mistakenly =
think that the file is sparse.
Thanks for pointing this out, I missed this case.
So for Dave's issue, even if he updated to the upstream Coreutils, this=
 issue will still exists occasionally for delayed allocation, if not  r=
un sync in between times.

>=20
> Given the danger of this bug, it is important to ensure ext4 returns =
DELALLOC extents for pages in the page cache.  I think Yongqiang Yang j=
ust submitted a patch series to do this for ext4, so it would be import=
ant to verify it fixes this problem.


Thanks,
-Jeff
>=20
>>> Do you means It should work in 3.1.0-rc6 even with cp which depends=
 fiemap?
>>>=20
>>>>=20
>>>>> I finally managed to find the way to reproduce this:
>>>>> just cp a elf binary A  to file B, then cp B to file C,  then you=
 will get:
>>>>> A =3D=3D B !=3D C
>>>>>=20
>>>>> ie.
>>>>> cp /bin/ls ls1
>>>>> cp ls1 ls2
>>>>>=20
>>>>> ls2 will be filled with zero
>>>>=20
>>>> If you add a "sync" between the two copies, does that work around =
the
>>>> problem?  I bet it will...
>>>=20
>>> Yes, it works
>>>=20
>>>>=20
>>>> My suggestion is to upgrade to a newer version of coreutils that
>>>> doesn't try to use FIEMAP.
>>>=20
>>> Thanks, will try
>>>=20
>>>>=20
>>>>                                      - Ted
>>>>=20
>>>=20
>>>=20
>>>=20
>>> --=20
>>> Regards
>>> Dave
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
> Cheers, Andreas
>=20
>=20
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
