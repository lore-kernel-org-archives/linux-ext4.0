Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7397C43218
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF3BC2084F
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfDYPCH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:02:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfDYPCH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 Apr 2019 11:02:07 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 74E33316EB65;
        Thu, 25 Apr 2019 15:02:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86210600C1;
        Thu, 25 Apr 2019 15:01:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/6] vfs: Change inode_hash_lock to a seqlock [ver #2]
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-ext4@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 25 Apr 2019 16:01:57 +0100
Message-ID: <155620451767.4720.690941185186112797.stgit@warthog.procyon.org.uk>
In-Reply-To: <155620449631.4720.8762546550728087460.stgit@warthog.procyon.org.uk>
References: <155620449631.4720.8762546550728087460.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 25 Apr 2019 15:02:06 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Change inode_hash_lock to a seqlock so that a subsequent patch can try
doing lockless searches of the icache, but we can still force a retry under
lock by bumping the sequence counter.

For the moment, all locking is done with read_seqlock_excl(), which is just
a wrapper around spin_lock() and doesn't bump the sequence counter at all.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/inode.c |   62 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 00bb48ca3642..cc2b08d82618 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -56,7 +56,7 @@
 static unsigned int i_hash_mask __read_mostly;
 static unsigned int i_hash_shift __read_mostly;
 static struct hlist_head *inode_hashtable __read_mostly;
-static __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_hash_lock);
+static __cacheline_aligned_in_smp DEFINE_SEQLOCK(inode_hash_lock);
 
 /*
  * Empty aops. Can be used for the cases where the user does not
@@ -477,11 +477,11 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
 	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
-	spin_lock(&inode_hash_lock);
+	read_seqlock_excl(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
 	hlist_add_head(&inode->i_hash, b);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_hash_lock);
+	read_sequnlock_excl(&inode_hash_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
 
@@ -493,11 +493,11 @@ EXPORT_SYMBOL(__insert_inode_hash);
  */
 void __remove_inode_hash(struct inode *inode)
 {
-	spin_lock(&inode_hash_lock);
+	read_seqlock_excl(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_hash_lock);
+	read_sequnlock_excl(&inode_hash_lock);
 }
 EXPORT_SYMBOL(__remove_inode_hash);
 
@@ -514,13 +514,13 @@ void rehash_inode(struct inode *inode, unsigned long hashval,
 {
 	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
-	spin_lock(&inode_hash_lock);
+	write_seqlock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
 	hlist_del_init(&inode->i_hash);
 	reset(inode, hashval, data);
 	hlist_add_head(&inode->i_hash, b);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_hash_lock);
+	write_sequnlock(&inode_hash_lock);
 }
 EXPORT_SYMBOL(rehash_inode);
 
@@ -1076,14 +1076,14 @@ struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
 	bool creating = inode->i_state & I_CREATING;
 
 again:
-	spin_lock(&inode_hash_lock);
+	read_seqlock_excl(&inode_hash_lock);
 	old = find_inode(inode->i_sb, head, test, data);
 	if (unlikely(old)) {
 		/*
 		 * Uhhuh, somebody else created the same inode under us.
 		 * Use the old inode instead of the preallocated one.
 		 */
-		spin_unlock(&inode_hash_lock);
+		read_sequnlock_excl(&inode_hash_lock);
 		if (IS_ERR(old))
 			return NULL;
 		wait_on_inode(old);
@@ -1110,7 +1110,7 @@ struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
 	if (!creating)
 		inode_sb_list_add(inode);
 unlock:
-	spin_unlock(&inode_hash_lock);
+	read_sequnlock_excl(&inode_hash_lock);
 
 	return inode;
 }
@@ -1174,9 +1174,9 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 again:
-	spin_lock(&inode_hash_lock);
+	read_seqlock_excl(&inode_hash_lock);
 	inode = find_inode_fast(sb, head, ino);
-	spin_unlock(&inode_hash_lock);
+	read_sequnlock_excl(&inode_hash_lock);
 	if (inode) {
 		if (IS_ERR(inode))
 			return NULL;
@@ -1192,17 +1192,17 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_hash_lock);
+		read_seqlock_excl(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
 			inode->i_ino = ino;
 			spin_lock(&inode->i_lock);
 			inode->i_state = I_NEW;
-			hlist_add_head(&inode->i_hash, head);
+			hlist_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
-			spin_unlock(&inode_hash_lock);
+			read_sequnlock_excl(&inode_hash_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -1215,7 +1215,7 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_unlock(&inode_hash_lock);
+		read_sequnlock_excl(&inode_hash_lock);
 		destroy_inode(inode);
 		if (IS_ERR(old))
 			return NULL;
@@ -1242,14 +1242,14 @@ static int test_inode_iunique(struct super_block *sb, unsigned long ino)
 	struct hlist_head *b = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
+	read_seqlock_excl(&inode_hash_lock);
 	hlist_for_each_entry(inode, b, i_hash) {
 		if (inode->i_ino == ino && inode->i_sb == sb) {
-			spin_unlock(&inode_hash_lock);
+			read_sequnlock_excl(&inode_hash_lock);
 			return 0;
 		}
 	}
-	spin_unlock(&inode_hash_lock);
+	read_sequnlock_excl(&inode_hash_lock);
 
 	return 1;
 }
@@ -1332,9 +1332,9 @@ struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
+	read_seqlock_excl(&inode_hash_lock);
 	inode = find_inode(sb, head, test, data);
-	spin_unlock(&inode_hash_lock);
+	read_sequnlock_excl(&inode_hash_lock);
 
 	return IS_ERR(inode) ? NULL : inode;
 }
@@ -1387,9 +1387,9 @@ struct inode *ilookup(struct super_block *sb, unsigned long ino)
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 again:
-	spin_lock(&inode_hash_lock);
+	read_seqlock_excl(&inode_hash_lock);
 	inode = find_inode_fast(sb, head, ino);
-	spin_unlock(&inode_hash_lock);
+	read_sequnlock_excl(&inode_hash_lock);
 
 	if (inode) {
 		if (IS_ERR(inode))
@@ -1437,7 +1437,7 @@ struct inode *find_inode_nowait(struct super_block *sb,
 	struct inode *inode, *ret_inode = NULL;
 	int mval;
 
-	spin_lock(&inode_hash_lock);
+	read_seqlock_excl(&inode_hash_lock);
 	hlist_for_each_entry(inode, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
@@ -1449,7 +1449,7 @@ struct inode *find_inode_nowait(struct super_block *sb,
 		goto out;
 	}
 out:
-	spin_unlock(&inode_hash_lock);
+	read_sequnlock_excl(&inode_hash_lock);
 	return ret_inode;
 }
 EXPORT_SYMBOL(find_inode_nowait);
@@ -1462,7 +1462,7 @@ int insert_inode_locked(struct inode *inode)
 
 	while (1) {
 		struct inode *old = NULL;
-		spin_lock(&inode_hash_lock);
+		read_seqlock_excl(&inode_hash_lock);
 		hlist_for_each_entry(old, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
@@ -1480,17 +1480,17 @@ int insert_inode_locked(struct inode *inode)
 			inode->i_state |= I_NEW | I_CREATING;
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_hash_lock);
+			read_sequnlock_excl(&inode_hash_lock);
 			return 0;
 		}
 		if (unlikely(old->i_state & I_CREATING)) {
 			spin_unlock(&old->i_lock);
-			spin_unlock(&inode_hash_lock);
+			read_sequnlock_excl(&inode_hash_lock);
 			return -EBUSY;
 		}
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_hash_lock);
+		read_sequnlock_excl(&inode_hash_lock);
 		wait_on_inode(old);
 		if (unlikely(!inode_unhashed(old))) {
 			iput(old);
@@ -1932,10 +1932,10 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_hash_lock);
+	read_sequnlock_excl(&inode_hash_lock);
 	schedule();
 	finish_wait(wq, &wait.wq_entry);
-	spin_lock(&inode_hash_lock);
+	read_seqlock_excl(&inode_hash_lock);
 }
 
 static __initdata unsigned long ihash_entries;

