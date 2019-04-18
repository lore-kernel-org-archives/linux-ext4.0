Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EED1C10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 14:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70D3E2083D
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 14:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389465AbfDROHI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:07:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389344AbfDROGb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 10:06:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C2E43094501;
        Thu, 18 Apr 2019 14:06:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EFA65D9CC;
        Thu, 18 Apr 2019 14:06:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 3/6] vfs: Allow searching of the icache under RCU
 conditions
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-ext4@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 18 Apr 2019 15:06:24 +0100
Message-ID: <155559638482.21702.10652831752816092947.stgit@warthog.procyon.org.uk>
In-Reply-To: <155559635133.21702.4737487773869377967.stgit@warthog.procyon.org.uk>
References: <155559635133.21702.4737487773869377967.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 18 Apr 2019 14:06:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Allow searching of the inode cache under RCU conditions - but with a
footnote that this is redone under lock under certain conditions.

The following changes are made:

 (1) Use hlist_add_head_rcu() and hlist_del_init_rcu() to add and remove
     an inode to/from a bucket.

 (2) In rehash_inode(), called by Coda to change the identifying parameters
     on an inode during resolution of disconnected operation, lock
     inode_hash_lock with write_seqlock(), which takes the spinlock and
     bumps the sequence counter.

 (3) Provide __find_inode_rcu() and __find_inode_by_ino rcu() which do an
     RCU-safe crawl through a hash bucket.

 (4) Provide find_inode_rcu() and find_inode_by_ino_rcu() which do a
     read_seqbegin_or_lock() conditional lock-loop on inode_hash_lock to
     cover searching the icache.  Normally this will work without needing
     to retry, but in case (4), where an inode may be moved between lists,
     we need to retry with the lock held.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/inode.c         |  202 +++++++++++++++++++++++++++++++++++++++++++++-------
 include/linux/fs.h |    3 +
 2 files changed, 176 insertions(+), 29 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cc2b08d82618..bec8fec3470a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -479,7 +479,7 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 
 	read_seqlock_excl(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_add_head(&inode->i_hash, b);
+	hlist_add_head_rcu(&inode->i_hash, b);
 	spin_unlock(&inode->i_lock);
 	read_sequnlock_excl(&inode_hash_lock);
 }
@@ -495,7 +495,7 @@ void __remove_inode_hash(struct inode *inode)
 {
 	read_seqlock_excl(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_del_init(&inode->i_hash);
+	hlist_del_init_rcu(&inode->i_hash);
 	spin_unlock(&inode->i_lock);
 	read_sequnlock_excl(&inode_hash_lock);
 }
@@ -507,6 +507,11 @@ EXPORT_SYMBOL(__remove_inode_hash);
  * @hashval: New hash value (usually inode number) to get
  * @reset: Callback used to relabel the inode
  * @data: Opaque data pointer to pass to @reset
+ *
+ * Reinsert the inode into the hash, potentially moving it between queues - but
+ * we have to be aware that someone might be trawling either list under the RCU
+ * readlock whilst we do so; to deal with this, we bump the seq counter in the
+ * hashtable lock.
  */
 void rehash_inode(struct inode *inode, unsigned long hashval,
 		  void (*reset)(struct inode *inode, unsigned long hashval, void *data),
@@ -516,9 +521,11 @@ void rehash_inode(struct inode *inode, unsigned long hashval,
 
 	write_seqlock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_del_init(&inode->i_hash);
+
+	hlist_del_init_rcu(&inode->i_hash);
 	reset(inode, hashval, data);
-	hlist_add_head(&inode->i_hash, b);
+	hlist_add_head_rcu(&inode->i_hash, b);
+
 	spin_unlock(&inode->i_lock);
 	write_sequnlock(&inode_hash_lock);
 }
@@ -806,8 +813,31 @@ long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 }
 
 static void __wait_on_freeing_inode(struct inode *inode);
+
 /*
- * Called with the inode lock held.
+ * Find an inode.  Can be called with either the RCU read lock or the
+ * inode cache lock held.  No check is made as to the validity of the
+ * inode found.
+ */
+static struct inode *__find_inode_rcu(struct super_block *sb,
+				      struct hlist_head *head,
+				      int (*test)(struct inode *, void *),
+				      void *data)
+{
+	struct inode *inode;
+
+	hlist_for_each_entry_rcu(inode, head, i_hash) {
+		if (inode->i_sb == sb &&
+		    test(inode, data))
+			return inode;
+	}
+
+	return NULL;
+}
+
+/*
+ * Called with the inode hash lock held.  Waits until dying inodes are freed,
+ * dropping the inode hash lock temporarily to do so.
  */
 static struct inode *find_inode(struct super_block *sb,
 				struct hlist_head *head,
@@ -817,11 +847,8 @@ static struct inode *find_inode(struct super_block *sb,
 	struct inode *inode = NULL;
 
 repeat:
-	hlist_for_each_entry(inode, head, i_hash) {
-		if (inode->i_sb != sb)
-			continue;
-		if (!test(inode, data))
-			continue;
+	inode = __find_inode_rcu(sb, head, test, data);
+	if (inode) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
@@ -838,6 +865,26 @@ static struct inode *find_inode(struct super_block *sb,
 	return NULL;
 }
 
+/*
+ * Find an inode by inode number.  Can be called with either the RCU
+ * read lock or the inode cache lock held.  No check is made as to the
+ * validity of the inode found.
+ */
+static struct inode *__find_inode_by_ino_rcu(struct super_block *sb,
+					     struct hlist_head *head,
+					     unsigned long ino)
+{
+	struct inode *inode;
+
+	hlist_for_each_entry_rcu(inode, head, i_hash) {
+		if (inode->i_ino == ino &&
+		    inode->i_sb == sb)
+			return inode;
+	}
+
+	return NULL;
+}
+
 /*
  * find_inode_fast is the fast path version of find_inode, see the comment at
  * iget_locked for details.
@@ -848,11 +895,8 @@ static struct inode *find_inode_fast(struct super_block *sb,
 	struct inode *inode = NULL;
 
 repeat:
-	hlist_for_each_entry(inode, head, i_hash) {
-		if (inode->i_ino != ino)
-			continue;
-		if (inode->i_sb != sb)
-			continue;
+	inode = __find_inode_by_ino_rcu(sb, head, ino);
+	if (inode) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
@@ -1105,7 +1149,7 @@ struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
 	 */
 	spin_lock(&inode->i_lock);
 	inode->i_state |= I_NEW;
-	hlist_add_head(&inode->i_hash, head);
+	hlist_add_head_rcu(&inode->i_hash, head);
 	spin_unlock(&inode->i_lock);
 	if (!creating)
 		inode_sb_list_add(inode);
@@ -1243,15 +1287,9 @@ static int test_inode_iunique(struct super_block *sb, unsigned long ino)
 	struct inode *inode;
 
 	read_seqlock_excl(&inode_hash_lock);
-	hlist_for_each_entry(inode, b, i_hash) {
-		if (inode->i_ino == ino && inode->i_sb == sb) {
-			read_sequnlock_excl(&inode_hash_lock);
-			return 0;
-		}
-	}
+	inode = __find_inode_by_ino_rcu(sb, b, ino);
 	read_sequnlock_excl(&inode_hash_lock);
-
-	return 1;
+	return inode ? 0 : 1;
 }
 
 /**
@@ -1323,6 +1361,7 @@ EXPORT_SYMBOL(igrab);
  *
  * Note: I_NEW is not waited upon so you have to be very careful what you do
  * with the returned inode.  You probably should be using ilookup5() instead.
+ * It may still sleep waiting for I_FREE and I_WILL_FREE, however.
  *
  * Note2: @test is called with the inode_hash_lock held, so can't sleep.
  */
@@ -1454,6 +1493,106 @@ struct inode *find_inode_nowait(struct super_block *sb,
 }
 EXPORT_SYMBOL(find_inode_nowait);
 
+/**
+ * find_inode_rcu - find an inode in the inode cache
+ * @sb:		Super block of file system to search
+ * @hashval:	Key to hash
+ * @test:	Function to test match on an inode
+ * @data:	Data for test function
+ *
+ * Search for the inode specified by @hashval and @data in the inode cache,
+ * where the helper function @test will return 0 if the inode does not match
+ * and 1 if it does.  The @test function must be responsible for taking the
+ * i_lock spin_lock and checking i_state for an inode being freed or being
+ * initialized.
+ *
+ * If successful, this will return the inode for which the @test function
+ * returned 1 and NULL otherwise.
+ *
+ * The @test function is not permitted to take a ref on any inode presented
+ * unless the caller is holding the inode hashtable lock.  It is also not
+ * permitted to sleep, since it may be called with the RCU read lock held.
+ *
+ * The caller must hold either the RCU read lock or the inode hashtable lock.
+ */
+struct inode *find_inode_rcu(struct super_block *sb, unsigned long hashval,
+			     int (*test)(struct inode *, void *), void *data)
+{
+	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode *inode;
+	unsigned int seq = 0;
+
+	WARN_ON(lockdep_is_held(&inode_hash_lock.lock));
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			 "suspicious find_inode_rcu() usage");
+
+	do {
+		read_seqbegin_or_lock(&inode_hash_lock, &seq);
+
+		hlist_for_each_entry_rcu(inode, head, i_hash) {
+			if (inode->i_sb == sb &&
+			    !(READ_ONCE(inode->i_state) & (I_FREEING | I_WILL_FREE)) &&
+			    test(inode, data))
+				goto done;
+		}
+	} while (need_seqretry(&inode_hash_lock, seq));
+
+	inode = NULL;
+done:
+	done_seqretry(&inode_hash_lock, seq);
+	return inode;
+}
+EXPORT_SYMBOL(find_inode_rcu);
+
+/**
+ * find_inode_by_ino_rcu - Find an inode in the inode cache
+ * @sb:		Super block of file system to search
+ * @ino:	The inode number to match
+ *
+ * Search for the inode specified by @hashval and @data in the inode cache,
+ * where the helper function @test will return 0 if the inode does not match
+ * and 1 if it does.  The @test function must be responsible for taking the
+ * i_lock spin_lock and checking i_state for an inode being freed or being
+ * initialized.
+ *
+ * If successful, this will return the inode for which the @test function
+ * returned 1 and NULL otherwise.
+ *
+ * The @test function is not permitted to take a ref on any inode presented
+ * unless the caller is holding the inode hashtable lock.  It is also not
+ * permitted to sleep, since it may be called with the RCU read lock held.
+ *
+ * The caller must hold either the RCU read lock or the inode hashtable lock.
+ */
+struct inode *find_inode_by_ino_rcu(struct super_block *sb,
+				    unsigned long ino)
+{
+	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode *inode;
+	unsigned int seq = 0;
+
+	WARN_ON(lockdep_is_held(&inode_hash_lock.lock));
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			 "suspicious find_inode_by_ino_rcu() usage");
+
+	do {
+		read_seqbegin_or_lock(&inode_hash_lock, &seq);
+
+		hlist_for_each_entry_rcu(inode, head, i_hash) {
+			if (inode->i_ino == ino &&
+			    inode->i_sb == sb &&
+			    !(READ_ONCE(inode->i_state) & (I_FREEING | I_WILL_FREE)))
+				goto done;
+		}
+	} while (need_seqretry(&inode_hash_lock, seq));
+
+	inode = NULL;
+done:
+	done_seqretry(&inode_hash_lock, seq);
+	return inode;
+}
+EXPORT_SYMBOL(find_inode_by_ino_rcu);
+
 int insert_inode_locked(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
@@ -1478,7 +1617,7 @@ int insert_inode_locked(struct inode *inode)
 		if (likely(!old)) {
 			spin_lock(&inode->i_lock);
 			inode->i_state |= I_NEW | I_CREATING;
-			hlist_add_head(&inode->i_hash, head);
+			hlist_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			read_sequnlock_excl(&inode_hash_lock);
 			return 0;
@@ -1538,6 +1677,7 @@ static void iput_final(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	const struct super_operations *op = inode->i_sb->s_op;
+	unsigned long state;
 	int drop;
 
 	WARN_ON(inode->i_state & I_NEW);
@@ -1553,16 +1693,20 @@ static void iput_final(struct inode *inode)
 		return;
 	}
 
+	state = READ_ONCE(inode->i_state);
 	if (!drop) {
-		inode->i_state |= I_WILL_FREE;
+		WRITE_ONCE(inode->i_state, state | I_WILL_FREE);
 		spin_unlock(&inode->i_lock);
+
 		write_inode_now(inode, 1);
+
 		spin_lock(&inode->i_lock);
-		WARN_ON(inode->i_state & I_NEW);
-		inode->i_state &= ~I_WILL_FREE;
+		state = READ_ONCE(inode->i_state);
+		WARN_ON(state & I_NEW);
+		state &= ~I_WILL_FREE;
 	}
 
-	inode->i_state |= I_FREEING;
+	WRITE_ONCE(inode->i_state, state | I_FREEING);
 	if (!list_empty(&inode->i_lru))
 		inode_lru_list_del(inode);
 	spin_unlock(&inode->i_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 654edbb93199..bc7b0d1356a9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2985,6 +2985,9 @@ extern struct inode *find_inode_nowait(struct super_block *,
 				       int (*match)(struct inode *,
 						    unsigned long, void *),
 				       void *data);
+extern struct inode *find_inode_rcu(struct super_block *, unsigned long,
+				    int (*)(struct inode *, void *), void *);
+extern struct inode *find_inode_by_ino_rcu(struct super_block *, unsigned long);
 extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC

