Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08C1C10F0B
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 15:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B3302133D
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554220121;
	bh=sXTzCdkJrYXxv/SHdPjmdIL5PN0MRwSnIQ9nL31vSRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=u1udFXzMwwATlFG2lCze8kFgA+3XpKrUy5mvmBHHNNN5olMw52Yg74WkEpqbNCkRW
	 mFFT0Q/RkMFoSBe1lkwNUWQsrPUowlAf8X84qlBlKt+ieCo0ErzSffDFpVqvGrWqbL
	 ipCK02+YheOFcvPN1JzR8MP/+W3knKZXxIeAyV90=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbfDBPsk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 11:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731383AbfDBPsj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Apr 2019 11:48:39 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D789321741;
        Tue,  2 Apr 2019 15:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554220118;
        bh=sXTzCdkJrYXxv/SHdPjmdIL5PN0MRwSnIQ9nL31vSRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ganR7fpq8u+FfoCR+Ev16F1/7Te9U+qa4UwB7Hu9reApO8UOxEaElRGkAex1tkmqp
         wyH4sEp0exKkh0p2Qe/uAa88fMSTWm8n0ERqHpymeftJDZLQWi8Q3cLeAUpyo9T9Jc
         EMuq1Ps8/0cB4CHthASEFkp7JlIc56eHoG4mM5BU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: [PATCH v4 15/17] f2fs: wire up new fscrypt ioctls
Date:   Tue,  2 Apr 2019 08:45:58 -0700
Message-Id: <20190402154600.32432-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190402154600.32432-1-ebiggers@kernel.org>
References: <20190402154600.32432-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up the new ioctls for adding and removing fscrypt keys to/from the
filesystem, and the new ioctl for retrieving v2 encryption policies.

FS_IOC_REMOVE_ENCRYPTION_KEY also required making f2fs_drop_inode() call
fscrypt_drop_inode().

For more details see Documentation/filesystems/fscrypt.rst, as well as
the fscrypt patches that added the implementation of these ioctls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/file.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/super.c |  2 ++
 2 files changed, 48 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5742ab8b57dc6..251e374353da8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2095,6 +2095,40 @@ static int f2fs_ioc_get_encryption_pwsalt(struct file *filp, unsigned long arg)
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
@@ -3000,6 +3034,14 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
@@ -3119,6 +3161,10 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f2aaa2cc6b3e0..7219b3b2af759 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -934,6 +934,8 @@ static int f2fs_drop_inode(struct inode *inode)
 		return 0;
 	}
 	ret = generic_drop_inode(inode);
+	if (!ret)
+		ret = fscrypt_drop_inode(inode);
 	trace_f2fs_drop_inode(inode, ret);
 	return ret;
 }
-- 
2.21.0

