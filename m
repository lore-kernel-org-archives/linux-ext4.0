From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] jbd: correctly unescape journal data blocks
Date: Sat, 15 Mar 2008 18:49:44 +0000
Message-ID: <1205606985-22645-2-git-send-email-duaneg@dghda.com>
References: <1205606985-22645-1-git-send-email-duaneg@dghda.com>
Cc: linux-ext4@vger.kernel.org, duaneg@dghda.com
To: sct@redhat.com, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2834 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYCOStv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Mar 2008 14:49:51 -0400
In-Reply-To: <1205606985-22645-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a long-standing typo (predating git) that will cause data corruption if a
journal data block needs unescaping. At the moment the wrong buffer head's data
is being unescaped.

To test this case mount a filesystem with data=journal, start creating and
deleting a bunch of files containing only JFS_MAGIC_NUMBER (0xc03b3998), then
pull the plug on the device. Without this patch the files will contain zeros
instead of the correct data after recovery.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/jbd/recovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index 2b8edf4..43bc5e5 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -478,7 +478,7 @@ static int do_one_pass(journal_t *journal,
 					memcpy(nbh->b_data, obh->b_data,
 							journal->j_blocksize);
 					if (flags & JFS_FLAG_ESCAPE) {
-						*((__be32 *)bh->b_data) =
+						*((__be32 *)nbh->b_data) =
 						cpu_to_be32(JFS_MAGIC_NUMBER);
 					}
 
-- 
1.5.3.7

