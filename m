From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: [PATCH 4/6] nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)
Date: Tue, 16 Aug 2011 13:25:57 +0200
Message-ID: <20110816112557.1808464.64349.stgit@fsdevel3>
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

Use 32-bit or 64-bit llseek() hashes for directory offsets depending on
the NFS version. NFSv2 gets 32-bit hashes only.

NOTE: This patch got rather complex as Christoph asked to set the
filp->f_mode flag in the open call or immediatly after dentry_open()
in nfsd_open() to avoid races.
Personally I still do not see a reason for that and in my opinion
FMODE_32BITHASH/FMODE_64BITHASH flags could be set nfsd_readdir(), as it
follows directly after nfsd_open() without a chance of races.


Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
---
 fs/nfsd/vfs.c |   15 +++++++++++++--
 fs/nfsd/vfs.h |    2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ca692b4..97a99f1 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -767,9 +767,15 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 			    flags, current_cred());
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
-	else
+	else {
 		host_err = ima_file_check(*filp, may_flags);
 
+		if (may_flags & NFSD_MAY_64BIT_COOKIE)
+			(*filp)->f_mode |= FMODE_64BITHASH;
+		else
+			(*filp)->f_mode |= FMODE_32BITHASH;
+	}
+
 out_nfserr:
 	err = nfserrno(host_err);
 out:
@@ -1991,8 +1997,13 @@ nfsd_readdir(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t *offsetp,
 	__be32		err;
 	struct file	*file;
 	loff_t		offset = *offsetp;
+	int             may_flags = NFSD_MAY_READ;
+
+	/* NFSv2 only supports 32 bit cookies */
+	if (rqstp->rq_vers > 2)
+		may_flags |= NFSD_MAY_64BIT_COOKIE;
 
-	err = nfsd_open(rqstp, fhp, S_IFDIR, NFSD_MAY_READ, &file);
+	err = nfsd_open(rqstp, fhp, S_IFDIR, may_flags, &file);
 	if (err)
 		goto out;
 
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index e0bbac0..ecd00e1 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -26,6 +26,8 @@
 #define NFSD_MAY_NOT_BREAK_LEASE 512
 #define NFSD_MAY_BYPASS_GSS	1024
 
+#define NFSD_MAY_64BIT_COOKIE	2048 /* 64 bit readdir cookies for >= NFSv3 */
+
 #define NFSD_MAY_CREATE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE)
 #define NFSD_MAY_REMOVE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC)
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
