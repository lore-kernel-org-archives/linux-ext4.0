From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG
Date: Sun, 21 Apr 2013 20:38:46 -0400
Message-ID: <1366591126-30911-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fox the Kconfig documentation for CONFIG_EXT4_DEBUG to match the
change made by commit a0b30c1229: ext4: use module parameters instead
of debugfs for mballoc_debug

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9873587..efea5d5 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -71,4 +71,5 @@ config EXT4_DEBUG
 	  Enables run-time debugging support for the ext4 filesystem.
 
 	  If you select Y here, then you will be able to turn on debugging
-	  with a command such as "echo 1 > /sys/kernel/debug/ext4/mballoc-debug"
+	  with a command such as:
+		echo 1 > /sys/module/ext4/parameters/mballoc_debug
-- 
1.7.12.rc0.22.gcdd159b
