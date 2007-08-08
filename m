From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits
	from VFS into individual setattr functions (RESEND)
Date: Tue, 07 Aug 2007 20:45:34 -0400
Message-ID: <1186533934.6625.91.camel@heimdal.trondhjem.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
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
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20070807171501.e31c4a97.akpm@linux-foundation.org>
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

On Tue, 2007-08-07 at 17:15 -0700, Andrew Morton wrote:

> Is there any way in which we can prevent these problems?  Say

The problem here is that we occasionally DO need to add new flags, and
yes, they MAY be security related. The whole reason why we're now having
to change the semantics of setattr is because somebody tried to hack
their way around the write+suid issue.

I suspect we will see the exact same thing will happen again in a couple
of years with Serge's ATTR_KILL_PRIV flag.

> - rename something so that unconverted filesystems will reliably fail to
>   compile?
> 
> - leave existing filesystems alone, but add a new
>   inode_operations.setattr_jeff, which the networked filesytems can
>   implement, and teach core vfs to call setattr_jeff in preference to
>   setattr?

If you really need to know that the filesystem is handling the flags,
then how about instead having ->setattr() return something which
indicates which flags it actually handled? That is likely to be a far
more intrusive change, but it is one which is future-proof.

Trond
