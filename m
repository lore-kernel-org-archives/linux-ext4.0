Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C842C10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 14:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 352832083D
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 14:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389425AbfDROGx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:06:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389153AbfDROGv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 10:06:51 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 926A83094501;
        Thu, 18 Apr 2019 14:06:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB7A519C58;
        Thu, 18 Apr 2019 14:06:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 5/6] ext4: Search for an inode to update under the RCU
 lock if we can
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 18 Apr 2019 15:06:44 +0100
Message-ID: <155559640398.21702.15109713276957584268.stgit@warthog.procyon.org.uk>
In-Reply-To: <155559635133.21702.4737487773869377967.stgit@warthog.procyon.org.uk>
References: <155559635133.21702.4737487773869377967.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 18 Apr 2019 14:06:51 +0000 (UTC)
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

 fs/ext4/inode.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b32a57bc5d5d..13e928ae70e5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5144,21 +5144,23 @@ static int ext4_inode_blocks_set(handle_t *handle,
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
+
+	inode = find_inode_by_ino_rcu(sb, ino);
+	if (!inode)
+		return;
 
 	if ((inode->i_ino != ino) ||
 	    (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
 			       I_DIRTY_INODE)) ||
 	    ((inode->i_state & I_DIRTY_TIME) == 0))
-		return 0;
+		return;
+
 	spin_lock(&inode->i_lock);
 	if (((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
 				I_DIRTY_INODE)) == 0) &&
@@ -5169,16 +5171,15 @@ static int other_inode_match(struct inode * inode, unsigned long ino,
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
@@ -5188,24 +5189,24 @@ static int other_inode_match(struct inode * inode, unsigned long ino,
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

