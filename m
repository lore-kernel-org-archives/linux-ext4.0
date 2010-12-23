From: Dave Chinner <david@fromorbit.com>
Subject: Re: Atomic non-durable file write API
Date: Fri, 24 Dec 2010 09:43:09 +1100
Message-ID: <20101223224309.GH18264@dastard>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
 <AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
 <AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
 <4D0A7278.3080506@gmail.com>
 <1292710543.17128.14.camel@nayuki>
 <AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
 <AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 23, 2010 at 04:49:53PM +0100, Olaf van der Spek wrote:
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

So you are looking for something like:

http://developer.apple.com/library/mac/#DOCUMENTATION/Darwin/Reference/=
ManPages/man2/exchangedata.2.html

?

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
