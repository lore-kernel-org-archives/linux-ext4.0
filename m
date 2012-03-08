From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Don't do page stablization if
 !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 16:12:21 -0500
Message-ID: <20120308211221.GB11861@thunk.org>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
 <4F57F523.3020703@redhat.com>
 <4F581BF6.8000305@zabbo.net>
 <20120308155419.GB6777@thunk.org>
 <20120308180951.GB29510@shiny>
 <4F59148A.4070001@panasas.com>
 <20120308203741.GE29510@shiny>
 <x49linaj037.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Zach Brown <zab@zabbo.net>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44030 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab2CHVM1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Mar 2012 16:12:27 -0500
Content-Disposition: inline
In-Reply-To: <x49linaj037.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 08, 2012 at 03:42:52PM -0500, Jeff Moyer wrote:
> 
> So now we're back to figuring out how to tell how long I/O will take?
> If writeback is issuing random access I/Os to spinning media, you can
> bet it might be a while.  Today, you could lower nr_requests to some
> obscenely small number to improve worst-case latency.  I thought there
> was some talk about improving the intelligence of writeback in this
> regard, but it's a tough problem, especially given that writeback isn't
> the only cook in the kitchen.

... and it gets worse if there is any kind of I/O prioritization going
on via ionice(), or (as was the case in our example) I/O cgroups were
being used to provide proportional I/O rate controls.  I don't think
it's realistic to assume the writeback code can predict how long I/O
will take when it does a submission.

BTW, I'd have to check (having not looked at the application code in
depth; the bug was primarily solved by bisection and reverting the
problem commit) but I'm not entirely sure the thread doing the write
was calling fsync(); the main issue as I understand things was that
the application wasn't expecting the write(2) system call would block
unexpectedly for long periods of time while doing small buffered,
appending I/O's.  (Again, for the kind of work that distributed
systems do, 99th percentile latency is important!)

						- Ted
