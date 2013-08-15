From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 15:31:22 -0400
Message-ID: <20130815193122.GA19536@thunk.org>
References: <520BB9EF.5020308@linux.intel.com>
	<20130815150506.GA10415@thunk.org>
	<520D13A5.2070808@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <ak@linux.intel.com>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Andy Lutomirski <luto@amacapital.net>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <520D13A5.2070808@linux.intel.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 15, 2013 at 10:45:09AM -0700, Dave Hansen wrote:
> 
> I _believe_ this is because the block allocation is occurring during the
> warmup, even in those numbers I posted previously.  will-it-scale forks
> things off early and the tests spend most of their time in those while
> loops.  Each "page fault handled" (the y-axis) is a trip through the
> while loop, *not* a call to testcase().

Ah, OK.  Sorry, I misinterpreted what was going on.

So basically, what we have going on in the test is (a) we're bumping
i_version and/or mtime, and (b) the munmap() implies an msync(), so
writeback is happening in the background concurrently with the write
page faults, and we may be (actually, almost certainly) seeing some
interference between the writeback and the page_mkwrite operations.

That implies that if you redid the test using a ramdisk, which will
significantly speed up the writeback and overhead caused by the
journal transactions for the metadata updates, the results might very
well be different.

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
