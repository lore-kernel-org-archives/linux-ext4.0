From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 1/2] ext4: fix journal ref count in move_extent_par_page
Date: Sun,  2 Aug 2009 19:43:23 +0800
Message-ID: <1249213404-6277-1-git-send-email-bergwolf@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f200.google.com ([209.85.222.200]:37047 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZHBLnd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Aug 2009 07:43:33 -0400
Received: by pzk38 with SMTP id 38so1735571pzk.33
        for <linux-ext4@vger.kernel.org>; Sun, 02 Aug 2009 04:43:33 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

move_extent_par_page calls a_ops->write_begin() to increase journal handler's
reference count. However, if either mext_replace_branches() or ext4_get_block
fails, the increased reference count isn't decreased. This will cause later
umounting of the fs forever hangs. The patch addresses the issue by calling
ext4_journal_stop() if page is not NULL (which means a_ops->write_end() isn't
invoked).

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 fs/ext4/move_extent.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index bbf2dd9..5821e0b 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -871,6 +871,7 @@ out:
 		if (PageLocked(page))
 			unlock_page(page);
 		page_cache_release(page);
+		ext4_journal_stop(handle);
 	}
 out2:
 	ext4_journal_stop(handle);
-- 
1.6.2.GIT

