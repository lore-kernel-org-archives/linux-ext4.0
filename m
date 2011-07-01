From: Tao Ma <tm@tao.ma>
Subject: [PATCH 5/5] ext4: Change the wrong param comment for ext4_trim_all_free.
Date: Fri,  1 Jul 2011 23:27:56 +0800
Message-ID: <1309534076-2784-5-git-send-email-tm@tao.ma>
References: <4E0DE63A.7030103@tao.ma>
 <1309534076-2784-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:38160 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751700Ab1GAPat (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2011 11:30:49 -0400
In-Reply-To: <1309534076-2784-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

at ext4_trim_all_free() comment, there is no longer an @e4b parameter,
instead it is @group.

Reported-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cecc304..9a35263 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4813,7 +4813,7 @@ static void ext4_trim_extent(struct super_block *sb, int start, int count,
 /**
  * ext4_trim_all_free -- function to trim all free space in alloc. group
  * @sb:			super block for file system
- * @e4b:		ext4 buddy
+ * @group:		group to be trimmed
  * @start:		first group block to examine
  * @max:		last group block to examine
  * @minblocks:		minimum extent block count
-- 
1.7.4

