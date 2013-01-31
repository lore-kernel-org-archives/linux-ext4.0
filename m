From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/3 v2] jbd2 performance improvements
Date: Thu, 31 Jan 2013 12:53:05 -0500
Message-ID: <1359654788-6078-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46391 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab3AaRxP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 12:53:15 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've added a patch which tracks the delay between when a commit was
first requested, and when the commit thread actually starts processing
the commit.  In addition to helping to assess the effects of the "commit
as soon as possible after log_start_commit", it is also useful in
debugging problems caused by real time processes which might interfere
with the kjournald thread (since we've had one user ask a question about
this already).

There are other performance metrics that we should consider adding,
including:

*) using a per-cpu variable to track t_max_wait, so we can measure this
   performance metric without incurring a scalability penalty; we
   currently disable this unless debugging is enabled, which is
   unfortunate.
*) how many handles are getting blocked waiting for a transaction to
   finish, and not just the max wait time
*) keeping statistics of why various commits have been started (was it
   due to an explicit fsync, or due to O_SYNC, or due to the transaction
   time expiring --- and in the latter case, whether it is due to an
   expiry while the file system was idle, and hence was picked up by
   kjournald, or during the stop_this_handle processing)

But these are things we can save for another time...

        	      	     	    	     - Ted

Eric Sandeen (1):
  jbd2: don't wake kjournald unnecessarily

Theodore Ts'o (2):
  jbd2: commit as soon as possible after log_start_commit
  jbd2: track request delay statistics

 fs/jbd2/commit.c            | 13 ++++++++++++-
 fs/jbd2/journal.c           | 17 ++++++++++++++---
 fs/jbd2/transaction.c       |  7 +++++--
 include/linux/jbd2.h        |  8 ++++++++
 include/trace/events/jbd2.h |  8 ++++++--
 5 files changed, 45 insertions(+), 8 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

