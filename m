From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 10:45:09 -0700
Message-ID: <520D13A5.2070808@linux.intel.com>
References: <520BB9EF.5020308@linux.intel.com>
	<20130815150506.GA10415@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	david@fromorbit.com, Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20130815150506.GA10415@thunk.org>
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

On 08/15/2013 08:05 AM, Theodore Ts'o wrote:
> IOW, if it really is about write page fault handling, the simplest
> test to do is to mmap /dev/zero and then start dirtying pages.  At
> that point we will be measuring the VM level write page fault code.

As I mentioned in some of the other replies, this is only one of six
tests that look at page faults.  It's the only one of the six that even
hinted at involvement by fs code.

> If we start trying to add in file system specific behavior, then we
> get into questions about block allocation vs. inode updates
> vs. writeback code paths, depending on what we are trying to measure,
> which then leads to the next logical question --- why are we trying to
> measure this?

At the risk of putting the cart before the horse, I ran the following:

	http://sr71.net/~dave/intel/page-fault-exts/page_fault4.c.txt

It should do all of the block allocation during will-it-scale's warmup
period.  I ran it for all 3 fs's with 160-processes.  The numbers were
indistinguishable from the case where the blocks were not preallocated.

I _believe_ this is because the block allocation is occurring during the
warmup, even in those numbers I posted previously.  will-it-scale forks
things off early and the tests spend most of their time in those while
loops.  Each "page fault handled" (the y-axis) is a trip through the
while loop, *not* a call to testcase().

It looks something like this:

	for_each_cpu(cpu)
		fork_off_stuff(testcase_func, &iterations[cpu]);
	while(test_nr++) {
		if (test_nr < 5)
			printf("warmup...")
		sleep(1);
		sample_iterations_from_shmem();
	}
	kill_everything();

In other words, block allocation isn't (or shouldn't be) playing a role
here, at least in the faults-per-second numbers.

> Is there a specific scalability problem that is show up in some real
> world use case?  Or is this a theoretical exercise?  It's Ok if it's
> just theoretical, since then we can try to figure out some kind of
> useful scalability limitation which is of practical importance.  But
> if there was some original workload which was motivating this
> exercise, it would be good if we kept this in mind....

It's definitely a theoretical exercise.  I'm in no way saying that all
you lazy filesystem developers need to get off your butts and go fix
this! ;)

Here's the problem:

We've got a kernel which works *really* well, even on very large
systems.  There are vanishingly few places to make performance
improvements, especially on more modestly-sized systems.  To _find_
those smallish issues (which I believe this is), we run things on
ridiculously-sized systems to make them easier to identify and measure.

1. The test is doing something that is not out of the question for a
   real workload to be doing (writing to an existing, medium-sized file
   with mmap())
2. I noticed that it exercised some of the same code paths Andy
   Lutomirski was trying to work around with his MADV_WILLWRITE patch
3. Dave Chinner _has_ patches which look to me like they could make an
   impact (at least on the xfs_log_commit_cil() spinlock)
4. This is something that is measurable, and we can easily measure
   improvements

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
