From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits
	from VFS into individual setattr functions (RESEND)
Date: Sat, 11 Aug 2007 03:57:39 +0100
Message-ID: <20070811025739.GA21244@infradead.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<1186533934.6625.91.camel@heimdal.trondhjem.org>
	<20070810164752.23117e0e.jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jfs-discussion@lists.sourceforge.net, zippel@linux-m68k.org,
	wli@holomorphy.com, dhowells@redhat.com,
	mikulas@artax.karlin.mff.cuni.cz, joel.becker@oracle.com,
	cluster-devel@redhat.com, v9fs-developer@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org,
	fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
	xfs@oss.sgi.com, user-mode-linux-user@lists.sourceforge.net,
	codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	bfennema@falcon.csc.calpoly.edu, jffs-dev@axis.com,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com
To: Jeff Layton <jlayton@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070810164752.23117e0e.jlayton@redhat.com>
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

On Fri, Aug 10, 2007 at 04:47:52PM -0400, Jeff Layton wrote:
> attr->ia_valid after the setattr operation returns. If either ATTR_KILL_*
> bit is set then BUG(). The helper function already clears those bits
> so anything using it should automatically be ok. We'd have to fix
> up NFS and a few others that don't implement suid/sgid.
> 
> This is not as certain as changing the name of the inode operation. It
> would only pop when someone is attempting to change a setuid/setgid
> file on these filesystems. Still, it should conceivably catch most if
> not all offenders. Would that be sufficient to take care of everyone's
> concerns?

I like the idea of checking ia_valid after return a lot.  But instead of
going BUG() it should just do the default action, that we can avoid
touching all the filesystem and only need to change those that need
special care.  I also have plans to add some new AT_ flags for implementing
some filesystem ioctl in generic code that would benefit greatly from
the ia_valid checkin after return to return ENOTTY fr filesystems not
implementing those ioctls.
