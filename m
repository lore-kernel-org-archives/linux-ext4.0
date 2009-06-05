From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH][BUG] ext4: dx_map_entry cannot support over 64KB block size
Date: Fri, 5 Jun 2009 16:50:49 +0900
Message-ID: <20090605165049.e8bd9c74.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36744 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbZFEIF5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 04:05:57 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n5585veB011203
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Fri, 5 Jun 2009 17:05:58 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id A980D45DD79
	for <linux-ext4@vger.kernel.org>; Fri,  5 Jun 2009 17:05:57 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 8448245DE5D
	for <linux-ext4@vger.kernel.org>; Fri,  5 Jun 2009 17:05:57 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6A6291DB803C
	for <linux-ext4@vger.kernel.org>; Fri,  5 Jun 2009 17:05:57 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.249.87.104])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 247A21DB803B
	for <linux-ext4@vger.kernel.org>; Fri,  5 Jun 2009 17:05:57 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

The dx_map_entry structure doesn't support over 64KB block size by current usage
of its member("offs"). Because "offs" treats an offset of copies of the 
ext4_dir_entry_2 structure as is. This member size is 16 bits. But real offset 
for over 64KB(256KB) block size needs 18 bits. However, real offset keeps
4 byte boundary, so lower 2 bits is not used.

Therefore, we do the following to fix this limitation:
For "store": 
	we divide the real offset by 4 and then store this result to "offs" 
	member.
For "use":
	we multiply "offs" member by 4 and then use this result 
	as real offset.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/namei.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.30-rc6/fs/ext4/namei.c.orig	2009-05-26 01:35:09.000000000 +0900
+++ linux-2.6.30-rc6/fs/ext4/namei.c	2009-06-06 00:05:51.000000000 +0900
@@ -750,7 +750,7 @@ static int dx_make_map(struct ext4_dir_e
 			ext4fs_dirhash(de->name, de->name_len, &h);
 			map_tail--;
 			map_tail->hash = h.hash;
-			map_tail->offs = (u16) ((char *) de - base);
+			map_tail->offs = ((char *) de - base)>>2;
 			map_tail->size = le16_to_cpu(de->rec_len);
 			count++;
 			cond_resched();
@@ -1148,7 +1148,8 @@ dx_move_dirents(char *from, char *to, st
 	unsigned rec_len = 0;
 
 	while (count--) {
-		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) (from + map->offs);
+		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) 
+							(from + (map->offs<<2));
 		rec_len = EXT4_DIR_REC_LEN(de->name_len);
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
