From: Jonas Bonn <jonas.bonn@gmail.com>
Subject: [PATCH] Do not try lock_acquire after handle made invalid
Date: Wed, 16 Jan 2008 00:39:26 +0100
Message-ID: <12004403661489-git-send-email-jonas.bonn@gmail.com>
Cc: Jonas Bonn <jonas.bonn@gmail.com>
To: akpm@linux-foundation.org, sct@redhat.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:45864 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYAOXjb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2008 18:39:31 -0500
Received: by ug-out-1314.google.com with SMTP id z38so142356ugc.16
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2008 15:39:29 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This likely fixes the oops in __lock_acquire reported as:

http://www.kerneloops.org/raw.php?rawid=2753&msgid=
http://www.kerneloops.org/raw.php?rawid=2749&msgid=

In these reported oopses, start_this_handle is returning -EROFS.

Signed-off-by: Jonas Bonn <jonas.bonn@gmail.com>
---
 fs/jbd/transaction.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 08ff6c7..038ed74 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -288,10 +288,12 @@ handle_t *journal_start(journal_t *journal, int nblocks)
 		jbd_free_handle(handle);
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
+		goto out;
 	}
 
 	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 
+out:
 	return handle;
 }
 
-- 
1.5.2.5
