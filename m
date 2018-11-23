Return-Path: <SRS0=kdxW=OC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49332 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730360AbeKXDZy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Nov 2018 22:25:54 -0500
From: Colin King <colin.king@canonical.com>
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jbd2: clean up indentation issue, replace spaces with tab
Date: Fri, 23 Nov 2018 16:40:53 +0000
Message-Id: <20181123164053.19193-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

There is a statement that is indented with spaces, replace it with
a tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/jbd2/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index c0b66a7a795b..4af8ff17ad5c 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -910,7 +910,7 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 	 * this is the first time this transaction is touching this buffer,
 	 * reset the modified flag
 	 */
-       jh->b_modified = 0;
+	jh->b_modified = 0;
 
 	/*
 	 * If the buffer is not journaled right now, we need to make sure it
-- 
2.19.1
