From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Tue, 7 Dec 2010 21:29:26 -0600
Message-ID: <AANLkTi=OC9Z68U-j8s6vfU-_-6tkg5W7aUz9HEupidX9@mail.gmail.com>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
 <20101207182243.GB21112@redhat.com> <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com>
 <1291747731-sup-3099@think> <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com>
 <1291751698-sup-9297@think> <AANLkTin79GzUbfuZNKyTtqcyoUSO9AJimO77_ZOvqggH@mail.gmail.com>
 <1291754340-sup-1631@think> <AANLkTim8uCmFK=LjkMmq_1O0KE3AiN_7g41AO0woxMv7@mail.gmail.com>
 <1291755258-sup-8760@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mike Snitzer <snitzer@redhat.com>, Matt <jackdachef@gmail.com>,
	Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f66.google.com ([209.85.214.66]:45952 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab0LHD3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 22:29:49 -0500
In-Reply-To: <1291755258-sup-8760@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 7, 2010 at 3:02 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Excerpts from Jon Nelson's message of 2010-12-07 15:48:58 -0500:
>> On Tue, Dec 7, 2010 at 2:41 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
>> > Excerpts from Jon Nelson's message of 2010-12-07 15:25:47 -0500:
>> >> On Tue, Dec 7, 2010 at 2:02 PM, Chris Mason <chris.mason@oracle.c=
om> wrote:
>> >> > Excerpts from Jon Nelson's message of 2010-12-07 14:34:40 -0500=
:
>> >> >> On Tue, Dec 7, 2010 at 12:52 PM, Chris Mason <chris.mason@orac=
le.com> wrote:
>> >> >> >> postgresql errors. Typically, header corruption but from th=
e limited
>> >> >> >> visibility I've had into this via strace, what I see is zer=
oed pages
>> >> >> >> where there shouldn't be.
>> >> >> >
>> >> >> > This sounds a lot like a bug higher up than dm-crypt. =C2=A0=
Zeros tend to
>> >> >> > come from some piece of code explicitly filling a page with =
zeros, and
>> >> >> > that often happens in the corner cases for O_DIRECT and a fe=
w other
>> >> >> > places in the filesystem.
>> >> >> >
>> >> >> > Have you tried triggering this with a regular block device?
>> >> >>
>> >> >> I just tried the whole set of tests, but with /dev/sdb directl=
y (as
>> >> >> ext4) without any crypt-y bits.
>> >> >> It takes more iterations but out of 6 tests I had one failure:=
 same
>> >> >> type of thing, 'invalid page header in block ....'.
>> >> >>
>> >> >> I can't guarantee that it is a full-page of zeroes, just what =
I saw
>> >> >> from the (limited) stracing I did.
>> >> >
>> >> > Fantastic. Now for our usual suspects:

Maybe not so fantastic. I kept testing and had no more failures. At
all. After 40+ iterations I gave up.
I went back to trying ext4 on a LUKS volume. The 'hit' ratio went to
something like 1 in 3, or better.

I will continue to do testing with and without LUKS. I did /not/
reboot between tests, but I do start with a fresh postgres database.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
