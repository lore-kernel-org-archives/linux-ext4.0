From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: ext4_da_convert_inline_data_to_extent drop locked page after error V2
Date: Wed,  3 Dec 2014 17:54:44 +0400
Message-ID: <1417614884-15225-1-git-send-email-dmonakhov@openvz.org>
References: <877fy9du0z.fsf@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:35586 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaLCNyy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2014 08:54:54 -0500
In-Reply-To: <877fy9du0z.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Testcase:
xfstests generic/270
MKFS_OPTIONS="-q -I 256 -O inline_data,64bit"

changes from V1
 - drop xattr_sem before ext4_truncate_failed_write() because
   ext4_inline_data_truncate() depends on it.
Call Trace:
 [<ffffffff81144c76>] lock_page+0x35/0x39 -------> DEADLOCK
 [<ffffffff81145260>] pagecache_get_page+0x65/0x15a
 [<ffffffff811507fc>] truncate_inode_pages_range+0x1db/0x45c
 [<ffffffff8120ea63>] ? ext4_da_get_block_prep+0x439/0x4b6
 [<ffffffff811b29b7>] ? __block_write_begin+0x284/0x29c
 [<ffffffff8120e62a>] ? ext4_change_inode_journal_flag+0x16b/0x16b
 [<ffffffff81150af0>] truncate_inode_pages+0x12/0x14
 [<ffffffff81247cb4>] ext4_truncate_failed_write+0x19/0x25
 [<ffffffff812488cf>] ext4_da_write_inline_data_begin+0x196/0x31c
 [<ffffffff81210dad>] ext4_da_write_begin+0x189/0x302
 [<ffffffff810c07ac>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff810ddd13>] ? read_seqcount_begin.clone.1+0x9f/0xcc
 [<ffffffff8114309d>] generic_perform_write+0xc7/0x1c6
 [<ffffffff810c040e>] ? mark_held_locks+0x59/0x77
 [<ffffffff811445d1>] __generic_file_write_iter+0x17f/0x1c5
 [<ffffffff8120726b>] ext4_file_write_iter+0x2a5/0x354
 [<ffffffff81185656>] ? file_start_write+0x2a/0x2c
 [<ffffffff8107bcdb>] ? bad_area_nosemaphore+0x13/0x15
 [<ffffffff811858ce>] new_sync_write+0x8a/0xb2
 [<ffffffff81186e7b>] vfs_write+0xb5/0x14d
 [<ffffffff81186ffb>] SyS_write+0x5c/0x8c
 [<ffffffff816f2529>] system_call_fastpath+0x12/0x17

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inline.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index d3d8192..acd79b7 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -811,8 +811,11 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
 	ret = __block_write_begin(page, 0, inline_size,
 				  ext4_da_get_block_prep);
 	if (ret) {
+		up_read(&EXT4_I(inode)->xattr_sem);
+		unlock_page(page);
+		page_cache_release(page);
 		ext4_truncate_failed_write(inode);
-		goto out;
+		return ret;
 	}
 
 	SetPageDirty(page);
-- 
1.7.1

