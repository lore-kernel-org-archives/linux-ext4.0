From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [RESEND][PATCH][BUG] ext4: fix infinite loop at ext4_da_writepages
 with the terminal extent block of too big file
Date: Fri, 17 Sep 2010 14:35:56 +0900
Message-ID: <20100917143556.bb9c303a.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42073 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0IQFyD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Sep 2010 01:54:03 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o8H5s1DQ002530
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Fri, 17 Sep 2010 14:54:01 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 1952345DE4E
	for <linux-ext4@vger.kernel.org>; Fri, 17 Sep 2010 14:54:01 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id E8CF745DD71
	for <linux-ext4@vger.kernel.org>; Fri, 17 Sep 2010 14:54:00 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id D624E1DB8017
	for <linux-ext4@vger.kernel.org>; Fri, 17 Sep 2010 14:54:00 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 81E8C1DB8013
	for <linux-ext4@vger.kernel.org>; Fri, 17 Sep 2010 14:54:00 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

On linux-2.6.36-rc2, if we execute the following script, we can encounter 
the hangup of '/bin/sync' command:
================================================================================
#!/bin/sh

echo -n "HANG UP TEST: "
/bin/dd if=/dev/zero of=/tmp/img bs=1k count=1 seek=1M 2> /dev/null
/sbin/mkfs.ext4 -Fq /tmp/img
/bin/mount -o loop -t ext4 /tmp/img /mnt
/bin/dd if=/dev/zero of=/mnt/file bs=1 count=1 \
seek=$((16*1024*1024*1024*1024-4096)) 2> /dev/null
/bin/sync
/bin/umount /mnt
echo "DONE"
exit 0
================================================================================

We can see the following backtrace if we get the kdump when this hangup occurs:
================================================================================
kthread()
=> bdi_writeback_thread()
   => wb_do_writeback()
      => wb_writeback()
         => writeback_inodes_wb()
            => writeback_sb_inodes()
               => writeback_single_inode()
                  => ext4_da_writepages()  ---+ 
                                ^ infinite    |
                                |   loop      |
                                +-------------+
================================================================================

The reason why this hangup happens is described as follows:
1) We write the last extent block of the file whose size is the filesystem 
   maximum size.
2) "BH_Delay" flag is set on the buffer_head of its block.
3) - the member, "m_lblk" of struct mpage_da_data is 4294967295 (UINT_MAX)
   - the member, "m_len" of struct mpage_da_data is 1
  mpage_put_bnr_to_bhs() which is called via ext4_da_writepages() cannot
  clear "BH_Delay" flag of the buffer_head because the type of m_lblk
  is ext4_lblk_t and then m_lblk + m_len is overflow.

  Therefore an infinite loop occurs because ext4_da_writepages() cannot write 
  the page (which corresponds to the block) since "BH_Delay" flag isn't cleared.
--------------------------------------------------------------------------------
static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd,
				struct ext4_map_blocks *map)
{
...
	int blocks = map->m_len;
...
		do {
			// cur_logical = 4294967295
			// map->m_lblk = 4294967295
			// blocks = 1
			// *** map->m_lblk + blocks == 0 (OVERFLOW!) ***
			// (cur_logical >= map->m_lblk + blocks) => true
			if (cur_logical >= map->m_lblk + blocks)
				break;
			if (buffer_delay(bh) || buffer_unwritten(bh)) {
				BUG_ON(bh->b_bdev != inode->i_sb->s_bdev);
				if (buffer_delay(bh)) {
					// *** cannot reach here! ***
					clear_buffer_delay(bh);
					bh->b_blocknr = pblock;
				} else {
					clear_buffer_unwritten(bh);
					BUG_ON(bh->b_blocknr != pblock);
				}
			} else if (buffer_mapped(bh))
				BUG_ON(bh->b_blocknr != pblock);
			if (map->m_flags & EXT4_MAP_UNINIT)
				set_buffer_uninit(bh);
			cur_logical++;
			pblock++;
		} while ((bh = bh->b_this_page) != head);
--------------------------------------------------------------------------------

Therefore, in order to fix this hangup easily, we change the following 
judgment only.(This change can prevent an overflow from occurring)
--------------------------------------------------------------------------------
			if (cur_logical >= map->m_lblk + blocks)
                           |                               |
                           v                               v
			if (cur_logical > map->m_lblk + blocks - 1)
--------------------------------------------------------------------------------

NOTE: However, if we mount with nodelalloc option, we cannot experience this
hangup while this script is running.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4b8debe..4124fa2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2103,7 +2103,7 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd,
 			} while ((bh = bh->b_this_page) != head);
 
 			do {
-				if (cur_logical >= map->m_lblk + blocks)
+				if (cur_logical > map->m_lblk + blocks - 1)
 					break;
 
 				if (buffer_delay(bh) || buffer_unwritten(bh)) {
-- 
1.5.5.6
