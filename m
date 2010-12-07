From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Tue, 7 Dec 2010 14:25:47 -0600
Message-ID: <AANLkTin79GzUbfuZNKyTtqcyoUSO9AJimO77_ZOvqggH@mail.gmail.com>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
 <20101207182243.GB21112@redhat.com> <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com>
 <1291747731-sup-3099@think> <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com>
 <1291751698-sup-9297@think>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291751698-sup-9297@think>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 7, 2010 at 2:02 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Excerpts from Jon Nelson's message of 2010-12-07 14:34:40 -0500:
>> On Tue, Dec 7, 2010 at 12:52 PM, Chris Mason <chris.mason@oracle.com=
> wrote:
>> >> postgresql errors. Typically, header corruption but from the limi=
ted
>> >> visibility I've had into this via strace, what I see is zeroed pa=
ges
>> >> where there shouldn't be.
>> >
>> > This sounds a lot like a bug higher up than dm-crypt. =C2=A0Zeros =
tend to
>> > come from some piece of code explicitly filling a page with zeros,=
 and
>> > that often happens in the corner cases for O_DIRECT and a few othe=
r
>> > places in the filesystem.
>> >
>> > Have you tried triggering this with a regular block device?
>>
>> I just tried the whole set of tests, but with /dev/sdb directly (as
>> ext4) without any crypt-y bits.
>> It takes more iterations but out of 6 tests I had one failure: same
>> type of thing, 'invalid page header in block ....'.
>>
>> I can't guarantee that it is a full-page of zeroes, just what I saw
>> from the (limited) stracing I did.
>
> Fantastic. Now for our usual suspects:
>
> 1) Is postgres using O_DIRECT? =C2=A0If yes, please turn it off

According to strace, O_DIRECT didn't show up once during the test.

> 2) Is postgres allocating sparse files? =C2=A0If yes, please have it =
fully
> allocate the file instead.

That's a tough one. I don't think postgresql does that, but I'm not an
expert here.

> 3) Is postgres using preallocation (fallocate)? =C2=A0If yes, please =
have it
> fully allocate the file instead

As far as strace is concerned, postgreql is not using fallocate in
this version.

--=20
Jon
