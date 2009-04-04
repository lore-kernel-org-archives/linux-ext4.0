From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sat, 4 Apr 2009 09:57:19 -0400
Message-ID: <20090404135719.GA9812@mit.edu>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36622 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbZDDN52 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Apr 2009 09:57:28 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 03, 2009 at 01:41:54PM -0700, Linus Torvalds wrote:
> 
> Hmm. So I decided to try with "data=writeback" to see if it really makes 
> that big of a difference. It does help, but I still easily trigger 
> multi-second pauses

Using ext3 data=writeback, your "write big (2GB) file and sync" as the
background workload, and fsync-tester, I was able to reduce the
latency down to under 1 second...

fsync time: 0.1717
fsync time: 0.0205
fsync time: 0.1814
fsync time: 0.7408
fsync time: 0.1955
fsync time: 0.0327
fsync time: 0.0456
fsync time: 0.0563

...by doing two things: (1) Applying the attached patch, which fixes
one last critical place where we were using WRITE instead of
WRITE_SYNC --- the commit record was being written by
sync_dirty_buffer(), and this of _all_ places needs to use WRITE_SYNC,
since it waits for the buffer to be written write after submitting the
I/O, and (2) using the anticipatory I/O scheduler instead of the cfq
I/O scheduler.

(1) brought things down from 2-3.5 seconds on my system to 1-2
seconds, and (2) brought things down to what you see above.  I think
what is going on with the cfq scheduler is that it's using time slices
to make sure sync and async operations never completely starve each
other out, and in this case we need to tune the I/O scheduling
parameters so that for this workload, the synchronous operations don't
end up getting impeded by the asynchronous writes caused by background
"write big file and sync" task.

In any case, Jens may want to look at this test case (ext3
data=writeback, 'while : ; do time sh -c "dd if=/dev/zero of=bigfile
bs=8M count=256 ; sync"; done', and fsync-tester) as a good way to see
how cfq might be improved.

On another thread, it's been commented that there are still workloads
for which people are quietly switching from CFQ to AS, and this is
bad, because it causes us not to try to figure out why our default I/O
scheduler still as these 1% of cases where people need to use another
scheduler.  Well, here's one such case which is relatively easy to
reproduce.

> Are we perhaps ending up doing those regular 'bigfile' writes as 
> WRITE_SYNC, just because of the global "sync()" call? That's probably a 
> bad idea. A "sync" is about pure throughput. It's not about latency like 
> "fsync()" is.

Well, at least on my system where I did this round of testing (4gig
X61s with a 5400 RPM laptop drive), most of the time we weren't
writing the bigfile writes because of the sync, but because dd and
pdflush processes was trying to flush out the dirty pages from the big
write operation.  At the moment where "dd" completes and the "sync"
command is executed, the fsync latency jumped up to about 4-5 seconds
before this last round of changes.  After adding the attached patch
and switching to the AS I/O scheduler, at the moment of the sync the
fsync latency was just over a second (1.1 to 1.2 seconds).  The rest
of the time we are averaging between a 1/4 and a 1/3 of a second, with
rare fsync latency spikes up to about 3/4 of a second, as show at the
beginning of this message.

(Maybe on a system with a lot more memory, the dirty pages don't start
getting flushed to disk until the sync command, but that's not what
I'm seeing on my 4 gig laptop.)

In answer to your question, "sync" does the writes in two passes;
first it pushes out writes with wbc.sync_mode set to WB_SYNC_NONE, and
then it calls the page writeback routines a second time with
WB_SYNC_ALL.  So most of the writes should go out with WRITE, except
that the page writeback routines aren't as aggressive about pushing
out _all_ pages in WB_SYNC_NONE, so I believe some of the pages would
still be written on the WB_SYNC_ALL, and thus would go out using
WRITE_SYNc.  This is based on 2-3 month old memory of how things
worked in the page-writeback routines, which is the last time I traced
the very deep call trees involved in this area.  I'd have to run a
blktrace experiment to see for sure how many of the writes were going
out as WRITE vs. WRITE_SYNC in the case of the 'sync' command.

In any case, I recommend you take the following attached patch, and
then try out ext3 data=writeback with anticipatory I/O scheduler.
Hopefully you'll be pleased with the results.

							- Ted

>From 6d293d2aa42d43c120f113bde55f7b0d6f3f35ae Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sat, 4 Apr 2009 09:17:38 -0400
Subject: [PATCH] sync_dirty_buffer: Use WRITE_SYNC instead of WRITE

The sync_dirty_buffer() function submits a buffer for write, and then
synchronously waits for it.  It clearly should use WRITE_SYNC instead
of WRITE.  This significantly reduces ext3's fsync() latency when
there is a huge background task writing data asyncronously in the
background, since ext3 uses sync_dirty_buffer() to write the commit
block.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2ed4b68..78ed086 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3038,7 +3038,7 @@ int sync_dirty_buffer(struct buffer_head *bh)
 	if (test_clear_buffer_dirty(bh)) {
 		get_bh(bh);
 		bh->b_end_io = end_buffer_write_sync;
-		ret = submit_bh(WRITE, bh);
+		ret = submit_bh(WRITE_SYNC, bh);
 		wait_on_buffer(bh);
 		if (buffer_eopnotsupp(bh)) {
 			clear_buffer_eopnotsupp(bh);
-- 
1.5.6.3

