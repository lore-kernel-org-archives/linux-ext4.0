Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC584C282DC
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BF852229E
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549906197;
	bh=HwPSPOr0wYTAZtr3ktUBjfwT7zSYqPUr1q4dWM5JAMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OK4ZEEz/V/DdUUSE8tTpvna4McPPmoHxeFbbx8ZB8zSdZheDbtZAZdKZsykmkGY7v
	 GHFJsnA61aPB8+ds4GI/w6l+KloorZXNZU4dx/mLY7L44zgEfwrpcEueDSgBHtggBX
	 tmvdrxCvtieEuUO1S/iao8RWwSirdvGou9T+B2oQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbfBKR3v (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:29:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbfBKR3q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 12:29:46 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3519222B3;
        Mon, 11 Feb 2019 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549906185;
        bh=HwPSPOr0wYTAZtr3ktUBjfwT7zSYqPUr1q4dWM5JAMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OX32Gq18yhhxMwUzvbLmeCf78FU4jlhXp0xFEA6g88pDlDqfTQeT04C55DSXqA4fR
         O4MksU4nxRUNK9sd3cwrpfWIz5EIL8I9KwD3mLFjghwvjbVgpn56iAkctgzdaim44z
         gvKnc2yu0rxHMP1m045XLyCgpOT7Q4GUGkOIhUsE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        keyrings@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [RFC PATCH v2 18/20] f2fs: wire up new fscrypt ioctls
Date:   Mon, 11 Feb 2019 09:27:36 -0800
Message-Id: <20190211172738.4633-19-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211172738.4633-1-ebiggers@kernel.org>
References: <20190211172738.4633-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up the new ioctls for adding and removing fscrypt keys to/from the
filesystem, and the new ioctl for retrieving v2 encryption policies.

For more details see Documentation/filesystems/fscrypt.rst, as well as
the fscrypt patches that added the implementation of these ioctls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/file.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ba5954f41e14..3e6da48e0530 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2093,6 +2093,40 @@ static int f2fs_ioc_get_encryption_pwsalt(struct file *filp, unsigned long arg)
 	return err;
 }
 
+static int f2fs_ioc_get_encryption_policy_ex(struct file *filp,
+					     unsigned long arg)
+{
+	if (!f2fs_sb_has_encrypt(F2FS_I_SB(file_inode(filp))))
+		return -EOPNOTSUPP;
+
+	return fscrypt_ioctl_get_policy_ex(filp, (void __user *)arg);
+}
+
+static int f2fs_ioc_add_encryption_key(struct file *filp, unsigned long arg)
+{
+	if (!f2fs_sb_has_encrypt(F2FS_I_SB(file_inode(filp))))
+		return -EOPNOTSUPP;
+
+	return fscrypt_ioctl_add_key(filp, (void __user *)arg);
+}
+
+static int f2fs_ioc_remove_encryption_key(struct file *filp, unsigned long arg)
+{
+	if (!f2fs_sb_has_encrypt(F2FS_I_SB(file_inode(filp))))
+		return -EOPNOTSUPP;
+
+	return fscrypt_ioctl_remove_key(filp, (const void __user *)arg);
+}
+
+static int f2fs_ioc_get_encryption_key_status(struct file *filp,
+					      unsigned long arg)
+{
+	if (!f2fs_sb_has_encrypt(F2FS_I_SB(file_inode(filp))))
+		return -EOPNOTSUPP;
+
+	return fscrypt_ioctl_get_key_status(filp, (void __user *)arg);
+}
+
 static int f2fs_ioc_gc(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -2998,6 +3032,14 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_get_encryption_policy(filp, arg);
 	case F2FS_IOC_GET_ENCRYPTION_PWSALT:
 		return f2fs_ioc_get_encryption_pwsalt(filp, arg);
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		return f2fs_ioc_get_encryption_policy_ex(filp, arg);
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		return f2fs_ioc_add_encryption_key(filp, arg);
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		return f2fs_ioc_remove_encryption_key(filp, arg);
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		return f2fs_ioc_get_encryption_key_status(filp, arg);
 	case F2FS_IOC_GARBAGE_COLLECT:
 		return f2fs_ioc_gc(filp, arg);
 	case F2FS_IOC_GARBAGE_COLLECT_RANGE:
@@ -3117,6 +3159,10 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case F2FS_IOC_SET_ENCRYPTION_POLICY:
 	case F2FS_IOC_GET_ENCRYPTION_PWSALT:
 	case F2FS_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
 	case F2FS_IOC_GARBAGE_COLLECT:
 	case F2FS_IOC_GARBAGE_COLLECT_RANGE:
 	case F2FS_IOC_WRITE_CHECKPOINT:
-- 
2.20.1

