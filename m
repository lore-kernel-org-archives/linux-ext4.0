From: Pavel Emelyanov <xemul@openvz.org>
Subject: [PATCH] A request to reserve a "tree id" field on ext[34] inodes
Date: Tue, 17 Nov 2009 17:04:59 +0300
Message-ID: <4B02AD8B.2030202@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dmitri Monakhov <dmonakhov@openvz.org>
To: Andreas Dilger <adilger@sun.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:27771 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZKQOFU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Nov 2009 09:05:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

We have a proposal to implement a 2-level disk quota on ext3 and ext4.

In two words - the aim is to have directories on ext3/4 partitions
which are limited by its disk usage and the number of inodes. Further
the plan is to allow configuring uid and gid quotas within them.

The main usage of this is containers. When two or more of them are
located on one disk their roots will be marked with a unique tree id
and thus the disk consumption of each container will be limited. While
achieving this goal having an id of what tree an inode belongs to is
a key requirement. 

So first we would like to ask to reserve a place on ext3 and ext4 inodes
for that ID.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 26d3cf8..0fda97c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -471,7 +471,7 @@ struct ext4_inode {
 			__le16	l_i_file_acl_high;
 			__le16	l_i_uid_high;	/* these 2 fields */
 			__le16	l_i_gid_high;	/* were reserved2[0] */
-			__u32	l_i_reserved2;
+			__u32	l_i_tree_id;	/* reserved for 2-level disk quota */
 		} linux2;
 		struct {
 			__le16	h_i_reserved1;	/* Obsoleted fragment number/size which are removed in ext4 */
@@ -585,7 +585,7 @@ do {									       \
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
-#define i_reserved2	osd2.linux2.l_i_reserved2
+#define i_tree_id	osd2.linux2.l_i_tree_id
 
 #elif defined(__GNU__)
 
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 7499b36..d9f633d 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -320,7 +320,7 @@ struct ext3_inode {
 			__u16	i_pad1;
 			__le16	l_i_uid_high;	/* these 2 fields    */
 			__le16	l_i_gid_high;	/* were reserved2[0] */
-			__u32	l_i_reserved2;
+			__u32	l_i_tree_id;	/* reserved for 2-level disk quota */
 		} linux2;
 		struct {
 			__u8	h_i_frag;	/* Fragment number */
@@ -351,7 +351,7 @@ struct ext3_inode {
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
-#define i_reserved2	osd2.linux2.l_i_reserved2
+#define i_tree_id	osd2.linux2.l_i_tree_id
 
 #elif defined(__GNU__)
 
