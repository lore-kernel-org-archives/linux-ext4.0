From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Thu, 14 Dec 2006 11:48:09 -0500
Message-ID: <1166114889.20014.30.camel@lade.trondhjem.org>
References: <20060913164202.GA14838@openx1.frec.bull.fr>
	<1158171071.6072.10.camel@lade.trondhjem.org>
	<20061214012428.GA11548@schatzie.adilger.int>
	<20061214015212.GA30071@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, Andreas Dilger <adilger@clusterfs.com>
Return-path: <nfsv4-bounces@linux-nfs.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <20061214015212.GA30071@fieldses.org>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2006-12-13 at 20:52 -0500, J. Bruce Fields wrote:
> > What kind of requirements does NFSv4 place on the version?  Monotonic is
> > probably a good bet.
> 
> The only requirement is that it be unique (assuming a file is never
> modified 2^64 times).  Clients can't compare them except for equality.

The other requirement is that they be updated in more or less any
situation where you would normally see a 'ctime' update. In other words
any time when the file metadata or data changes, and any time when the
ACL changes.

(NB: I'm not sure what we should do w.r.t. xattr changes since those are
not really covered by RFC3530.)

Atomicity is not a hard requirement, however the server is required to
know whether or not the update was atomic. If the update is atomic, a
careful client may perform certain optimisations based upon it knowing
that no other changes to the inode have raced with this one. For
instance, if it knows that a file creation atomically updated the change
attribute of the directory, then it can determine that it does not need
to check for other changes to that directory.

> > Does it need to be global for the filesystem
> 
> Nope.
> 
> > or is a per-inode version sufficient?
> 
> Yes.

Yes. If your filesystem wants to support Solaris or Reiser4-like
subfiles, then it is expected that each subfile should have its own
change attribute (whereas changes to the subfile 'directory' will be
reflected by the parent inode's change attribute.

Change attribute values may be reused if the inode number is reused (as
long as the filesystem has something like a generation counter that
allows it to distinguish between different instances of the same inode
number).

> > What functionality of NFSv4 needs the version?
> 
> Clients use it to revalidate their caches.

Yup. It is used to detect changes made on the NFS server itself
(possibly by other NFS clients, possibly by local processes on the
server), so that the client can flush out any stale cached data.

Cheers
  Trond
