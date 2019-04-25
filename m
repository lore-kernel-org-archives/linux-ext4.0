Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67207C43219
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B8062084F
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbfDYPCa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:02:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfDYPCa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 Apr 2019 11:02:30 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF6A73164680;
        Thu, 25 Apr 2019 15:02:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA6D760BE5;
        Thu, 25 Apr 2019 15:02:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 5/6] ext4: Search for an inode to update under the RCU lock
 if we can [ver #2]
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 25 Apr 2019 16:02:26 +0100
Message-ID: <155620454692.4720.7259353879500966035.stgit@warthog.procyon.org.uk>
In-Reply-To: <155620449631.4720.8762546550728087460.stgit@warthog.procyon.org.uk>
References: <155620449631.4720.8762546550728087460.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 25 Apr 2019 15:02:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When we're updating timestamps in an inode, search for that inode under RCU
conditions to avoid holding the icache lock if we can.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "Theodore Ts'o" <tytso@mit.edu>
cc: Andreas Dilger <adilger.kernel@dilger.ca>
cc: linux-ext4@vger.kernel.org
---

 fs/ext4/inode.c |   54 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b32a57bc5d5d..b1eb55d5c329 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5144,41 +5144,43 @@ static int ext4_inode_blocks_set(handle_t *handle,
 	return 0;
 }
 
-struct other_inode {
-	unsigned long		orig_ino;
-	struct ext4_inode	*raw_inode;
-};
-
-static int other_inode_match(struct inode * inode, unsigned long ino,
-			     void *data)
+static void __ext4_update_other_inode_time(struct super_block *sb,
+					   unsigned long orig_ino,
+					   unsigned long ino,
+					   struct ext4_inode *raw_inode)
 {
-	struct other_inode *oi = (struct other_inode *) data;
+	struct inode *inode;
+	unsigned long state;
+
+	inode = find_inode_by_ino_rcu(sb, ino);
+	if (!inode)
+		return;
 
+	state = READ_ONCE(inode->i_state);
 	if ((inode->i_ino != ino) ||
-	    (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
-			       I_DIRTY_INODE)) ||
-	    ((inode->i_state & I_DIRTY_TIME) == 0))
-		return 0;
+	    (state & (I_FREEING | I_WILL_FREE | I_NEW | I_DIRTY_INODE)) ||
+	    ((state & I_DIRTY_TIME) == 0))
+		return;
+
 	spin_lock(&inode->i_lock);
-	if (((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
-				I_DIRTY_INODE)) == 0) &&
-	    (inode->i_state & I_DIRTY_TIME)) {
+	state = READ_ONCE(inode->i_state);
+	if (((state & (I_FREEING | I_WILL_FREE | I_NEW | I_DIRTY_INODE)) == 0) &&
+	    (state & I_DIRTY_TIME)) {
 		struct ext4_inode_info	*ei = EXT4_I(inode);
 
 		inode->i_state &= ~(I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED);
 		spin_unlock(&inode->i_lock);
 
 		spin_lock(&ei->i_raw_lock);
-		EXT4_INODE_SET_XTIME(i_ctime, inode, oi->raw_inode);
-		EXT4_INODE_SET_XTIME(i_mtime, inode, oi->raw_inode);
-		EXT4_INODE_SET_XTIME(i_atime, inode, oi->raw_inode);
-		ext4_inode_csum_set(inode, oi->raw_inode, ei);
+		EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
+		EXT4_INODE_SET_XTIME(i_mtime, inode, raw_inode);
+		EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
+		ext4_inode_csum_set(inode, raw_inode, ei);
 		spin_unlock(&ei->i_raw_lock);
-		trace_ext4_other_inode_update_time(inode, oi->orig_ino);
-		return -1;
+		trace_ext4_other_inode_update_time(inode, orig_ino);
+		return;
 	}
 	spin_unlock(&inode->i_lock);
-	return -1;
 }
 
 /*
@@ -5188,24 +5190,24 @@ static int other_inode_match(struct inode * inode, unsigned long ino,
 static void ext4_update_other_inodes_time(struct super_block *sb,
 					  unsigned long orig_ino, char *buf)
 {
-	struct other_inode oi;
 	unsigned long ino;
 	int i, inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
 	int inode_size = EXT4_INODE_SIZE(sb);
 
-	oi.orig_ino = orig_ino;
 	/*
 	 * Calculate the first inode in the inode table block.  Inode
 	 * numbers are one-based.  That is, the first inode in a block
 	 * (assuming 4k blocks and 256 byte inodes) is (n*16 + 1).
 	 */
 	ino = ((orig_ino - 1) & ~(inodes_per_block - 1)) + 1;
+	rcu_read_lock();
 	for (i = 0; i < inodes_per_block; i++, ino++, buf += inode_size) {
 		if (ino == orig_ino)
 			continue;
-		oi.raw_inode = (struct ext4_inode *) buf;
-		(void) find_inode_nowait(sb, ino, other_inode_match, &oi);
+		__ext4_update_other_inode_time(sb, orig_ino, ino,
+					       (struct ext4_inode *)buf);
 	}
+	rcu_read_unlock();
 }
 
 /*

