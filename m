From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: fix wrong counting of s_dirtyclusters_counter for bigalloc in race condition
Date: Thu,  9 Feb 2012 18:46:34 +0800
Message-ID: <1328784394-12977-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43781 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2BIKqm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Feb 2012 05:46:42 -0500
Received: by pbcun15 with SMTP id un15so1429375pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 09 Feb 2012 02:46:42 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When I run the shell scripts below for about 10 minutes in a 16-core server (upstream kernel):



DEV=/dev/sdc
FILE=/test/hello


do_write()
{
	while [ 1 ]
	do
		dd if=/dev/zero of=$FILE bs=1k count=$1 conv=notrunc &> /dev/null
	done
}

do_truncate()
{
	while [ 1 ]
	do
		truncate -s $1 $FILE
	done
}

mke2fs -m 0 -C 1048576 -O ^has_journal,^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,bigalloc $DEV
mount -t ext4 $DEV /test/

do_write 1 &
do_write 3 &
do_write 5 &
do_write 7 &
do_truncate 0 &
do_truncate 0 &
do_truncate 0 &



The "Used" ratio of ext4 filesystem ( which reported from "df" command ) grow very fast until it reach 100%, but actually the max size of the file in /test/ is only 7k.

Imaging a file has only one page (0~4k) which is delayed and not writeback yet (the i_reserved_data_blocks is 1),
and here comes two processes, process0 truncate page0(bh0), process1 write page1(bh1), the race condition will be like:


             process0                                                   process1

  -->truncate
    -->ext4_da_invalidatepage
      -->ext4_da_page_release_reservation
        -->clear_buffer_delay(bh0)                          
                                                                        -->ext4_da_map_blocks
                                                                          -->ext4_ext_map_blocks
                                                                            -->map->m_flags |= EXT4_MAP_FROM_CLUSTER
                                                                              (because bh0 is not delay now)
                                                                          -->ext4_da_reserve_space
                                                                            (i_reserved_data_blocks is 2 now)

        (the bh1 is delay, so ext4_da_release_space
         will not be called)


after bh1 writeback, the i_reserved_data_blocks is 1 but there is no really dirty cluster in the fs.

The following write operations will call ext4_da_update_reserve_space, but the sbi->s_dirtyclusters_counter will not be decreased since the i_reserved_data_block will not be zero any more. As a result, the s_dirtyclusters_counter grows fast.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..9b3ceac 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1209,10 +1209,10 @@ static void ext4_da_page_release_reservation(struct page *page,
 	do {
 		unsigned int next_off = curr_off + bh->b_size;
 
-		if ((offset <= curr_off) && (buffer_delay(bh))) {
+		if ((offset <= curr_off) && buffer_delay(bh) &&
+				!buffer_da_mapped(bh)) {
 			to_release++;
 			clear_buffer_delay(bh);
-			clear_buffer_da_mapped(bh);
 		}
 		curr_off = next_off;
 	} while ((bh = bh->b_this_page) != head);
@@ -2544,6 +2544,7 @@ static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
 	 * Drop reserved blocks
 	 */
 	BUG_ON(!PageLocked(page));
+	down_write(&EXT4_I(page->mapping->host)->i_data_sem);
 	if (!page_has_buffers(page))
 		goto out;
 
@@ -2552,6 +2553,7 @@ static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
 out:
 	ext4_invalidatepage(page, offset);
 
+	up_write(&EXT4_I(page->mapping->host)->i_data_sem);
 	return;
 }
 
-- 
1.7.3.2

