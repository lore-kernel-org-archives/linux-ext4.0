Return-Path: <SRS0=oRRr=OR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726263AbeLHGxc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2018 01:53:32 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wB86mOcS028007
        for <linux-ext4@vger.kernel.org>; Sat, 8 Dec 2018 01:53:31 -0500
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2p81fcr4bp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2018 01:53:31 -0500
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 8 Dec 2018 06:53:30 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-mips@linux-mips.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com, corbet@lwn.net, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, green.hu@gmail.com,
        deanbo422@gmail.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, richard@nod.at, dedekind1@gmail.com,
        adrian.hunter@intel.com, viro@zeniv.linux.org.uk
Subject: [PATCH V3 9/9] fsverity: Move verity status check to fsverity_prepare_setattr
Date: Sat,  8 Dec 2018 12:21:44 +0530
In-Reply-To: <20181208065144.19486-1-chandan@linux.vnet.ibm.com>
References: <20181208065144.19486-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20181208065144.19486-10-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Instead of conditionally checking for verity status of an inode before
invoking fsverity_prepare_setattr(), this commit moves the check inside the
definition of fsverity_prepare_setattr().

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/ext4/inode.c   | 8 +++-----
 fs/f2fs/file.c    | 8 +++-----
 fs/verity/setup.c | 2 +-
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 703f55635824..44561e68886b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5510,11 +5510,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (error)
 		return error;
 
-	if (IS_VERITY(inode)) {
-		error = fsverity_prepare_setattr(dentry, attr);
-		if (error)
-			return error;
-	}
+	error = fsverity_prepare_setattr(dentry, attr);
+	if (error)
+		return error;
 
 	if (is_quota_modification(inode, attr)) {
 		error = dquot_initialize(inode);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 925c0d9608da..422907ca37c6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -798,11 +798,9 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	if (err)
 		return err;
 
-	if (IS_VERITY(inode)) {
-		err = fsverity_prepare_setattr(dentry, attr);
-		if (err)
-			return err;
-	}
+	err = fsverity_prepare_setattr(dentry, attr);
+	if (err)
+		return err;
 
 	if (is_quota_modification(inode, attr)) {
 		err = dquot_initialize(inode);
diff --git a/fs/verity/setup.c b/fs/verity/setup.c
index bc463dc601b1..154556d72691 100644
--- a/fs/verity/setup.c
+++ b/fs/verity/setup.c
@@ -796,7 +796,7 @@ EXPORT_SYMBOL_GPL(fsverity_file_open);
  */
 int fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	if (attr->ia_valid & ATTR_SIZE) {
+	if (IS_VERITY(d_inode(dentry)) && (attr->ia_valid & ATTR_SIZE)) {
 		pr_debug("Denying truncate of verity file (ino %lu)\n",
 			 d_inode(dentry)->i_ino);
 		return -EPERM;
-- 
2.19.1
