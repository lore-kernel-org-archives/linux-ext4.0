From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 12/23] richacl: Use directory specific mask values for operation on directories.
Date: Mon,  1 Feb 2010 11:04:54 +0530
Message-ID: <1265002505-8387-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/namei.c         |    4 ++--
 fs/richacl_base.c       |   24 ++++++++++++++++--------
 include/linux/richacl.h |    2 +-
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 48ee6a3..a7c87c8 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2514,11 +2514,11 @@ end_rename:
 
 int ext4_permission(struct inode *inode, int mask)
 {
-
 #ifdef CONFIG_EXT4_FS_RICHACL
 	if (richacl_enabled(inode->i_sb))
 		return ext4_richacl_permission(inode,
-					richacl_want_to_mask(mask));
+					richacl_want_to_mask(mask,
+					S_ISDIR(inode->i_mode)));
 	else
 #endif
 	return generic_permission(inode, mask, ext4_check_acl);
diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 0d8953c..b5c28cf 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -188,16 +188,24 @@ EXPORT_SYMBOL_GPL(richacl_chmod);
  * When checking for append, @want is (MAY_WRITE | MAY_APPEND).
  */
 unsigned int
-richacl_want_to_mask(int want)
+richacl_want_to_mask(int want, int is_dir)
 {
 	unsigned int mask = 0;
-
-	if (want & MAY_READ)
-		mask |= ACE4_READ_DATA;
-	if (want & MAY_APPEND)
-		mask |= ACE4_APPEND_DATA;
-	else if (want & MAY_WRITE)
-		mask |= ACE4_WRITE_DATA;
+	if (is_dir) {
+		if (want & MAY_READ)
+			mask |=  ACE4_LIST_DIRECTORY;
+		if (want & MAY_APPEND)
+			mask |= ACE4_ADD_FILE | ACE4_ADD_SUBDIRECTORY;
+		else if (want & MAY_WRITE)
+			mask |= ACE4_ADD_FILE | ACE4_ADD_SUBDIRECTORY;
+	} else {
+		if (want & MAY_READ)
+			mask |= ACE4_READ_DATA;
+		if (want & MAY_APPEND)
+			mask |= ACE4_APPEND_DATA;
+		else if (want & MAY_WRITE)
+			mask |= ACE4_WRITE_DATA;
+	}
 	if (want & MAY_EXEC)
 		mask |= ACE4_EXECUTE;
 
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index b0df740..de71ca5 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -222,7 +222,7 @@ richace_is_deny(const struct richace *ace)
 extern struct richacl *richacl_alloc(int count);
 extern struct richacl *richacl_clone(const struct richacl *acl);
 
-extern unsigned int richacl_want_to_mask(int want);
+extern unsigned int richacl_want_to_mask(int want, int is_dir);
 extern int richacl_permission(struct inode *,
 			const struct richacl *, unsigned int);
 extern int richacl_generic_permission(struct inode *, unsigned int);
-- 
1.7.0.rc0.48.gdace5

