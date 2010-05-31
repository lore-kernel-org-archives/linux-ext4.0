From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 02/53] jbd: jbd-debug and jbd2-debug should be writable
Date: Sun, 30 May 2010 22:49:15 -0400
Message-ID: <1275274206-3900-2-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Yin Kangkai <kangkai.yin@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44553 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab0EaCuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:14 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yin Kangkai <kangkai.yin@intel.com>

commit 765f8361902d015c864d5e62019b2f139452d7ef upstream (as of v2.6.33-rc2)

jbd-debug and jbd2-debug is currently read-only (S_IRUGO), which is not
correct. Make it writable so that we can start debuging.

Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 4160afa..bd224ee 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1913,7 +1913,7 @@ static void __init jbd_create_debugfs_entry(void)
 {
 	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
 	if (jbd_debugfs_dir)
-		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO,
+		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO | S_IWUSR,
 					       jbd_debugfs_dir,
 					       &journal_enable_debug);
 }
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b7ca3a9..17af879 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2115,7 +2115,8 @@ static void __init jbd2_create_debugfs_entry(void)
 {
 	jbd2_debugfs_dir = debugfs_create_dir("jbd2", NULL);
 	if (jbd2_debugfs_dir)
-		jbd2_debug = debugfs_create_u8(JBD2_DEBUG_NAME, S_IRUGO,
+		jbd2_debug = debugfs_create_u8(JBD2_DEBUG_NAME,
+					       S_IRUGO | S_IWUSR,
 					       jbd2_debugfs_dir,
 					       &jbd2_journal_enable_debug);
 }
-- 
1.6.6.1.1.g974db.dirty

