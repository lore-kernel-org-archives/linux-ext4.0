Return-Path: <SRS0=3ydV=VX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7BAC76191
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Jul 2019 22:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44109218B0
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Jul 2019 22:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564181166;
	bh=2BBPza+X6s9HoVjl/k6SG6IYumBX/0JWPy7d6aCs5pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ruwNiBZ425qy5puoVgL9dlitfnBbZ1ZbhbFRcCIh5RUHxXaihg3ESLVqhbNkiXik8
	 WhetCtsnc4fNzMyx5lxRAf6zz8umcJqwEZDn7Bd1a3Yeh6O3qI0I99Jc9T9Bcv/o8q
	 RC99NjSVePPBaQmP6rfQXgS4qVA5hgCtUQK1u3qI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387626AbfGZWqF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Jul 2019 18:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387559AbfGZWqD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 26 Jul 2019 18:46:03 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B149C22CD7;
        Fri, 26 Jul 2019 22:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564181162;
        bh=2BBPza+X6s9HoVjl/k6SG6IYumBX/0JWPy7d6aCs5pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOmFFPZy4cDjxF2UBzMYJxIAzVIr34gNLkvF+tLg96WX94dSdjpkESZRsuyfhPM07
         IzfMPJKFE2tYVrBKIDLBtKLoXggz/5JRCofQEIlSOo1iqAx9ZGJKTkmnVlV4NycbC4
         VXBTruid7tWv1XDYMUzgYlhRLYqT6d/c+ZLG/TSw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: [PATCH v7 13/16] ext4: wire up new fscrypt ioctls
Date:   Fri, 26 Jul 2019 15:41:38 -0700
Message-Id: <20190726224141.14044-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726224141.14044-1-ebiggers@kernel.org>
References: <20190726224141.14044-1-ebiggers@kernel.org>
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
index 442f7ef873fc3..616fcf9eb52ec 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1115,6 +1115,26 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
@@ -1231,6 +1251,10 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
index 4079605d437ae..757819139b8f7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1107,6 +1107,9 @@ static int ext4_drop_inode(struct inode *inode)
 {
 	int drop = generic_drop_inode(inode);
 
+	if (!drop)
+		drop = fscrypt_drop_inode(inode);
+
 	trace_ext4_drop_inode(inode, drop);
 	return drop;
 }
-- 
2.22.0

