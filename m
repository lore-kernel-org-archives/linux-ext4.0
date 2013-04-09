From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: defragmentation code cleanup
Date: Tue,  9 Apr 2013 19:15:59 +0400
Message-ID: <1365520559-6622-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:47231 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761532Ab3DIPQG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 11:16:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- grab_cache_page_write_begin() may not wait on page's writeback since
  (1d1d1a767206). But it is still reasonable to wait on page's writeback
  here in order to be on the safe side.

- Fix miss typo: pass 'length' instead of 'end' to __block_write_begin()
  https://bugzilla.kernel.org/show_bug.cgi?id=56241

TESTCASE: git://oss.sgi.com/xfs/cmds/xfstests.git
MKFS_OPTIONS="-b1024" ; ./check ext4/304

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/move_extent.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 33e1c08..58b33e9 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -737,6 +737,7 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 		donor_off += dext_alen;
 		orig_off += dext_alen;
 
+		BUG_ON(replaced_count > count);
 		/* Already moved the expected blocks */
 		if (replaced_count >= count)
 			break;
@@ -814,7 +815,13 @@ mext_page_double_lock(struct inode *inode1, struct inode *inode2,
 		page_cache_release(page[0]);
 		return -ENOMEM;
 	}
