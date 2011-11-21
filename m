From: Tao Ma <tm@tao.ma>
Subject: [PATCH V2 02/19] ext4: export inline xattr functions.
Date: Tue, 22 Nov 2011 00:39:40 +0800
Message-ID: <1321893597-11024-2-git-send-email-tm@tao.ma>
References: <4ECA7DB3.9040605@tao.ma>
 <1321893597-11024-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1321893597-11024-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Inline data needs some inline xattr functions, so export them
from fs/ext4/xattr.c so that inline.c can uses them.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/xattr.c |   39 +++++-------------------------------
 fs/ext4/xattr.h |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 93a00d8..71ef45e 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -61,11 +61,6 @@
 #include "xattr.h"
 #include "acl.h"
 
-#define BHDR(bh) ((struct ext4_xattr_header *)((bh)->b_data))
-#define ENTRY(ptr) ((struct ext4_xattr_entry *)(ptr))
-#define BFIRST(bh) ENTRY(BHDR(bh)+1)
-#define IS_LAST_ENTRY(entry) (*(__u32 *)(entry) == 0)
-
 #ifdef EXT4_XATTR_DEBUG
 # define ea_idebug(inode, f...) do { \
 		printk(KERN_DEBUG "inode %s:%lu: ", \
@@ -255,7 +250,7 @@ cleanup:
 	return error;
 }
 
-static int
+int
 ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 		     void *buffer, size_t buffer_size)
 {
@@ -522,21 +517,6 @@ static size_t ext4_xattr_free_space(struct ext4_xattr_entry *last,
 	return (*min_offs - ((void *)last - base) - sizeof(__u32));
 }
 
-struct ext4_xattr_info {
-	int name_index;
-	const char *name;
-	const void *value;
-	size_t value_len;
-};
-
-struct ext4_xattr_search {
-	struct ext4_xattr_entry *first;
-	void *base;
-	void *end;
-	struct ext4_xattr_entry *here;
-	int not_found;
-};
-
 static int
 ext4_xattr_set_entry(struct ext4_xattr_info *i, struct ext4_xattr_search *s)
 {
@@ -890,14 +870,8 @@ bad_block:
 #undef header
 }
 
-struct ext4_xattr_ibody_find {
-	struct ext4_xattr_search s;
-	struct ext4_iloc iloc;
-};
-
-static int
-ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
-		      struct ext4_xattr_ibody_find *is)
+int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
+			  struct ext4_xattr_ibody_find *is)
 {
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_inode *raw_inode;
@@ -925,10 +899,9 @@ ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 	return 0;
 }
 
-static int
-ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
-		     struct ext4_xattr_info *i,
-		     struct ext4_xattr_ibody_find *is)
+int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+			 struct ext4_xattr_info *i,
+			 struct ext4_xattr_ibody_find *is)
 {
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_xattr_search *s = &is->s;
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 25b7387..c4c015d 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -63,6 +63,32 @@ struct ext4_xattr_entry {
 		EXT4_I(inode)->i_extra_isize))
 #define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))
 
+#define BHDR(bh) ((struct ext4_xattr_header *)((bh)->b_data))
+#define ENTRY(ptr) ((struct ext4_xattr_entry *)(ptr))
+#define BFIRST(bh) ENTRY(BHDR(bh)+1)
+#define IS_LAST_ENTRY(entry) (*(__u32 *)(entry) == 0)
+
+
+struct ext4_xattr_info {
+	int name_index;
+	const char *name;
+	const void *value;
+	size_t value_len;
+};
+
+struct ext4_xattr_search {
+	struct ext4_xattr_entry *first;
+	void *base;
+	void *end;
+	struct ext4_xattr_entry *here;
+	int not_found;
+};
+
+struct ext4_xattr_ibody_find {
+	struct ext4_xattr_search s;
+	struct ext4_iloc iloc;
+};
+
 # ifdef CONFIG_EXT4_FS_XATTR
 
 extern const struct xattr_handler ext4_xattr_user_handler;
@@ -88,6 +114,15 @@ extern void ext4_exit_xattr(void);
 
 extern const struct xattr_handler *ext4_xattr_handlers[];
 
+extern int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
+				 struct ext4_xattr_ibody_find *is);
+extern int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+				struct ext4_xattr_info *i,
+				struct ext4_xattr_ibody_find *is);
+extern int ext4_xattr_ibody_get(struct inode *inode, int name_index,
+				const char *name,
+				void *buffer, size_t buffer_size);
+
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -141,6 +176,28 @@ ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 
 #define ext4_xattr_handlers	NULL
 
+static inline int
+ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
+		      struct ext4_xattr_ibody_find *is)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int
+ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+		     struct ext4_xattr_info *i,
+		     struct ext4_xattr_ibody_find *is)
+{
+	return -EOPNOTSUPP;
+}
+
+extern int ext4_xattr_ibody_get(struct inode *inode, int name_index,
+				const char *name,
+				void *buffer, size_t buffer_size)
+{
+	return -EOPNOTSUPP;
+}
+
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4
