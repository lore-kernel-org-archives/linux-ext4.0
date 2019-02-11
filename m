Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5215C282DA
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B39D5222A0
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549906211;
	bh=kM4pg2Rdp43WKU3Rr7NdmkJUuONRbQtiNUiEXfHaslQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yWZf2Nc1yD/8dePV9zIdduCyaUujabstKc/D04hcuVXmpLAoUIwmxqkQEO9HoPLw0
	 Xjle6wiBUGLJfBfZLtmwZu5pyIhpmQ6gvAbaY+7iE4gLJ2vO22KqPV+5cHQtrWIGMp
	 ys1Su3M9O+3wiaqzqyO1Iy99i/v7H3jdo9ljI6Vw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbfBKRaJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:30:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730782AbfBKR3q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 12:29:46 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E90222B1;
        Mon, 11 Feb 2019 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549906184;
        bh=kM4pg2Rdp43WKU3Rr7NdmkJUuONRbQtiNUiEXfHaslQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pT79FYYqFSOd68wzquLU134OQo2Z42ryT6KSB+cfnzbN39emzRmKXOiQ4CRnCoK7M
         0jlNO8mK9G2vxVO49dfWgX/eqxywlssAco1HBO948JaiG5HBJsLD7IbtvOIf49nj81
         dTY5r7HCk5Kx5v9INUE57zdTBQOS5mWvK52XOZwg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        keyrings@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [RFC PATCH v2 17/20] ext4: wire up new fscrypt ioctls
Date:   Mon, 11 Feb 2019 09:27:35 -0800
Message-Id: <20190211172738.4633-18-ebiggers@kernel.org>
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
 fs/ext4/ioctl.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d26bcac291bb..c939dbd2f2ac 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1020,6 +1020,26 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
@@ -1138,6 +1158,10 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
-- 
2.20.1

