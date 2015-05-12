From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] ext4 crypto: require CONFIG_CRYPTO_CTR if ext4 encryption is enabled
Date: Tue, 12 May 2015 14:59:52 -0400
Message-ID: <1431457192-3432-5-git-send-email-tytso@mit.edu>
References: <1431457192-3432-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60053 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbbELTA1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2015 15:00:27 -0400
In-Reply-To: <1431457192-3432-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On arm64 this is apparently needed for CTS mode to function correctly.
Otherwise attempts to use CTS return ENOENT.

Change-Id: I732ea9a5157acc76de5b89edec195d0365f4ca63
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 024f228..bf8bc8a 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -72,6 +72,7 @@ config EXT4_ENCRYPTION
 	select CRYPTO_ECB
 	select CRYPTO_XTS
 	select CRYPTO_CTS
+	select CRYPTO_CTR
 	select CRYPTO_SHA256
 	select KEYS
 	select ENCRYPTED_KEYS
-- 
2.3.0

