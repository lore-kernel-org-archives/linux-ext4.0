From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 20/23] nfsd: Apply NFSv4acl to posix acl mapping only if MS_POSIXACL is set
Date: Mon,  1 Feb 2010 11:05:02 +0530
Message-ID: <1265002505-8387-21-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

We should be doing NFSv4 acl to POSIX acl mapping only if
MS_POSIXACL flag is set in the superblock.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/nfsd/vfs.c |   87 ++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 58 insertions(+), 29 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c194793..3046ecd 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -476,31 +476,18 @@ out:
 	return error;
 }
 
-__be32
-nfsd4_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
-    struct nfs4_acl *acl)
+static __be32
+nfsd4_set_posix_acl(struct dentry *dentry,
+		struct nfs4_acl *acl, unsigned int flags)
 {
-	__be32 error;
 	int host_error;
-	struct dentry *dentry;
-	struct inode *inode;
+	struct inode *inode = dentry->d_inode;
 	struct posix_acl *pacl = NULL, *dpacl = NULL;
-	unsigned int flags = 0;
-
-	/* Get inode */
-	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, NFSD_MAY_SATTR);
-	if (error)
-		return error;
-
-	dentry = fhp->fh_dentry;
-	inode = dentry->d_inode;
-	if (S_ISDIR(inode->i_mode))
-		flags = NFS4_ACL_DIR;
 
 	host_error = nfs4_acl_nfsv4_to_posix(acl, &pacl, &dpacl, flags);
-	if (host_error == -EINVAL) {
+	if (host_error == -EINVAL)
 		return nfserr_attrnotsupp;
-	} else if (host_error < 0)
+	else if (host_error < 0)
 		goto out_nfserr;
 
 	host_error = set_nfsv4_acl_one(dentry, pacl, POSIX_ACL_XATTR_ACCESS);
@@ -520,6 +507,33 @@ out_nfserr:
 		return nfserrno(host_error);
 }
 
+__be32
+nfsd4_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
+    struct nfs4_acl *acl)
+{
+	__be32 error;
+	struct dentry *dentry;
+	struct inode *inode;
+	unsigned int flags = 0;
+
+	/* Get inode */
+	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, NFSD_MAY_SATTR);
+	if (error)
+		return error;
+
+	dentry = fhp->fh_dentry;
+	inode = dentry->d_inode;
+	if (S_ISDIR(inode->i_mode))
+		flags = NFS4_ACL_DIR;
+
+	if (IS_POSIXACL(inode))
+		error = nfsd4_set_posix_acl(dentry, acl, flags);
+	else
+		error = nfserr_attrnotsupp;
+
+	return error;
+}
+
 static struct posix_acl *
 _get_posix_acl(struct dentry *dentry, char *key)
 {
@@ -538,19 +552,19 @@ _get_posix_acl(struct dentry *dentry, char *key)
 	return pacl;
 }
 
-int
-nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry, struct nfs4_acl **acl)
+static struct nfs4_acl *
+nfsd4_get_posix_acl(struct dentry *dentry)
 {
+	struct nfs4_acl *acl;
+	unsigned int flags = 0;
 	struct inode *inode = dentry->d_inode;
-	int error = 0;
 	struct posix_acl *pacl = NULL, *dpacl = NULL;
-	unsigned int flags = 0;
 
 	pacl = _get_posix_acl(dentry, POSIX_ACL_XATTR_ACCESS);
 	if (IS_ERR(pacl) && PTR_ERR(pacl) == -ENODATA)
 		pacl = posix_acl_from_mode(inode->i_mode, GFP_KERNEL);
 	if (IS_ERR(pacl)) {
-		error = PTR_ERR(pacl);
+		acl  = ERR_PTR(PTR_ERR(pacl));
 		pacl = NULL;
 		goto out;
 	}
@@ -560,21 +574,36 @@ nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry, struct nfs4_ac
 		if (IS_ERR(dpacl) && PTR_ERR(dpacl) == -ENODATA)
 			dpacl = NULL;
 		else if (IS_ERR(dpacl)) {
-			error = PTR_ERR(dpacl);
+			acl  = ERR_PTR(PTR_ERR(dpacl));
 			dpacl = NULL;
 			goto out;
 		}
 		flags = NFS4_ACL_DIR;
 	}
 
-	*acl = nfs4_acl_posix_to_nfsv4(pacl, dpacl, flags);
+	acl = nfs4_acl_posix_to_nfsv4(pacl, dpacl, flags);
+ out:
+	posix_acl_release(pacl);
+	posix_acl_release(dpacl);
+	return acl;
+}
+
+int
+nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry, struct nfs4_acl **acl)
+{
+	int error = 0;
+	struct inode *inode = dentry->d_inode;
+
+	if (IS_POSIXACL(inode))
+		*acl = nfsd4_get_posix_acl(dentry);
+	else {
+		*acl = NULL;
+		error = -EOPNOTSUPP;
+	}
 	if (IS_ERR(*acl)) {
 		error = PTR_ERR(*acl);
 		*acl = NULL;
 	}
- out:
-	posix_acl_release(pacl);
-	posix_acl_release(dpacl);
 	return error;
 }
 
-- 
1.7.0.rc0.48.gdace5

