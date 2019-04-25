Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A165C43219
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DBBA20891
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfDYPCj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:02:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbfDYPCi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 Apr 2019 11:02:38 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 863469D1FB;
        Thu, 25 Apr 2019 15:02:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF77119729;
        Thu, 25 Apr 2019 15:02:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 6/6] vfs: Delete find_inode_nowait() [ver #2]
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-ext4@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 25 Apr 2019 16:02:35 +0100
Message-ID: <155620455515.4720.15278931349424987474.stgit@warthog.procyon.org.uk>
In-Reply-To: <155620449631.4720.8762546550728087460.stgit@warthog.procyon.org.uk>
References: <155620449631.4720.8762546550728087460.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 25 Apr 2019 15:02:38 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Delete find_inode_nowait() as it's no longer used.
---

 fs/inode.c         |   50 --------------------------------------------------
 include/linux/fs.h |    5 -----
 2 files changed, 55 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index f13e2db7cc1d..6aae3aa7aa9a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1443,56 +1443,6 @@ struct inode *ilookup(struct super_block *sb, unsigned long ino)
 }
 EXPORT_SYMBOL(ilookup);
 
-/**
- * find_inode_nowait - find an inode in the inode cache
- * @sb:		super block of file system to search
- * @hashval:	hash value (usually inode number) to search for
- * @match:	callback used for comparisons between inodes
- * @data:	opaque data pointer to pass to @match
- *
- * Search for the inode specified by @hashval and @data in the inode
- * cache, where the helper function @match will return 0 if the inode
- * does not match, 1 if the inode does match, and -1 if the search
- * should be stopped.  The @match function must be responsible for
- * taking the i_lock spin_lock and checking i_state for an inode being
- * freed or being initialized, and incrementing the reference count
- * before returning 1.  It also must not sleep, since it is called with
- * the inode_hash_lock spinlock held.
- *
- * This is a even more generalized version of ilookup5() when the
- * function must never block --- find_inode() can block in
- * __wait_on_freeing_inode() --- or when the caller can not increment
- * the reference count because the resulting iput() might cause an
- * inode eviction.  The tradeoff is that the @match funtion must be
- * very carefully implemented.
- */
-struct inode *find_inode_nowait(struct super_block *sb,
-				unsigned long hashval,
-				int (*match)(struct inode *, unsigned long,
-					     void *),
-				void *data)
-{
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
-	struct inode *inode, *ret_inode = NULL;
-	int mval;
-
-	read_seqlock_excl(&inode_hash_lock);
-	hlist_for_each_entry(inode, head, i_hash) {
-		if (inode->i_sb != sb)
-			continue;
-		mval = match(inode, hashval, data);
-		if (mval == 0)
-			continue;
-		if (mval == 1)
-			ret_inode = inode;
-		goto out;
-	}
-out:
-	read_sequnlock_excl(&inode_hash_lock);
-	return ret_inode;
-}
-EXPORT_SYMBOL(find_inode_nowait);
-
 /**
  * find_inode_rcu - find an inode in the inode cache
  * @sb:		Super block of file system to search
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d252242b0ac0..3e8689ff3a2f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2979,11 +2979,6 @@ extern struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
 		void *data);
 extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
 extern struct inode * iget_locked(struct super_block *, unsigned long);
-extern struct inode *find_inode_nowait(struct super_block *,
-				       unsigned long,
-				       int (*match)(struct inode *,
-						    unsigned long, void *),
-				       void *data);
 extern struct inode *find_inode_rcu(struct super_block *, unsigned long,
 				    int (*)(struct inode *, void *), void *);
 extern struct inode *find_inode_by_ino_rcu(struct super_block *, unsigned long);

