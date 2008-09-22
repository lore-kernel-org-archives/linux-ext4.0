From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 1/10] VFS: Fix error handling of write_super_lockfs/unlockfs
Date: Mon, 22 Sep 2008 19:55:26 +0900
Message-ID: <20080922195526t-sato__30814.0622023076$1222081077$gmane$org@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redh
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36798 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYIVK4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 06:56:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've changed the type of write_super_lockfs and unlockfs from "void" to
"int" so that they can return an error. 

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 Documentation/filesystems/Locking |    4 ++--
 Documentation/filesystems/vfs.txt |    4 ++--
 include/linux/fs.h                |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -uprN -X linux-2.6.27-rc7.org/Documentation/dontdiff linux-2.6.27-rc7.org/Documentation/filesystems/Locking linux-2
.6.27-rc7-lockfs/Documentation/filesystems/Locking
--- linux-2.6.27-rc7.org/Documentation/filesystems/Locking	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs/Documentation/filesystems/Locking	2008-09-22 09:53:22.000000000 +0900
@@ -97,8 +97,8 @@ prototypes:
 	void (*put_super) (struct super_block *);
 	void (*write_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
-	void (*write_super_lockfs) (struct super_block *);
-	void (*unlockfs) (struct super_block *);
+	int (*write_super_lockfs) (struct super_block *);
+	int (*unlockfs) (struct super_block *);
 	int (*statfs) (struct dentry *, struct kstatfs *);
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
diff -uprN -X linux-2.6.27-rc7.org/Documentation/dontdiff linux-2.6.27-rc7.org/Documentation/filesystems/vfs.txt linux-2
.6.27-rc7-lockfs/Documentation/filesystems/vfs.txt
--- linux-2.6.27-rc7.org/Documentation/filesystems/vfs.txt	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs/Documentation/filesystems/vfs.txt	2008-09-22 09:53:22.000000000 +0900
@@ -210,8 +210,8 @@ struct super_operations {
         void (*put_super) (struct super_block *);
         void (*write_super) (struct super_block *);
         int (*sync_fs)(struct super_block *sb, int wait);
-        void (*write_super_lockfs) (struct super_block *);
-        void (*unlockfs) (struct super_block *);
+        int (*write_super_lockfs) (struct super_block *);
+        int (*unlockfs) (struct super_block *);
         int (*statfs) (struct dentry *, struct kstatfs *);
         int (*remount_fs) (struct super_block *, int *, char *);
         void (*clear_inode) (struct inode *);
diff -uprN -X linux-2.6.27-rc7.org/Documentation/dontdiff linux-2.6.27-rc7.org/include/linux/fs.h linux-2.6.27-rc7-lockf
s/include/linux/fs.h
--- linux-2.6.27-rc7.org/include/linux/fs.h	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs/include/linux/fs.h	2008-09-22 09:53:46.000000000 +0900
@@ -1314,8 +1314,8 @@ struct super_operations {
 	void (*put_super) (struct super_block *);
 	void (*write_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
-	void (*write_super_lockfs) (struct super_block *);
-	void (*unlockfs) (struct super_block *);
+	int (*write_super_lockfs) (struct super_block *);
+	int (*unlockfs) (struct super_block *);
 	int (*statfs) (struct dentry *, struct kstatfs *);
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
