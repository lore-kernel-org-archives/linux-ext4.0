From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] jbd: Remove unnecessary goto statement
Date: Tue,  5 Oct 2010 00:13:59 +0900
Message-ID: <1286205239-2662-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Remove goto statement which jumps to very next line. Also remove
target label because it is no longer used anywhere.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/transaction.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 5ae71e7..981449c 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -293,9 +293,7 @@ handle_t *journal_start(journal_t *journal, int nblocks)
 		jbd_free_handle(handle);
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
-		goto out;
 	}
-out:
 	return handle;
 }
 
-- 
1.7.0.4
