From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 19/23] fs: Use the correct MS_*ACL flags in file system code
Date: Mon,  1 Feb 2010 11:05:01 +0530
Message-ID: <1265002505-8387-20-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52769 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0BAFfY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:24 -0500
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should use MS_ACL flag when we want to check whether
we want to enforce some generic acl rules like not
using umask values.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c    |   26 ++++++++++++++++++++------
 fs/nfs/nfs4proc.c  |    2 +-
 fs/nfsd/nfs4proc.c |    2 +-
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fb051a1..bd75b27 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2500,9 +2500,16 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			   &journal_ioprio, NULL, 0))
 		goto failed_mount;
 
-	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT4_MOUNT_ACL) ? MS_POSIXACL : 0);
-
+	if (test_opt(sb, ACL)) {
+		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+					EXT4_FEATURE_INCOMPAT_RICHACL)) {
+			sb->s_flags &= ~MS_POSIXACL;
+			sb->s_flags |= MS_RICHACL;
+		} else {
+			sb->s_flags &= ~MS_RICHACL;
+			sb->s_flags |= MS_POSIXACL;
+		}
+	}
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV &&
 	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT4_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
@@ -3537,9 +3544,16 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
 		ext4_abort(sb, __func__, "Abort forced by user");
 
-	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT4_MOUNT_ACL) ? MS_POSIXACL : 0);
-
+	if (test_opt(sb, ACL)) {
+		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+					EXT4_FEATURE_INCOMPAT_RICHACL)) {
+			sb->s_flags &= ~MS_POSIXACL;
+			sb->s_flags |= MS_RICHACL;
+		} else {
+			sb->s_flags &= ~MS_RICHACL;
+			sb->s_flags |= MS_POSIXACL;
+		}
+	}
 	es = sbi->s_es;
 
 	if (sbi->s_journal) {
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 198d51d..fa957f1 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2005,7 +2005,7 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	if (nd->flags & LOOKUP_CREATE) {
 		attr.ia_mode = nd->intent.open.create_mode;
 		attr.ia_valid = ATTR_MODE;
-		if (!IS_POSIXACL(dir))
+		if (!IS_ACL(dir))
 			attr.ia_mode &= ~current_umask();
 	} else {
 		attr.ia_valid = 0;
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 37514c4..9ac23d6 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -72,7 +72,7 @@ check_attr_support(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	 * in current environment or not.
 	 */
 	if (bmval[0] & FATTR4_WORD0_ACL) {
-		if (!IS_POSIXACL(dentry->d_inode))
+		if (!IS_ACL(dentry->d_inode))
 			return nfserr_attrnotsupp;
 	}
 
-- 
1.7.0.rc0.48.gdace5

