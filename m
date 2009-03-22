From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC 0/2] Mitigate fsync's with ext3's data=ordered mode
Date: Sat, 21 Mar 2009 21:12:08 -0400
Message-ID: <1237684330-11770-1-git-send-email-tytso@mit.edu>
Cc: akpm@linux-foundation.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35240 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbZCVBMS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Mar 2009 21:12:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Given the recent hoo-hah about ext4 and delayed allocation, I reviewed
the history of the Firefox 3.0 bug here:

    https://bugzilla.mozilla.org/show_bug.cgi?id=421482

Reports of the fsync() getting delayed by up to 30 seconds didn't make
sense to me, since there shouldn't be that much data waiting to be
flushed out, even if there was a very heavy write-intensive job
writing multiple gigabytes to the file.  When I looked more closely,
it became clear that what was really going on was a *read* intensive
job that was starving writes, due to the fact that the writes
submitted from the journal are using WRITE instead of WRITE_SYNC, and
I/O schedulers tend to prioritize reads ahead of writes.

This also explains why Aryan's patch which forced a higher I/O
priority for kjournald was helpful.  This is a better approach, since
we only force journal blocks out using WRITE_SYNC if the transaction
was triggered by something synchronous, such as an fsync() call, or a
file descriptor opened with O_SYNC.  The first patch does cause data
blocks forced out using data=ordered to be written out using
WRITE_SYNC even if the commit kicked off due to the 5 second commit
interval --- however, it does make the right thing happen when the
blocks are being forced out due to fsync() or fdatasync(), when before
the writes were being submitted without being marked as synchronous
writes.  

If it is considered highly objectionable that asynchronous commits
will result in WRITE_SYNC writes, we could add a new flag to the wbc
structure which could be passed all the way down to
block_write_full_page().  On the other hand, in the long run it's
better that commit complete sooner rather than later, since a
subsequent transaction could end up blocked behind the current
transaction, and that subsequent transaction could be a synchronous
one blocking an fsync() or some other synchronous operation.

I've done experiments with and without these patches, and it
definitely helps fsync() latency from between when there is a heavy
read intensive job starving the writes by about 75%.  The workload I
used was a tar command; I suspect if I had used a dd of a really huge
file, the fsync times without the patch would be even worse, and the
concommittent improvements would be even better.

						- Ted
