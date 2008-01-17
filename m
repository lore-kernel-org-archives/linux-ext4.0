From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 1/4]jbd2: port jbd lockdep support to jbd2
Date: Thu, 17 Jan 2008 11:47:59 -0800
Message-ID: <1200599279.4134.31.camel@localhost.localdomain>
References: <12004403661489-git-send-email-jonas.bonn@gmail.com>
	 <20080115155914.c72aaea9.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jonas Bonn <jonas.bonn@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51097 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYAQTrz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2008 14:47:55 -0500
In-Reply-To: <20080115155914.c72aaea9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew, Ted,

I walked through the linus's git tree history and found 4 patches should
port from ext3/jbd to ext4/jbd2, since the day ext4 was forked
(2006.10.11) to today. I have already queued the ported patches in ext4
patch queue and verified they seems fine. Here is the first one.



jbd2: port jbd lockdep support to jbd2
> Except lockdep doesn't know about journal_start(), which has ranking
> requirements similar to a semaphore.  

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/jbd2/transaction.c |   11 +++++++++++
 include/linux/jbd2.h  |    4 ++++
 2 files changed, 15 insertions(+)

Index: linux-2.6.24-rc7/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.24-rc7.orig/fs/jbd2/transaction.c	2008-01-16 15:30:24.000000000 -0800
+++ linux-2.6.24-rc7/fs/jbd2/transaction.c	2008-01-16 15:41:14.000000000 -0800
@@ -241,6 +241,8 @@ out:
 	return ret;
 }
 
+static struct lock_class_key jbd2_handle_key;
+
 /* Allocate a new handle.  This should probably be in a slab... */
 static handle_t *new_handle(int nblocks)
 {
@@ -251,6 +253,9 @@ static handle_t *new_handle(int nblocks)
 	handle->h_buffer_credits = nblocks;
 	handle->h_ref = 1;
 
+	lockdep_init_map(&handle->h_lockdep_map, "jbd2_handle",
+						&jbd2_handle_key, 0);
+
 	return handle;
 }
 
@@ -293,7 +298,11 @@ handle_t *jbd2_journal_start(journal_t *
 		jbd2_free_handle(handle);
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
+		goto out;
 	}
+
+	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+out:
 	return handle;
 }
 
@@ -1419,6 +1428,8 @@ int jbd2_journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
+	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+
 	jbd2_free_handle(handle);
 	return err;
 }
Index: linux-2.6.24-rc7/include/linux/jbd2.h
===================================================================
--- linux-2.6.24-rc7.orig/include/linux/jbd2.h	2008-01-16 15:29:03.000000000 -0800
+++ linux-2.6.24-rc7/include/linux/jbd2.h	2008-01-16 15:29:54.000000000 -0800
@@ -418,6 +418,10 @@ struct handle_s
 	unsigned int	h_sync:		1;	/* sync-on-close */
 	unsigned int	h_jdata:	1;	/* force data journaling */
 	unsigned int	h_aborted:	1;	/* fatal error on handle */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	h_lockdep_map;
+#endif
 };
 
