From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [BUG] copy file result with zero
Date: Sun, 2 Oct 2011 07:37:32 +0800
Message-ID: <CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com>
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com>
	<20111001143900.GH28234@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Dave Young <hidave.darkstar@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34325 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1JAXhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Oct 2011 19:37:33 -0400
In-Reply-To: <20111001143900.GH28234@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 1, 2011 at 10:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sat, Oct 01, 2011 at 10:01:35PM +0800, Dave Young wrote:
>> Hi,
>>
>> Weird problem, when I build app from source,
>> make; make install
>> run the command, but got "cannot execute binary file"
>>
>> hexdump shows the installed binary is full of zero
>>
>> Is it related to ext4 fiemap problem described below?
>> http://lwn.net/Articles/429349/
>
> There is general agreement that /bin/cp should not have been relying
> on FIEMAP, and I believe the more recent versions of /bin/cp have
> removed that code by default pending implementation of
> SEEK_HOLE/SEEK_DATA. =C2=A0That being said, ext4 had a workaround to =
its
> FIEMAP implementation that landed in 2.6.39, and you're using
> 3.1.0-rc6.

Do you means It should work in 3.1.0-rc6 even with cp which depends fie=
map?

>
>> I finally managed to find the way to reproduce this:
>> just cp a elf binary A =C2=A0to file B, then cp B to file C, =C2=A0t=
hen you will get:
>> A =3D=3D B !=3D C
>>
>> ie.
>> cp /bin/ls ls1
>> cp ls1 ls2
>>
>> ls2 will be filled with zero
>
> If you add a "sync" between the two copies, does that work around the
> problem? =C2=A0I bet it will...

Yes, it works

>
> My suggestion is to upgrade to a newer version of coreutils that
> doesn't try to use FIEMAP.

Thanks, will try

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-=
 Ted
>



--=20
Regards
Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
