From: Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.21-ext4-1
Date: Mon, 30 Apr 2007 11:58:56 -0400
Message-ID: <20070430155856.GC10604@thunk.org>
References: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Johann Lombardi <johann.lombardi@bull.net>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Dave Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1423454AbXD3QEA@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Sorry, I forgot to include the URL's where ext4 development patchset
can be found:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.21-ext4-1

					- Ted

On Mon, Apr 30, 2007 at 11:14:57AM -0400, Theodore Ts'o wrote:
> 
> I've respun the ext4 development patchset, with Amit's updated fallocate
> patches.  I've added Dave's patch to add ia64 support to the fallocate
> system call, but *not* the XFS fallocate support patches.  (Probably
> better for them to live in an xfs tree, where they can more easily
> tested and updated.)  Yes, we haven't reached complete closure on the
> fallocate system call calling convention, but it's enough for us to get
> more testing in -mm.
> 
> Also added Johann's jbd2-stats-through-procfs patches; it provides
> useful help in turning the size of the journal, which will be useful in
> benchmarking efforts.  In addition, Alex Tomas's patch to free
> just-allocated patches when there is an error inserting the extent into
> the extent tree has also been included.
> 
> The patches have been compile-tested on x86, and compile/run-tested on
> x86/UML.  Would appreciate reports about testing on other platforms.
> 
> Thanks,
> 
> 						- Ted
> 
> P.S.  One bug which I've noted --- if there is a failure due to disk
> filling up, running e2fsck on the filesystem will show that the i_blocks
> fields on the inodes where there was a failure to allocate disk blocks
> are left incorrect.  I'm guessing this is a bug in the delayed
> allocation patches.  Alex, when you have a moment, could you take a
> look?  Thanks!!
