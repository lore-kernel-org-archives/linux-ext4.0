From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/9] rw_semaphore: remove up/down_read_non_owner
Date: Fri, 24 Jun 2011 14:29:44 -0400
Message-ID: <20110624183207.729955463@bombadil.infradead.org>
References: <20110624182939.401012221@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline; filename=remove-rw_semaphore-non_owner
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Now that the last users is gone these can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/include/linux/rwsem.h
===================================================================
--- linux-2.6.orig/include/linux/rwsem.h	2011-06-24 14:30:21.571735905 +0200
+++ linux-2.6/include/linux/rwsem.h	2011-06-24 15:02:14.854972359 +0200
@@ -124,19 +124,9 @@ extern void downgrade_write(struct rw_se
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
-/*
- * Take/release a lock when not the owner will release it.
- *
- * [ This API should be avoided as much as possible - the
- *   proper abstraction for this case is completions. ]
- */
-extern void down_read_non_owner(struct rw_semaphore *sem);
-extern void up_read_non_owner(struct rw_semaphore *sem);
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
-# define down_read_non_owner(sem)		down_read(sem)
-# define up_read_non_owner(sem)			up_read(sem)
 #endif
 
 #endif /* _LINUX_RWSEM_H */
Index: linux-2.6/kernel/rwsem.c
===================================================================
--- linux-2.6.orig/kernel/rwsem.c	2011-06-24 14:30:21.588402571 +0200
+++ linux-2.6/kernel/rwsem.c	2011-06-24 15:02:14.854972359 +0200
@@ -117,15 +117,6 @@ void down_read_nested(struct rw_semaphor
 
 EXPORT_SYMBOL(down_read_nested);
 
-void down_read_non_owner(struct rw_semaphore *sem)
-{
-	might_sleep();
-
-	__down_read(sem);
-}
-
-EXPORT_SYMBOL(down_read_non_owner);
-
 void down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	might_sleep();
@@ -136,13 +127,6 @@ void down_write_nested(struct rw_semapho
 
 EXPORT_SYMBOL(down_write_nested);
 
-void up_read_non_owner(struct rw_semaphore *sem)
-{
-	__up_read(sem);
-}
-
-EXPORT_SYMBOL(up_read_non_owner);
-
 #endif
 
 

