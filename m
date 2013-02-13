From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 10:36:54 -0500
Message-ID: <20130213153654.GC17431@thunk.org>
References: <20130212202841.GC10267@fieldses.org>
 <20130213040003.GB2614@thunk.org>
 <20130213133131.GE14195@fieldses.org>
 <20130213151455.GB17431@thunk.org>
 <20130213151953.GJ14195@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	gluster-devel@nongnu.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48134 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab3BMPhE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 10:37:04 -0500
Content-Disposition: inline
In-Reply-To: <20130213151953.GJ14195@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 13, 2013 at 10:19:53AM -0500, J. Bruce Fields wrote:
> > > (In more detail: they're spreading a single directory across multiple
> > > nodes, and encoding a node ID into the cookie they return, so they can
> > > tell which node the cookie came from when they get it back.)
> > > 
> > > That works if you assume the cookie is an "offset" bounded above by some
> > > measure of the directory size, hence unlikely to ever use the high
> > > bits....
> > 
> > Right, but why wouldn't a nfs export option solave the problem for
> > gluster?
> 
> No, gluster is running on ext4 directly.

OK, so let me see if I can get this straight.  Each local gluster node
is running a userspace NFS server, right?  Because if it were running
a kernel-side NFS server, it would be sufficient to use an nfs export
option.

A client which mounts a "gluster file system" is also doing this via
NFSv3, right?  Or are they using their own protocol?  If they are
using their own protocol, why can't they encode the node ID somewhere
else?

So this a correct picture of what is going on:

                                                  /------ GFS Storage
                                                 /        Server #1
  GFS Cluster     NFS V3      GFS Cluster      -- NFS v3
  Client        <--------->   Frontend Server  ---------- GFS Storage
                                               --         Server #2
                                                 \
                                                  \------ GFS Storage
                                                          Server #3


And the reason why it needs to use the high bits is because when it
needs to coalesce the results from each GFS Storage Server to the GFS
Cluster client?


The other thing that I'd note is that the readdir cookie has been
64-bit since NFSv3, which was released in June ***1995***.  And the
explicit, stated purpose of making it be a 64-bit value (as stated in
RFC 1813) was to reduce interoperability problems.  If that were the
case, are you telling me that Sun (who has traditionally been pretty
good worrying about interoperability concerns, and in fact employed
the editors of RFC 1813) didn't get this right?  This seems
quite.... surprising to me.

I thought this was the whole point of the various NFS interoperability
testing done at Connectathon, for which Sun was a major sponsor?!?  No
one noticed?!?

	     		      	    	- Ted
