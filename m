From: "Theodore Ts'o" <tytso@mit.edu>
Subject: jbd/jbd2 performance improvements
Date: Tue, 07 Oct 2008 09:14:06 -0400
Message-ID: <E1KnCO6-0001qG-SV@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35995 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752474AbYJGNOI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 09:14:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


As I mentioned on the ext4 call yesterday, there was an interesting
thread on LKML that wasn't cc'ed onto the linux-ext4 mailing list.  So
in case folks missed it, it might be worth taking a look at this mail
thread:

	[PATCH] Give kjournald a IOPRIO_CLASS_RT io priority

	http://lkml.org/lkml/2008/10/1/405

The main issue that got discussed was the age-old "entaglement" problem.
The jbd/jbd2 layer is supposed to avoid this by not blocking the
"current" transaction why the blocks from the previous "committing"
transaction are still being written out to disk.  Apparently this was
broken sometime in the 2.5 time-frame:

	http://lkml.org/lkml/2008/10/2/41
	http://lkml.org/lkml/2008/10/2/322

Later in the thread, a major contention point in do_get_write_access()
was identified as the problem:

	http://lkml.org/lkml/2008/10/3/7

... and then andrew produced the following "hacky" fix:

	http://lkml.org/lkml/2008/10/3/22

If someone has time to runs some benchmarks to see how this improves
things, especially on a workload that has plenty of "engtanglements",
that would be great.  (I bet Ric's fs_mark run should do a good job;
fsyncs to creates lots of commits and the need to modify blocks that had
been modified in the previous tansactions.)

If we can get some quick testing done, and it shows really good results,
this could be something that could try fast-tracking into the 2.6.28
merge window.

						- Ted

