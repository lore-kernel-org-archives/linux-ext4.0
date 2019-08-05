Return-Path: <SRS0=I98z=WB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57027C0650F
	for <linux-ext4@archiver.kernel.org>; Mon,  5 Aug 2019 16:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CA1D2086D
	for <linux-ext4@archiver.kernel.org>; Mon,  5 Aug 2019 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565022548;
	bh=ysbdRDp4t6yR1/mnrxfjF5Thy72larG2YRdxScNw3NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DUzw8zlX5gdYV/67CKpab8Tv3+pdN1NhFMnIlVmbE9ogbgn0JMMKWFf6OJVr/FE8i
	 tLm0i0Fi4h9tpQRLlRWNO8MpqroJum+RkHZmn4cdJYi2n4WnclHb+4PPIkbCw8frAC
	 vCpHCqXE23d7vtvAAEvV9tgv2+IfVpE3C8H4tJAA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfHEQ3H (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 5 Aug 2019 12:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729856AbfHEQ2e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Aug 2019 12:28:34 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8ADD21872;
        Mon,  5 Aug 2019 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565022514;
        bh=ysbdRDp4t6yR1/mnrxfjF5Thy72larG2YRdxScNw3NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkaekEVWEZv6P2zLxKDfAFH2Rc6UZEkYYApZq0mdc1+4uY1/CZV13/7sak9dAfvi5
         TVTcBTb9vnNLTJjQihbmUmF9b9Grh8tR04GSku4ZTqZC2Tv2iYxol8vBleANB+5qTD
         Ft4OIaHcgSEFShuge2qtieXLdDjlceCu/wpmEpHw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        linux-api@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v8 08/20] fscrypt: rename keyinfo.c to keysetup.c
Date:   Mon,  5 Aug 2019 09:25:09 -0700
Message-Id: <20190805162521.90882-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190805162521.90882-1-ebiggers@kernel.org>
References: <20190805162521.90882-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Rename keyinfo.c to keysetup.c since this better describes what the file
does (sets up the key), and it matches the new file keysetup_v1.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/Makefile                  | 2 +-
 fs/crypto/fscrypt_private.h         | 2 +-
 fs/crypto/{keyinfo.c => keysetup.c} | 0
 include/linux/fscrypt.h             | 4 ++--
 4 files changed, 4 insertions(+), 4 deletions(-)
 rename fs/crypto/{keyinfo.c => keysetup.c} (100%)

diff --git a/fs/crypto/Makefile b/fs/crypto/Makefile
index 1fba255c34ca56..ad14d4c29784a6 100644
--- a/fs/crypto/Makefile
+++ b/fs/crypto/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_FS_ENCRYPTION)	+= fscrypto.o
 fscrypto-y := crypto.o \
 	      fname.o \
 	      hooks.o \
-	      keyinfo.o \
+	      keysetup.o \
 	      keysetup_v1.o \
 	      policy.o
 
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 387b44b255f6ab..794dcba25ca826 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -156,7 +156,7 @@ extern bool fscrypt_fname_encrypted_size(const struct inode *inode,
 					 u32 orig_len, u32 max_len,
 					 u32 *encrypted_len_ret);
 
-/* keyinfo.c */
+/* keysetup.c */
 
 struct fscrypt_mode {
 	const char *friendly_name;
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keysetup.c
similarity index 100%
rename from fs/crypto/keyinfo.c
rename to fs/crypto/keysetup.c
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 81c0c754f8b21b..583802cb2e35d0 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -138,7 +138,7 @@ extern int fscrypt_ioctl_get_policy(struct file *, void __user *);
 extern int fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
 					void *, bool);
-/* keyinfo.c */
+/* keysetup.c */
 extern int fscrypt_get_encryption_info(struct inode *);
 extern void fscrypt_put_encryption_info(struct inode *);
 extern void fscrypt_free_inode(struct inode *);
@@ -367,7 +367,7 @@ static inline int fscrypt_inherit_context(struct inode *parent,
 	return -EOPNOTSUPP;
 }
 
-/* keyinfo.c */
+/* keysetup.c */
 static inline int fscrypt_get_encryption_info(struct inode *inode)
 {
 	return -EOPNOTSUPP;
-- 
2.22.0.770.g0f2c4a37fd-goog

