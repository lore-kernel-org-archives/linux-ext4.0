From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 18/23] richacl: Add helper function for creating richacl from mode values.
Date: Mon,  1 Feb 2010 11:05:00 +0530
Message-ID: <1265002505-8387-19-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56059 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0BAFfY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:24 -0500
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we don't have richacl stored on disk for permission check
we need to generate richacl from mode values. This patch adds
a helper function for doing that.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/richacl_base.c       |   29 +++++++++++++++++++++++++++++
 include/linux/richacl.h |    1 +
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 4a340d7..5d61b30 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -640,3 +640,32 @@ richacl_inherit(const struct richacl *dir_acl, mode_t mode)
 	return acl;
 }
 EXPORT_SYMBOL_GPL(richacl_inherit);
+
+struct richacl *
+richacl_from_mode(mode_t mode)
+{
+	struct richacl *acl;
+	struct richace *ace;
+	int is_dir = S_ISDIR(mode);
+
+	acl = richacl_alloc(1);
+	if (!acl)
+		return NULL;
+	ace = acl->a_entries;
+
+	acl->a_owner_mask = richacl_mode_to_mask(mode >> 6, is_dir);
+	acl->a_group_mask = richacl_mode_to_mask(mode >> 3, is_dir);
+	acl->a_other_mask = richacl_mode_to_mask(mode, is_dir);
+
+	ace->e_type  = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+	ace->e_flags = ACE4_SPECIAL_WHO;
+	ace->e_mask  = ACE4_VALID_MASK;
+	ace->u.e_who = richace_everyone_who;
+	if (richacl_apply_masks(&acl)) {
+		richacl_put(acl);
+		acl = NULL;
+	}
+	return acl;
+
+}
+EXPORT_SYMBOL_GPL(richacl_from_mode);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 705e061..ecb76bc 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -238,5 +238,6 @@ extern int richacl_apply_masks(struct richacl **acl);
 extern int richacl_write_through(struct richacl **acl);
 extern struct richacl *map_posix_to_richacl(struct inode *, struct posix_acl *,
 					struct posix_acl *);
+extern struct richacl *richacl_from_mode(mode_t);
 
 #endif /* __RICHACL_H */
-- 
1.7.0.rc0.48.gdace5

