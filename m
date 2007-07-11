From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Wed, 11 Jul 2007 05:41:13 -0600
Message-ID: <20070711114113.GQ6417@schatzie.adilger.int>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<20070710163038.ceb2ae94.akpm@linux-foundation.org>
	<1184105380.3759.65.camel@localhost.localdomain>
	<20070710182237.e2f88bf3.akpm@linux-foundation.org>
	<18068.19667.942363.686858@notabene.brown>
	<1184124869.6480.99.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Return-path: <nfsv4-bounces@linux-nfs.org>
Content-Disposition: inline
In-Reply-To: <1184124869.6480.99.camel@heimdal.trondhjem.org>
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

On Jul 10, 2007  23:34 -0400, Trond Myklebust wrote:
> On Wed, 2007-07-11 at 13:21 +1000, Neil Brown wrote:
> > So my vote is to increment i_version in common code every time any
> > change is made to the file, and alloc_inode should initialise it to
> > current time, which might be changed by the filesystem before it calls
> > unlock_new_inode. 
> > ... but doesn't lustre want to control its i_version... so maybe not :-(
> 
> If lustre wants to be exportable via pNFS (as Peter Braam has suggested
> it should), then it had better be able to return a change attribute that
> is compatible with the NFSv4.1 spec...

The Lustre use of i_version is a superset of what NFSv4 needs - the Lustre
version can be used to compare the updates of two inodes.  It is set
to be the Lustre transaction number (which is sequentially incremented
on a per filesystem basis), so that we can use the per-inode version
to do replay of client operations even if they have been disconnected for
a long time, which is why we want to be able to control the actual value.
We don't want the version to be updated for e.g. file defragmentation
or other similar internal-only changes which need ext4_mark_inode_dirty().

We had a patch to disable ext4 inode versioning by a flag the superblock,
but we dropped it at the last minute because it needed some updates and
we didn't want to wait on that for submitting these changes upstream.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
