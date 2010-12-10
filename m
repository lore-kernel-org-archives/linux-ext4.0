From: Matt <jackdachef@gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Fri, 10 Dec 2010 02:53:30 +0100
Message-ID: <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andi Kleen <andi@firstfloor.org>, Jon Nelson <jnelson@jamponi.net>,
	"Ted Ts'o" <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:39337 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab0LJBxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Dec 2010 20:53:33 -0500
In-Reply-To: <1291945065-sup-1838@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 10, 2010 at 2:38 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
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
> Do we have a known good kernel? =A0I looked back through the thread a=
nd
> didn't see any reports where the postgres test on ext4 passed in this
> config.
>
> -chris
>

Try a kernel before 5a87b7a5da250c9be6d757758425dfeaf8ed3179

from the tests I've done that one showed the least or no corruption if
you count the empty /etc/env.d/03opengl as an artefact

(I tested 3 commits in total)


1) 5a87b7a5da250c9be6d757758425dfeaf8ed3179

2) 1de3e3df917459422cb2aecac440febc8879d410

3) bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc

1 -> 3 (earlier -> later)

Regards

Matt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
