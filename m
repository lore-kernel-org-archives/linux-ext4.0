From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: [PATCH 3/6] nfsd_open(): rename 'int access' to 'int may_flags' in
	nfsd_open()
Date: Tue, 16 Aug 2011 13:25:52 +0200
Message-ID: <20110816112552.1808464.49310.stgit@fsdevel3>
References: <20110816112536.1808464.7174.stgit@fsdevel3>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110816112536.1808464.7174.stgit@fsdevel3>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Just rename this variable, as the next patch will add a flag and
'access' as variable name would not be correct any more.


Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
---
 fs/nfsd/vfs.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index fd0acca..ca692b4 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -708,12 +708,13 @@ static int nfsd_open_break_lease(struct inode *inode, int access)
 
 /*
  * Open an existing file or directory.
- * The access argument indicates the type of open (read/write/lock)
+ * The may_flags argument indicates the type of open (read/write/lock)
+ * and additional flags.
  * N.B. After this call fhp needs an fh_put
  */
 __be32
 nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
-			int access, struct file **filp)
+			int may_flags, struct file **filp)
 {
 	struct dentry	*dentry;
 	struct inode	*inode;
@@ -728,7 +729,7 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	 * and (hopefully) checked permission - so allow OWNER_OVERRIDE
 	 * in case a chmod has now revoked permission.
 	 */
-	err = fh_verify(rqstp, fhp, type, access | NFSD_MAY_OWNER_OVERRIDE);
+	err = fh_verify(rqstp, fhp, type, may_flags | NFSD_MAY_OWNER_OVERRIDE);
 	if (err)
 		goto out;
 
@@ -739,7 +740,7 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	 * or any access when mandatory locking enabled
 	 */
 	err = nfserr_perm;
-	if (IS_APPEND(inode) && (access & NFSD_MAY_WRITE))
+	if (IS_APPEND(inode) && (may_flags & NFSD_MAY_WRITE))
 		goto out;
 	/*
 	 * We must ignore files (but only files) which might have mandatory
@@ -752,12 +753,12 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	if (!inode->i_fop)
 		goto out;
 
-	host_err = nfsd_open_break_lease(inode, access);
+	host_err = nfsd_open_break_lease(inode, may_flags);
 	if (host_err) /* NOMEM or WOULDBLOCK */
 		goto out_nfserr;
 
-	if (access & NFSD_MAY_WRITE) {
-		if (access & NFSD_MAY_READ)
+	if (may_flags & NFSD_MAY_WRITE) {
+		if (may_flags & NFSD_MAY_READ)
 			flags = O_RDWR|O_LARGEFILE;
 		else
 			flags = O_WRONLY|O_LARGEFILE;
@@ -767,7 +768,8 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
 	else
-		host_err = ima_file_check(*filp, access);
+		host_err = ima_file_check(*filp, may_flags);
+
 out_nfserr:
 	err = nfserrno(host_err);
 out:

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
