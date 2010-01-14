From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [REPOST][RFC][PATCH] ext4: unify each meaning of the offset in
 ext4_check_dir_entry calling from some functions.
Date: Thu, 14 Jan 2010 15:57:39 +0900
Message-ID: <20100114155739.99150559.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55891 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab0ANHRQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2010 02:17:16 -0500
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o0E7HE4S005285
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Thu, 14 Jan 2010 16:17:15 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id A89AB45DE4F
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2010 16:17:14 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 883B545DE51
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2010 16:17:14 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 7067A1DB8042
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2010 16:17:14 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 260631DB8038
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2010 16:17:14 +0900 (JST)
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
#12: rec_len is too small for name_len - block_nr=78:offset=0, inode=216, \
rec_len=12, name_len=11

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
--
 fs/ext4/dir.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -Nurp linux-2.6.33-rc3.org/fs/ext4/dir.c linux-2.6.33-rc3/fs/ext4/dir.c
--- linux-2.6.33-rc3.org/fs/ext4/dir.c	2010-01-06 09:02:46.000000000 +0900
+++ linux-2.6.33-rc3/fs/ext4/dir.c	2010-01-14 13:13:17.000000000 +0900
@@ -84,9 +84,10 @@ int ext4_check_dir_entry(const char *fun
 
 	if (error_msg != NULL)
 		ext4_error(dir->i_sb, function,
-			"bad entry in directory #%lu: %s - "
+			"bad entry in directory #%lu: %s - block_nr=%llu:"
 			"offset=%u, inode=%u, rec_len=%d, name_len=%d",
-			dir->i_ino, error_msg, offset,
+			dir->i_ino, error_msg, 
+			(u64)bh->b_blocknr, (u32)(offset%bh->b_size),
 			le32_to_cpu(de->inode),
 			rlen, de->name_len);
 	return error_msg == NULL ? 1 : 0;
