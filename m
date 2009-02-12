From: Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: [PATCH] ext3: Use unsigned instead of int for type of blocksize in
 fs/ext3/namei.c
Date: Thu, 12 Feb 2009 15:15:40 +0800
Message-ID: <4993CC9C.9040308@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55584 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbZBLHPz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 02:15:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use unsigned instead of int for paramter which means blocksize.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 fs/ext3/namei.c |   8 +++++-----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 4db4ffa..40d0844 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -161,12 +161,12 @@ static struct dx_frame *dx_probe(struct qstr *entry,
 				 struct dx_frame *frame,
 				 int *err);
 static void dx_release (struct dx_frame *frames);
-static int dx_make_map (struct ext3_dir_entry_2 *de, int size,
+static int dx_make_map (struct ext3_dir_entry_2 *de, unsigned size,
 			struct dx_hash_info *hinfo, struct dx_map_entry map[]);
 static void dx_sort_map(struct dx_map_entry *map, unsigned count);
 static struct ext3_dir_entry_2 *dx_move_dirents (char *from, char *to,
 		struct dx_map_entry *offsets, int count);
-static struct ext3_dir_entry_2* dx_pack_dirents (char *base, int size);
+static struct ext3_dir_entry_2* dx_pack_dirents (char *base, unsigned size);
 static void dx_insert_block (struct dx_frame *frame, u32 hash, u32 block);
 static int ext3_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
@@ -708,7 +708,7 @@ errout:
  * Create map of hash values, offsets, and sizes, stored at end of block.
  * Returns number of entries mapped.
  */
-static int dx_make_map (struct ext3_dir_entry_2 *de, int size,
+static int dx_make_map (struct ext3_dir_entry_2 *de, unsigned size,
 			struct dx_hash_info *hinfo, struct dx_map_entry *map_tail)
 {
 	int count = 0;
@@ -1120,7 +1120,7 @@ dx_move_dirents(char *from, char *to, struct dx_map_entry *map, int count)
  * Compact each dir entry in the range to the minimal rec_len.
  * Returns pointer to last entry in range.
  */
-static struct ext3_dir_entry_2* dx_pack_dirents(char *base, int size)
+static struct ext3_dir_entry_2* dx_pack_dirents(char *base, unsigned size)
 {
 	struct ext3_dir_entry_2 *next, *to, *prev, *de = (struct ext3_dir_entry_2 *) base;
 	unsigned rec_len = 0;
-- 
1.5.3.8




