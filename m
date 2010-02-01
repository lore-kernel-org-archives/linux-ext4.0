From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 11/23] richacl: Move the xattr representation to little-endian format
Date: Mon,  1 Feb 2010 11:04:53 +0530
Message-ID: <1265002505-8387-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:40822 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0BAFfZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:25 -0500
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Posix acl already use little-endian representation on disk. Move
richacl also to little-endian representation

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/richacl_xattr.c            |   34 +++++++++++++++++-----------------
 include/linux/richacl_xattr.h |   16 ++++++++--------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/richacl_xattr.c b/fs/richacl_xattr.c
index 4c04417..46e966a 100644
--- a/fs/richacl_xattr.c
+++ b/fs/richacl_xattr.c
@@ -34,7 +34,7 @@ richacl_from_xattr(const void *value, size_t size)
 	    (xattr_acl->a_flags & ~ACL4_VALID_FLAGS))
 		return ERR_PTR(-EINVAL);
 
-	count = be16_to_cpu(xattr_acl->a_count);
+	count = le16_to_cpu(xattr_acl->a_count);
 	if (count > ACL4_XATTR_MAX_COUNT)
 		return ERR_PTR(-EINVAL);
 
@@ -43,13 +43,13 @@ richacl_from_xattr(const void *value, size_t size)
 		return ERR_PTR(-ENOMEM);
 
 	acl->a_flags = xattr_acl->a_flags;
-	acl->a_owner_mask = be32_to_cpu(xattr_acl->a_owner_mask);
+	acl->a_owner_mask = le32_to_cpu(xattr_acl->a_owner_mask);
 	if (acl->a_owner_mask & ~ACE4_VALID_MASK)
 		goto fail_einval;
-	acl->a_group_mask = be32_to_cpu(xattr_acl->a_group_mask);
+	acl->a_group_mask = le32_to_cpu(xattr_acl->a_group_mask);
 	if (acl->a_group_mask & ~ACE4_VALID_MASK)
 		goto fail_einval;
-	acl->a_other_mask = be32_to_cpu(xattr_acl->a_other_mask);
+	acl->a_other_mask = le32_to_cpu(xattr_acl->a_other_mask);
 	if (acl->a_other_mask & ~ACE4_VALID_MASK)
 		goto fail_einval;
 
@@ -63,10 +63,10 @@ richacl_from_xattr(const void *value, size_t size)
 		if (!end)
 			goto fail_einval;
 
-		ace->e_type = be16_to_cpu(xattr_ace->e_type);
-		ace->e_flags = be16_to_cpu(xattr_ace->e_flags);
-		ace->e_mask = be32_to_cpu(xattr_ace->e_mask);
-		ace->u.e_id = be32_to_cpu(xattr_ace->e_id);
+		ace->e_type = le16_to_cpu(xattr_ace->e_type);
+		ace->e_flags = le16_to_cpu(xattr_ace->e_flags);
+		ace->e_mask = le32_to_cpu(xattr_ace->e_mask);
+		ace->u.e_id = le32_to_cpu(xattr_ace->e_id);
 
 		if (ace->e_flags & ~ACE4_VALID_FLAGS) {
 			memset(ace, 0, sizeof(struct richace));
@@ -117,26 +117,26 @@ richacl_to_xattr(const struct richacl *acl, void *buffer)
 
 	xattr_acl->a_version = ACL4_XATTR_VERSION;
 	xattr_acl->a_flags = acl->a_flags;
-	xattr_acl->a_count = cpu_to_be16(acl->a_count);
+	xattr_acl->a_count = cpu_to_le16(acl->a_count);
 
-	xattr_acl->a_owner_mask = cpu_to_be32(acl->a_owner_mask);
-	xattr_acl->a_group_mask = cpu_to_be32(acl->a_group_mask);
-	xattr_acl->a_other_mask = cpu_to_be32(acl->a_other_mask);
+	xattr_acl->a_owner_mask = cpu_to_le32(acl->a_owner_mask);
+	xattr_acl->a_group_mask = cpu_to_le32(acl->a_group_mask);
+	xattr_acl->a_other_mask = cpu_to_le32(acl->a_other_mask);
 
 	xattr_ace = (void *)(xattr_acl + 1);
 	richacl_for_each_entry(ace, acl) {
-		xattr_ace->e_type = cpu_to_be16(ace->e_type);
-		xattr_ace->e_flags = cpu_to_be16(ace->e_flags &
+		xattr_ace->e_type = cpu_to_le16(ace->e_type);
+		xattr_ace->e_flags = cpu_to_le16(ace->e_flags &
 			ACE4_VALID_FLAGS);
-		xattr_ace->e_mask = cpu_to_be32(ace->e_mask);
+		xattr_ace->e_mask = cpu_to_le32(ace->e_mask);
 		if (richace_is_unix_id(ace)) {
-			xattr_ace->e_id = cpu_to_be32(ace->u.e_id);
+			xattr_ace->e_id = cpu_to_le32(ace->u.e_id);
 			memset(xattr_ace->e_who, 0, 4);
 			xattr_ace = (void *)xattr_ace->e_who + 4;
 		} else {
 			int sz = ALIGN(strlen(ace->u.e_who) + 1, 4);
 
-			xattr_ace->e_id = cpu_to_be32(-1);
+			xattr_ace->e_id = cpu_to_le32(-1);
 			memset(xattr_ace->e_who + sz - 4, 0, 4);
 			strcpy(xattr_ace->e_who, ace->u.e_who);
 			xattr_ace = (void *)xattr_ace->e_who + sz;
diff --git a/include/linux/richacl_xattr.h b/include/linux/richacl_xattr.h
index 5a75284..de7acf7 100644
--- a/include/linux/richacl_xattr.h
+++ b/include/linux/richacl_xattr.h
@@ -6,20 +6,20 @@
 #define RICHACL_XATTR "system.richacl"
 
 struct richace_xattr {
-	__be16		e_type;
-	__be16		e_flags;
-	__be32		e_mask;
-	__be32		e_id;
+	__le16		e_type;
+	__le16		e_flags;
+	__le32		e_mask;
+	__le32		e_id;
 	char		e_who[0];
 };
 
 struct richacl_xattr {
 	unsigned char	a_version;
 	unsigned char	a_flags;
-	__be16		a_count;
-	__be32		a_owner_mask;
-	__be32		a_group_mask;
-	__be32		a_other_mask;
+	__le16		a_count;
+	__le32		a_owner_mask;
+	__le32		a_group_mask;
+	__le32		a_other_mask;
 };
 
 #define ACL4_XATTR_VERSION	0
-- 
1.7.0.rc0.48.gdace5

