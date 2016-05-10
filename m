From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info
 available
Date: Tue, 10 May 2016 09:21:05 -0400
Message-ID: <1462886465.20038.6.camel@poochiereds.net>
References: <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
	 <20160429125743.23636.85219.stgit@warthog.procyon.org.uk>
	 <20160508083543.GA14316@infradead.org>
	 <1462795378.4481.31.camel@poochiereds.net>
	 <20160510070044.GA30896@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-afs@vger.kernel.org, linux-nfs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160510070044.GA30896@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2016-05-10 at 00:00 -0700, Christoph Hellwig wrote:
> On Mon, May 09, 2016 at 08:02:58AM -0400, Jeff Layton wrote:
> > > > AT_FORCE_ATTR_SYNC can be set in flags.????This will require a
> > > > network
> > > > filesystem to synchronise its attributes with the server.
> > > >=20
> > > > AT_NO_ATTR_SYNC can be set in flags.????This will suppress
> > > > synchronisation
> > > > with the server in a network filesystem.????The resulting
> > > > values should be
> > > > considered approximate.
> > >=20
> > > And what happens if neither is set?
> > >=20
> >=20
> > I'd suggest we have the documentation state that the lack of either
> > flag leaves it up to the filesystem. In the case of NFS, you'd get
> > "normal" attribute cache behavior, for instance which is governed
> > by
> > the ac* attributes.
> >=20
> > We should also note that in the case of something like
> > AT_NO_ATTR_SYNC
> > on NFS, you might _still_ end up talking to the server if the
> > client
> > has nothing in-core for that inode.
>=20
> File systems specific "legacy" defaults are a bad idea.=C2=A0=C2=A0If=
 we can't
> describe the semantics we should not allow them, never mind making
> the the default.=C2=A0=C2=A0I'd strongly suggest picking one of the a=
bove flags
> as the default behavior and only allowing the other as optional flag.
> I suspect NO_SYNC is the better one for the flag, as otherwise people
> will be surprised once they test their default case on a network
> filesystem.

Ok, that's a good point. So basically you suggest that xstat should
always have FORCE_SYNC semantics unless the NO_SYNC flag is set? Given
that we don't need to worry about legacy users with this interface,
that seems like a reasonable approach to me.
=C2=A0
--=20
Jeff Layton <jlayton@poochiereds.net>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
