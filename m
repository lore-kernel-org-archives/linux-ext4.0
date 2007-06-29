From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Date: Fri, 29 Jun 2007 11:03:25 +1000
Message-ID: <20070629010325.GG31489@sgi.com>
References: <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070626153413.GC6652@schatzie.adilger.int> <20070626231803.GQ31489@sgi.com> <20070628181913.GC1674@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33854 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754525AbXF2BD6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jun 2007 21:03:58 -0400
Content-Disposition: inline
In-Reply-To: <20070628181913.GC1674@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 28, 2007 at 11:49:13PM +0530, Amit K. Arora wrote:
> On Wed, Jun 27, 2007 at 09:18:04AM +1000, David Chinner wrote:
> > On Tue, Jun 26, 2007 at 11:34:13AM -0400, Andreas Dilger wrote:
> > > On Jun 26, 2007  16:02 +0530, Amit K. Arora wrote:
> > > > On Mon, Jun 25, 2007 at 03:46:26PM -0600, Andreas Dilger wrote:
> > > > > Can you clarify - what is the current behaviour when ENOSPC (or some other
> > > > > error) is hit?  Does it keep the current fallocate() or does it free it?
> > > > 
> > > > Currently it is left on the file system implementation. In ext4, we do
> > > > not undo preallocation if some error (say, ENOSPC) is hit. Hence it may
> > > > end up with partial (pre)allocation. This is inline with dd and
> > > > posix_fallocate, which also do not free the partially allocated space.
> > > 
> > > Since I believe the XFS allocation ioctls do it the opposite way (free
> > > preallocated space on error) this should be encoded into the flags.
> > > Having it "filesystem dependent" just means that nobody will be happy.
> > 
> > No, XFs does not free preallocated space on error. it is up to the
> > application to clean up.
> 
> Since XFS also does not free preallocated space on error and this
> behavior is inline with dd, posix_fallocate() and the current ext4
> implementation, do we still need FA_FL_FREE_ENOSPC flag ?

Not at the moment.

> > > What I mean is that any data read from the file should have the "appearance"
> > > of being zeroed (whether zeroes are actually written to disk or not).  What
> > > I _think_ David is proposing is to allow fallocate() to return without
> > > marking the blocks even "uninitialized" and subsequent reads would return
> > > the old data from the disk.
> > 
> > Correct, but for swap files that's not an issue - no user should be able
> > too read them, and FA_MKSWAP would really need root privileges to execute.
> 
> Will the FA_MKSWAP mode still be required with your suggested change of
> teaching do_mpage_readpage() about unwritten extents being in place ?
> Or, will you still like to have FA_MKSWAP mode ?

budgie:/mnt/test # xfs_io -f -c "resvsp 0 1048576" -c "truncate 1048576" swap_file
budgie:/mnt/test # mkswap swap_file
Setting up swapspace version 1, size = 1032 kB
budgie:/mnt/test # swapon -v swap_file
swapon on swap_file
budgie:/mnt/test # swapon -s
Filename                                Type            Size    Used    Priority
/dev/sda2                               partition       9437152 0       -1
/mnt/test/swap_file                     file            992     0       -2
budgie:/mnt/test # xfs_bmap -vvp swap_file
swap_file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..31]:         96..127           0 (96..127)           32
   1: [32..2047]:      128..2143         0 (128..2143)       2016 10000
 FLAG Values:
    010000 Unwritten preallocated extent
    001000 Doesn't begin on stripe unit
    000100 Doesn't end   on stripe unit
    000010 Doesn't begin on stripe width
    000001 Doesn't end   on stripe width

Looks like the changes work, so FA_MKSWAP is not necessary for XFS.
We can drop that for the moment unless anyone else sees a need for it.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
