From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 6/6] jbd2: remove debug dependency on debug_fs; update help text
Date: Tue, 11 Jun 2013 18:44:30 -0400
Message-ID: <1370990670-49249-7-git-send-email-paul.gortmaker@windriver.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:48001 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab3FKWpQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Jun 2013 18:45:16 -0400
In-Reply-To: <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit b6e96d0067d8 ("jbd2: use module parameters instead of debugfs
for jbd_debug") removed any need for a dependency on DEBUG_FS.  It
also moved the /sys variables out from underneath the typical debugfs
mount point.  Delete the dependency and update the /sys path to where
the debug settings are currently.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/jbd2/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/Kconfig b/fs/jbd2/Kconfig
index 69a48c2..5a9f553 100644
--- a/fs/jbd2/Kconfig
+++ b/fs/jbd2/Kconfig
@@ -20,7 +20,7 @@ config JBD2
 
 config JBD2_DEBUG
 	bool "JBD2 (ext4) debugging support"
-	depends on JBD2 && DEBUG_FS
+	depends on JBD2
 	help
 	  If you are using the ext4 journaled file system (or
 	  potentially any other filesystem/device using JBD2), this option
@@ -29,7 +29,7 @@ config JBD2_DEBUG
 	  By default, the debugging output will be turned off.
 
 	  If you select Y here, then you will be able to turn on debugging
-	  with "echo N > /sys/kernel/debug/jbd2/jbd2-debug", where N is a
+	  with "echo N > /sys/module/jbd2/parameters/jbd2_debug", where N is a
 	  number between 1 and 5. The higher the number, the more debugging
 	  output is generated.  To turn debugging off again, do
-	  "echo 0 > /sys/kernel/debug/jbd2/jbd2-debug".
+	  "echo 0 > /sys/module/jbd2/parameters/jbd2_debug".
-- 
1.8.1.2

