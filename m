From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH][BUG][RFC] ext4: Each meaning of the offset in
 ext4_check_dir_entry calling from some functions should be unified.
Date: Thu, 19 Nov 2009 09:55:47 +0900
Message-ID: <20091119095547.adfdfba0.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33989 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbZKSBNS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Nov 2009 20:13:18 -0500
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id nAJ1DMVH009103
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Thu, 19 Nov 2009 10:13:22 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 0EB3D45DE4F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2009 10:13:22 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id D969545DE4C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2009 10:13:21 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 8DA741DB803A
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2009 10:13:21 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 1AD461DB8043
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2009 10:13:21 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

This problem is originated from the one message which has two meanings.
Meanings are: 
- File offset
  used by:
   ext4_readdir, htree_dirblock_to_tree, search_dirblock, ext4_dx_find_entry,
   empty_dir
- Buffer offset
  used by:
   add_dirent_to_buf, ext4_delete_entry

To solve this, there is the method how we change the meaning of add_dirent_to_buf() and 
ext4_delete_entry() but it is not easy to change. But we can solve this problem easily
if we unify the meanings into "Buffer offset". So, instead of "File Offset" meaning,
we add the block number information to this message.

--- Examples ---
Original:
EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory \
#12: rec_len is too small for name_len - offset=12288, inode=216, rec_len=12,\
 name_len=11

Change:
EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory \
#12: rec_len is too small for name_len - block_nr=78:offset=0, inode=216, \
rec_len=12, name_len=11

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
--
 fs/ext4/dir.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -Nurp linux-2.6.32-rc7.org/fs/ext4/dir.c linux-2.6.32-rc7/fs/ext4/dir.c
--- linux-2.6.32-rc7.org/fs/ext4/dir.c	2009-11-13 09:46:07.000000000 +0900
+++ linux-2.6.32-rc7/fs/ext4/dir.c	2009-11-19 18:32:31.000000000 +0900
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
