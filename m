From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 08/23] vfs: Add a flag to denote posix mapped richacl
Date: Mon,  1 Feb 2010 11:04:50 +0530
Message-ID: <1265002505-8387-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
 fs/richacl_posix.c      |    7 +++++++
 include/linux/richacl.h |   10 ++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/richacl_posix.c b/fs/richacl_posix.c
index 07db970..3cf2124 100644
--- a/fs/richacl_posix.c
+++ b/fs/richacl_posix.c
@@ -183,6 +183,13 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 	acl->a_group_mask = richacl_mode_to_mask(mode >> 3);
 	acl->a_other_mask = richacl_mode_to_mask(mode);
 
+	/*
+	 * Mark that the acl as mapped from posix
+	 * This gives user space the chance to verify
+	 * whether the mapping was correct
+	 */
+	acl->a_flags |= ACL4_POSIX_MAPPED;
+
 	return;
 }
 
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index b08fdf1..41d93d8 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -36,12 +36,14 @@ struct richacl {
 #define ACL4_AUTO_INHERIT		0x01
 #define ACL4_PROTECTED			0x02
 #define ACL4_DEFAULTED			0x04
+#define ACL4_POSIX_MAPPED		0x10
 #define ACL4_WRITE_THROUGH		0x40
 
-#define ACL4_VALID_FLAGS ( \
-	ACL4_AUTO_INHERIT | \
-	ACL4_PROTECTED | \
-	ACL4_DEFAULTED | \
+#define ACL4_VALID_FLAGS (	\
+	ACL4_AUTO_INHERIT |	\
+	ACL4_PROTECTED |	\
+	ACL4_DEFAULTED |	\
+	ACL4_POSIX_MAPPED |	\
 	ACL4_WRITE_THROUGH)
 
 /* e_type values */
-- 
1.7.0.rc0.48.gdace5

