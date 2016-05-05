From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info available
Date: Thu, 05 May 2016 21:04:09 +0100
Message-ID: <2052.1462478649@warthog.procyon.org.uk>
References: <1462477696.12332.17.camel@poochiereds.net> <20160429125736.23636.47874.stgit@warthog.procyon.org.uk> <20160429125743.23636.85219.stgit@warthog.procyon.org.uk> <20160504225601.GZ26977@dastard> <87shxxbc1e.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells@redhat.com, NeilBrown <nfbrown@novell.com>,
	Dave Chinner <david@fromorbit.com>,
	linux-fsdevel@vger.kernel.org, linux-afs@vger.kernel.org,
	linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1462477696.12332.17.camel@poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jeff Layton <jlayton@poochiereds.net> wrote:

> I don't see a real attack vector here either, but OTOH is there a
> potential user of this at the moment?

I'm not sure.  BSD stat has an st_gen, so it's possible something out t=
here
will use it if it exists.

> An earlier chunk of the patch description says:
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

Yeah...  probably a good idea.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
