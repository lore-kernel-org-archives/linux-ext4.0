From: Jan Kara <jack@suse.cz>
Subject: Re: Unwritten extent zeroing beyond i_size
Date: Thu, 14 Mar 2013 13:05:27 +0100
Message-ID: <20130314120527.GB12789@quack.suse.cz>
References: <20130313095640.GC29730@quack.suse.cz>
 <alpine.LFD.2.00.1303140850460.18319@dhcp-1-104.brq.redhat.com>
 <20130314105629.GA12789@quack.suse.cz>
 <alpine.LFD.2.00.1303141205330.18319@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab3CNMFb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Mar 2013 08:05:31 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303141205330.18319@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 14-03-13 12:11:28, Luk=C3=A1=C5=A1 Czerner wrote:
> On Thu, 14 Mar 2013, Jan Kara wrote:
>=20
> > Date: Thu, 14 Mar 2013 11:56:29 +0100
> > From: Jan Kara <jack@suse.cz>
> > To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>=
,
> >     linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
> > Subject: Re: Unwritten extent zeroing beyond i_size
> >=20
> > On Thu 14-03-13 08:56:55, Luk=C3=A1=C5=A1 Czerner wrote:
> > > On Wed, 13 Mar 2013, Jan Kara wrote:
> > >=20
> > > > Date: Wed, 13 Mar 2013 10:56:40 +0100
> > > > From: Jan Kara <jack@suse.cz>
> > > > To: Dmitry Monakhov <dmonakhov@openvz.org>
> > > > Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
> > > > Subject: Unwritten extent zeroing beyond i_size
> > > >=20
> > > >   Hello Dmitry,
> > > >=20
> > > >   I'm tracking down failure in xfstests test 274 (fallocate + E=
NOSPC
> > > > testing). The problem I found (and that's really unrelated to t=
he question
> > > > I want to ask) is that if write beyond i_size fails, we truncat=
e the file
> > > > to i_size to remove any blocks that may have been allocated und=
er the page
> > > > by the write before it failed (think of blocksize < pagesize co=
nfig).
> > > >=20
> > > > Now in this test the write fails because it needs to split unwr=
itten extent
> > > > and there's no space for that and zeroing out is impossible bec=
ause we are
> > > > beyond i_size. And here comes my question: You disallowed zeroi=
ng of
> > > > extents beyond i_size because fsck complains about those. Won't=
 it be
> > > > better to just add inode flag saying "this inode has blocks pre=
allocated
> > > > beyond i_size" and make fsck not complain about such blocks? IM=
HO that
> > > > would catch 99% of corruptions as well and would let us solve t=
he problem
> > > > with ENOSPC on writes to preallocated space (plus it would simp=
lify the
> > > > kernel code).
> > > >=20
> > > > 								Honza
> > >=20
> > > Unfortunately this will not solve the real issue that writing int=
o
> > > preallocated space should _not_ fail at all, because it is
> > > preallocated.
> > >=20
> > > The problem right now is that we simply do not have block to
> > > allocate metadata, and there is no way for us to reserve metadata
> > > blocks in advance as we might try to do in delalloc.
> >   But if you don't need to split the extent (you will change the wh=
ole
> > extent from unwritten to written state) you don't need any aditiona=
l
> > metadata blocks. So write cannot fail...
>=20
> Right, but that's not always the case, also this is not the
> problematic case, or am I missing something ?
  It's always the case when writing to preallocated data - you can just
overwrite the whole extent with zeros, convert it to initialized and th=
en
write the data you have to the part you are interested in. Even for pun=
ch
hole if you get ENOSPC, you can just overwrite the punched region with
zeros instead of removing blocks. So it all works just results in more =
IO
in ENOSPC cases.

> > > I've proposed the solution for this in the recent email with subj=
ect
> > > "Metadata reservation for unwritten extent conversion". Basically
> > > the idea is to have reserved pool of blocks which could be used f=
or
> > > exactly this (and other) cases. Note that xfs actually have the s=
ame
> > > thing for exactly the same reasons.
> >   Yeah, I've read your proposal. I don't really object to this solu=
tion as
> > it has advantages over "don't split extent if we are out of space" =
- namely
> > it's going to be faster than writing extent full of zeros. But OTOH=
 writing
> > zeros is so much simpler than implementing some reservation of bloc=
ks for
> > emergency cases that it looks as a compelling solution to me.
>=20
> The reservation is not really all that complicated. Here is what I
> have so far. Note that the code is not ready yet, nor is it properly
> tested.
  I just briefly scanned the code - what I'm missing is that IMHO we sh=
ould
automatically refill reserved blocks during freeing of blocks.

> But you're right that zeroing the extent should be simpler. We might
> want to have both solutions as in extreme cases we might run out of
> the reserved space as well - it really depends on the default
> setting. In that case a warning would be appropriate.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
