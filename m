From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/6] tests: make sure MKE2FS_FIRST_META_BG is unset while running tests
Date: Sat,  9 Aug 2014 13:10:18 -0400
Message-ID: <1407604220-2620-4-git-send-email-tytso@mit.edu>
References: <1407604220-2620-1-git-send-email-tytso@mit.edu>
Cc: antymat+debian@chelmska.waw.pl, 756922@bugs.debian.org,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52424 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbaHIRK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Aug 2014 13:10:27 -0400
In-Reply-To: <1407604220-2620-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the developer has set the MKE2FS_FIRST_META_BG environment
variable, this can cause test failures.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/test_config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/test_config b/tests/test_config
index 6789656..1872e5c 100644
--- a/tests/test_config
+++ b/tests/test_config
@@ -32,6 +32,7 @@ E2FSCK_CONFIG=/dev/null
 export E2FSCK_CONFIG
 MKE2FS_CONFIG=./mke2fs.conf
 export MKE2FS_CONFIG
+unset MKE2FS_FIRST_META_BG
 E2FSPROGS_SKIP_PROGRESS=yes
 export E2FSPROGS_SKIP_PROGRESS
 EXT2FS_NO_MTAB_OK=yes
-- 
2.0.0

