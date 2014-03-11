From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/49] create_inode: handle hard link inum mappings per
 populate_fs invocation
Date: Mon, 10 Mar 2014 23:54:30 -0700
Message-ID: <20140311065430.30585.46364.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32140 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaCKGye (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:54:34 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When calling populate_fs, the map for hardlink detection is not
cleaned up between populate_fs invocations, which could lead to
unexpected results if anyone calls populate_fs twice in the same
client program).  This doesn't happen right now, but we might as well
clean it up.

The detctor fails if the external directory crosses mountpoints,
so fix that too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/create_inode.c |   63 +++++++++++++++++++++++++++++++++++----------------
 misc/create_inode.h |   10 +++-----
 misc/mke2fs.c       |   12 ----------
 3 files changed, 47 insertions(+), 38 deletions(-)


diff --git a/misc/create_inode.c b/misc/create_inode.c
index 588f3f6..fc4172d 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -21,9 +21,6 @@
 #define S_BLKSIZE 512
 #endif
 
-/* For saving the hard links */
-int hdlink_cnt = HDLINK_CNT;
-
 /* Link an inode number to a directory */
 static errcode_t add_link(ext2_filsys fs, ext2_ino_t parent_ino,
 			  ext2_ino_t ino, const char *name)
@@ -331,12 +328,13 @@ fail:
 	return retval;
 }
 
-static int is_hardlink(ext2_ino_t ino)
+static int is_hardlink(struct hdlinks_s *hdlinks, dev_t dev, ino_t ino)
 {
 	int i;
 
-	for(i = 0; i < hdlinks.count; i++) {
-		if(hdlinks.hdl[i].src_ino == ino)
+	for (i = 0; i < hdlinks->count; i++) {
+		if (hdlinks->hdl[i].src_dev == dev &&
+		    hdlinks->hdl[i].src_ino == ino)
 			return i;
 	}
 	return -1;
@@ -458,8 +456,9 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 }
 
 /* Copy files from source_dir to fs */
-errcode_t populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
-		      const char *source_dir, ext2_ino_t root)
+static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
+			       const char *source_dir, ext2_ino_t root,
+			       struct hdlinks_s *hdlinks)
 {
 	const char	*name;
 	DIR		*dh;
@@ -496,10 +495,10 @@ errcode_t populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 		save_inode = 0;
 		if (!S_ISDIR(st.st_mode) && !S_ISLNK(st.st_mode) &&
 		    st.st_nlink > 1) {
-			hdlink = is_hardlink(st.st_ino);
+			hdlink = is_hardlink(hdlinks, st.st_dev, st.st_ino);
 			if (hdlink >= 0) {
 				retval = add_link(fs, parent_ino,
-						  hdlinks.hdl[hdlink].dst_ino,
+						  hdlinks->hdl[hdlink].dst_ino,
 						  name);
 				if (retval) {
 					com_err(__func__, retval,
@@ -571,7 +570,7 @@ errcode_t populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 					return retval;
 			}
 			/* Populate the dir recursively*/
-			retval = populate_fs(fs, ino, name, root);
+			retval = __populate_fs(fs, ino, name, root, hdlinks);
 			if (retval) {
 				com_err(__func__, retval,
 					_("while adding dir \"%s\""), name);
@@ -608,20 +607,44 @@ errcode_t populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 			 * free() since the lifespan will be over after the fs
 			 * populated.
 			 */
-			if (hdlinks.count == hdlink_cnt) {
-				if ((hdlinks.hdl = realloc (hdlinks.hdl,
-						(hdlink_cnt + HDLINK_CNT) *
-						sizeof (struct hdlink_s))) == NULL) {
-					com_err(name, errno, "Not enough memory");
+			if (hdlinks->count == hdlinks->size) {
+				void *p = realloc(hdlinks->hdl,
+						(hdlinks->size + HDLINK_CNT) *
+						sizeof(struct hdlink_s));
+				if (p == NULL) {
+					com_err(name, errno,
+						_("Not enough memory"));
 					return errno;
 				}
-				hdlink_cnt += HDLINK_CNT;
+				hdlinks->hdl = p;
+				hdlinks->size += HDLINK_CNT;
 			}
-			hdlinks.hdl[hdlinks.count].src_ino = st.st_ino;
-			hdlinks.hdl[hdlinks.count].dst_ino = ino;
-			hdlinks.count++;
+			hdlinks->hdl[hdlinks->count].src_dev = st.st_dev;
+			hdlinks->hdl[hdlinks->count].src_ino = st.st_ino;
+			hdlinks->hdl[hdlinks->count].dst_ino = ino;
+			hdlinks->count++;
 		}
 	}
 	closedir(dh);
 	return retval;
 }
+
+errcode_t populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
+		      const char *source_dir, ext2_ino_t root)
+{
+	struct hdlinks_s hdlinks;
+	errcode_t retval;
+
+	hdlinks.count = 0;
+	hdlinks.size = HDLINK_CNT;
+	hdlinks.hdl = realloc(NULL, hdlinks.size * sizeof(struct hdlink_s));
+	if (hdlinks.hdl == NULL) {
+		com_err(__func__, errno, "Not enough memory");
+		return errno;
+	}
+
+	retval = __populate_fs(fs, parent_ino, source_dir, root, &hdlinks);
+
+	free(hdlinks.hdl);
+	return retval;
+}
diff --git a/misc/create_inode.h b/misc/create_inode.h
index fd96910..067bf96 100644
--- a/misc/create_inode.h
+++ b/misc/create_inode.h
@@ -11,21 +11,19 @@
 
 struct hdlink_s
 {
-	ext2_ino_t src_ino;
+	dev_t src_dev;
+	ino_t src_ino;
 	ext2_ino_t dst_ino;
 };
 
 struct hdlinks_s
 {
 	int count;
+	int size;
 	struct hdlink_s *hdl;
 };
 
-struct hdlinks_s hdlinks;
-
-/* For saving the hard links */
-#define HDLINK_CNT     4
-extern int hdlink_cnt;
+#define HDLINK_CNT	(4)
 
 /* For populating the filesystem */
 extern errcode_t populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 1422336..aecd5d5 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2988,18 +2988,6 @@ no_journal:
 		if (!quiet)
 			printf("%s", _("Copying files into the device: "));
 
-		/*
-		 * Allocate memory for the hardlinks, we don't need free()
-		 * since the lifespan will be over after the fs populated.
-		 */
-		if ((hdlinks.hdl = (struct hdlink_s *)
-				malloc(hdlink_cnt * sizeof(struct hdlink_s))) == NULL) {
-			fprintf(stderr, "%s", _("\nNot enough memory\n"));
-			retval = ext2fs_close(fs);
-			return retval;
-		}
