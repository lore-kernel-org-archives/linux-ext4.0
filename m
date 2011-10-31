From: Jan Kara <jack@suse.cz>
Subject: Re: Latency writing to an mlocked ext4 mapping
Date: Tue, 1 Nov 2011 00:10:31 +0100
Message-ID: <20111031231031.GD10107@quack.suse.cz>
References: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
 <ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca>
 <CALCETrU23vyCXPG6mJU9qaPeAGOWDQtur5C+LRT154V5FM=Ajg@mail.gmail.com>
 <CALCETrX=-CnNQ9+4tRbqMG4mfuy2FBPXXoJeBVDVPnEiRJYRFQ@mail.gmail.com>
 <CALCETrUcOKQAJTTmCSD3Q3wYS-zLqv6tBa4AdkK50bNobRhDUQ@mail.gmail.com>
 <20111025122618.GA8072@quack.suse.cz>
 <CALCETrWoZeFpznU5Nv=+PvL9QRkTnS4atiGXx0jqZP_E3TJPqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab1JaXKg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 19:10:36 -0400
Content-Disposition: inline
In-Reply-To: <CALCETrWoZeFpznU5Nv=+PvL9QRkTnS4atiGXx0jqZP_E3TJPqw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 28-10-11 16:37:03, Andy Lutomirski wrote:
> On Tue, Oct 25, 2011 at 5:26 AM, Jan Kara <jack@suse.cz> wrote:
> >> =A0- Why are we calling file_update_time at all? =A0Presumably we =
also
> >> update the time when the page is written back (if not, that sounds
> >> like a bug, since the contents may be changed after something saw =
the
> >> mtime update), and, if so, why bother updating it on the first wri=
te?
> >> Anything that relies on this behavior is, I think, unreliable, bec=
ause
> >> the page could be made writable arbitrarily early by another progr=
am
> >> that changes nothing.
> > =A0We don't update timestamp when the page is written back. I belie=
ve this
> > is mostly because we don't know whether the data has been changed b=
y a
> > write syscall, which already updated the timestamp, or by mmap. Tha=
t is
> > also the reason why we update the timestamp at page fault time.
> >
> > =A0The reason why file_update_time() blocks for you is probably tha=
t it
> > needs to get access to buffer where inode is stored on disk and bec=
ause a
> > transaction including this buffer is committing at the moment, your=
 thread
> > has to wait until the transaction commit finishes. This is mostly a=
 problem
> > specific to how ext4 works so e.g. xfs shouldn't have it.
> >
> > =A0Generally I believe the attempts to achieve any RT-like latencie=
s when
> > writing to a filesystem are rather hopeless. How much hopeless depe=
nds on
> > the load of the filesystem (e.g., in your case of mostly idle files=
ystem I
> > can imagine some tweaks could reduce your latencies to an acceptabl=
e level
> > but once the disk gets loaded you'll be screwed). So I'd suggest th=
at
> > having RT thread just store log in memory (or write to a pipe) and =
have
> > another non-RT thread write the data to disk would be a much more r=
obust
> > design.
>=20
> Windows seems to do pretty well at this, and I think it should be fix=
able on
> Linux too.  "All" that needs to be done is to remove the pte_wrprotec=
t from
> page_mkclean_one.  The fallout from that might be unpleasant, though,=
 but
> it would probably speed up a number of workloads.
  Well, but Linux's mm pretty much depends the pte_wrprotect() so that'=
s
unlikely to go away in a forseeable future. The reason is that we need =
to
reliably account the number of dirty pages so that we can throttle
processes that dirty too much of memory and also protect agaist system
going into out-of-memory problems when too many pages would be dirty (a=
nd
thus hard to reclaim). Thus we create clean pages as write-protected, w=
hen
they are first written to, we account them as dirtied and unprotect the=
m.
When pages are cleaned by writeback, we decrement number of dirty pages
accordingly and write-protect them again.=20
=20
> Adding a whole separate process just to copy data from memory to disk=
 sounds
> a bit like a hack -- that's what mmap + mlock would do if it worked b=
etter.
  Well, always only guarantees you cannot hit major fault when accessin=
g
the page. And we keep that promise - we only hit a minor fault. But I a=
gree
that for your usecase this is impractical.

I can see as theoretically feasible for writeback to skip mlocked pages
which would help your case. But practically, I do not see how to implem=
ent
that efficiently (just skipping a dirty page when we find it's mlocked
seems like a way to waste CPU needlessly).

> Incidentally, pipes are no good.  I haven't root-caused it yet, but b=
oth
> reading to and writing from pipes, even if O_NONBLOCK, can block.  I
> haven't root-caused it yet.
  Interesting. I imagine they could block on memory allocation but I gu=
ess
you don't put that much pressure on your system. So it might be interes=
ting
to know where else they block...

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
