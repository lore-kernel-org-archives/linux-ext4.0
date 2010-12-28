From: Neil Brown <neilb@suse.de>
Subject: Re: Atomic non-durable file write API
Date: Wed, 29 Dec 2010 09:31:58 +1100
Message-ID: <20101229093158.2bfed8ca@notabene.brown>
References: <20101224095105.GG12763@thunk.org>
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
	<AANLkTikZ5wFf0KHiLFNxUO=0EGTqb5Ce-GDTVnGCCUaD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Nick Piggin <npiggin@gmail.com>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikZ5wFf0KHiLFNxUO=0EGTqb5Ce-GDTVnGCCUaD@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 28 Dec 2010 23:10:51 +0100 Olaf van der Spek <olafvdspek@gmail.=
com>
wrote:

> On Tue, Dec 28, 2010 at 9:59 PM, Neil Brown <neilb@suse.de> wrote:
> >> Writing code is a lot of work and one should have the design clear
> >> before writing code, IMO.
> >
> > Yes and no.
> >
> > Having some design is obviously important before starting to code.
> > However it is a common experience that once you start writing code,=
 you start
> > to see all the holes in your design - all the corner cases that you=
 didn't
> > think about. =A0So sometimes writing some proof-of-concept code is =
a very
> > valuable step in the design process.
>=20
> Sometimes, yes.
>=20
> > I think the real disconnect here is that you haven't really establi=
shed or
> > justified a need.
>=20
> True, but all those exceptions (IMO) should be (proven to be) no prob=
lem.
> I'd prefer designs that don't have such exceptions. I may not be able
> to think of a concrete problem right now, but that doesn't mean such
> problems don't exist.

Very true.  But until such problems are described an understood, there =
is not
a lot of point trying to implement a solution.  Premature implementatio=
n,
like premature optimisation, is unlikely to be fruitful.  I know this f=
rom
experience.

>=20
> I also don't understand why providing this feature is such a
> (performance) problem.
> Surely the people that claim this should be able to explain why.

Without a concrete design, it is hard to assess the performance impact.=
  I
would guess that those who anticipate a significant performance impact =
are
assuming a more feature-full implementation than you are, and they are
probably doing that because they feel that you need the extra features =
to
meet the actual needs (and so suggest those needs a best met by a DBMS =
rather
than a file-system).
Of course this is just guess work.  With concreted reference points it =
is
hard to be sure.

>=20
> > You seem to be asking for the ability to atomically change the data=
 in a file
> > without changing the metadata. =A0I cannot see why you would want t=
his. =A0Maybe
> > you could give an explicit use-case??
>=20
> Where losing meta-data is bad? That should be obvious.
> Or where losing file owner is bad? Still thinking about that one.

This is a bit left-field, but I think that losing metadata is always a =
good
thing.  A file should contain data - nothing else.  At all.  Owner and =
access
permissions should be based on location as dictated by external policy.=
=2E..
but yeah - off topic.

Clearly maintaining metadata by creating a new file and renaming in-pla=
ce is
easy for root (chown/chmod/etc).  So you are presumably envisaging situ=
ations
where a non-root user has write access to a file that they don't own, a=
nd
they want to make an atomic data-update to that file.
Sorry, but I think that allowing non-owners to write to a file is a rea=
lly
really bad idea and providing extra support for that use-case is comple=
tely
unjustifiable.

If you want multiple people to be able to update some data you should h=
ave
some way to ask the owner to make an update.  That could be:
  - setuid program
  - daemon which authenticates requests
  - distributed workflow tool like 'git' where you speak to the owner
    and ask them to pull updates.

and there are probably other options.  But un-mediated writes to a file=
 you
don't own?  Just say NO!

NeilBrown


>=20
> > Another significant issue here is "how much atomicity can we justif=
y".
> > One possibility is for the file system not to provide any atomicity=
, and so
> > require lots of repair after a crash: =A0fsck for the filesystem, "=
make clean"
> > for your compile tree, removal of stray temp files etc for other su=
bsystems.
> >
> > On the other extreme we could allow full transactions encompassing
> > multiple changes to multiple files which a guarantee to be either c=
ommitted
> > completely or not at all after a crash.
> >
> > We gave up on the first extreme about a decade ago when journalling
> > filesystems became available for Linux. =A0There seems to be little=
 desire to
> > pay the cost of ever implementing the other extreme in general purp=
ose
> > filesystems.
>=20
> Note that I'm not asking for this other extreme.
>=20
> > So the important question is "Where on that spectrum of options sho=
uld we be?"
> > The answer has to be based on cost/benefit. =A0The cost of adding j=
ournalling
> > was quite high, but the benefit of not having to fsck an enormous f=
ilesystem
> > after a crash is enormous, so it is a cost we have chosen to pay.
> >
> > If you want some extra level of atomicity, you need to demonstrate =
either a
> > high benefit or a low cost. =A0There seems to be some scepticism as=
 to whether
> > you can. =A0A convincing use-case might demonstrate the high benefi=
t. =A0Working
> > code might demonstrate low cost. =A0But you really need to provide =
at least one
> > (ideally both) or people are unlikely to take you seriously.
>=20
> I understand.
>=20
> Olaf

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
