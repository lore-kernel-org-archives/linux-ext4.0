From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Thu, 14 Sep 2006 15:48:31 +0200
Message-ID: <20060914134831.GE28663@openx1.frec.bull.fr>
References: <20060913164202.GA14838@openx1.frec.bull.fr>
	<1158171071.6072.10.camel@lade.trondhjem.org>
	<20060913183001.GA1702@moule.localdomain>
	<20060914092318.GA18911@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <nfsv4-bounces@linux-nfs.org>
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20060914092318.GA18911@schatzie.adilger.int>
Content-Disposition: inline
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

On Thu, Sep 14, 2006 at 03:23:18AM -0600, Andreas Dilger wrote:
> On Sep 13, 2006  20:30 +0200, Alexandre Ratchov wrote:
> > On Wed, Sep 13, 2006 at 02:11:11PM -0400, Trond Myklebust wrote:
> > > On Wed, 2006-09-13 at 18:42 +0200, Alexandre Ratchov wrote:
> > > > the change attribute is a simple counter that is reset to zero on
> > > > inode creation and that is incremented every time the inode data is
> > > > modified (similarly to the "ctime" time-stamp).
> > > 
> > > I would really have preferred a full-blown 64-bit counter as per
> > > RFC3530, but I suppose we could always combine this change attribute
> > > with the high word from ctime in order to make up the NFSv4 change
> > > attribute. That should keep us safe until someone develops a ramdisk
> > > with < 1 nsecond access time.
> > 
> > do you mean something like "(ctime.tv_sec << 32) | change_attribute"? this
> > would allow 2^32 inode changes per second.
> 
> It might be preferrable, since we are depending on the ctime here anyways,
> is to combine this with the nsec-resolution ctime, and kill two birds with
> one field in the inode.
> 
> The implementation would be to update the ctime+nsec field as normal, but
> in the unlikely case that both the second+nsec ctime is the same as before
> the nsec value would be incremented by 1.  This could happen in case of
> low-resolution kernel timers, and would also handle the future case where
> the inode is modified more than once in the same nanosecond.
> 
> The other benefit is that it allows comparisons between two different
> inodes to be more meaningful, instead of just using the seconds + random
> version number.
> 
> It would be possible/desirable to make the nsec ctime field be part of the 
> small inode (using the proposed reserved field) instead of the large inode,
> since that is a requirement for working with existing ext3 filesystems.  The
> previous nsec timestamp patch would only need trivial modifications to make
> this work, just #define i_ctime_extra to be l_i_reserved1 I believe.
> 

there is something i dislike with incrementing the nsec value. The ctime is
a global (as opposed to per-inode) time reference for the file-system. And
it is expected to be globally coherent; imagine the following situation:

Within the same time-slice (with time-stamp T0, in nanoseconds), we do the
following in this order:

change file1	-> 	ctime = T0
change file2	->	ctime = T0
change file2	->	ctime = T0 + 1
change file2	->	ctime = T0 + 2
change file1	->	ctime = T0 + 1

so it appears that file2 is strictly newer than file1, which is false. So
the assumption "if ctime(file1) < ctime(file2) then file2 is newer that
file1" is no longer true.

In order to fix this, we'll need to increment a global counter, not a
pre-inode counter. It's feasable.

cheers,

-- Alexandre
