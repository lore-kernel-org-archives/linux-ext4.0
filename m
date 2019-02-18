Return-Path: <SRS0=geXL=QZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56875C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 10:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21EF02146F
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 10:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfBRKEP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:04:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728955AbfBRKEO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Feb 2019 05:04:14 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1IA3u73023178
        for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2019 05:04:14 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qqrf5dm3v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2019 05:04:13 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 18 Feb 2019 10:04:12 -0000
Received: from b03cxnp08026.gho.boulder.ibm.com (9.17.130.18)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 18 Feb 2019 10:04:10 -0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1IA49Lj29425786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Feb 2019 10:04:09 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5316B136063;
        Mon, 18 Feb 2019 10:04:09 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDAD5136051;
        Mon, 18 Feb 2019 10:04:06 +0000 (GMT)
Received: from localhost.in.ibm.com (unknown [9.124.35.115])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 18 Feb 2019 10:04:06 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.vnet.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [RFC PATCH 02/10] f2fs: use IS_ENCRYPTED() to check encryption status
Date:   Mon, 18 Feb 2019 15:34:25 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190218100433.20048-1-chandan@linux.ibm.com>
References: <20190218100433.20048-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19021810-8235-0000-0000-00000E607B51
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010619; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000280; SDB=6.01162773; UDB=6.00607075; IPR=6.00943349;
 MB=3.00025633; MTD=3.00000008; XFM=3.00000015; UTC=2019-02-18 10:04:12
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19021810-8236-0000-0000-000044846E05
Message-Id: <20190218100433.20048-3-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-18_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902180077
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Chandan Rajendra <chandan@linux.vnet.ibm.com>

This commit removes the f2fs specific f2fs_encrypted_inode() and makes
use of the generic IS_ENCRYPTED() macro to check for the encryption
status of an inode.

Acked-by: Chao Yu <yuchao0@huawei.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/f2fs/data.c  |  4 ++--
 fs/f2fs/dir.c   | 10 +++++-----
 fs/f2fs/f2fs.h  |  7 +------
 fs/f2fs/file.c  | 10 +++++-----
 fs/f2fs/inode.c |  4 ++--
 fs/f2fs/namei.c |  6 +++---
 6 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2cba513b7b8c..dca01fbe9c21 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1495,7 +1495,7 @@ int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	}
 
 	if (size) {
-		if (f2fs_encrypted_inode(inode))
+		if (IS_ENCRYPTED(inode))
 			flags |= FIEMAP_EXTENT_DATA_ENCRYPTED;
 
 		ret = fiemap_fill_next_extent(fieinfo, logical,
@@ -1769,7 +1769,7 @@ static inline bool check_inplace_update_policy(struct inode *inode,
 	if (policy & (0x1 << F2FS_IPU_ASYNC) &&
 			fio && fio->op == REQ_OP_WRITE &&
 			!(fio->op_flags & REQ_SYNC) &&
-			!f2fs_encrypted_inode(inode))
+			!IS_ENCRYPTED(inode))
 		return true;
 
 	/* this is only set during fdatasync */
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 50d0d36280fa..713b36a10a79 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -385,7 +385,7 @@ struct page *f2fs_init_inode_metadata(struct inode *inode, struct inode *dir,
 		if (err)
 			goto put_error;
 
-		if ((f2fs_encrypted_inode(dir) || dummy_encrypt) &&
+		if ((IS_ENCRYPTED(dir) || dummy_encrypt) &&
 					f2fs_may_encrypt(inode)) {
 			err = fscrypt_inherit_context(dir, inode, page, false);
 			if (err)
@@ -399,7 +399,7 @@ struct page *f2fs_init_inode_metadata(struct inode *inode, struct inode *dir,
 
 	if (new_name) {
 		init_dent_inode(new_name, page);
-		if (f2fs_encrypted_inode(dir))
+		if (IS_ENCRYPTED(dir))
 			file_set_enc_name(inode);
 	}
 
@@ -819,7 +819,7 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 			goto out;
 		}
 
-		if (f2fs_encrypted_inode(d->inode)) {
+		if (IS_ENCRYPTED(d->inode)) {
 			int save_len = fstr->len;
 
 			err = fscrypt_fname_disk_to_usr(d->inode,
@@ -862,7 +862,7 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
 	int err = 0;
 
-	if (f2fs_encrypted_inode(inode)) {
+	if (IS_ENCRYPTED(inode)) {
 		err = fscrypt_get_encryption_info(inode);
 		if (err && err != -ENOKEY)
 			goto out;
@@ -924,7 +924,7 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 
 static int f2fs_dir_open(struct inode *inode, struct file *filp)
 {
-	if (f2fs_encrypted_inode(inode))
+	if (IS_ENCRYPTED(inode))
 		return fscrypt_get_encryption_info(inode) ? -EACCES : 0;
 	return 0;
 }
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 0634b10697f0..520558a3fb63 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3466,14 +3466,9 @@ void f2fs_unregister_sysfs(struct f2fs_sb_info *sbi);
 /*
  * crypto support
  */
-static inline bool f2fs_encrypted_inode(struct inode *inode)
-{
-	return file_is_encrypt(inode);
-}
-
 static inline bool f2fs_encrypted_file(struct inode *inode)
 {
-	return f2fs_encrypted_inode(inode) && S_ISREG(inode->i_mode);
+	return IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode);
 }
 
 static inline void f2fs_set_encrypted_inode(struct inode *inode)
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 07ebbf4e492d..dd8f1c38b436 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -586,7 +586,7 @@ static int truncate_partial_data_page(struct inode *inode, u64 from,
 	zero_user(page, offset, PAGE_SIZE - offset);
 
 	/* An encrypted inode should have a key and truncate the last page. */
-	f2fs_bug_on(F2FS_I_SB(inode), cache_only && f2fs_encrypted_inode(inode));
+	f2fs_bug_on(F2FS_I_SB(inode), cache_only && IS_ENCRYPTED(inode));
 	if (!cache_only)
 		set_page_dirty(page);
 	f2fs_put_page(page, 1);
@@ -731,7 +731,7 @@ int f2fs_getattr(const struct path *path, struct kstat *stat,
 		stat->attributes |= STATX_ATTR_APPEND;
 	if (flags & F2FS_COMPR_FL)
 		stat->attributes |= STATX_ATTR_COMPRESSED;
-	if (f2fs_encrypted_inode(inode))
+	if (IS_ENCRYPTED(inode))
 		stat->attributes |= STATX_ATTR_ENCRYPTED;
 	if (flags & F2FS_IMMUTABLE_FL)
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
@@ -1587,7 +1587,7 @@ static long f2fs_fallocate(struct file *file, int mode,
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 
-	if (f2fs_encrypted_inode(inode) &&
+	if (IS_ENCRYPTED(inode) &&
 		(mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)))
 		return -EOPNOTSUPP;
 
@@ -1671,7 +1671,7 @@ static int f2fs_ioc_getflags(struct file *filp, unsigned long arg)
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	unsigned int flags = fi->i_flags;
 
-	if (f2fs_encrypted_inode(inode))
+	if (IS_ENCRYPTED(inode))
 		flags |= F2FS_ENCRYPT_FL;
 	if (f2fs_has_inline_data(inode) || f2fs_has_inline_dentry(inode))
 		flags |= F2FS_INLINE_DATA_FL;
@@ -2438,7 +2438,7 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
 	if (!S_ISREG(src->i_mode) || !S_ISREG(dst->i_mode))
 		return -EINVAL;
 
-	if (f2fs_encrypted_inode(src) || f2fs_encrypted_inode(dst))
+	if (IS_ENCRYPTED(src) || IS_ENCRYPTED(dst))
 		return -EOPNOTSUPP;
 
 	if (src == dst) {
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index fe702cb3f4ec..5053944ed221 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -43,7 +43,7 @@ void f2fs_set_inode_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (flags & F2FS_DIRSYNC_FL)
 		new_fl |= S_DIRSYNC;
-	if (f2fs_encrypted_inode(inode))
+	if (file_is_encrypt(inode))
 		new_fl |= S_ENCRYPTED;
 	if (file_is_verity(inode))
 		new_fl |= S_VERITY;
@@ -455,7 +455,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_mapping->a_ops = &f2fs_dblock_aops;
 		inode_nohighmem(inode);
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (f2fs_encrypted_inode(inode))
+		if (file_is_encrypt(inode))
 			inode->i_op = &f2fs_encrypted_symlink_inode_operations;
 		else
 			inode->i_op = &f2fs_symlink_inode_operations;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 62d9829f3a6a..e967d27c1a89 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -75,7 +75,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	set_inode_flag(inode, FI_NEW_INODE);
 
 	/* If the directory encrypted, then we should encrypt the inode. */
-	if ((f2fs_encrypted_inode(dir) || DUMMY_ENCRYPTION_ENABLED(sbi)) &&
+	if ((IS_ENCRYPTED(dir) || DUMMY_ENCRYPTION_ENABLED(sbi)) &&
 				f2fs_may_encrypt(inode))
 		f2fs_set_encrypted_inode(inode);
 
@@ -476,7 +476,7 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 		if (err)
 			goto out_iput;
 	}
-	if (f2fs_encrypted_inode(dir) &&
+	if (IS_ENCRYPTED(dir) &&
 	    (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)) &&
 	    !fscrypt_has_permitted_context(dir, inode)) {
 		f2fs_msg(inode->i_sb, KERN_WARNING,
@@ -803,7 +803,7 @@ static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (unlikely(f2fs_cp_error(sbi)))
 		return -EIO;
 
-	if (f2fs_encrypted_inode(dir) || DUMMY_ENCRYPTION_ENABLED(sbi)) {
+	if (IS_ENCRYPTED(dir) || DUMMY_ENCRYPTION_ENABLED(sbi)) {
 		int err = fscrypt_get_encryption_info(dir);
 		if (err)
 			return err;
-- 
2.19.1

