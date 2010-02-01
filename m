From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 04/23] richacl: Add write retention and retention hold access mask
Date: Mon,  1 Feb 2010 11:04:46 +0530
Message-ID: <1265002505-8387-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

These new flags are added in nfsv4.1. They don't have any
meaning in posix. So we don't need to do access checks with
these mask. But nfsd should be able to save these masks

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/richacl.h |   47 +++++++++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index a2b4bd0..c56f152 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -75,32 +75,39 @@ struct richacl {
 #define ACE4_DELETE_CHILD		0x00000040
 #define ACE4_READ_ATTRIBUTES		0x00000080
 #define ACE4_WRITE_ATTRIBUTES		0x00000100
+#define ACE4_WRITE_RETENTION		0x00000200
+#define ACE4_WRITE_RETENTION_HOLD	0x00000400
+
+
+
 #define ACE4_DELETE			0x00010000
 #define ACE4_READ_ACL			0x00020000
 #define ACE4_WRITE_ACL			0x00040000
 #define ACE4_WRITE_OWNER		0x00080000
 #define ACE4_SYNCHRONIZE		0x00100000
 
-#define ACE4_VALID_MASK ( \
-	ACE4_READ_DATA | ACE4_LIST_DIRECTORY | \
-	ACE4_WRITE_DATA | ACE4_ADD_FILE | \
-	ACE4_APPEND_DATA | ACE4_ADD_SUBDIRECTORY | \
-	ACE4_READ_NAMED_ATTRS | \
-	ACE4_WRITE_NAMED_ATTRS | \
-	ACE4_EXECUTE | \
-	ACE4_DELETE_CHILD | \
-	ACE4_READ_ATTRIBUTES | \
-	ACE4_WRITE_ATTRIBUTES | \
-	ACE4_DELETE | \
-	ACE4_READ_ACL | \
-	ACE4_WRITE_ACL | \
-	ACE4_WRITE_OWNER | \
-	ACE4_SYNCHRONIZE)
-
-#define ACE4_POSIX_ALWAYS_ALLOWED ( \
-	ACE4_SYNCHRONIZE | \
-	ACE4_READ_ATTRIBUTES | \
-	ACE4_READ_ACL)
+#define ACE4_VALID_MASK (					\
+		ACE4_READ_DATA | ACE4_LIST_DIRECTORY |		\
+		ACE4_WRITE_DATA | ACE4_ADD_FILE |		\
+		ACE4_APPEND_DATA | ACE4_ADD_SUBDIRECTORY |	\
+		ACE4_READ_NAMED_ATTRS |				\
+		ACE4_WRITE_NAMED_ATTRS |			\
+		ACE4_EXECUTE |					\
+		ACE4_DELETE_CHILD |				\
+		ACE4_READ_ATTRIBUTES |				\
+		ACE4_WRITE_ATTRIBUTES |				\
+		ACE4_WRITE_RETENTION |				\
+		ACE4_WRITE_RETENTION_HOLD |			\
+		ACE4_DELETE |					\
+		ACE4_READ_ACL |					\
+		ACE4_WRITE_ACL |				\
+		ACE4_WRITE_OWNER |				\
+		ACE4_SYNCHRONIZE)
+
+#define ACE4_POSIX_ALWAYS_ALLOWED (		\
+		ACE4_SYNCHRONIZE |		\
+		ACE4_READ_ATTRIBUTES |		\
+		ACE4_READ_ACL)
 /*
  * Duplicate an RICHACL handle.
  */
-- 
1.7.0.rc0.48.gdace5

