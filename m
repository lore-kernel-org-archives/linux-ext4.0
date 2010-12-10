From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Thu, 9 Dec 2010 17:58:40 -0800
Message-ID: <AANLkTimXznTKJAk7NAQPJC1op8iozsRCT5CHYm72hkkq@mail.gmail.com>
References: <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
	<20101207142145.GA27861@think>
	<AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
	<20101207182243.GB21112@redhat.com>
	<20101207193514.GA2921@thunk.org>
	<AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
	<20101209180111.GF2921@thunk.org>
	<AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
	<20101209201359.GG2921@thunk.org>
	<AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
	<20101209231616.GA12515@basil.fritz.box>
	<1291945065-sup-1838@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andi Kleen <andi@firstfloor.org>, Jon Nelson <jnelson@jamponi.net>,
	"Ted Ts'o" <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>,
	Matt <jackdachef@gmail.com>, Milan Broz <mbroz@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291945065-sup-1838@think>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 9, 2010 at 5:38 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Excerpts from Andi Kleen's message of 2010-12-09 18:16:16 -0500:
>> > 512MB.
>> >
>> > 'free' reports 75MB, 419MB free.
>> >
>> > I originally noticed the problem on really real hardware (thinkpad
>> > T61p), however.
>>
>> If you can easily reproduce it could you try a git bisect?
>
> Do we have a known good kernel? =C2=A0I looked back through the threa=
d and
> didn't see any reports where the postgres test on ext4 passed in this
> config.
>

2.6.34.something.  -- Any chance a newer kernel can be tested to be fou=
nd good?
