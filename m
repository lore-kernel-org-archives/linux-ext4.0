From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/3] ext4: fix incorrect locking in move_extent_per_page
Date: Mon, 21 Jul 2014 19:04:49 +0400
Message-ID: <1405955089-12777-3-git-send-email-dmonakhov@openvz.org>
References: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:34851 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489AbaGUPFJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jul 2014 11:05:09 -0400
In-Reply-To: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have to copy data we must drop i_data_sem because of
get_blocks() will be called inside mext_page_mkuptodate(), but later we must
reacquire it again because we are about to change extent's tree

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/move_extent.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 2484c7e..671a74b 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1013,10 +1013,11 @@ data_copy:
 		*err = -EBUSY;
 		goto unlock_pages;
 	}
