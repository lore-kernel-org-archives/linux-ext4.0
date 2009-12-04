From: "Yin, Kangkai" <kangkai.yin@intel.com>
Subject: [PATCH] jbd: jbd-debug and jbd2-debug should be writable.
Date: Fri, 4 Dec 2009 11:17:35 +0800
Message-ID: <20091204031735.GN19635@kai-debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, "Yin, Kangkai" <kangkai.yin@intel.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:28625 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbZLDDRc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Dec 2009 22:17:32 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Re-send since seems my mail was dropped by vger, because of my wrong
envelope_from..

----
I was trying to enable the jbd debug option, and found that jbd-debug
in debugfs is read-only, shouldn't that be writable?

Found in both .31 stable kernel and .32 one.

Thanks,
Kangkai

>From 492ec0453ca3458c68deaa6e308ca01acc0eca1f Mon Sep 17 00:00:00 2001
From: Yin Kangkai <kangkai.yin@intel.com>
Date: Thu, 3 Dec 2009 18:01:38 +0800
Subject: [PATCH] jbd: jbd-debug and jbd2-debug should be writable.

jbd-debug and jbd2-debug is currently read-only (S_IRUGO), which is not
correct. Make it writable so that we can start debuging.

Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
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
index fed8538..3c41c5a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2103,7 +2103,8 @@ static void __init jbd2_create_debugfs_entry(void)
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
1.6.5

