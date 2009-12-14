From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Ext4: Don't ask about supporting ext2/3 in ext4 if ext4 is
	not configured
Date: Mon, 14 Dec 2009 13:55:46 +0000
Message-ID: <20091214135546.10111.4495.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: torvalds@osdl.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757302AbZLNN4A@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Don't offer to build ext2/3 support into ext4 if ext4 itself is not configured
on.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext4/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9acf7e8..c48a6bc 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -28,7 +28,7 @@ config EXT4_FS
 
 config EXT4_USE_FOR_EXT23
 	bool "Use ext4 for ext2/ext3 file systems"
-	depends on EXT3_FS=n || EXT2_FS=n
+	depends on EXT4_FS && (EXT3_FS=n || EXT2_FS=n)
 	default y
 	help
 	  Allow the ext4 file system driver code to be used for ext2 or
