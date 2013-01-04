From: Chen Gang <gang.chen@asianux.com>
Subject: [PATCH v3] fs/ext*,f2fs,jffs2,reiserfs: give comments for acl size
 and count calculation
Date: Fri, 04 Jan 2013 11:26:53 +0800
Message-ID: <50E64BFD.6090000@asianux.com>
References: <50DD20B2.6040204@asianux.com> <50E646BC.2090201@asianux.com> <50E64A4E.7010408@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	Theodore Ts'o <tytso@mit.edu>, jaegeuk.kim@samsung.com,
	dwmw2@infradead.org, torvalds@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <50E64A4E.7010408@asianux.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


  give comments (by Theodore Ts'o)

    ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK[2] ACL_OTHER

    [1] Where * is the regexp sense of "0 or more times"
    [2] Only if there is at least one ACL_USER or ACL_GROUP tag;
        otherwise skip ACL_MASK.

  give comments (by Jan Kara)
    posix_acl_valid() makes sure that if there are <= 4 ACL entries, then
    all of them are short. Otherwise exactly 4 entries are short ones and
    other have full length. See comment before that function for exact ACL
    format.

  use macro instead of hard code number (by Chen Gang)

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 fs/ext2/acl.h             |   10 +++++-----
 fs/ext3/acl.h             |   10 +++++-----
 fs/ext4/acl.h             |   10 +++++-----
 fs/f2fs/acl.c             |   12 +++++++-----
 fs/jffs2/acl.c            |   15 +++++++++------
 fs/posix_acl.c            |    8 ++++++++
 fs/reiserfs/acl.h         |   10 +++++-----
 include/linux/posix_acl.h |    8 ++++++++
 8 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/fs/ext2/acl.h b/fs/ext2/acl.h
index 503bfb0..9af79d0 100644
--- a/fs/ext2/acl.h
+++ b/fs/ext2/acl.h
@@ -25,13 +25,13 @@ typedef struct {
 
 static inline size_t ext2_acl_size(int count)
 {
-	if (count <= 4) {
+	if (count <= ACL_MAX_SHORT_ENTRY) {
 		return sizeof(ext2_acl_header) +
 		       count * sizeof(ext2_acl_entry_short);
 	} else {
 		return sizeof(ext2_acl_header) +
-		       4 * sizeof(ext2_acl_entry_short) +
-		       (count - 4) * sizeof(ext2_acl_entry);
+		       ACL_MAX_SHORT_ENTRY * sizeof(ext2_acl_entry_short) +
+		       (count - ACL_MAX_SHORT_ENTRY) * sizeof(ext2_acl_entry);
 	}
 }
 
@@ -39,7 +39,7 @@ static inline int ext2_acl_count(size_t size)
 {
 	ssize_t s;
 	size -= sizeof(ext2_acl_header);
-	s = size - 4 * sizeof(ext2_acl_entry_short);
+	s = size - ACL_MAX_SHORT_ENTRY * sizeof(ext2_acl_entry_short);
 	if (s < 0) {
 		if (size % sizeof(ext2_acl_entry_short))
 			return -1;
@@ -47,7 +47,7 @@ static inline int ext2_acl_count(size_t size)
 	} else {
 		if (s % sizeof(ext2_acl_entry))
 			return -1;
-		return s / sizeof(ext2_acl_entry) + 4;
+		return s / sizeof(ext2_acl_entry) + ACL_MAX_SHORT_ENTRY;
 	}
 }
 
diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
index dbc921e..b1cf2c0 100644
--- a/fs/ext3/acl.h
+++ b/fs/ext3/acl.h
@@ -25,13 +25,13 @@ typedef struct {
 
 static inline size_t ext3_acl_size(int count)
 {
-	if (count <= 4) {
+	if (count <= ACL_MAX_SHORT_ENTRY) {
 		return sizeof(ext3_acl_header) +
 		       count * sizeof(ext3_acl_entry_short);
 	} else {
 		return sizeof(ext3_acl_header) +
-		       4 * sizeof(ext3_acl_entry_short) +
-		       (count - 4) * sizeof(ext3_acl_entry);
+		       ACL_MAX_SHORT_ENTRY * sizeof(ext3_acl_entry_short) +
+		       (count - ACL_MAX_SHORT_ENTRY) * sizeof(ext3_acl_entry);
 	}
 }
 
@@ -39,7 +39,7 @@ static inline int ext3_acl_count(size_t size)
 {
 	ssize_t s;
 	size -= sizeof(ext3_acl_header);
-	s = size - 4 * sizeof(ext3_acl_entry_short);
+	s = size - ACL_MAX_SHORT_ENTRY * sizeof(ext3_acl_entry_short);
 	if (s < 0) {
 		if (size % sizeof(ext3_acl_entry_short))
 			return -1;
@@ -47,7 +47,7 @@ static inline int ext3_acl_count(size_t size)
 	} else {
 		if (s % sizeof(ext3_acl_entry))
 			return -1;
-		return s / sizeof(ext3_acl_entry) + 4;
+		return s / sizeof(ext3_acl_entry) + ACL_MAX_SHORT_ENTRY;
 	}
 }
 
diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 18cb39e..66d1fa3 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -25,13 +25,13 @@ typedef struct {
 
 static inline size_t ext4_acl_size(int count)
 {
-	if (count <= 4) {
+	if (count <= ACL_MAX_SHORT_ENTRY) {
 		return sizeof(ext4_acl_header) +
 		       count * sizeof(ext4_acl_entry_short);
 	} else {
 		return sizeof(ext4_acl_header) +
-		       4 * sizeof(ext4_acl_entry_short) +
-		       (count - 4) * sizeof(ext4_acl_entry);
+		       ACL_MAX_SHORT_ENTRY * sizeof(ext4_acl_entry_short) +
+		       (count - ACL_MAX_SHORT_ENTRY) * sizeof(ext4_acl_entry);
 	}
 }
 
@@ -39,7 +39,7 @@ static inline int ext4_acl_count(size_t size)
 {
 	ssize_t s;
 	size -= sizeof(ext4_acl_header);
-	s = size - 4 * sizeof(ext4_acl_entry_short);
+	s = size - ACL_MAX_SHORT_ENTRY * sizeof(ext4_acl_entry_short);
 	if (s < 0) {
 		if (size % sizeof(ext4_acl_entry_short))
 			return -1;
@@ -47,7 +47,7 @@ static inline int ext4_acl_count(size_t size)
 	} else {
 		if (s % sizeof(ext4_acl_entry))
 			return -1;
-		return s / sizeof(ext4_acl_entry) + 4;
+		return s / sizeof(ext4_acl_entry) + ACL_MAX_SHORT_ENTRY;
 	}
 }
 
diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index fed74d1..42e0070 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -22,13 +22,15 @@
 
 static inline size_t f2fs_acl_size(int count)
 {
-	if (count <= 4) {
+	if (count <= ACL_MAX_SHORT_ENTRY) {
 		return sizeof(struct f2fs_acl_header) +
 			count * sizeof(struct f2fs_acl_entry_short);
 	} else {
 		return sizeof(struct f2fs_acl_header) +
-			4 * sizeof(struct f2fs_acl_entry_short) +
-			(count - 4) * sizeof(struct f2fs_acl_entry);
+			ACL_MAX_SHORT_ENTRY
+			 * sizeof(struct f2fs_acl_entry_short) +
+			(count - ACL_MAX_SHORT_ENTRY)
+			 * sizeof(struct f2fs_acl_entry);
 	}
 }
 
@@ -36,7 +38,7 @@ static inline int f2fs_acl_count(size_t size)
 {
 	ssize_t s;
 	size -= sizeof(struct f2fs_acl_header);
-	s = size - 4 * sizeof(struct f2fs_acl_entry_short);
+	s = size - ACL_MAX_SHORT_ENTRY * sizeof(struct f2fs_acl_entry_short);
 	if (s < 0) {
 		if (size % sizeof(struct f2fs_acl_entry_short))
 			return -1;
@@ -44,7 +46,7 @@ static inline int f2fs_acl_count(size_t size)
 	} else {
 		if (s % sizeof(struct f2fs_acl_entry))
 			return -1;
-		return s / sizeof(struct f2fs_acl_entry) + 4;
+		return s / sizeof(struct f2fs_acl_entry) + ACL_MAX_SHORT_ENTRY;
 	}
 }
 
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 223283c..48ef4b8 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -25,13 +25,15 @@
 
 static size_t jffs2_acl_size(int count)
 {
-	if (count <= 4) {
+	if (count <= ACL_MAX_SHORT_ENTRY) {
 		return sizeof(struct jffs2_acl_header)
 		       + count * sizeof(struct jffs2_acl_entry_short);
 	} else {
 		return sizeof(struct jffs2_acl_header)
-		       + 4 * sizeof(struct jffs2_acl_entry_short)
-		       + (count - 4) * sizeof(struct jffs2_acl_entry);
+		       + ACL_MAX_SHORT_ENTRY
+				 * sizeof(struct jffs2_acl_entry_short)
+		       + (count - ACL_MAX_SHORT_ENTRY)
+				 * sizeof(struct jffs2_acl_entry);
 	}
 }
 
@@ -40,15 +42,16 @@ static int jffs2_acl_count(size_t size)
 	size_t s;
 
 	size -= sizeof(struct jffs2_acl_header);
-	if (size < 4 * sizeof(struct jffs2_acl_entry_short)) {
+	if (size < ACL_MAX_SHORT_ENTRY * sizeof(struct jffs2_acl_entry_short)) {
 		if (size % sizeof(struct jffs2_acl_entry_short))
 			return -1;
 		return size / sizeof(struct jffs2_acl_entry_short);
 	} else {
-		s = size - 4 * sizeof(struct jffs2_acl_entry_short);
+		s = size - ACL_MAX_SHORT_ENTRY
+				 * sizeof(struct jffs2_acl_entry_short);
 		if (s % sizeof(struct jffs2_acl_entry))
 			return -1;
-		return s / sizeof(struct jffs2_acl_entry) + 4;
+		return s / sizeof(struct jffs2_acl_entry) + ACL_MAX_SHORT_ENTRY;
 	}
 }
 
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 8bd2135..8cfdebe 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -72,6 +72,14 @@ posix_acl_clone(const struct posix_acl *acl, gfp_t flags)
 
 /*
  * Check if an acl is valid. Returns 0 if it is, or -E... otherwise.
+ *
+ * make sure ACL format is the following:
+ *
+ *   ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK[2] ACL_OTHER
+ *
+ *   [1] Where * is the regexp sense of "0 or more times"
+ *   [2] Only if there is at least one ACL_USER or ACL_GROUP tag;
+ *       otherwise skip ACL_MASK.
  */
 int
 posix_acl_valid(const struct posix_acl *acl)
diff --git a/fs/reiserfs/acl.h b/fs/reiserfs/acl.h
index f096b80..cb967a3 100644
--- a/fs/reiserfs/acl.h
+++ b/fs/reiserfs/acl.h
@@ -20,13 +20,13 @@ typedef struct {
 
 static inline size_t reiserfs_acl_size(int count)
 {
-	if (count <= 4) {
+	if (count <= ACL_MAX_SHORT_ENTRY) {
 		return sizeof(reiserfs_acl_header) +
 		    count * sizeof(reiserfs_acl_entry_short);
 	} else {
 		return sizeof(reiserfs_acl_header) +
-		    4 * sizeof(reiserfs_acl_entry_short) +
-		    (count - 4) * sizeof(reiserfs_acl_entry);
+		    ACL_MAX_SHORT_ENTRY * sizeof(reiserfs_acl_entry_short) +
+		    (count - ACL_MAX_SHORT_ENTRY) * sizeof(reiserfs_acl_entry);
 	}
 }
 
@@ -34,7 +34,7 @@ static inline int reiserfs_acl_count(size_t size)
 {
 	ssize_t s;
 	size -= sizeof(reiserfs_acl_header);
-	s = size - 4 * sizeof(reiserfs_acl_entry_short);
+	s = size - ACL_MAX_SHORT_ENTRY * sizeof(reiserfs_acl_entry_short);
 	if (s < 0) {
 		if (size % sizeof(reiserfs_acl_entry_short))
 			return -1;
@@ -42,7 +42,7 @@ static inline int reiserfs_acl_count(size_t size)
 	} else {
 		if (s % sizeof(reiserfs_acl_entry))
 			return -1;
-		return s / sizeof(reiserfs_acl_entry) + 4;
+		return s / sizeof(reiserfs_acl_entry) + ACL_MAX_SHORT_ENTRY;
 	}
 }
 
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 7931efe..2c5609c 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -26,6 +26,14 @@
 #define ACL_MASK		(0x10)
 #define ACL_OTHER		(0x20)
 
+/*
+ * posix_acl_valid() makes sure that if there are <= 4 ACL entries, then
+ * all of them are short. Otherwise exactly 4 entries are short ones and
+ * other have full length. See comment before that function for exact ACL
+ * format.
+ */
+#define ACL_MAX_SHORT_ENTRY	4
+
 /* permissions in the e_perm field */
 #define ACL_READ		(0x04)
 #define ACL_WRITE		(0x02)
-- 
1.7.10.4
