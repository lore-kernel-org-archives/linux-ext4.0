From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sun, 12 Dec 2010 07:11:28 -0600
Message-ID: <AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=@mail.gmail.com>
References: <1291945065-sup-1838@think> <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
 <20101210023852.GB3059@thunk.org> <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
 <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
 <20101212023415.GG3059@thunk.org> <AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
 <AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com> <20101212124354.GA4513@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>,
	Matt <jackdachef@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mike Snitzer <snitz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:51226 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0LLNLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Dec 2010 08:11:50 -0500
In-Reply-To: <20101212124354.GA4513@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 12, 2010 at 6:43 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Dec 12, 2010 at 04:18:29AM -0600, Jon Nelson wrote:
>> > I have one CPU configured in the environment, 512MB of memory.
>> > I have not done any memory-constriction tests whatsoever.
>
> I've finally been able to reproduce it myself, on real hardware. =C2=A0=
SMP
> is not necessary to reproduce it, although having more than one CPU
> doesn't hurt. =C2=A0What I did need to do (on real hardware with 4 gi=
gs of
> memory) was to turn off swap and pin enough memory so that free memor=
y
> was around 200megs or so before the start of the test. =C2=A0(This is=
 the
> natural amount of free memory that the system would try to reach,
> since 200 megs is about 5% of 4 gigs.)
>
> Then, during the test, free memory would drop to 50-70 megabytes,
> forcing writeback to run, and then I could trigger it about 1-2 times
> out of three.
>
> I'm guessing that when you used 512mb of memory, that was in effect a
> memory-constriction test, and if you were to push the memory down a
> little further, it might reproduce even more quickly. =C2=A0My next s=
tep is
> to try to reproduce this in a VM, and then I can start probing to see
> what might be going on.

I'm glad you've been able to reproduce the problem! If you should need
any further assistance, please do not hesitate to ask.


--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
