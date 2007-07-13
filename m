From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
	features in larger inode
Date: Fri, 13 Jul 2007 15:33:41 +0200
Message-ID: <1184333621.20032.85.camel@twins>
References: <1183275482.4010.133.camel@localhost.localdomain>
	 <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	 <20070713020529.1486491f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46220 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbXGMNds (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2007 09:33:48 -0400
In-Reply-To: <20070713020529.1486491f.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-07-13 at 02:05 -0700, Andrew Morton wrote:

> Except lockdep doesn't know about journal_start(), which has ranking
> requirements similar to a semaphore.  

Something like so?

Or can journal_stop() be done by a different task than the one that did
journal_start()? - in which case nothing much can be done :-/

This seems to boot... albeit I did not push it hard.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/jbd/transaction.c |    9 +++++++++
 include/linux/jbd.h  |    5 +++++
 2 files changed, 14 insertions(+)

Index: linux-2.6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.orig/fs/jbd/transaction.c
+++ linux-2.6/fs/jbd/transaction.c
@@ -233,6 +233,8 @@ out:
 	return ret;
 }
 
+static struct lock_class_key jbd_handle_key;
+
 /* Allocate a new handle.  This should probably be in a slab... */
 static handle_t *new_handle(int nblocks)
 {
@@ -243,6 +245,8 @@ static handle_t *new_handle(int nblocks)
 	handle->h_buffer_credits = nblocks;
 	handle->h_ref = 1;
 
+	lockdep_init_map(&handle->h_lockdep_map, "jbd_handle", &jbd_handle_key, 0);
+
 	return handle;
 }
 
@@ -286,6 +290,9 @@ handle_t *journal_start(journal_t *journ
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
 	}
+
+	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+
 	return handle;
 }
 
@@ -1411,6 +1418,8 @@ int journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
+	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+
 	jbd_free_handle(handle);
 	return err;
 }
Index: linux-2.6/include/linux/jbd.h
===================================================================
--- linux-2.6.orig/include/linux/jbd.h
+++ linux-2.6/include/linux/jbd.h
@@ -30,6 +30,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
+#include <linux/lockdep.h>
 
 #include <asm/semaphore.h>
 #endif
@@ -405,6 +406,10 @@ struct handle_s
 	unsigned int	h_sync:		1;	/* sync-on-close */
 	unsigned int	h_jdata:	1;	/* force data journaling */
 	unsigned int	h_aborted:	1;	/* fatal error on handle */
+
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map	h_lockdep_map;
+#endif
 };
 
 
