From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A proposal for making ext4's journal more SMR (and flash)
 friendly
Date: Wed, 8 Jan 2014 10:20:37 -0500
Message-ID: <20140108152037.GA25639@thunk.org>
References: <nsxfvozavl2.fsf@lambda.thunk.org>
 <alpine.LFD.2.00.1401081212370.2257@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46864 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbaAHPUm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jan 2014 10:20:42 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1401081212370.2257@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 08, 2014 at 12:43:35PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
>So it means that we would have to have bigger journal which is
>multiple zones (or bands) of size long, right ? However I assume that
>the optimal journal size in this case will be very much dependent
>on the workload used - for example small file workload or other metada=
ta
>heavy workloads would need bigger journal. Could we possibly make jour=
nal
>size variable ?

The journal size is already variable, e.g., "mke2fs -J size=3D512M".
But yes, the optimal journal size will be highly variable. =20

> > The journal is not truncated when the file system is unmounted, and=
 so
> > there is no difference between mounting a file system which has bee=
n
> > cleanly unmounted or after a system crash.
>=20
> I would maybe argue that clean unmount might be the right time for
> checkpoint and resetting journal head back to the beginning because
> I do not see it as a performance sensitive operation. This would in
> turn help us on subsequent mount and run.

Yes, maybe.  It depends on how the the SMR drive handles random
writes.  I suspect that most of the time, if the zones are close to
the 256MB to 512MB rather than 32MB, the SMR drive is not going to
rewrite the entire block just to handle a couple of random writes.  If
we are doing an unmount, and so we don't care about performance for
these random writes, if there is a way for us to hint to the SMR drive
that no, really, it really should do a full zone rewrite, even if we
are only updating a dozen blocks out of the 256MB zone, then sure,
this might be a good thing to do.

But if the SMR drive takes these random metadata writes and writes
them to some staging area, then it might not improve performance after
we reboot and remount the file system --- indeed, depending on the
location and nature of the staging area, it might make things worse.

I think we will need to do some experiments, and perhaps get some
input from SMR drive vendors.  They probably won't be willing to
release detailed design information without our being under NDA, but
we can probably explain the design, and watch how their faces grin or
twitch or scowl.  :-)

BTW, even if we do have NDA information from one vendor, it might not
necessarily follow that other vendors use the same tradeoffs.  So even
if some of us has NDA'ed information from one or two vendors, I'm a
bit hesitant about hard-coding the design based on what they tell us.
Besides the risk that one of the vendor might do things differently,
there is also the concern that future versions of the drive might use
different schemes for managing the logical->physical translation
layer.  So we will probably want to keep our implementation and design
flexible.

> While this helps a lot to avoid random writes it could possibly
> result in much higher seek rates especially with bigger journals.
> We're trying hard to keep data and associated metadata close
> together and this would very much break that. This might be
> especially bad with SMR devices because those are designed to be much
> bigger in size. But of course this is a trade-off which makes it
> very important to have good benchmark.

While the file system is mounted, if the metadata block is being
referenced frequently, it will be in kept in memory, so the fact that
it would have to seek to some random journal location if we need to
read that metadata block might not be a big deal.  (This is similar to
the argument used by log-structured file systems which claims that if
we have enough memory, the fact that the metadata is badly fragmented
doesn't matter.  Yes, if we are under heavy memory pressure, it might
not work out.)

> I assume that the information about the newest commits for
> particular metadata blocks would be kept in memory ? Otherwise it
> would be quite expensive operation. But it seems unavoidable on
> mount time, so it might really be better to clear the journal at
> unmount when we should have all this information already in memory ?

Information about all commits and what blocks are still associated
with them is alreaady being kept in memory.  Currently this is being
done via a jh/bh; we'd want to do this differently, since we wouldn't
necessarily enforce that all blocks which are in the journal must be
in the buffer cache.  (Although if we did keep all blocks in the
journal in the buffer cache, it would address the issue you raised
above, at the expense of using a large amount of memory --- more
memory than we would be comfortable using, although I'd bet is still
less memory than, say, ZFS requires. :-)

       	      	    	      	      	     	- Ted

P.S.  One other benefit of this design which I forgot to mention in
this version of the draft.  Using this scheme would also allow us to
implement true read-only mounts and file system checks, without
requiring that we modify the file system by replaying the journal
before proceeding with the mount or e2fsck run.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
