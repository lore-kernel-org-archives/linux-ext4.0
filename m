Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726005AbeLDJ5v (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 04:57:51 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wB49ru0u119516
        for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2018 04:57:50 -0500
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2p5pn7jbaq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Tue, 04 Dec 2018 04:57:49 -0500
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 4 Dec 2018 09:57:49 -0000
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
Subject: [PATCH V2 6/7] f2fs: use IS_VERITY() to check inode's fsverity status
Date: Tue,  4 Dec 2018 15:26:49 +0530
In-Reply-To: <20181204095650.12562-1-chandan@linux.vnet.ibm.com>
References: <20181204095650.12562-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20181204095650.12562-7-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit now uses IS_VERITY() macro to check if fsverity is
enabled on an inode.

Acked-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/f2fs/file.c  | 6 +++---
 fs/f2fs/inode.c | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6c7ad15000b9..2eb4821d95d1 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -491,7 +491,7 @@ static int f2fs_file_open(struct inode *inode, struct file *filp)
 	if (err)
 		return err;
 
-	if (f2fs_verity_file(inode)) {
+	if (IS_VERITY(inode)) {
 		err = fsverity_file_open(inode, filp);
 		if (err)
 			return err;
@@ -701,7 +701,7 @@ int f2fs_getattr(const struct path *path, struct kstat *stat,
 	struct f2fs_inode *ri;
 	unsigned int flags;
 
-	if (f2fs_verity_file(inode)) {
+	if (IS_VERITY(inode)) {
 		/*
 		 * For fs-verity we need to override i_size with the original
 		 * data i_size.  This requires I/O to the file which with
@@ -800,7 +800,7 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	if (err)
 		return err;
 
-	if (f2fs_verity_file(inode)) {
+	if (IS_VERITY(inode)) {
 		err = fsverity_prepare_setattr(dentry, attr);
 		if (err)
 			return err;
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index ddef483ad689..02806feed64c 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -45,9 +45,11 @@ void f2fs_set_inode_flags(struct inode *inode)
 		new_fl |= S_DIRSYNC;
 	if (f2fs_encrypted_inode(inode))
 		new_fl |= S_ENCRYPTED;
+	if (f2fs_verity_file(inode))
+		new_fl |= S_VERITY;
 	inode_set_flags(inode, new_fl,
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|
-			S_ENCRYPTED);
+			S_ENCRYPTED|S_VERITY);
 }
 
 static void __get_inode_rdev(struct inode *inode, struct f2fs_inode *ri)
-- 
2.19.1
