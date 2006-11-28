From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Tue, 28 Nov 2006 14:06:22 -0800
Message-ID: <20061128220622.GB5673@schatzie.adilger.int>
References: <20060913164202.GA14838@openx1.frec.bull.fr>
	<1158171071.6072.10.camel@lade.trondhjem.org>
	<20060913183001.GA1702@moule.localdomain>
	<20060914092318.GA18911@schatzie.adilger.int>
	<20061114221725.GA14024@schatzie.adilger.int>
	<20061124002311.GA32033@schatzie.adilger.int>
	<20061128190016.GH6375@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
Return-path: <nfsv4-bounces@linux-nfs.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Content-Disposition: inline
In-Reply-To: <20061128190016.GH6375@fieldses.org>
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

On Nov 28, 2006  14:00 -0500, J. Bruce Fields wrote:
> On Thu, Nov 23, 2006 at 05:23:11PM -0700, Andreas Dilger wrote:
> > On Nov 14, 2006  15:17 -0700, Andreas Dilger wrote:
> > > I've been giving this further thought, and it may be that a full 64-bit
> > > counter per inode is the only bulletproof solution.
> > > 
> > > One reason that ctime+nsec as the version number isn't so great is that if
> > > there is some reason to set the clock backward (i.e. it was incorrectly
> > > set into the future at some point) the inode ctime may jump backward.
> > > This could cause either misordering of events, or collisions between
> > > version numbers.  The problem could be mitigated by having the ctime+nsec
> > > value only increment the nsec component by 1 for each new version (like
> > > a counter) until real time catches up with the bad ctime, but it might
> > > leave files with a bad ctime for a long time.
> > > 
> > > The main drawback of a 64-bit counter is the space in the inode that it
> > > consumes...  I don't think we can find 64 bits of free space in the core
> > > inode, so this would relegate the solution to new filesystems that are
> > > formatted with large inodes.
> > 
> > Alexandre, Trond,
> > what do you think about using a 32-bit in-inode version (sufficient for
> > causal uses of NFSv4),
> > and put the 32-bit MSB of the version into the
> > large part of the inode (say after cr_time)?
> 
> So does that mean that the MSB of the change attribute would only be
> available on some filesystems, or that it would be available on all of
> them but be slower on those with smaller inodes?  And how does the user
> (e.g. the nfsd code) distinguish the two cases?

One other option is to use the other reserved field (l_i_reserved2) to
store the MSB of the version.

> > That allows use of the version for existing ext3 filesystems, and with
> > large inodes (Lustre, ext4) it also meets the specs of RFC 3530 and any
> > intended NFSv4 future use?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
