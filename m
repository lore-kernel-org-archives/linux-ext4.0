From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] jbd2: Remove unnecessary check for NULL after calling kzalloc
	with __GFP_NOFAIL
Date: Mon, 2 Mar 2009 12:11:28 +0530
Message-ID: <ea11fea30903012241u44d31e6aw6c18af7c06f60734@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:2955 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbZCBGlh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2009 01:41:37 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2723280tib.23
        for <linux-ext4@vger.kernel.org>; Sun, 01 Mar 2009 22:41:29 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since new_transaction is allocated with __GFP_NOFAIL flags, NULL check
for the returned value is
not needed.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/jbd2/transaction.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 46b4e34..e22f993 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -101,14 +101,9 @@ static int start_this_handle(journal_t *journal,
handle_t *handle)
 	}

 alloc_transaction:
-	if (!journal->j_running_transaction) {
+	if (!journal->j_running_transaction)
 		new_transaction = kzalloc(sizeof(*new_transaction),
 						GFP_NOFS|__GFP_NOFAIL);
-		if (!new_transaction) {
-			ret = -ENOMEM;
-			goto out;
-		}
-	}

 	jbd_debug(3, "New handle %p going live.\n", handle);

-- 
1.5.4.3


Thanks -
Manish
