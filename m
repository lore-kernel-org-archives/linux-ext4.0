From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 22/23] nfsd: Add support for reading rich acl from file system
Date: Mon,  1 Feb 2010 11:05:04 +0530
Message-ID: <1265002505-8387-23-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

With this patch nfsd will check whether exported file system
use richacl format. If yes it will read richacl format and
map it to NFSv4acl. Richacl can be better mapped to NFSv4
acl format.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/nfsd/vfs.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 3046ecd..ce727a5 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -23,6 +23,7 @@
 #include <linux/quotaops.h>
 #include <linux/fsnotify.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/richacl_xattr.h>
 #include <linux/xattr.h>
 #include <linux/jhash.h>
 #include <linux/ima.h>
@@ -588,6 +589,40 @@ nfsd4_get_posix_acl(struct dentry *dentry)
 	return acl;
 }
 
+static struct richacl *
+__get_richacl(struct dentry *dentry)
+{
+	int buflen;
+	void *buf = NULL;
+	struct richacl *racl;
+
+	buflen = nfsd_getxattr(dentry, RICHACL_XATTR, &buf);
+	if (!buflen)
+		buflen = -ENODATA;
+	if (buflen <= 0)
+		return ERR_PTR(buflen);
+
+	racl = richacl_from_xattr(buf, buflen);
+	kfree(buf);
+	return racl;
+}
+
+static struct nfs4_acl *
+nfsd4_get_richacl(struct dentry *dentry)
+{
+	struct nfs4_acl *acl;
+	struct richacl *racl;
+	racl = __get_richacl(dentry);
+	if (IS_ERR(racl) && PTR_ERR(racl) == -ENODATA)
+		racl = richacl_from_mode(dentry->d_inode->i_mode);
+	if (IS_ERR(racl))
+		return ERR_PTR(PTR_ERR(racl));
+	acl = nfs4_acl_richacl_to_nfsv4(racl);
+
+	richacl_put(racl);
+	return acl;
+}
+
 int
 nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry, struct nfs4_acl **acl)
 {
@@ -596,6 +631,8 @@ nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry, struct nfs4_ac
 
 	if (IS_POSIXACL(inode))
 		*acl = nfsd4_get_posix_acl(dentry);
+	else if (IS_RICHACL(inode))
+		*acl = nfsd4_get_richacl(dentry);
 	else {
 		*acl = NULL;
 		error = -EOPNOTSUPP;
-- 
1.7.0.rc0.48.gdace5

