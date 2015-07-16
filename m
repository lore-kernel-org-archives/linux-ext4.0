From: Jan Kara <jack@suse.com>
Subject: [PATCH 4/4] ext4: Improve ext4 Kconfig test
Date: Thu, 16 Jul 2015 11:53:06 +0200
Message-ID: <1437040386-31148-5-git-send-email-jack@suse.com>
References: <1437040386-31148-1-git-send-email-jack@suse.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437040386-31148-1-git-send-email-jack@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Now that ext4 driver must be used to access ext3 filesystems, improve
the Kconfig help text to better explain that using ext4 driver to access
the filesystem is fully compatible with the old ext3 driver.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/ext4/Kconfig | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 219a190ccae9..47728da7702c 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -49,12 +49,13 @@ config EXT4_FS
 	  up fsck time.  For more information, please see the web pages at
 	  http://ext4.wiki.kernel.org.
 
-	  The ext4 filesystem will support mounting an ext3
-	  filesystem; while there will be some performance gains from
-	  the delayed allocation and inode table readahead, the best
-	  performance gains will require enabling ext4 features in the
-	  filesystem, or formatting a new filesystem as an ext4
-	  filesystem initially.
+	  The ext4 filesystem supports mounting an ext3 filesystem; while there
+	  are some performance gains from the delayed allocation and inode
+	  table readahead, the best performance gains require enabling ext4
+	  features in the filesystem using tune2fs, or formatting a new
+	  filesystem as an ext4 filesystem initially. Without explicit enabling
+	  of ext4 features, the on disk filesystem format stays fully backward
+	  compatible.
 
 	  To compile this file system support as a module, choose M here. The
 	  module will be called ext4.
-- 
2.1.4
