From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits
 from VFS into individual setattr functions (RESEND)
Date: Fri, 10 Aug 2007 16:47:52 -0400
Message-ID: <20070810164752.23117e0e.jlayton@redhat.com>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<1186533934.6625.91.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, zippel@linux-m68k.org,
	wli@holomorphy.com, dhowells@redhat.com,
	mikulas@artax.karlin.mff.cuni.cz, Jeff Layton <jlayton@redhat.com>,
	joel.becker@oracle.com, cluster-devel@redhat.com,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-cifs-client@lists.samba.org, fuse-devel@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
	user-mode-linux-user@lists.sourceforge.net,
	codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org,
	bfennema@falcon.csc.calpoly.edu, jffs-dev@axis.com,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <1186533934.6625.91.camel@heimdal.trondhjem.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Tue, 07 Aug 2007 20:45:34 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > - rename something so that unconverted filesystems will reliably fail to
> >   compile?
> > 
> > - leave existing filesystems alone, but add a new
> >   inode_operations.setattr_jeff, which the networked filesytems can
> >   implement, and teach core vfs to call setattr_jeff in preference to
> >   setattr?
> 
> If you really need to know that the filesystem is handling the flags,
> then how about instead having ->setattr() return something which
> indicates which flags it actually handled? That is likely to be a far
> more intrusive change, but it is one which is future-proof.
> 

One thing that we could do here is have notify_change check
attr->ia_valid after the setattr operation returns. If either ATTR_KILL_*
bit is set then BUG(). The helper function already clears those bits
so anything using it should automatically be ok. We'd have to fix
up NFS and a few others that don't implement suid/sgid.

This is not as certain as changing the name of the inode operation. It
would only pop when someone is attempting to change a setuid/setgid
file on these filesystems. Still, it should conceivably catch most if
not all offenders. Would that be sufficient to take care of everyone's
concerns?

-- 
Jeff Layton <jlayton@redhat.com>
