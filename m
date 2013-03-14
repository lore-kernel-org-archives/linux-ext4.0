From: Jan Kara <jack@suse.cz>
Subject: Re: Unwritten extent zeroing beyond i_size
Date: Thu, 14 Mar 2013 11:56:29 +0100
Message-ID: <20130314105629.GA12789@quack.suse.cz>
References: <20130313095640.GC29730@quack.suse.cz>
 <alpine.LFD.2.00.1303140850460.18319@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445Ab3CNK4d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Mar 2013 06:56:33 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303140850460.18319@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 14-03-13 08:56:55, Luk=C3=A1=C5=A1 Czerner wrote:
> On Wed, 13 Mar 2013, Jan Kara wrote:
>=20
> > Date: Wed, 13 Mar 2013 10:56:40 +0100
> > From: Jan Kara <jack@suse.cz>
> > To: Dmitry Monakhov <dmonakhov@openvz.org>
> > Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
> > Subject: Unwritten extent zeroing beyond i_size
> >=20
> >   Hello Dmitry,
> >=20
> >   I'm tracking down failure in xfstests test 274 (fallocate + ENOSP=
C
> > testing). The problem I found (and that's really unrelated to the q=
uestion
> > I want to ask) is that if write beyond i_size fails, we truncate th=
e file
> > to i_size to remove any blocks that may have been allocated under t=
he page
> > by the write before it failed (think of blocksize < pagesize config=
).
> >=20
> > Now in this test the write fails because it needs to split unwritte=
n extent
> > and there's no space for that and zeroing out is impossible because=
 we are
> > beyond i_size. And here comes my question: You disallowed zeroing o=
f
> > extents beyond i_size because fsck complains about those. Won't it =
be
> > better to just add inode flag saying "this inode has blocks preallo=
cated
> > beyond i_size" and make fsck not complain about such blocks? IMHO t=
hat
> > would catch 99% of corruptions as well and would let us solve the p=
roblem
> > with ENOSPC on writes to preallocated space (plus it would simplify=
 the
> > kernel code).
> >=20
> > 								Honza
>=20
> Unfortunately this will not solve the real issue that writing into
> preallocated space should _not_ fail at all, because it is
> preallocated.
>=20
> The problem right now is that we simply do not have block to
> allocate metadata, and there is no way for us to reserve metadata
> blocks in advance as we might try to do in delalloc.
  But if you don't need to split the extent (you will change the whole
extent from unwritten to written state) you don't need any aditional
metadata blocks. So write cannot fail...

> I've proposed the solution for this in the recent email with subject
> "Metadata reservation for unwritten extent conversion". Basically
> the idea is to have reserved pool of blocks which could be used for
> exactly this (and other) cases. Note that xfs actually have the same
> thing for exactly the same reasons.
  Yeah, I've read your proposal. I don't really object to this solution=
 as
it has advantages over "don't split extent if we are out of space" - na=
mely
it's going to be faster than writing extent full of zeros. But OTOH wri=
ting
zeros is so much simpler than implementing some reservation of blocks f=
or
emergency cases that it looks as a compelling solution to me.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
