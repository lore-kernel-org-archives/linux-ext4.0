From: Fang Wenqi <anton.fang@gmail.com>
Subject: [PATCH] ext4: Update documentation to correct the inode_readahead_blks option name
Date: Thu, 17 Dec 2009 15:40:23 +0800
Message-ID: <1261035623-28474-1-git-send-email-antonf@turbolinux.com.cn>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Fang Wenqi <antonf@turbolinux.com.cn>
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Per commit 240799cd, the option name for readahead should be
inode_readahead_blks, not inode_readahead.

Signed-off-by: Fang Wenqi <antonf@turbolinux.com.cn>
---
 Documentation/filesystems/ext4.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index af6885c..e1def17 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -196,7 +196,7 @@ nobarrier		This also requires an IO stack which can support
 			also be used to enable or disable barriers, for
 			consistency with other ext4 mount options.
 
-inode_readahead=n	This tuning parameter controls the maximum
+inode_readahead_blks=n	This tuning parameter controls the maximum
 			number of inode table blocks that ext4's inode
 			table readahead algorithm will pre-read into
 			the buffer cache.  The default value is 32 blocks.
-- 
1.6.5.2

