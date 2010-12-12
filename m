From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sun, 12 Dec 2010 04:18:29 -0600
Message-ID: <AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF__37284.8642444753$1292149166$gmane$org@mail.gmail.com>
References: <20101209201359.GG2921@thunk.org> <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
 <20101209231616.GA12515@basil.fritz.box> <1291945065-sup-1838@think>
 <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
 <20101210023852.GB3059@thunk.org> <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
 <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
 <20101212023415.GG3059@thunk.org> <AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>,
	Matt <jackdachef@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mike Snitzer <snitz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:42072 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0LLKSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Dec 2010 05:18:51 -0500
In-Reply-To: <AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 11, 2010 at 9:16 PM, Jon Nelson <jnelson@jamponi.net> wrote=
:
> On Sat, Dec 11, 2010 at 7:40 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> Yes, indeed. =C2=A0Is this in the virtualized environment or on real
>> hardware at this point? =C2=A0And how many CPU's do you have configu=
red in
>> your virtualized environment, and how memory memory? =C2=A0Is having=
 a
>> certain number of CPU's critical for reproducing the problem? =C2=A0=
Is
>> constricting the amount of memory important?
>
> Originally, I observed the behavior on really real hardware.
>
> Since then, I have been able to reproduce it in VirtualBox and
> qemu-kvm, with openSUSE 11.3 and KUbuntu. All of the more recent test=
s
> have been with qemu-kvm.
>
> I have one CPU configured in the environment, 512MB of memory.
> I have not done any memory-constriction tests whatsoever.
>
>> It'll be a lot easier if I can reproduce it locally, which is why I'=
m
>> asking all of these questions.
>
> On Sat, Dec 11, 2010 at 8:34 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> One experiment --- can you try this with the file system mounted wit=
h
>> data=3Dwriteback, and see if the problem reproduces in that journall=
ing
>> mode?
>
> That test is running now, first with encryption. I will report if it
> shows problems. If it does, I will wait until I have been able to see
> that a few times, and move to a no-encryption test. Typically, I have
> to run quite a few more iterations of that test before problems show
> up (if they will at all).
>
>> I want to rule out (if possible) journal_submit_inode_data_buffers()
>> racing with mpage_da_submit_io(). =C2=A0I don't think that's the iss=
ue, but
>> I'd prefer to do the experiment to make sure. =C2=A0So if you can us=
e a
>> kernel and system configuration which triggers the problem, and then
>> try changing the mount options to include data=3Dwriteback, and then
>> rerun the test, and let me know if the problem still reproduces, I'd
>> be really grateful.

Using 2.6.37-rc5 and data=3Dwriteback,noatime and LUKS encryption I hit
the problem 71 times out of 173.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
