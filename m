Return-Path: <SRS0=Op7R=MQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38548 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727077AbeJDRj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 Oct 2018 13:39:27 -0400
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] jbd2: Fix use after free in jbd2_log_do_checkpoint()
Date: Thu,  4 Oct 2018 12:46:40 +0200
Message-Id: <20181004104640.28326-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The code cleaning transaction's lists of checkpoint buffers has a bug
where it increases bh refcount only after releasing
journal->j_list_lock. Thus the following race is possible:

CPU0					CPU1
jbd2_log_do_checkpoint()
					jbd2_journal_try_to_free_buffers()
					  __journal_try_to_free_buffer(bh)
  ...
  while (transaction->t_checkpoint_io_list)
  ...
    if (buffer_locked(bh)) {

<-- IO completes now, buffer gets unlocked -->

      spin_unlock(&journal->j_list_lock);
					    spin_lock(&journal->j_list_lock);
					    __jbd2_journal_remove_checkpoint(jh);
					    spin_unlock(&journal->j_list_lock);
					  try_to_free_buffers(page);
      get_bh(bh) <-- accesses freed bh

Fix the problem by grabbing bh reference before unlocking
journal->j_list_lock.

Fixes: dc6e8d669cf5cb3ff84707c372c0a2a8a5e80845
Fixes: be1158cc615fd723552f0d9912087423c7cadda5
Reported-by: syzbot+7f4a27091759e2fe7453@syzkaller.appspotmail.com
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index c125d662777c..26f8d7e46462 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -251,8 +251,8 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 		bh = jh2bh(jh);
 
 		if (buffer_locked(bh)) {
-			spin_unlock(&journal->j_list_lock);
 			get_bh(bh);
+			spin_unlock(&journal->j_list_lock);
 			wait_on_buffer(bh);
 			/* the journal_head may have gone by now */
 			BUFFER_TRACE(bh, "brelse");
@@ -333,8 +333,8 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 		jh = transaction->t_checkpoint_io_list;
 		bh = jh2bh(jh);
 		if (buffer_locked(bh)) {
-			spin_unlock(&journal->j_list_lock);
 			get_bh(bh);
+			spin_unlock(&journal->j_list_lock);
 			wait_on_buffer(bh);
 			/* the journal_head may have gone by now */
 			BUFFER_TRACE(bh, "brelse");
-- 
2.16.4
