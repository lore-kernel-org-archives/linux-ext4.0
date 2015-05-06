From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] jbd2: Fix memory leak in jbd2_journal_stop()
Date: Wed,  6 May 2015 10:05:14 +0200
Message-ID: <1430899514-19128-2-git-send-email-lczerner@redhat.com>
References: <1430899514-19128-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbbEFIF3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2015 04:05:29 -0400
In-Reply-To: <1430899514-19128-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in the case that we've got to the jbd2_journal_stop() with
already sopped handle we might leak the memory previously allocated
for the reserved handle because we only free the handle structure
leaving handle->h_rsv_handle intact.

Fix it by freeing the handle->h_rsv_handle structure in case we're
dealing with already stopped handle in jbd2_journal_stop().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/jbd2/transaction.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 34bd0c5..807c378 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1535,8 +1535,11 @@ int jbd2_journal_stop(handle_t *handle)
 			jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
 							 handle->h_ref);
 			return err;
-		} else
+		} else {
+			if (handle->h_rsv_handle)
+				jbd2_free_handle(handle->h_rsv_handle);
 			goto free_and_exit;
+		}
 	}
 	journal = transaction->t_journal;
 
-- 
1.8.3.1

