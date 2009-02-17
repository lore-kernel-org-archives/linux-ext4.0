From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext3/4: Clear pagep after write_begin() has failed
Date: Tue, 17 Feb 2009 22:24:19 +0300
Message-ID: <1234898659-4686-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitri Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:23669 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZBQTZS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 14:25:18 -0500
In-Reply-To: <>
References: <>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Seems there is no strict rule to for this case. In fact everybody
just ignored this variable after write_begin() has failed.
This was true until ext4_defrag_partial(). So let's follows simple
rule similar to block_write_begin().

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/inode.c |    2 ++
 fs/ext4/inode.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5fa453b..7aa60db 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1170,6 +1170,7 @@ retry:
 	if (IS_ERR(handle)) {
 		unlock_page(page);
 		page_cache_release(page);
+		*pagep = NULL;
 		ret = PTR_ERR(handle);
 		goto out;
 	}
@@ -1187,6 +1188,7 @@ write_begin_failed:
 		ext3_journal_stop(handle);
 		unlock_page(page);
 		page_cache_release(page);
+		*pagep = NULL;
 		/*
 		 * block_write_begin may have instantiated a few blocks
 		 * outside i_size.  Trim these off again. Don't need
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 658c4a7..0581c48 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1388,6 +1388,7 @@ retry:
 		unlock_page(page);
 		ext4_journal_stop(handle);
 		page_cache_release(page);
+		*pagep = NULL;
 		/*
 		 * block_write_begin may have instantiated a few blocks
 		 * outside i_size.  Trim these off again. Don't need
-- 
1.5.4.3

