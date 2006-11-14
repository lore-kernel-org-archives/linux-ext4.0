From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Tue, 14 Nov 2006 15:17:25 -0700
Message-ID: <20061114221725.GA14024@schatzie.adilger.int>
References: <20060913164202.GA14838@openx1.frec.bull.fr>
	<1158171071.6072.10.camel@lade.trondhjem.org>
	<20060913183001.GA1702@moule.localdomain>
	<20060914092318.GA18911@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <nfsv4-bounces@linux-nfs.org>
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060914092318.GA18911@schatzie.adilger.int>
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

On Sep 13, 2006  20:30 +0200, Alexandre Ratchov wrote:
> On Wed, Sep 13, 2006 at 02:11:11PM -0400, Trond Myklebust wrote:
> > I would really have preferred a full-blown 64-bit counter as per
> > RFC3530, but I suppose we could always combine this change attribute
> > with the high word from ctime in order to make up the NFSv4 change
> > attribute. That should keep us safe until someone develops a ramdisk
> > with < 1 nsecond access time.
> 
> do you mean something like "(ctime.tv_sec << 32) | change_attribute"? this
> would allow 2^32 inode changes per second.

I've been giving this further thought, and it may be that a full 64-bit
counter per inode is the only bulletproof solution.

One reason that ctime+nsec as the version number isn't so great is that if
there is some reason to set the clock backward (i.e. it was incorrectly
set into the future at some point) the inode ctime may jump backward.
This could cause either misordering of events, or collisions between
version numbers.  The problem could be mitigated by having the ctime+nsec
value only increment the nsec component by 1 for each new version (like
a counter) until real time catches up with the bad ctime, but it might
leave files with a bad ctime for a long time.

Other than not being able to set ctime backward (which isn't really
something that should happen under normal behaviour), this is a reasonable
solution.

The main drawback of a 64-bit counter is the space in the inode that it
consumes...  I don't think we can find 64 bits of free space in the core
inode, so this would relegate the solution to new filesystems that are
formatted with large inodes.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
