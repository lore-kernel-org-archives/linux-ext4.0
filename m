From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info
 available
Date: Tue, 10 May 2016 00:00:44 -0700
Message-ID: <20160510070044.GA30896@infradead.org>
References: <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
 <20160429125743.23636.85219.stgit@warthog.procyon.org.uk>
 <20160508083543.GA14316@infradead.org>
 <1462795378.4481.31.camel@poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462795378.4481.31.camel-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 09, 2016 at 08:02:58AM -0400, Jeff Layton wrote:
> > > AT_FORCE_ATTR_SYNC can be set in flags.????This will require a network
> > > filesystem to synchronise its attributes with the server.
> > > 
> > > AT_NO_ATTR_SYNC can be set in flags.????This will suppress synchronisation
> > > with the server in a network filesystem.????The resulting values should be
> > > considered approximate.
> > 
> > And what happens if neither is set?
> > 
> 
> I'd suggest we have the documentation state that the lack of either
> flag leaves it up to the filesystem. In the case of NFS, you'd get
> "normal" attribute cache behavior, for instance which is governed by
> the ac* attributes.
> 
> We should also note that in the case of something like AT_NO_ATTR_SYNC
> on NFS, you might _still_ end up talking to the server if the client
> has nothing in-core for that inode.

File systems specific "legacy" defaults are a bad idea.  If we can't
describe the semantics we should not allow them, never mind making
the the default.  I'd strongly suggest picking one of the above flags
as the default behavior and only allowing the other as optional flag.
I suspect NO_SYNC is the better one for the flag, as otherwise people
will be surprised once they test their default case on a network
filesystem.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
