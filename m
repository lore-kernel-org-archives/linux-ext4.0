From: Vasily Averin <vvs@sw.ru>
Subject: [PATCH ext3/ext4] lost brelse in ext3_read_inode
Date: Sat, 02 Jun 2007 16:40:13 +0400
Message-ID: <4661652D.9040404@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org,
	linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
	adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:7445 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506AbXFBMki (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Jun 2007 08:40:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From:	Kirill Korotaev <dev@openvz.org>

One of error path in ext3_read_inode() leaks bh since brelse is forgoten.

Signed-Off-By:	Kirill Korotaev <dev@openvz.org>
Acked-by:	Vasily Averin <vvs@sw.ru>

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index a6cb617..2a85dde 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2677,8 +2677,10 @@ void ext3_read_inode(struct inode * inode)
 		 */
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT3_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
-		    EXT3_INODE_SIZE(inode->i_sb))
+		    EXT3_INODE_SIZE(inode->i_sb)) {
+			brelse (bh);
 			goto bad_inode;
+		}
 		if (ei->i_extra_isize == 0) {
 			/* The extra space is currently unused. Use it. */
 			ei->i_extra_isize = sizeof(struct ext3_inode) -
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b34182b..0cd7bc4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2673,8 +2673,10 @@ void ext4_read_inode(struct inode * inode)
 		 */
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
-		    EXT4_INODE_SIZE(inode->i_sb))
+		    EXT4_INODE_SIZE(inode->i_sb)) {
+			brelse (bh);
 			goto bad_inode;
+		}
 		if (ei->i_extra_isize == 0) {
 			/* The extra space is currently unused. Use it. */
 			ei->i_extra_isize = sizeof(struct ext4_inode) -
