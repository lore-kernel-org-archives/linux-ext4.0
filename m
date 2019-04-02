Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA2BC10F0C
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 15:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C0832084B
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 15:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554220131;
	bh=41GP8Yjo0+8dQSPM4iw7HW6C6zzvGO0pLKV+NuTF9s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Rergk0XsjSkVbWThpWabrCw1NSpkjDyhco574IRZp58VwZ5wmRuC34WMqEVTePvkA
	 yWsL7DctUaFSO/I6I6v/dxe7UHPxeTxxYeWRNNr3YkucWEcdKrht7JZLjc1X7taA/T
	 jql8rrfQTmU662lAB4Mg1L0UmHLRTSKESTRzIidc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfDBPsu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 11:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbfDBPsk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Apr 2019 11:48:40 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57EBA20857;
        Tue,  2 Apr 2019 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554220118;
        bh=41GP8Yjo0+8dQSPM4iw7HW6C6zzvGO0pLKV+NuTF9s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YG7XC8W9V997ZoH5DN6+mEANCrE0ICM8BzrXRiftyUfaEYHTpqmHCg2TTaerajB4d
         TrEJVbR2xA4A8P6/6D7xyersephTYeaYVy52+hweySesJNHY/7hzRMM4ZBW3x8u2rp
         9ogcy218bkDv9lQPpMjRgpW7h7O7J8Yb9lhU3epA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: [PATCH v4 16/17] ubifs: wire up new fscrypt ioctls
Date:   Tue,  2 Apr 2019 08:45:59 -0700
Message-Id: <20190402154600.32432-17-ebiggers@kernel.org>
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

FS_IOC_REMOVE_ENCRYPTION_KEY also required making UBIFS use
fscrypt_drop_inode().

For more details see Documentation/filesystems/fscrypt.rst, as well as
the fscrypt patches that added the implementation of these ioctls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/ioctl.c | 23 +++++++++++++++++------
 fs/ubifs/super.c | 11 +++++++++++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
index 82e4e6a30b044..3c640a7e937f4 100644
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -205,13 +205,20 @@ long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return -EOPNOTSUPP;
 #endif
 	}
-	case FS_IOC_GET_ENCRYPTION_POLICY: {
-#ifdef CONFIG_FS_ENCRYPTION
+	case FS_IOC_GET_ENCRYPTION_POLICY:
 		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
-#else
-		return -EOPNOTSUPP;
-#endif
-	}
+
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
+
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		return fscrypt_ioctl_add_key(file, (void __user *)arg);
+
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		return fscrypt_ioctl_remove_key(file, (const void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
 
 	default:
 		return -ENOTTY;
@@ -230,6 +237,10 @@ long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	case FS_IOC_SET_ENCRYPTION_POLICY:
 	case FS_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 8dc2818fdd849..cd4a3e2be2043 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -334,6 +334,16 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return err;
 }
 
+static int ubifs_drop_inode(struct inode *inode)
+{
+	int drop = generic_drop_inode(inode);
+
+	if (!drop)
+		drop = fscrypt_drop_inode(inode);
+
+	return drop;
+}
+
 static void ubifs_evict_inode(struct inode *inode)
 {
 	int err;
@@ -1982,6 +1992,7 @@ const struct super_operations ubifs_super_operations = {
 	.destroy_inode = ubifs_destroy_inode,
 	.put_super     = ubifs_put_super,
 	.write_inode   = ubifs_write_inode,
+	.drop_inode    = ubifs_drop_inode,
 	.evict_inode   = ubifs_evict_inode,
 	.statfs        = ubifs_statfs,
 	.dirty_inode   = ubifs_dirty_inode,
-- 
2.21.0

