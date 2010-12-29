From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Wed, 29 Dec 2010 10:09:48 +0100
Message-ID: <AANLkTi=ULuM6fHH1V2zKGpaSjKRrbUJen5oAMKAkAaei@mail.gmail.com>
References: <20101226221016.GF2595@thunk.org>
	<AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
	<4D18B106.4010308@ontolinux.com>
	<AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
	<4D18E94C.3080908@ontolinux.com>
	<AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
	<20101229075928.6bdafb08@notabene.brown>
	<AANLkTikZ5wFf0KHiLFNxUO=0EGTqb5Ce-GDTVnGCCUaD@mail.gmail.com>
	<20101229093158.2bfed8ca@notabene.brown>
	<AANLkTinkHQ2tqAzqo77Bg_iyyYWUE72V85rTQqsEH4Nc@mail.gmail.com>
	<20101228234216.GJ10149@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Neil Brown <neilb@suse.de>,
	Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Nick Piggin <npiggin@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0L2JJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Dec 2010 04:09:50 -0500
In-Reply-To: <20101228234216.GJ10149@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 29, 2010 at 12:42 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Dec 28, 2010 at 11:54:33PM +0100, Olaf van der Spek wrote:
>
>> > Very true. =C2=A0But until such problems are described an understo=
od,
>> > there is not a lot of point trying to implement a
>> > solution. =C2=A0Premature implementation, like premature optimisat=
ion,
>> > is unlikely to be fruitful. =C2=A0I know this from experience.
>>
>> The problems seem clear. The implications not yet.
>
> I don't think there's even agreement that it is a problem. =C2=A0A pr=
oblem

Maybe problem isn't the right word, but it does seem a cornercase / exc=
eption.

> implies a use case where where such a need is critical, and I haven't
> seen it yet. =C2=A0I'd rather characeterize it as a demand for a "sol=
ution"
> for a problem that hasn't been proven to exist yet.
>
>> True, I don't understand why people say it will cause a performance
>> hit but then don't want to tell why.
>
> Because I don't want waste time doing a hypothetical design when (a)
> the specification space hasn't even been fully spec'ed out, and (b) n=
o
> compelling use case has been demonstrated, and (c) no one is paying
> me.

> The last point is a critical one; who's going to do the work? =C2=A0I=
f you
> are going to do the work, then implement it and send us the patches.
> If you expect a technology expert to do the work, it's dirty pool to
> try force him or her do a design to "prove" that it's not trivial.
>
> If you're going to pay me $50,000 or $100,000, then it's on the golde=
n
> rule principle (the customer with the gold, makes the rules), and I'l=
l
> happily work on a design even if in my best judgment it's ill-advised=
,
> and probably will be a waste of money, because, hey, it's the
> customer's money. =C2=A0But if you're going to ask me to spend my tim=
e
> working on something which in my professional opinion is a waste of
> time, and do it pro bono, you must be smoking something really good,
> and probably really illegal.

I don't want you to work on something you do not support.
I want to understand why you think it's a bad idea.

> Here are some of the hints though about trouble spots.
>
> 1) What happens in disk full cases? =C2=A0Remember, we can't free the=
 old
> inode until writeback has happened. =C2=A0And if we haven't allocated=
 space
> yet for the file, and space is needed for the new file, what happens?
> What if some other disk write needs the space?

I would expect a no space error.

> 2) How big are the files that you imagine should be supported with
> such a scheme? =C2=A0If the file system is 1 GB, and the file is 600M=
G, and
> you want to replace it with new contents which is 750MB long, what
> happens? =C2=A0How does the system degrade gracefully in the case of =
larger
> files? =C2=A0Does the user get any notification that maybe the magic
> O_PONIES semantics might be changing?

No sementics will change, you'll get a no space error.
Just like you would if you use the temp file approach.

> 3) What if the rename is still pending, but in the mean time, some
> other process modifies the file? =C2=A0Do those writes also have to b=
e
> atomic vis-a-vis the rename?

So the rename has been executed already (but has not yet been comitted
to disk) and then the file is modified? They would apply to the new
file.

> 4) What if the rename is still pending, but in the meantime, some
> other process does another create a new file, and rename over the sam=
e
> file name?

The last update would win, if by pending you mean the rename has been
executed already but hasn't been written to disk yet.

> etc.
>
>> >> Where losing meta-data is bad? That should be obvious.
>>
>> In that case meta-data shouldn't be supported in the first place.
>
> Well, hold on a minute. =C2=A0It depends on what the meta-data means.=
 =C2=A0If
> the meta-data is supposed to be a secure indication of who created th=
e
> file, or more importantly if quotes are enforced, to whom the disk
> usage quota should be charged, then it might not be allowable to
> "preserve the metadata in some cases".

I understand you can't just allow chown, but ...

> In general, you can always save the meta data, and restore the meta
> data to the new file --- except when there are security reasons why
> this isn't allowed. =C2=A0For example, file ownership is special, bec=
ause
> of (a) setuid bit considerations, and (b) file quota considerations.
> If you don't have those issues, then allowing a non-privileged user t=
o
> use chown() is perfectly acceptable. =C2=A0But it's because of these =
issues
> that chown() is special.
>
> And if quota is enabled, replacing a 10MB file with a 6TB file, while
> preserving the same file "owner", and therefore charging the 6TB to
> the old owner, would be a total evasion of the quota system.

Isn't that already a problem if you have write access to a file you don=
't own?

Still waiting on an answer to:
> What is the recommended way for atomic (complete) file writes?

Given that (you say) so many get it wrong, it would be nice to know
the right way.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
