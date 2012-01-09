From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 5 4/4] nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)
Date: Mon, 09 Jan 2012 14:21:58 +0100
Message-ID: <20120109132158.2616029.30467.stgit@localhost.localdomain>
References: <20120109132137.2616029.76288.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, yong.fan@whamcloud.com,
	"J. Bruce Fields" <bfields@redhat.com>, sandeen@redhat.com,
	adilger@whamcloud.com
To: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120109132137.2616029.76288.stgit@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use 32-bit or 64-bit llseek() hashes for directory offsets depending on
the NFS version. NFSv2 gets 32-bit hashes only.

NOTE: This patch got rather complex as Christoph asked to set the
filp->f_mode flag in the open call or immediatly after dentry_open()
in nfsd_open() to avoid races.
Personally I still do not see a reason for that and in my opinion
FMODE_32BITHASH/FMODE_64BITHASH flags could be set nfsd_readdir(), as it
follows directly after nfsd_open() without a chance of races.


Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Acked-by: J. Bruce Fields<bfields@redhat.com>
---
 fs/nfsd/vfs.c |   15 +++++++++++++--
 fs/nfsd/vfs.h |    2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 20fa252..f162dc3 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -785,9 +785,15 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
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
@@ -2011,8 +2017,13 @@ nfsd_readdir(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t *offsetp,
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
index 1dcd238..ec0611b 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -27,6 +27,8 @@
 #define NFSD_MAY_BYPASS_GSS		0x400
 #define NFSD_MAY_READ_IF_EXEC		0x800
 
+#define NFSD_MAY_64BIT_COOKIE		0x1000 /* 64 bit readdir cookies for >= NFSv3 */
+
 #define NFSD_MAY_CREATE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE)
 #define NFSD_MAY_REMOVE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC)
 

