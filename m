From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH] ext4: Fix check of dqget() return value in ext4_ioctl_setproject()
Date: Tue, 29 Mar 2016 08:01:03 -0500
Message-ID: <1459256463-48543-1-git-send-email-seth.forshee@canonical.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

A failed call to dqget() returns an ERR_PTR() and not null. Fix
the check in ext4_ioctl_setproject() to handle this correctly.

Fixes: 9b7365fc1c82 ("ext4: add FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support")
Cc: stable@vger.kernel.org # v4.5
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/ext4/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 322f5bdbf76a..dd82cf1c4e39 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -365,7 +365,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 		struct dquot *transfer_to[MAXQUOTAS] = { };
 
 		transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
-		if (transfer_to[PRJQUOTA]) {
+		if (!IS_ERR(transfer_to[PRJQUOTA])) {
 			err = __dquot_transfer(inode, transfer_to);
 			dqput(transfer_to[PRJQUOTA]);
 			if (err)
-- 
1.9.1
