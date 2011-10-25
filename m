From: Jan Kara <jack@suse.cz>
Subject: Re: Latency writing to an mlocked ext4 mapping
Date: Tue, 25 Oct 2011 14:26:18 +0200
Message-ID: <20111025122618.GA8072@quack.suse.cz>
References: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
 <ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca>
 <CALCETrU23vyCXPG6mJU9qaPeAGOWDQtur5C+LRT154V5FM=Ajg@mail.gmail.com>
 <CALCETrX=-CnNQ9+4tRbqMG4mfuy2FBPXXoJeBVDVPnEiRJYRFQ@mail.gmail.com>
 <CALCETrUcOKQAJTTmCSD3Q3wYS-zLqv6tBa4AdkK50bNobRhDUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932571Ab1JYM0V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Oct 2011 08:26:21 -0400
Content-Disposition: inline
In-Reply-To: <CALCETrUcOKQAJTTmCSD3Q3wYS-zLqv6tBa4AdkK50bNobRhDUQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 19-10-11 22:59:55, Andy Lutomirski wrote:
> On Wed, Oct 19, 2011 at 7:17 PM, Andy Lutomirski <luto@amacapital.net=
> wrote:
> > On Wed, Oct 19, 2011 at 6:15 PM, Andy Lutomirski <luto@amacapital.n=
et> wrote:
> >> On Wed, Oct 19, 2011 at 6:02 PM, Andreas Dilger <adilger@dilger.ca=
> wrote:
> >>> What kernel are you using? =A0A change to keep pages consistent d=
uring writeout was landed not too long ago (maybe Linux 3.0) in order t=
o allow checksumming of the data.
> >>
> >> 3.0.6, with no relevant patches. =A0(I have a one-liner added to t=
he tcp
> >> code that I'll submit sometime soon.) =A0Would this explain the la=
tency
> >> in file_update_time or is that a separate issue? =A0file_update_ti=
me
> >> seems like a good thing to make fully asynchronous (especially if =
the
> >> file in question is a fifo, but I've already moved my fifos to tmp=
fs).
> >
> > On 2.6.39.4, I got one instance of:
> >
> > call_rwsem_down_read_failed ext4_map_blocks ext4_da_get_block_prep
> > __block_write_begin ext4_da_write_begin ext4_page_mkwrite do_wp_pag=
e
> > handle_pte_fault handle_mm_fault do_page_fault page_fault
> >
> > but I'm not seeing the large numbers of the ext4_page_mkwrite trace
> > that I get on 3.0.6. =A0file_update_time is now by far the dominant
> > cause of latency.
>=20
> The culprit seems to be do_wp_page -> file_update_time ->
> mark_inode_dirty_sync.  This surprises me for two reasons:
>=20
>  - Why the _sync?  Are we worried that data will be written out befor=
e
> the metadata?  If so, surely there's a better way than adding latency
> here.
  _sync just means that inode will become dirty for fsync(2) purposes b=
ut
not for fdatasync(2) purposes - i.e. it's just a timestamp update (or
it could be something similar).

>  - Why are we calling file_update_time at all?  Presumably we also
> update the time when the page is written back (if not, that sounds
> like a bug, since the contents may be changed after something saw the
> mtime update), and, if so, why bother updating it on the first write?
> Anything that relies on this behavior is, I think, unreliable, becaus=
e
> the page could be made writable arbitrarily early by another program
> that changes nothing.
  We don't update timestamp when the page is written back. I believe th=
is
is mostly because we don't know whether the data has been changed by a
write syscall, which already updated the timestamp, or by mmap. That is
also the reason why we update the timestamp at page fault time.

  The reason why file_update_time() blocks for you is probably that it
needs to get access to buffer where inode is stored on disk and because=
 a
transaction including this buffer is committing at the moment, your thr=
ead
has to wait until the transaction commit finishes. This is mostly a pro=
blem
specific to how ext4 works so e.g. xfs shouldn't have it.

  Generally I believe the attempts to achieve any RT-like latencies whe=
n
writing to a filesystem are rather hopeless. How much hopeless depends =
on
the load of the filesystem (e.g., in your case of mostly idle filesyste=
m I
can imagine some tweaks could reduce your latencies to an acceptable le=
vel
but once the disk gets loaded you'll be screwed). So I'd suggest that
having RT thread just store log in memory (or write to a pipe) and have
another non-RT thread write the data to disk would be a much more robus=
t
design.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
