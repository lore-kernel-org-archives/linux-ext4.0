From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] aborted ext4 leads to inifinity loop in
 balance_dirty_pages
Date: Tue, 8 Nov 2011 01:03:35 +0100
Message-ID: <20111108000335.GA7518@quack.suse.cz>
References: <4EA6A5E5.2050604@sx.jp.nec.com>
 <20111025134045.GB8072@quack.suse.cz>
 <4EAA3EE7.4040802@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1KHADh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Nov 2011 19:03:37 -0500
Content-Disposition: inline
In-Reply-To: <4EAA3EE7.4040802@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 28-10-11 14:34:31, Kazuya Mio wrote:
> 2011/10/25 22:40, Jan Kara wrote:
> >  Please no. Generally this boils down to what do we do with dirty data
> >when there's error in writing them out. Currently we just throw them away
> >(e.g. in media error case) but I don't think that's a generally good thing
> >because e.g. admin may want to copy the data to other working storage or
> >so. So I think we should rather keep the data and provide a mechanism for
> >userspace to ask kernel to get rid of the data (so that we don't eventually
> >run OOM).
> 
> I see. I agree with you.
> 
> >>Do you have any ideas?
> >  So the question is what would you like to achieve. If you just want to
> >unblock a thread then a solution would be to make a thread at
> >balance_dirty_pages() killable. If generally you want to get rid of dirty
> >memory, then I don't have a really good answer but throwing dirty data away
> >seems like a bad answer to me.
> 
> The problem is that we cannot unmount the corrupted filesystem due to
> un-killable dd process. We must bring down the system to resume the service
> with no dirty pages. I think it is important for the service continuity
> to be able to kill the thread handling in balance_dirty_pages().
  OK, attached are two patches based on latest Linus's tree that should
make your task killable. Can you test them?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--pf9I7BMVVzbSWLtt
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-mm-Make-task-in-balance_dirty_pages-killable.patch"

>From 62d9916059c0441b3f545158f723c7006bcdc1e8 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 7 Nov 2011 18:41:05 +0100
Subject: [PATCH 1/2] mm: Make task in balance_dirty_pages() killable

There is no reason why task in balance_dirty_pages() shouldn't be killable
and it helps in recovering from some error conditions (like when filesystem
goes in error state and cannot accept writeback anymore but we still want to
kill processes using it to be able to unmount it).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0360d1b..e83c286 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1133,8 +1133,10 @@ pause:
 					  pages_dirtied,
 					  pause,
 					  start_time);
-		__set_current_state(TASK_UNINTERRUPTIBLE);
+		__set_current_state(TASK_KILLABLE);
 		io_schedule_timeout(pause);
+		if (fatal_signal_pending(current))
+			break;
 
 		dirty_thresh = hard_dirty_limit(dirty_thresh);
 		/*
-- 
1.7.1


--pf9I7BMVVzbSWLtt
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-fs-Make-write-2-interruptible-by-a-signal.patch"

>From 6eefa10d92cc35b66a8166cc26472d383b572b0d Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 7 Nov 2011 18:46:39 +0100
Subject: [PATCH 2/2] fs: Make write(2) interruptible by a signal

Currently write(2) to a file is not interruptible by a signal. Sometimes this
is desirable (e.g. when you want to quickly kill a process hogging your disk or
when some process gets blocked in balance_dirty_pages() indefinitely due to a
filesystem being in an error condition).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/filemap.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c0018f2..6b01d2f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2407,6 +2407,10 @@ static ssize_t generic_perform_write(struct file *file,
 						iov_iter_count(i));
 
 again:
+		if (signal_pending(current)) {
+			status = -EINTR;
+			break;
+		}
 
 		/*
 		 * Bring in the user page that we will copy from _first_.
-- 
1.7.1


--pf9I7BMVVzbSWLtt--
