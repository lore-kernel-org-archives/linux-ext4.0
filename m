From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 23/23] nfsd: Add support for saving richacl
Date: Mon,  1 Feb 2010 11:05:05 +0530
Message-ID: <1265002505-8387-24-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

With this patch nfsd will check whether the exported filesystem
use richacl format. If yes nfsd will map NFSv4 acl to richacl
and save the acl in richacl format ondisk. NFSv4 acl can be
better mapped to richacl format without loosing information.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/nfsd/vfs.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ce727a5..a1e5895 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -508,6 +508,50 @@ out_nfserr:
 		return nfserrno(host_error);
 }
 
+static int
+__set_richacl(struct dentry *dentry, struct richacl *racl)
+{
+	size_t buflen;
+	char *buf = NULL;
+	int error = 0;
+
+	buflen = richacl_xattr_size(racl);
+	buf = kmalloc(buflen, GFP_KERNEL);
+	error = -ENOMEM;
+	if (buf == NULL)
+		goto out;
+
+	richacl_to_xattr(racl, buf);
+	error = vfs_setxattr(dentry, RICHACL_XATTR, buf, buflen, 0);
+out:
+	kfree(buf);
+	return error;
+}
+
+static __be32
+nfsd4_set_richacl(struct dentry *dentry, struct nfs4_acl *acl)
+{
+	int host_error;
+	struct richacl *racl;
+
+	host_error = nfs4_acl_nfsv4_to_richacl(acl, &racl);
+	if (host_error == -EINVAL)
+		return nfserr_attrnotsupp;
+	else if (host_error < 0)
+		goto out_nfserr;
+
+	host_error = __set_richacl(dentry, racl);
+	if (host_error < 0)
+		goto out_release;
+out_release:
+	richacl_put(racl);
+out_nfserr:
+	if (host_error == -EOPNOTSUPP)
+		return nfserr_attrnotsupp;
+	else
+		return nfserrno(host_error);
+}
+
 __be32
 nfsd4_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
     struct nfs4_acl *acl)
@@ -529,6 +573,8 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	if (IS_POSIXACL(inode))
 		error = nfsd4_set_posix_acl(dentry, acl, flags);
+	else if (IS_RICHACL(inode))
+		error = nfsd4_set_richacl(dentry, acl);
 	else
 		error = nfserr_attrnotsupp;
 
-- 
1.7.0.rc0.48.gdace5

