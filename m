From: Jan Kara <jack@suse.cz>
Subject: Re: Latency writing to an mlocked ext4 mapping
Date: Wed, 2 Nov 2011 00:03:20 +0100
Message-ID: <20111101230320.GH18701@quack.suse.cz>
References: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
 <ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca>
 <CALCETrU23vyCXPG6mJU9qaPeAGOWDQtur5C+LRT154V5FM=Ajg@mail.gmail.com>
 <CALCETrX=-CnNQ9+4tRbqMG4mfuy2FBPXXoJeBVDVPnEiRJYRFQ@mail.gmail.com>
 <CALCETrUcOKQAJTTmCSD3Q3wYS-zLqv6tBa4AdkK50bNobRhDUQ@mail.gmail.com>
 <20111025122618.GA8072@quack.suse.cz>
 <CALCETrWoZeFpznU5Nv=+PvL9QRkTnS4atiGXx0jqZP_E3TJPqw@mail.gmail.com>
 <20111031231031.GD10107@quack.suse.cz>
 <CALCETrViG6t1forOFtO-R=bGABvtLcECxJ8m8Tenv6rwxLg_ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab1KAXDV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 19:03:21 -0400
Content-Disposition: inline
In-Reply-To: <CALCETrViG6t1forOFtO-R=bGABvtLcECxJ8m8Tenv6rwxLg_ew@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 31-10-11 16:14:47, Andy Lutomirski wrote:
> On Mon, Oct 31, 2011 at 4:10 PM, Jan Kara <jack@suse.cz> wrote:
> > On Fri 28-10-11 16:37:03, Andy Lutomirski wrote:
> >> On Tue, Oct 25, 2011 at 5:26 AM, Jan Kara <jack@suse.cz> wrote:
> >> >> =A0- Why are we calling file_update_time at all? =A0Presumably =
we also
> >> >> update the time when the page is written back (if not, that sou=
nds
> >> >> like a bug, since the contents may be changed after something s=
aw the
> >> >> mtime update), and, if so, why bother updating it on the first =
write?
> >> >> Anything that relies on this behavior is, I think, unreliable, =
because
> >> >> the page could be made writable arbitrarily early by another pr=
ogram
> >> >> that changes nothing.
> >> > =A0We don't update timestamp when the page is written back. I be=
lieve this
> >> > is mostly because we don't know whether the data has been change=
d by a
> >> > write syscall, which already updated the timestamp, or by mmap. =
That is
> >> > also the reason why we update the timestamp at page fault time.
> >> >
> >> > =A0The reason why file_update_time() blocks for you is probably =
that it
> >> > needs to get access to buffer where inode is stored on disk and =
because a
> >> > transaction including this buffer is committing at the moment, y=
our thread
> >> > has to wait until the transaction commit finishes. This is mostl=
y a problem
> >> > specific to how ext4 works so e.g. xfs shouldn't have it.
> >> >
> >> > =A0Generally I believe the attempts to achieve any RT-like laten=
cies when
> >> > writing to a filesystem are rather hopeless. How much hopeless d=
epends on
> >> > the load of the filesystem (e.g., in your case of mostly idle fi=
lesystem I
> >> > can imagine some tweaks could reduce your latencies to an accept=
able level
> >> > but once the disk gets loaded you'll be screwed). So I'd suggest=
 that
> >> > having RT thread just store log in memory (or write to a pipe) a=
nd have
> >> > another non-RT thread write the data to disk would be a much mor=
e robust
> >> > design.
> >>
> >> Windows seems to do pretty well at this, and I think it should be =
fixable on
> >> Linux too. =A0"All" that needs to be done is to remove the pte_wrp=
rotect from
> >> page_mkclean_one. =A0The fallout from that might be unpleasant, th=
ough, but
> >> it would probably speed up a number of workloads.
> > =A0Well, but Linux's mm pretty much depends the pte_wrprotect() so =
that's
> > unlikely to go away in a forseeable future. The reason is that we n=
eed to
> > reliably account the number of dirty pages so that we can throttle
> > processes that dirty too much of memory and also protect agaist sys=
tem
> > going into out-of-memory problems when too many pages would be dirt=
y (and
> > thus hard to reclaim). Thus we create clean pages as write-protecte=
d, when
> > they are first written to, we account them as dirtied and unprotect=
 them.
> > When pages are cleaned by writeback, we decrement number of dirty p=
ages
> > accordingly and write-protect them again.
>=20
> What about skipping pte_wrprotect for mlocked pages and continuing to
> account them dirty even if they're actually clean?  This should be a
> straightforward patch except for the effect on stable pages for
> writeback.  (It would also have unfortunate side effects on
> ctime/mtime without my other patch to rearrange that code.)
  Well, doing proper dirty accounting would be a mess (you'd have to
unaccount dirty pages during munlock etc.) and I'm not sure what all wo=
uld
break when page writes would not be coupled with page faults. So I don'=
t
think it's really worth it.

Avoiding IO during a minor fault would be a decent thing which might be
worth pursuing. As you properly noted "stable pages during writeback"
requirement is one obstacle which won't be that trivial to avoid though=
=2E..

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
