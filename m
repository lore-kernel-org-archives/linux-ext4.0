From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits
 from VFS into individual setattr functions (RESEND)
Date: Tue, 7 Aug 2007 17:54:02 -0700
Message-ID: <20070807175402.03ceb0b7.akpm@linux-foundation.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<1186533934.6625.91.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: codalist@TELEMANN.coda.cs.cmu.edu, cluster-devel@redhat.com,
	jfs-discussion@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
	mikulas@artax.karlin.mff.cuni.cz, Jeff Layton <jlayton@redhat.com>,
	zippel@linux-m68k.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
	wli@holomorphy.com, joel.becker@oracle.com, dhowells@redhat.com,
	fuse-devel@lists.sourceforge.net, jffs-dev@axis.com,
	user-mode-linux-user@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org,
	ocfs2-devel@oss.oracle.com, bfennema@falcon.csc.calpoly.edu
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

If we change ->setattr so that it will return a positive, non-zero value
which the caller can then check and reliably do printk("that filesystem
needs updating") then that addresses my concern, sure.
