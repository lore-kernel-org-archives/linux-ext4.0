From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Thu, 9 Dec 2010 20:05:05 -0600
Message-ID: <AANLkTi=eL-tMYLXuoeqeKg_k-Sjxy4d0Lxdk5YEjXQf4@mail.gmail.com>
References: <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
 <20101207182243.GB21112@redhat.com> <20101207193514.GA2921@thunk.org>
 <AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
 <20101209180111.GF2921@thunk.org> <AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
 <20101209201359.GG2921@thunk.org> <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
 <20101209231616.GA12515@basil.fritz.box> <1291945065-sup-1838@think>
 <AANLkTimXznTKJAk7NAQPJC1op8iozsRCT5CHYm72hkkq@mail.gmail.com> <1291946360-sup-154@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mike Fedyk <mfedyk@mikefedyk.com>,
	Andi Kleen <andi@firstfloor.org>, "Ted Ts'o" <tytso@mit.edu>,
	Mike Snitzer <snitzer@redhat.com>, Matt <jackdachef@gmail.com>,
	Milan Broz <mbroz@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:56868 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0LJCF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Dec 2010 21:05:27 -0500
In-Reply-To: <1291946360-sup-154@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 9, 2010 at 8:00 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Excerpts from Mike Fedyk's message of 2010-12-09 20:58:40 -0500:
>> On Thu, Dec 9, 2010 at 5:38 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
>> > Excerpts from Andi Kleen's message of 2010-12-09 18:16:16 -0500:
>> >> > 512MB.
>> >> >
>> >> > 'free' reports 75MB, 419MB free.
>> >> >
>> >> > I originally noticed the problem on really real hardware (think=
pad
>> >> > T61p), however.
>> >>
>> >> If you can easily reproduce it could you try a git bisect?
>> >
>> > Do we have a known good kernel? =C2=A0I looked back through the th=
read and
>> > didn't see any reports where the postgres test on ext4 passed in t=
his
>> > config.
>> >
>>
>> 2.6.34.something. =C2=A0-- Any chance a newer kernel can be tested t=
o be found good?
>
> But he is triggering the ext4 corruption without dm-crypt. =C2=A0I th=
ink
> dm-crypt was still used somewhere on the system during the test, just
> not on the partitions that actually hit the corruption.

I now have my doubts about being able to trigger it without dm-crypt.
I stand by my report, but I'm also unable to reproduce it after after
50 test iterations. I did run 2.6.36 for a few weeks without any issue
that I recall.



--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
