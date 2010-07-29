From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 12/17] richacl: Automatic Inheritance
Date: Thu, 29 Jul 2010 23:27:50 +0530
Message-ID: <1280426275-4602-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1280426275-4602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de, adilger@sun.com,
	sandeen@redhat.com, tytso@mit.edu, bfields@citi.umich.edu,
	jlayton@redhat.com
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <1280426275-4602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/options/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Automatic Inheritance (AI) allows changes to the acl of a directory to
recursively propagate down to files and directories in the directory.

To implement this, the kernel keeps track of which permissions have been
inherited, and makes sure that permission propagation is turned off when
the file permission bits of a file are changed (upon create or chmod).

The actual permission propagation is implemented in user space.

AI works as follows:

 - When the ACL4_AUTO_INHERIT flag in the acl of a file is cleared, the
   file is not affected by AI.

 - When the ACL4_AUTO_INHERIT flag in the acl of a directory is set and
   a file or subdirectory is created in that directory, files created in
   the directory will have the ACL4_AUTO_INHERIT flag set, and all
   inherited aces will have the ACE4_INHERITED_ACE flag set.  This
   allows user space to distinguish between aces which have been
   inherited, and aces which have been explicitly added.

 - When the ACL4_PROTECTED acl flag in the acl of a file is set, AI will
   not modify the acl of the file.  This does not affect propagation of
   permissions from the file to its children (if the file is a
   directory).

Linux does not have a way of creating files without setting the file
permission bits, so all files created inside a directory with
ACL4_AUTO_INHERIT set will also have the ACL4_PROTECTED flag set.  This
effectively disables AI.

Protocols which support creating files without specifying permissions
can explicitly clear the ACL4_PROTECTED flag after creating a file (and
reset the file masks to "undo" applying the create mode; see
richacl_compute_max_masks()).  This is a workaround; a per-create or
per-process flag indicating to ignore the create mode when AI is in
effect would fix this problem.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/richacl_base.c       |   10 +++++++++-
 fs/richacl_inode.c      |    7 ++++++-
 include/linux/richacl.h |   25 +++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 5afdc5a..27dd2f1 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -357,7 +357,8 @@ richacl_chmod(struct richacl *acl, mode_t mode)
 	if (acl->a_owner_mask == owner_mask &&
 	    acl->a_group_mask == group_mask &&
 	    acl->a_other_mask == other_mask &&
-	    (acl->a_flags & ACL4_MASKED))
+	    (acl->a_flags & ACL4_MASKED) &&
+	    (!richacl_is_auto_inherit(acl) || richacl_is_protected(acl)))
 		return acl;
 
 	clone = richacl_clone(acl);
@@ -369,6 +370,8 @@ richacl_chmod(struct richacl *acl, mode_t mode)
 	clone->a_owner_mask = owner_mask;
 	clone->a_group_mask = group_mask;
 	clone->a_other_mask = other_mask;
+	if (richacl_is_auto_inherit(clone))
+		clone->a_flags |= ACL4_PROTECTED;
 
 	return clone;
 }
@@ -538,6 +541,11 @@ richacl_inherit(const struct richacl *dir_acl, int isdir)
 			ace++;
 		}
 	}
+	if (richacl_is_auto_inherit(dir_acl)) {
+		acl->a_flags = ACL4_AUTO_INHERIT;
+		richacl_for_each_entry(ace, acl)
+			ace->e_flags |= ACE4_INHERITED_ACE;
+	}
 
 	return acl;
 }
diff --git a/fs/richacl_inode.c b/fs/richacl_inode.c
index f5dd95a..2101832 100644
--- a/fs/richacl_inode.c
+++ b/fs/richacl_inode.c
@@ -213,9 +213,14 @@ richacl_inherit_inode(const struct richacl *dir_acl, struct inode *inode)
 
 	acl = richacl_inherit(dir_acl, S_ISDIR(inode->i_mode));
 	if (acl) {
+		/*
+		 * We need to set ACL4_PROTECTED because we are
+		 * doing an implicit chmod
+		 */
+		if (richacl_is_auto_inherit(acl))
+			acl->a_flags |= ACL4_PROTECTED;
 
 		richacl_compute_max_masks(acl);
-
 		/*
 		 * Ensure that the acl will not grant any permissions beyond
 		 * the create mode.
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 6151770..bb0c9b2 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -47,10 +47,16 @@ struct richacl {
 	     _ace != _acl->a_entries - 1; \
 	     _ace--)
 
+/* a_flags values */
+#define ACL4_AUTO_INHERIT		0x01
+#define ACL4_PROTECTED			0x02
+/* #define ACL4_DEFAULTED			0x04 */
 /* Flag values defined by rich-acl */
 #define ACL4_MASKED			0x80
 
 #define ACL4_VALID_FLAGS (			\
+		ACL4_AUTO_INHERIT |		\
+		ACL4_PROTECTED |		\
 		ACL4_MASKED)
 
 /* e_type values */
@@ -67,6 +73,7 @@ struct richacl {
 /*#define ACE4_SUCCESSFUL_ACCESS_ACE_FLAG	0x0010*/
 /*#define ACE4_FAILED_ACCESS_ACE_FLAG	0x0020*/
 #define ACE4_IDENTIFIER_GROUP		0x0040
+#define ACE4_INHERITED_ACE		0x0080
 /* in-memory representation only */
 #define ACE4_SPECIAL_WHO		0x4000
 
@@ -75,7 +82,8 @@ struct richacl {
 	ACE4_DIRECTORY_INHERIT_ACE |		\
 	ACE4_NO_PROPAGATE_INHERIT_ACE |		\
 	ACE4_INHERIT_ONLY_ACE |			\
-	ACE4_IDENTIFIER_GROUP)
+	ACE4_IDENTIFIER_GROUP |			\
+	ACE4_INHERITED_ACE)
 
 /* e_mask bitflags */
 #define ACE4_READ_DATA			0x00000001
@@ -181,6 +189,18 @@ richacl_put(struct richacl *acl)
 		kfree(acl);
 }
 
+static inline int
+richacl_is_auto_inherit(const struct richacl *acl)
+{
+	return acl->a_flags & ACL4_AUTO_INHERIT;
+}
+
+static inline int
+richacl_is_protected(const struct richacl *acl)
+{
+	return acl->a_flags & ACL4_PROTECTED;
+}
+
 /*
  * Special e_who identifiers: we use these pointer values in comparisons
  * instead of doing a strcmp.
@@ -259,7 +279,8 @@ richace_clear_inheritance_flags(struct richace *ace)
 	ace->e_flags &= ~(ACE4_FILE_INHERIT_ACE |
 			  ACE4_DIRECTORY_INHERIT_ACE |
 			  ACE4_NO_PROPAGATE_INHERIT_ACE |
-			  ACE4_INHERIT_ONLY_ACE);
+			  ACE4_INHERIT_ONLY_ACE |
+			  ACE4_INHERITED_ACE);
 }
 
 /**
-- 
1.7.0.4

_______________________________________________
NOTE: THIS LIST IS DEPRECATED.  Please use linux-nfs@vger.kernel.org instead.
(To subscribe to linux-nfs@vger.kernel.org: send "subscribe linux-nfs" in the body of a message to majordomo@vger.kernel.org.)

NFSv4 mailing list
NFSv4@linux-nfs.org
http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
