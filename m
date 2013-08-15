From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 11:05:06 -0400
Message-ID: <20130815150506.GA10415@thunk.org>
References: <520BB9EF.5020308@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, david@fromorbit.com,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andy Lutomirski <luto@amacapital.net>
To: Dave Hansen <dave.hansen@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <520BB9EF.5020308@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 14, 2013 at 10:10:07AM -0700, Dave Hansen wrote:
> We talked a little about this issue in this thread:
> 
> 	http://marc.info/?l=linux-mm&m=137573185419275&w=2
> 
> but I figured I'd follow up with a full comparison.  ext4 is about 20%
> slower in handling write page faults than ext3.

Let's take a step back from the details of whether the benchmark is
measuring what it claims to be measuring, and address this a different
way --- what's the workload which might be run on an 8-socket, 80-core
system, which is heavily modifying mmap'ed pages in such a way that
all or most of the memory writes are to clean pages that require write
page fault handling?

We can talk about isolating the test so that we remove block
allocation, timestamp modifications, etc., but then are we stil
measuring whatever motivated Dave's work in the first place?

IOW, if it really is about write page fault handling, the simplest
test to do is to mmap /dev/zero and then start dirtying pages.  At
that point we will be measuring the VM level write page fault code.

If we start trying to add in file system specific behavior, then we
get into questions about block allocation vs. inode updates
vs. writeback code paths, depending on what we are trying to measure,
which then leads to the next logical question --- why are we trying to
measure this?

Is there a specific scalability problem that is show up in some real
world use case?  Or is this a theoretical exercise?  It's Ok if it's
just theoretical, since then we can try to figure out some kind of
useful scalability limitation which is of practical importance.  But
if there was some original workload which was motivating this
exercise, it would be good if we kept this in mind....

Cheers,

		     	      	      	 - Ted
