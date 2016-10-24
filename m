From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: remove unneeded Kconfig dependencies
Date: Mon, 24 Oct 2016 13:17:06 -0700
Message-ID: <1477340226-144248-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org, richard@nod.at,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:32911 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965401AbcJXUR5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Oct 2016 16:17:57 -0400
Received: by mail-pf0-f172.google.com with SMTP id 128so104848128pfz.0
        for <linux-ext4@vger.kernel.org>; Mon, 24 Oct 2016 13:17:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

SHA256 and ENCRYPTED_KEYS are not needed.  CTR shouldn't be needed
either, but I left it for now because it was intentionally added by
commit 71dea01ea2ed ("ext4 crypto: require CONFIG_CRYPTO_CTR if ext4
encryption is enabled").  So it sounds like there may be a dependency
problem elsewhere, which I have not been able to identify specifically,
that must be solved before CTR can be removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index 92348fa..f514978 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -8,9 +8,7 @@ config FS_ENCRYPTION
 	select CRYPTO_XTS
 	select CRYPTO_CTS
 	select CRYPTO_CTR
-	select CRYPTO_SHA256
 	select KEYS
-	select ENCRYPTED_KEYS
 	help
 	  Enable encryption of files and directories.  This
 	  feature is similar to ecryptfs, but it is more memory
-- 
2.8.0.rc3.226.g39d4020

