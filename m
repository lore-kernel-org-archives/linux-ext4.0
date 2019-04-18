Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEF3C282DD
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 23:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4A5F217FA
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 23:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555630249;
	bh=l934gpm3/E/NLsKDXRgSWr/s/TMu29sXvTJSrSrIxZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=dXei45vPZZs5PZGzEplf4Yy7Erf+/5GRr+Al6VfBk3iLQXZxVI4qhLVBjDFG06HhY
	 T8NbArj04H5Q+zWofuniZ4CxuDOJa8GHiUAkRfQ365FNZN2rfy7xvthtsmRcjqvzDo
	 khRemurYaSq4djeZg1Hm5ww0CwyY+ZsZ3SWwSDfQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfDRXas (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 19:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbfDRXaa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 19:30:30 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD307218CD;
        Thu, 18 Apr 2019 23:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555630230;
        bh=l934gpm3/E/NLsKDXRgSWr/s/TMu29sXvTJSrSrIxZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=se3iq7aRQrRySctyYnMkKDWbIyM5LgyKiyBN2ODSQDhknZ7lu5fCziqn5PWxYA6VA
         49I98EtEfbqzFF1vv+2uUACSvTuk1WiJuugQOZXiEiN4cIO6dsxK6RmKnqAOrC5G8m
         e49TMXMbcSRwvH6/PhuXbaaZ+z0nRYjq+dh2nWS8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v5 13/16] ext4: wire up new fscrypt ioctls
Date:   Thu, 18 Apr 2019 16:29:20 -0700
Message-Id: <20190418232923.250800-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190418232923.250800-1-ebiggers@kernel.org>
References: <20190418232923.250800-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up the new ioctls for adding and removing fscrypt keys to/from the
filesystem, and the new ioctl for retrieving v2 encryption policies.

FS_IOC_REMOVE_ENCRYPTION_KEY also required making ext4_drop_inode() call
fscrypt_drop_inode().

For more details see Documentation/filesystems/fscrypt.rst and the
fscrypt patches that added the implementation of these ioctls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ioctl.c | 24 ++++++++++++++++++++++++
 fs/ext4/super.c |  3 +++
 2 files changed, 27 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bab3da4f1e0d3..3ed66628e9301 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1074,6 +1074,26 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
 		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
 
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
+		return fscrypt_ioctl_get_policy_ex(filp, (void __user *)arg);
+
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
+		return fscrypt_ioctl_add_key(filp, (void __user *)arg);
+
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
+		return fscrypt_ioctl_remove_key(filp, (const void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
+		return fscrypt_ioctl_get_key_status(filp, (void __user *)arg);
+
 	case EXT4_IOC_FSGETXATTR:
 	{
 		struct fsxattr fa;
@@ -1192,6 +1212,10 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_SET_ENCRYPTION_POLICY:
 	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
 	case EXT4_IOC_SHUTDOWN:
 	case FS_IOC_GETFSMAP:
 		break;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5b92054bf8ea0..6640831f77735 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1103,6 +1103,9 @@ static int ext4_drop_inode(struct inode *inode)
 {
 	int drop = generic_drop_inode(inode);
 
+	if (!drop)
+		drop = fscrypt_drop_inode(inode);
+
 	trace_ext4_drop_inode(inode, drop);
 	return drop;
 }
-- 
2.21.0.392.gf8f6787159e-goog

