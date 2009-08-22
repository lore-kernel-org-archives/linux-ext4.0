From: Theodore Tso <tytso@mit.edu>
Subject: Re: RFC: Clarifying Direct I/O Semantics
Date: Sat, 22 Aug 2009 16:40:11 -0400
Message-ID: <20090822204011.GC4800@mit.edu>
References: <E1Mec4O-0005ka-NN@closure.thunk.org> <4A8F1FA5.5080501@hp.com> <20090822000745.GP9529@mit.edu> <5956ddbe0908220625h6a6eeba2w679602d3a1f6336c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Lawrence Greenfield <leg@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38753 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933098AbZHVUkP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Aug 2009 16:40:15 -0400
Content-Disposition: inline
In-Reply-To: <5956ddbe0908220625h6a6eeba2w679602d3a1f6336c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 22, 2009 at 09:25:20AM -0400, Lawrence Greenfield wrote:
> > The question in my mind is whether we should guarantee that the dat=
a
> > block is written synchronously for allocating writes when the file
> > metadata is not written synchronously; what's the point? =A0After a=
ll,
> > the application can't distinguish between the data block not making=
 it
> > out to disk, versus the metadata that will allow the data block to =
be
> > accessed after a crash, why should one by synchronous but not the
> > other?
>=20
> O_DIRECT is about avoiding polluting the buffer cache, not only about
> data integrity. If an application wants allocating writes to have a
> data integrity guarantee, they can open the file O_DIRECT|O_DSYNC, at
> the cost that writes they think might be one disk seek end up being 2
> (or more). But please don't fall back to putting the data into the
> buffer cache!

Well, it really depends on who you talk to.  This goes back to the
problem that O_DIRECT's goals and semantics aren't well defined. =20

I find it really hard to believe that the main point is to avoid
polluting the page/buffer cache.  If that were true, then fadvise's
=46ADV_NOREUSE would be sufficient, and much simpler semantics to
implement than O_DIRECT's rather baroque restrictions and
requirements.

=46or the enterprise database folks (who were the ones who originally
asked the Solaris, AIX, and Irix OS's of the world for this feature)
it was always about performance/speed; they wanted to avoid copying
data in and out of the buffer/page cache for speed reasons.  But if
you need to take time out to maniulate allocation data structures, the
disk reads/writes are in the noise compared to the memory copy in and
out of the buffer cache.

> I think it would be useful to be explicit to applications what they
> need to do for O_DIRECT writes to be guaranteed to be visible after a
> crash. As a naive application writer, I would have thought using
> posix_fallocate would have been "good enough". If I understand
> correctly, an application that wants to know that O_DIRECT writes wil=
l
> both avoid the buffer cache and be visible after a crash must
> guarantee that it's previously written to those blocks either O_DSYNC
> or has used fdatasync() on the file after such writes. All subsequent
> writes can be done with only O_DIRECT.
>=20
> That means that a database must explicitly initialize its files by
> writing 0s: it can't rely on posix_fallocate. (Amusingly, it would
> have worked before fallocate() was introduced into the kernel!)

Well, all a database needs to do is use fdatasync() after an
application-level commit.  If there hasn't been any metadata changes,
the fdatasync() is cheap.  If the application is keeping track of when
it might be doing an allocating write() and when it isn't, it can try
to work out when it can omit the fdatasync() call.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
