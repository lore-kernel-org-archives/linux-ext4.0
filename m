From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sat, 4 Apr 2009 19:22:22 -0400
Message-ID: <20090404232222.GA7480@mit.edu>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34504 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZDDXWb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Apr 2009 19:22:31 -0400
Content-Disposition: inline
In-Reply-To: <20090404180108.GH5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 04, 2009 at 08:01:08PM +0200, Jens Axboe wrote:
> 
> Unless you make all journal writes sync, ext3 fsync will always suck big
> time. But I get your point.
> 

We have already made all other journal writes sync when triggered by
fsync() --- except for the commit record which is being written by
sync_dirty_buffer().  I've verified this via blktrace.

However, you're right.  We do have an performance regression using the
regression test provided in commit 78f707bf.  Taking the average of at
least 5 runs, I found:

stock 2.6.29				 1687 ms
2.6.29 w/ ext3-latency-fixes		 7337 ms
2.6.29 w/ full-latency-fixes		13722 ms

"ext3-latency-fixes" are the patches which Linus has already pulled
into the 2.6.29 tree.  "full-latency-fixes" are ext3-latency-fixes
plus the sync_dirty_buffes() patch.

Looking at blktrace of stock 2.6.29 running the sqlite performance
measurement, we see this:

254,2    1       13     0.005120554  7183  Q   W 199720 + 8 [sqlite-fsync-te]
254,2    1       15     0.005666573  6947  Q   W 10277200 + 8 [kjournald]
254,2    1       16     0.005691576  6947  Q   W 10277208 + 8 [kjournald]
254,2    1       18     0.006145684  6947  Q   W 10277216 + 8 [kjournald]
254,2    1       21     0.006685348  7183  Q   W 199720 + 8 [sqlite-fsync-te]
254,2    1       24     0.007162644  6947  Q   W 10277224 + 8 [kjournald]
254,2    1       25     0.007187857  6947  Q   W 10277232 + 8 [kjournald]
254,2    0       27     0.007616473  6947  Q   W 10277240 + 8 [kjournald]

Looking at a blktrace of 2.6.29 plus the full-latency-fixes, we see this:

254,2    0       13     0.013744556  7205  Q  WS 199208 + 8 [sqlite-fsync-te]
254,2    0       16     0.019270748  6965  Q  WS 10301896 + 8 [kjournald]
254,2    0       17     0.019400024  6965  Q  WS 10301904 + 8 [kjournald]
254,2    1       23     0.019892824  6965  Q  WS 10301912 + 8 [kjournald]
254,2    0       20     0.020450995  7205  Q  WS 199208 + 8 [sqlite-fsync-te]
254,2    1       26     0.025954909  6965  Q  WS 10301920 + 8 [kjournald]
254,2    1       27     0.026084814  6965  Q  WS 10301928 + 8 [kjournald]
254,2    0       24     0.026612884  6965  Q  WS 10301936 + 8 [kjournald]

Looking at the deltas between the two iterations of the sqlite
analogue, we see that stock 2.6.29 is 1.56ms, where as with the full
latency fixes, it's 6.70ms. 

However, the full latency fixes all the writes are synchronous, so it
must be the case that the delays are caused by the fact that queue is
getting implicitly unplugged after the synchronous write, and the
problem is no longer the mixing of WRITE and WRITE_SYNC requests as
posted in the commit log for 78f707bf.  If we remove the automatic
unplug for WRITE_SYNC requests, and add an explicit unplug where it is
needed, that should fix the performance regression for this particular
sqlite test case.  (Which isn't a throughput issue, since the test is
basically fopen/write/fsync/fclose over and over again, with no
background load.)

The scenario which Linus and I had been focused on is one where there
was a heavy background load writing asynchronously.  We do want to
make sure that a series of fsync() calls in a tight loop is also
reasonable as well, so Jens, I do think you are absolutely right that
this is something that we need to pay attention to.

I had missed the commit 78f707bf when you originally submitted it, so
I didn't do this test before submitting the patch.  And I guess you
had missed my patch proposal to LKML, and I didn't think to explicitly
CC you on my patches.  Apologies for the communication faults, but
hopefully we can fix this performance issue for both cases and get
these problems behind us.

Regards,

						- Ted
