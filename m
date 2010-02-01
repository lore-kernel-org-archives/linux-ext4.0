From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 21/23] richacl: Add helpers for NFSv4 acl to richacl conversion
Date: Mon,  1 Feb 2010 11:05:03 +0530
Message-ID: <1265002505-8387-22-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:47546 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0BAFfX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:23 -0500
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add helper function for mapping NFSv4acl to richacl and vice versa
Using richacl as the ondisk format ensures that we can map
NFSv4acl better to richacl.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/nfsd/nfs4acl.c        |   72 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nfs4_acl.h |    4 ++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
index 8815068..6724235 100644
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -835,3 +835,75 @@ nfs4_acl_write_who(int who, char *p)
 EXPORT_SYMBOL(nfs4_acl_new);
 EXPORT_SYMBOL(nfs4_acl_get_whotype);
 EXPORT_SYMBOL(nfs4_acl_write_who);
+
+struct nfs4_acl *
+nfs4_acl_richacl_to_nfsv4(struct richacl *racl)
+{
+	int error;
+	struct nfs4_acl *acl;
+	struct richace *race;
+	struct nfs4_ace *ace;
+
+	error = richacl_apply_masks(&racl);
+	if (error)
+		ERR_PTR(error);
+
+	acl = nfs4_acl_new(racl->a_count);
+	if (acl == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	ace = acl->aces;
+	richacl_for_each_entry(race, racl) {
+		ace->type = race->e_type;
+		ace->access_mask = race->e_mask;
+		ace->flag = race->e_flags & ~ACE4_SPECIAL_WHO;
+		if (richace_is_owner(race))
+			ace->whotype = NFS4_ACL_WHO_OWNER;
+		else if (richace_is_group(race))
+			ace->whotype = NFS4_ACL_WHO_GROUP;
+		else if (richace_is_everyone(race))
+			ace->whotype = NFS4_ACL_WHO_EVERYONE;
+		else {
+			ace->whotype = NFS4_ACL_WHO_NAMED;
+			ace->who     = race->u.e_id;
+		}
+		ace++;
+		acl->naces++;
+	}
+	return acl;
+}
+
+int nfs4_acl_nfsv4_to_richacl(struct nfs4_acl *acl, struct richacl **racl)
+{
+	struct richace *race;
+	struct nfs4_ace *ace;
+
+	*racl = richacl_alloc(acl->naces);
+	if (*racl == NULL)
+		return -ENOMEM;
+	race = (*racl)->a_entries;
+	for (ace = acl->aces; ace < acl->aces + acl->naces; ace++) {
+		race->e_type  = ace->type;
+		race->e_flags = ace->flag;
+		race->e_mask  = ace->access_mask;
+		switch (ace->whotype) {
+		case NFS4_ACL_WHO_OWNER:
+			richace_set_who(race, richace_owner_who);
+			break;
+		case NFS4_ACL_WHO_GROUP:
+			richace_set_who(race, richace_group_who);
+			break;
+		case NFS4_ACL_WHO_EVERYONE:
+			richace_set_who(race, richace_everyone_who);
+			break;
+		case NFS4_ACL_WHO_NAMED:
+			race->u.e_id = ace->who;
+			break;
+		default:
+			richacl_put(*racl);
+			return -EINVAL;
+		}
+		race++;
+	}
+	return 0;
+}
diff --git a/include/linux/nfs4_acl.h b/include/linux/nfs4_acl.h
index c9c05a7..e14b03f 100644
--- a/include/linux/nfs4_acl.h
+++ b/include/linux/nfs4_acl.h
@@ -38,6 +38,7 @@
 #define LINUX_NFS4_ACL_H
 
 #include <linux/posix_acl.h>
+#include <linux/richacl.h>
 
 /* Maximum ACL we'll accept from client; chosen (somewhat arbitrarily) to
  * fit in a page: */
@@ -58,4 +59,7 @@ struct nfs4_acl *nfs4_acl_posix_to_nfsv4(struct posix_acl *,
 int nfs4_acl_nfsv4_to_posix(struct nfs4_acl *, struct posix_acl **,
 				struct posix_acl **, unsigned int flags);
 
+struct nfs4_acl *nfs4_acl_richacl_to_nfsv4(struct richacl *racl);
+int nfs4_acl_nfsv4_to_richacl(struct nfs4_acl *acl, struct richacl **racl);
+
 #endif /* LINUX_NFS4_ACL_H */
-- 
1.7.0.rc0.48.gdace5

