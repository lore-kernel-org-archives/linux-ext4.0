From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Atomic non-durable file write API
Date: Tue, 28 Dec 2010 18:42:16 -0500
Message-ID: <20101228234216.GJ10149@thunk.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Neil Brown <neilb@suse.de>,
	Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Nick Piggin <npiggin@gmail.com>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58709 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab0L1Xml (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Dec 2010 18:42:41 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTinkHQ2tqAzqo77Bg_iyyYWUE72V85rTQqsEH4Nc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 28, 2010 at 11:54:33PM +0100, Olaf van der Spek wrote:

> > Very true.  But until such problems are described an understood,
> > there is not a lot of point trying to implement a
> > solution.  Premature implementation, like premature optimisation,
> > is unlikely to be fruitful.  I know this from experience.
>=20
> The problems seem clear. The implications not yet.

I don't think there's even agreement that it is a problem.  A problem
implies a use case where where such a need is critical, and I haven't
seen it yet.  I'd rather characeterize it as a demand for a "solution"
for a problem that hasn't been proven to exist yet.

> >> I also don't understand why providing this feature is such a
> >> (performance) problem.
> >> Surely the people that claim this should be able to explain why.
> >
> > Without a concrete design, it is hard to assess the performance
> > impact.  I would guess that those who anticipate a significant
> > performance impact are assuming a more feature-full implementation
> > than you are, and they are probably doing that because they feel
> > that you need the extra features to meet the actual needs (and so
> > suggest those needs a best met by a DBMS rather than a
> > file-system).  Of course this is just guess work. =A0With concreted
> > reference points it is hard to be sure.
>=20
> True, I don't understand why people say it will cause a performance
> hit but then don't want to tell why.

Because I don't want waste time doing a hypothetical design when (a)
the specification space hasn't even been fully spec'ed out, and (b) no
compelling use case has been demonstrated, and (c) no one is paying
me.

The last point is a critical one; who's going to do the work?  If you
are going to do the work, then implement it and send us the patches.
If you expect a technology expert to do the work, it's dirty pool to
try force him or her do a design to "prove" that it's not trivial.

If you're going to pay me $50,000 or $100,000, then it's on the golden
rule principle (the customer with the gold, makes the rules), and I'll
happily work on a design even if in my best judgment it's ill-advised,
and probably will be a waste of money, because, hey, it's the
customer's money.  But if you're going to ask me to spend my time
working on something which in my professional opinion is a waste of
time, and do it pro bono, you must be smoking something really good,
and probably really illegal.

Here are some of the hints though about trouble spots.

1) What happens in disk full cases?  Remember, we can't free the old
inode until writeback has happened.  And if we haven't allocated space
yet for the file, and space is needed for the new file, what happens?
What if some other disk write needs the space?

2) How big are the files that you imagine should be supported with
such a scheme?  If the file system is 1 GB, and the file is 600MG, and
you want to replace it with new contents which is 750MB long, what
happens?  How does the system degrade gracefully in the case of larger
files?  Does the user get any notification that maybe the magic
O_PONIES semantics might be changing?

3) What if the rename is still pending, but in the mean time, some
other process modifies the file?  Do those writes also have to be
atomic vis-a-vis the rename?

4) What if the rename is still pending, but in the meantime, some
other process does another create a new file, and rename over the same
file name?

etc.

> >> Where losing meta-data is bad? That should be obvious.
>=20
> In that case meta-data shouldn't be supported in the first place.

Well, hold on a minute.  It depends on what the meta-data means.  If
the meta-data is supposed to be a secure indication of who created the
file, or more importantly if quotes are enforced, to whom the disk
usage quota should be charged, then it might not be allowable to
"preserve the metadata in some cases".

In general, you can always save the meta data, and restore the meta
data to the new file --- except when there are security reasons why
this isn't allowed.  For example, file ownership is special, because
of (a) setuid bit considerations, and (b) file quota considerations.
If you don't have those issues, then allowing a non-privileged user to
use chown() is perfectly acceptable.  But it's because of these issues
that chown() is special.

And if quota is enabled, replacing a 10MB file with a 6TB file, while
preserving the same file "owner", and therefore charging the 6TB to
the old owner, would be a total evasion of the quota system.

In any case, have fun trying to design this system for which you have
no use cases....

       	       	      	    	      - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
