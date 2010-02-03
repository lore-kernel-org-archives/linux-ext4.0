From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH][BUG][TAKE2] ext4: unify each meaning of the offset in
 ext4_check_dir_entry calling from some functions.
Date: Wed, 3 Feb 2010 16:13:48 +0900
Message-ID: <20100203161348.0bf98d58.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44799 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab0BCHmX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Feb 2010 02:42:23 -0500
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o137gLbC010436
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 3 Feb 2010 16:42:21 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 94A7745DE7A
	for <linux-ext4@vger.kernel.org>; Wed,  3 Feb 2010 16:42:21 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 3465345DE7C
	for <linux-ext4@vger.kernel.org>; Wed,  3 Feb 2010 16:42:21 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id A86571DB803E
	for <linux-ext4@vger.kernel.org>; Wed,  3 Feb 2010 16:42:20 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.249.87.107])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 4ED04E18009
	for <linux-ext4@vger.kernel.org>; Wed,  3 Feb 2010 16:42:20 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

"offset" of the error message of ext4_check_dir_entry() might change the
meaning by the caller. There are 2 meanings:
- "File offset"
  called by:
   ext4_readdir, htree_dirblock_to_tree, search_dirblock, ext4_dx_find_entry,
   empty_dir
- "Buffer offset"
  called by:
   add_dirent_to_buf, ext4_delete_entry

The best way to solve this problem is to change the meaning of
"Buffer offset" into "File offset" but it is not easy.
However, we can solve this problem easily if we unify the meanings into
"Buffer offset". So, instead of "File Offset" meaning, we add the block number
information to this message.

--- Examples ---
Original error message:
 EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory \
 #12: rec_len is too small for name_len - offset=12288, inode=216, rec_len=12,\
  name_len=11

Error message which is changed by this patch:
 EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory \
 #12: rec_len is too small for name_len - block=78, offset=0, inode=216, \
 rec_len=12, name_len=11

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/dir.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 9dc9316..65da7e5 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -84,9 +84,11 @@ int ext4_check_dir_entry(const char *function, struct inode *dir,
 
 	if (error_msg != NULL)
 		ext4_error(dir->i_sb, function,
-			"bad entry in directory #%lu: %s - "
+			"bad entry in directory #%lu: %s - block=%llu, "
 			"offset=%u, inode=%u, rec_len=%d, name_len=%d",
-			dir->i_ino, error_msg, offset,
+			dir->i_ino, error_msg, 
+			(unsigned long long)bh->b_blocknr, 
+			(unsigned)(offset%bh->b_size),
 			le32_to_cpu(de->inode),
 			rlen, de->name_len);
 	return error_msg == NULL ? 1 : 0;
-- 
1.5.5.6
