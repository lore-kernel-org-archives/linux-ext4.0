From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] trivial: fix ext3/ext4 comment typo s/compain/complain/
Date: Sun, 17 Jan 2010 19:10:07 -0200
Message-ID: <1263762607-8996-1-git-send-email-cascardo@holoscopio.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: trivial@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.254.139]:56356 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0AQVMn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jan 2010 16:12:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 fs/ext3/super.c |    2 +-
 fs/ext4/super.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index afa2b56..7761c68 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -164,7 +164,7 @@ void ext3_msg(struct super_block *sb, const char *prefix,
  * write out the superblock safely.
  *
  * We'll just use the journal_abort() error code to record an error in
- * the journal instead.  On recovery, the journal will compain about
+ * the journal instead.  On recovery, the journal will complain about
  * that error until we've noted it down and cleared it.
  */
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 735c20d..adcb713 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -302,7 +302,7 @@ void ext4_journal_abort_handle(const char *caller, const char *err_fn,
  * write out the superblock safely.
  *
  * We'll just use the jbd2_journal_abort() error code to record an error in
- * the journal instead.  On recovery, the journal will compain about
+ * the journal instead.  On recovery, the journal will complain about
  * that error until we've noted it down and cleared it.
  */
 
-- 
1.6.6

