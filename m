From: bfields@fieldses.org (J. Bruce Fields)
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info
 available
Date: Fri, 6 May 2016 14:07:42 -0400
Message-ID: <20160506180742.GA13350@fieldses.org>
References: <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
 <20160429125743.23636.85219.stgit@warthog.procyon.org.uk>
 <20160504225601.GZ26977@dastard>
 <87shxxbc1e.fsf@notabene.neil.brown.name>
 <1462477696.12332.17.camel@poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: NeilBrown <nfbrown@novell.com>, Dave Chinner <david@fromorbit.com>,
	David Howells <dhowells@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-afs@vger.kernel.org,
	linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462477696.12332.17.camel@poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 05, 2016 at 03:48:16PM -0400, Jeff Layton wrote:
> On Thu, 2016-05-05 at 10:09 +1000, NeilBrown wrote:
> > On Thu, May 05 2016, Dave Chinner wrote:
> >=20
> > >=20
> > > On Fri, Apr 29, 2016 at 01:57:43PM +0100, David Howells wrote:
> > > >=20
> > > > =C2=A0(4) File creation time (st_btime*), data version (st_vers=
ion), inode
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0generation number (st_gen).
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0These will be returned if availab=
le whether the caller asked for them or
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0not.=C2=A0=C2=A0The corresponding=
 bits in st_mask will be set or cleared as
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0appropriate to indicate a valid v=
alue.
> > > IMO, exposing the inode generation number to anyone is a potentia=
l
> > > security problem because they are used in file handles.
> > "security through obscurity".=C2=A0=C2=A0We have Kerberos working r=
eally nicely
> > for NFS these days.=C2=A0=C2=A0Do we still care?
> >=20
> > What if the generation number were only made available to "root"?=C2=
=A0=C2=A0Would
> > that allay your concerns?
> > Would that still be useful?
> > We already have name_to_handle_at().=C2=A0=C2=A0Exposing the genera=
tion number
> > could/should follow the same rules at that.=C2=A0=C2=A0Or maybe the=
 exposure of
> > each field should be guided by the filesystem, depending on (for
> > example) whether it is used to provide uniqueness to the filehandle=
=2E
> >=20
> > >=20
> > >=20
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0If the caller didn't ask for them=
, then they may be approximated.=C2=A0=C2=A0For
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0example, NFS won't waste any time=
 updating them from the server, unless
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0as a byproduct of updating someth=
ing requested.
> > > I would suggest that exposing them from the NFS server is somethi=
ng
> > > we most definitely don't want to do because they are the only thi=
ng
> > > that keeps remote users from guessing filehandles with ease....
> > Given that the NFS protocol does not define a "generation number"
> > attribute, I think there is no risk for them being exposed from the=
 NFS
> > server ... except implicitly within the filehandle of course.
> >=20
> > NeilBrown
>=20
>=20
>=20
> I don't see a real attack vector here either, but OTOH is there a
> potential user of this at the moment? An earlier chunk of the patch
> description says:
>=20
> (7) Inode generation number: Useful for FUSE and userspace NFS server=
s
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0[Bernd Schubert].=C2=A0=C2=A0This was a=
sked for but later deemed unnecessary
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0with the open-by-handle capability avai=
lable
>=20
> ...the last bit seems to indicate that we don't really need this
> anyway, as most userland servers now work with filehandles from the
> kernel.
>=20
> Maybe leave it out for now? It can always be added later.

Sounds like a good compromise to me!

That said, filehandles can never be changed, and generally have to be
exposed on the network, so I don't think it's worth going to great
lengths to try keep them secret.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
