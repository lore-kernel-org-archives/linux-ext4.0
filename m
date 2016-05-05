From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info
 available
Date: Thu, 05 May 2016 15:48:16 -0400
Message-ID: <1462477696.12332.17.camel@poochiereds.net>
References: <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
	 <20160429125743.23636.85219.stgit@warthog.procyon.org.uk>
	 <20160504225601.GZ26977@dastard> <87shxxbc1e.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-afs@vger.kernel.org,
	linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>, Dave Chinner <david@fromorbit.com>,
	David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87shxxbc1e.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2016-05-05 at 10:09 +1000, NeilBrown wrote:
> On Thu, May 05 2016, Dave Chinner wrote:
>=20
> >=20
> > On Fri, Apr 29, 2016 at 01:57:43PM +0100, David Howells wrote:
> > >=20
> > > =C2=A0(4) File creation time (st_btime*), data version (st_versio=
n), inode
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0generation number (st_gen).
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0These will be returned if available=
 whether the caller asked for them or
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0not.=C2=A0=C2=A0The corresponding b=
its in st_mask will be set or cleared as
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0appropriate to indicate a valid val=
ue.
> > IMO, exposing the inode generation number to anyone is a potential
> > security problem because they are used in file handles.
> "security through obscurity".=C2=A0=C2=A0We have Kerberos working rea=
lly nicely
> for NFS these days.=C2=A0=C2=A0Do we still care?
>=20
> What if the generation number were only made available to "root"?=C2=A0=
=C2=A0Would
> that allay your concerns?
> Would that still be useful?
> We already have name_to_handle_at().=C2=A0=C2=A0Exposing the generati=
on number
> could/should follow the same rules at that.=C2=A0=C2=A0Or maybe the e=
xposure of
> each field should be guided by the filesystem, depending on (for
> example) whether it is used to provide uniqueness to the filehandle.
>=20
> >=20
> >=20
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0If the caller didn't ask for them, =
then they may be approximated.=C2=A0=C2=A0For
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0example, NFS won't waste any time u=
pdating them from the server, unless
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0as a byproduct of updating somethin=
g requested.
> > I would suggest that exposing them from the NFS server is something
> > we most definitely don't want to do because they are the only thing
> > that keeps remote users from guessing filehandles with ease....
> Given that the NFS protocol does not define a "generation number"
> attribute, I think there is no risk for them being exposed from the N=
=46S
> server ... except implicitly within the filehandle of course.
>=20
> NeilBrown



I don't see a real attack vector here either, but OTOH is there a
potential user of this at the moment? An earlier chunk of the patch
description says:

(7) Inode generation number: Useful for FUSE and userspace NFS servers
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0[Bernd Schubert].=C2=A0=C2=A0This was ask=
ed for but later deemed unnecessary
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0with the open-by-handle capability availa=
ble

=2E..the last bit seems to indicate that we don't really need this
anyway, as most userland servers now work with filehandles from the
kernel.

Maybe leave it out for now? It can always be added later.

--=20
Jeff Layton <jlayton@poochiereds.net>
