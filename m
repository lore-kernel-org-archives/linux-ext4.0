From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info
 available
Date: Fri, 6 May 2016 11:39:05 +1000
Message-ID: <20160506013905.GQ18496@dastard>
References: <1462477696.12332.17.camel@poochiereds.net>
 <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
 <20160429125743.23636.85219.stgit@warthog.procyon.org.uk>
 <20160504225601.GZ26977@dastard>
 <87shxxbc1e.fsf@notabene.neil.brown.name>
 <2052.1462478649@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton@poochiereds.net>,
	NeilBrown <nfbrown@novell.com>, linux-fsdevel@vger.kernel.org,
	linux-afs@vger.kernel.org, linux-nfs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2052.1462478649@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 05, 2016 at 09:04:09PM +0100, David Howells wrote:
> Jeff Layton <jlayton@poochiereds.net> wrote:
>=20
> > I don't see a real attack vector here either, but OTOH is there a
> > potential user of this at the moment?
>=20
> I'm not sure.  BSD stat has an st_gen, so it's possible something out=
 there
> will use it if it exists.

Oh, I know of several userspace applications that use the inode
generation number for some purpose. However, all of them are so
tightly tied to the XFS internal structure, implementation and the
XFS specific bulkstat interface that they cannot be considered
generic applications.

> > An earlier chunk of the patch description says:
> >=20
> > (7) Inode generation number: Useful for FUSE and userspace NFS serv=
ers
> > =A0=A0=A0=A0=A0[Bernd Schubert].=A0=A0This was asked for but later =
deemed unnecessary
> > =A0=A0=A0=A0=A0with the open-by-handle capability available
> >=20
> > ...the last bit seems to indicate that we don't really need this
> > anyway, as most userland servers now work with filehandles from the
> > kernel.
> >=20
> > Maybe leave it out for now? It can always be added later.
>=20
> Yeah...  probably a good idea.

=46ine by me.

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
