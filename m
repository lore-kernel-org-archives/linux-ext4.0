From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH -V2 00/16]  New ACL format for better NFSv4 acl interoperability
Date: Mon, 19 Jul 2010 21:19:50 +0200
Message-ID: <201007192119.50868.agruen@suse.de>
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, adilger@sun.com,
	sandeen@redhat.com, tytso@mit.edu, staubach@redhat.com,
	bfields@citi.umich.edu, jlayton@redhat.com,
	linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965355Ab0GSTYr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jul 2010 15:24:47 -0400
In-Reply-To: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh,

here is a patch on top of the richacl-upstream queue.

So far, we were assuming that acls are always masked, and the file masks
could be set so that they would not mask any permissions.  This is fine
for permission checking, but richacl_apply_masks() didn't recognize when
the file masks were set to mask nothing, and was still transforming such
acls unnecessarily.  This could lead to correct but surprising results.

Instead of using a flag here we could check if the file masks are set to
"ineffective" values, but that would require the same computation as
richacl_compute_max_masks(), which can be a slow on large acls.  It is a
lot easier to instead remember if the file masks are "effective".

(We still need to compute the file masks in nfsd where no file masks are
supplied so that the file permission bits will be set to a reasonable
value. user space will always pass valid file masks in, so we are covered
in that side.)

Thanks,
Andreas

--------------------------------------------------------------------------------

[PATCH] richacl: Allow acls to be masked or unmasked

Use a flag to indicate when the file masks can mask something
(e.g., after a chmod).  richacl_apply_masks() can skip transforming acls
without this flag, which speeds things up and avoids modifying those
acls unnecessarily.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
---
 fs/richacl_base.c       |   46 +++++++++++++++++++++++++++++++---------------
 fs/richacl_compat.c     |   31 ++++++++++++++++++-------------
 fs/richacl_inode.c      |    1 +
 include/linux/richacl.h |    1 +
 4 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 79fb00f..baaecf2 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -329,6 +329,8 @@ restart:
 			}
 		}
 	}
+
+	acl->a_flags &= ~ACL4_MASKED;
 }
 EXPORT_SYMBOL_GPL(richacl_compute_max_masks);
 
@@ -354,7 +356,8 @@ richacl_chmod(struct richacl *acl, mode_t mode)
 	if (acl->a_owner_mask == owner_mask &&
 	    acl->a_group_mask == group_mask &&
 	    acl->a_other_mask == other_mask &&
-	    (!richacl_is_auto_inherit(acl) || richacl_is_protected(acl)))
+	    (!richacl_is_auto_inherit(acl) || richacl_is_protected(acl)) &&
+	    (acl->a_flags & ACL4_MASKED))
 		return acl;
 
 	clone = richacl_clone(acl);
@@ -362,6 +365,7 @@ richacl_chmod(struct richacl *acl, mode_t mode)
 	if (!clone)
 		return ERR_PTR(-ENOMEM);
 
+	clone->a_flags |= ACL4_MASKED;
 	clone->a_owner_mask = owner_mask;
 	clone->a_group_mask = group_mask;
 	clone->a_other_mask = other_mask;
@@ -385,11 +389,18 @@ richacl_permission(struct inode *inode, const struct richacl *acl,
 		   unsigned int mask)
 {
 	const struct richace *ace;
-	unsigned int file_mask, requested = mask, denied = 0;
+	unsigned int requested = mask, denied = 0;
 	int in_owning_group = in_group_p(inode->i_gid);
 	int in_owner_or_group_class = in_owning_group;
 
 	/*
+	 * We don't need to know which class the process is in when the acl is
+	 * not masked.
+	 */
+	if (!(acl->a_flags & ACL4_MASKED))
+		in_owner_or_group_class = 1;
+
+	/*
 	 * A process is
 	 *   - in the owner file class if it owns the file,
 	 *   - in the group file class if it is in the file's owning group or
@@ -431,7 +442,7 @@ richacl_permission(struct inode *inode, const struct richacl *acl,
 		 * computed by richacl_apply_masks() would grant.  See
 		 * richacl_apply_masks() for a more detailed explanation.
 		 */
-		if (richace_is_allow(ace))
+		if ((acl->a_flags & ACL4_MASKED) && richace_is_allow(ace))
 			ace_mask &= acl->a_group_mask;
 
 is_owner:
@@ -453,17 +464,22 @@ is_everyone:
 	}
 	denied |= mask;
 
-	/*
-	 * The file class a process is in determines which file mask applies.
-	 * Check if that file mask also grants the requested access.
-	 */
-	if (current_fsuid() == inode->i_uid)
-		file_mask = acl->a_owner_mask;
-	else if (in_owner_or_group_class)
-		file_mask = acl->a_group_mask;
-	else
-		file_mask = acl->a_other_mask;
-	denied |= requested & ~file_mask;
+	if (acl->a_flags & ACL4_MASKED) {
+		unsigned int file_mask;
+
+		/*
+		 * The file class a process is in determines which file mask
+		 * applies.  Check if that file mask also grants the requested
+		 * access.
+		 */
+		if (current_fsuid() == inode->i_uid)
+			file_mask = acl->a_owner_mask;
+		else if (in_owner_or_group_class)
+			file_mask = acl->a_group_mask;
+		else
+			file_mask = acl->a_other_mask;
+		denied |= requested & ~file_mask;
+	}
 
 	return denied ? -EACCES : 0;
 }
@@ -563,7 +579,7 @@ richacl_equiv_mode(const struct richacl *acl, mode_t *mode_p)
 	mode_t mode;
 
 	if (acl->a_count != 1 ||
-	    acl->a_flags ||
+	    acl->a_flags != ACL4_MASKED ||
 	    !richace_is_everyone(ace) ||
 	    !richace_is_allow(ace) ||
 	    ace->e_flags & ~ACE4_SPECIAL_WHO)
diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
index 9adbd62..4aa0b7d 100644
--- a/fs/richacl_compat.c
+++ b/fs/richacl_compat.c
@@ -699,20 +699,25 @@ __richacl_apply_masks(struct richacl_alloc *x)
 int
 richacl_apply_masks(struct richacl **acl)
 {
-	struct richacl_alloc x = {
-		.acl = *acl,
-		.count = (*acl)->a_count,
-	};
 	int retval = 0;
 
-	if (richacl_move_everyone_aces_down(&x) ||
-	    richacl_propagate_everyone(&x) ||
-	    __richacl_apply_masks(&x) ||
-	    richacl_isolate_owner_class(&x) ||
-	    richacl_isolate_group_class(&x))
-		retval = -ENOMEM;
+	if ((*acl)->a_flags & ACL4_MASKED) {
+		struct richacl_alloc x = {
+			.acl = *acl,
+			.count = (*acl)->a_count,
+		};
+
+		if (richacl_move_everyone_aces_down(&x) ||
+		    richacl_propagate_everyone(&x) ||
+		    __richacl_apply_masks(&x) ||
+		    richacl_isolate_owner_class(&x) ||
+		    richacl_isolate_group_class(&x))
+			retval = -ENOMEM;
+
+		x.acl->a_flags &= ~ACL4_MASKED;
+		*acl = x.acl;
+	}
 
-	*acl = x.acl;
 	return retval;
 }
 EXPORT_SYMBOL_GPL(richacl_apply_masks);
@@ -730,12 +735,12 @@ richacl_from_mode(mode_t mode)
 	acl = richacl_alloc(1);
 	if (!acl)
 		return NULL;
-	ace = acl->a_entries;
-
+	acl->a_flags = ACL4_MASKED;
 	acl->a_owner_mask = richacl_mode_to_mask(mode >> 6);
 	acl->a_group_mask = richacl_mode_to_mask(mode >> 3);
 	acl->a_other_mask = richacl_mode_to_mask(mode);
 
+	ace = acl->a_entries;
 	ace->e_type  = ACE4_ACCESS_ALLOWED_ACE_TYPE;
 	ace->e_flags = ACE4_SPECIAL_WHO;
 	ace->e_mask = ACE4_POSIX_MODE_ALL;
diff --git a/fs/richacl_inode.c b/fs/richacl_inode.c
index 1e9c901..6be821a 100644
--- a/fs/richacl_inode.c
+++ b/fs/richacl_inode.c
@@ -224,6 +224,7 @@ richacl_inherit_inode(const struct richacl *dir_acl, struct inode *inode)
 		 * Ensure that the acl will not grant any permissions beyond
 		 * the create mode.
 		 */
+		acl->a_flags |= ACL4_MASKED;
 		acl->a_owner_mask &= richacl_mode_to_mask(inode->i_mode >> 6);
 		acl->a_group_mask &= richacl_mode_to_mask(inode->i_mode >> 3);
 		acl->a_other_mask &= richacl_mode_to_mask(inode->i_mode);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 74b4c80..8ff317c 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -51,6 +51,7 @@ struct richacl {
 #define ACL4_AUTO_INHERIT		0x01
 #define ACL4_PROTECTED			0x02
 /*#define ACL4_DEFAULTED			0x04*/
+#define ACL4_MASKED			0x08
 
 #define ACL4_VALID_FLAGS (	\
 	ACL4_AUTO_INHERIT |	\
-- 
1.7.1.rc2
