Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF5BC10F14
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 14:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A1922083D
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 14:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389267AbfDROGR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:06:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388392AbfDROGR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 10:06:17 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 18BEE70D6C;
        Thu, 18 Apr 2019 14:06:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBD2C19C58;
        Thu, 18 Apr 2019 14:06:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 1/6] vfs,
 coda: Fix the lack of locking in FID replacement inode rehashing
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@coda.cs.cmu.edu, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 18 Apr 2019 15:06:07 +0100
Message-ID: <155559636704.21702.4538723150377303298.stgit@warthog.procyon.org.uk>
In-Reply-To: <155559635133.21702.4737487773869377967.stgit@warthog.procyon.org.uk>
References: <155559635133.21702.4737487773869377967.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 18 Apr 2019 14:06:17 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When coda attempts to recover from disconnected operation, there exists the
possibility of an file created during disconnected operation not being
creatable on the server with the same file identifier (FID).  In such a
case, coda_replace_fid() has to rehash the inode and move it between chains
- but, as the comment notes, this really needs some locking.

Fix this by moving the core part of the code to fs/inode.c and providing it
with a set() function akin to iget5().  We can then take the inode cache
lock whilst performing the move.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jan Harkes <jaharkes@cs.cmu.edu>
cc: coda@cs.cmu.edu
cc: codalist@coda.cs.cmu.edu
---

 fs/coda/cnode.c    |   11 +++++++++++
 fs/inode.c         |   23 +++++++++++++++++++++++
 include/linux/fs.h |    3 +++
 3 files changed, 37 insertions(+)

diff --git a/fs/coda/cnode.c b/fs/coda/cnode.c
index 845b5a66952a..ab6ba6e00674 100644
--- a/fs/coda/cnode.c
+++ b/fs/coda/cnode.c
@@ -107,6 +107,15 @@ struct inode *coda_cnode_make(struct CodaFid *fid, struct super_block *sb)
 }
 
 
+static void coda_reset_inode(struct inode *inode, unsigned long hash, void *data)
+{
+	struct CodaFid *fid = (struct CodaFid *)data;
+	struct coda_inode_info *cii = ITOC(inode);
+
+	cii->c_fid = *fid;
+	inode->i_ino = hash;
+}
+
 /* Although we treat Coda file identifiers as immutable, there is one
  * special case for files created during a disconnection where they may
  * not be globally unique. When an identifier collision is detected we
@@ -123,6 +132,8 @@ void coda_replace_fid(struct inode *inode, struct CodaFid *oldfid,
 	
 	BUG_ON(!coda_fideq(&cii->c_fid, oldfid));
 
+	rehash_inode(inode, hash, coda_reset_inode, newfid);
+	
 	/* replace fid and rehash inode */
 	/* XXX we probably need to hold some lock here! */
 	remove_inode_hash(inode);
diff --git a/fs/inode.c b/fs/inode.c
index e9d97add2b36..00bb48ca3642 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -501,6 +501,29 @@ void __remove_inode_hash(struct inode *inode)
 }
 EXPORT_SYMBOL(__remove_inode_hash);
 
+/**
+ * rehash_inode - Relabel and rehash an inode
+ * @inode: Inode to rehash
+ * @hashval: New hash value (usually inode number) to get
+ * @reset: Callback used to relabel the inode
+ * @data: Opaque data pointer to pass to @reset
+ */
+void rehash_inode(struct inode *inode, unsigned long hashval,
+		  void (*reset)(struct inode *inode, unsigned long hashval, void *data),
+		  void *data)
+{
+	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
+
+	spin_lock(&inode_hash_lock);
+	spin_lock(&inode->i_lock);
+	hlist_del_init(&inode->i_hash);
+	reset(inode, hashval, data);
+	hlist_add_head(&inode->i_hash, b);
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&inode_hash_lock);
+}
+EXPORT_SYMBOL(rehash_inode);
+
 void clear_inode(struct inode *inode)
 {
 	/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 744908e0bdec..654edbb93199 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3020,6 +3020,9 @@ static inline void remove_inode_hash(struct inode *inode)
 		__remove_inode_hash(inode);
 }
 
+extern void rehash_inode(struct inode *, unsigned long,
+			 void (*reset)(struct inode *, unsigned long, void *), void *);
+
 extern void inode_sb_list_add(struct inode *inode);
 
 #ifdef CONFIG_BLOCK

