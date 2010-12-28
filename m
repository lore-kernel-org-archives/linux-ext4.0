From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Tue, 28 Dec 2010 23:10:51 +0100
Message-ID: <AANLkTikZ5wFf0KHiLFNxUO=0EGTqb5Ce-GDTVnGCCUaD@mail.gmail.com>
References: <20101224095105.GG12763@thunk.org>
	<AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>
	<20101225031529.GA2595@thunk.org>
	<AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>
	<AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>
	<AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
	<AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
	<AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
	<AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
	<AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
	<20101226221016.GF2595@thunk.org>
	<AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
	<4D18B106.4010308@ontolinux.com>
	<AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
	<4D18E94C.3080908@ontolinux.com>
	<AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
	<20101229075928.6bdafb08@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Nick Piggin <npiggin@gmail.com>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52795 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0L1WKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Dec 2010 17:10:53 -0500
In-Reply-To: <20101229075928.6bdafb08@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 28, 2010 at 9:59 PM, Neil Brown <neilb@suse.de> wrote:
>> Writing code is a lot of work and one should have the design clear
>> before writing code, IMO.
>
> Yes and no.
>
> Having some design is obviously important before starting to code.
> However it is a common experience that once you start writing code, y=
ou start
> to see all the holes in your design - all the corner cases that you d=
idn't
> think about. =C2=A0So sometimes writing some proof-of-concept code is=
 a very
> valuable step in the design process.

Sometimes, yes.

> I think the real disconnect here is that you haven't really establish=
ed or
> justified a need.

True, but all those exceptions (IMO) should be (proven to be) no proble=
m.
I'd prefer designs that don't have such exceptions. I may not be able
to think of a concrete problem right now, but that doesn't mean such
problems don't exist.

I also don't understand why providing this feature is such a
(performance) problem.
Surely the people that claim this should be able to explain why.

> You seem to be asking for the ability to atomically change the data i=
n a file
> without changing the metadata. =C2=A0I cannot see why you would want =
this. =C2=A0Maybe
> you could give an explicit use-case??

Where losing meta-data is bad? That should be obvious.
Or where losing file owner is bad? Still thinking about that one.

> Another significant issue here is "how much atomicity can we justify"=
=2E
> One possibility is for the file system not to provide any atomicity, =
and so
> require lots of repair after a crash: =C2=A0fsck for the filesystem, =
"make clean"
> for your compile tree, removal of stray temp files etc for other subs=
ystems.
>
> On the other extreme we could allow full transactions encompassing
> multiple changes to multiple files which a guarantee to be either com=
mitted
> completely or not at all after a crash.
>
> We gave up on the first extreme about a decade ago when journalling
> filesystems became available for Linux. =C2=A0There seems to be littl=
e desire to
> pay the cost of ever implementing the other extreme in general purpos=
e
> filesystems.

Note that I'm not asking for this other extreme.

> So the important question is "Where on that spectrum of options shoul=
d we be?"
> The answer has to be based on cost/benefit. =C2=A0The cost of adding =
journalling
> was quite high, but the benefit of not having to fsck an enormous fil=
esystem
> after a crash is enormous, so it is a cost we have chosen to pay.
>
> If you want some extra level of atomicity, you need to demonstrate ei=
ther a
> high benefit or a low cost. =C2=A0There seems to be some scepticism a=
s to whether
> you can. =C2=A0A convincing use-case might demonstrate the high benef=
it. =C2=A0Working
> code might demonstrate low cost. =C2=A0But you really need to provide=
 at least one
> (ideally both) or people are unlikely to take you seriously.

I understand.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
