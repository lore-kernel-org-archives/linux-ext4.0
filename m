From: Neil Brown <neilb@suse.de>
Subject: Re: Atomic non-durable file write API
Date: Fri, 24 Dec 2010 08:51:26 +1100
Message-ID: <20101224085126.2a7ff187@notabene.brown>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
	<AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
	<AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
	<4D0A7278.3080506@gmail.com>
	<1292710543.17128.14.camel@nayuki>
	<AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
	<AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42302 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab0LWVvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Dec 2010 16:51:39 -0500
In-Reply-To: <AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 23 Dec 2010 16:49:53 +0100 Olaf van der Spek <olafvdspek@gmail.=
com>
wrote:

> On Sun, Dec 19, 2010 at 5:39 PM, Olaf van der Spek <olafvdspek@gmail.=
com> wrote:
> > On Sat, Dec 18, 2010 at 11:15 PM, Calvin Walton <calvin.walton@gmai=
l.com> wrote:
> >> Hmm. I=E2=80=99m doing a little interpretation of what Olaf said h=
ere; but I
> >> think you may have misunderstood the question?
> >>
> >> He doesn=E2=80=99t care about whether or not the file is securely =
written to
> >> disk (durable); however he doesn=E2=80=99t want to see any partial=
ly written
> >> files. In other words, something like
> >>
> >> =C2=A0 =C2=A0 1. Write to temp file
> >> =C2=A0 =C2=A0 2. Rename temp file over original file
> >
> > Meta data, including file owner, should be preserved.
> > Ideally, no temp files should be visible either.
> >
> >> Where the rename is only committed to disk once the entire content=
s of
> >> the file have been written securely =E2=80=93 whenever that may ev=
entually
> >> happen.
> >>
> >> He doesn=E2=80=99t want to synchronously wait for the file to be w=
ritten,
> >> because the new data isn=E2=80=99t particularly important. The onl=
y important
> >> thing is that the file either contains the old or new data after a
> >> filesystem crash; not incomplete data. So, it=E2=80=99s more of an=
 ordering
> >> problem, I think? (Analogous to putting some sort of barrier betwe=
en the
> >> file write/close and the file rename to maintain ordering.)
> >>
> >> Hopefully I=E2=80=99ve interpreted the original question correctly=
, because this
> >> is something I would find interesting as well.
> >
> > Yes, you did.
>=20
> Somebody?
>=20

You are asking for something that doesn't exist, which is why no-one ca=
n tell
you want the answer is.

The only mechanism for synchronising different filesystem operations is
fsync.  You should use that.

If it is too slow, use data journalling, and place your journal on a
small low-latency device (NVRAM??)

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
