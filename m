From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] tune2fs, mke2fs: clarify proceed delay question
Date: Wed, 23 Aug 2017 11:42:10 -0400
Message-ID: <20170823154210.8756-5-tytso@mit.edu>
References: <20170823154210.8756-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45874 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754140AbdHWPmS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Aug 2017 11:42:18 -0400
In-Reply-To: <20170823154210.8756-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The explanation of the what happens after delaying N seconds is
ambiguous.  Clarify what happens.

Addresses-Debian-Bug: #857336

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/util.c              |  2 +-
 tests/t_dangerous/expect | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/misc/util.c b/misc/util.c
index 0ff3d4967..1d33883d4 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -101,7 +101,7 @@ void proceed_question(int delay)
 			return;
 		}
 		signal(SIGALRM, alarm_signal);
-		printf(_("Proceed anyway (or wait %d seconds) ? (y,N) "),
+		printf(_("Proceed anyway (or wait %d seconds to proceed) ? (y,N) "),
 		       delay);
 		alarm(delay);
 	} else
diff --git a/tests/t_dangerous/expect b/tests/t_dangerous/expect
index 3bae8fafd..a9903b750 100644
--- a/tests/t_dangerous/expect
+++ b/tests/t_dangerous/expect
@@ -37,15 +37,15 @@ Pass 5: Checking group summary information
 Exit status is 0
 tune2fs -O metadata_csum test.img
 Enabling checksums could take some time.
-Proceed anyway (or wait 5 seconds) ? (y,N) 
+Proceed anyway (or wait 5 seconds to proceed) ? (y,N) 
 Exit status is 1
 tune2fs -I 512 test.img
 Resizing inodes could take some time.
-Proceed anyway (or wait 5 seconds) ? (y,N) 
+Proceed anyway (or wait 5 seconds to proceed) ? (y,N) 
 Exit status is 1
 tune2fs -U random test.img
 Setting UUID on a checksummed filesystem could take some time.
-Proceed anyway (or wait 5 seconds) ? (y,N) 
+Proceed anyway (or wait 5 seconds to proceed) ? (y,N) 
 Exit status is 1
 
 Change in FS metadata:
@@ -58,7 +58,7 @@ Pass 5: Checking group summary information
 Exit status is 0
 tune2fs -O metadata_csum test.img
 Enabling checksums could take some time.
-Proceed anyway (or wait 5 seconds) ? (y,N) 
+Proceed anyway (or wait 5 seconds to proceed) ? (y,N) 
 This operation requires a freshly checked filesystem.
 
 Please run e2fsck -fD on the filesystem.
@@ -76,11 +76,11 @@ Pass 5: Checking group summary information
 
 tune2fs -I 512 test.img
 Resizing inodes could take some time.
-Proceed anyway (or wait 5 seconds) ? (y,N) Setting inode size 512
+Proceed anyway (or wait 5 seconds to proceed) ? (y,N) Setting inode size 512
 Exit status is 0
 tune2fs -U f0f0f0f0-f0f0-f0f0-f0f0-f0f0f0f0f0f0 test.img
 Setting UUID on a checksummed filesystem could take some time.
-Proceed anyway (or wait 5 seconds) ? (y,N) Exit status is 0
+Proceed anyway (or wait 5 seconds to proceed) ? (y,N) Exit status is 0
 Backing up journal inode block information.
 
 
-- 
2.11.0.rc0.7.gbe5a750
