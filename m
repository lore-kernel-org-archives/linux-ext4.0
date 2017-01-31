From: Sahitya Tummala <stummala@codeaurora.org>
Subject: [PATCH] jbd2: Fix use after free in kjournald2()
Date: Tue, 31 Jan 2017 20:08:57 +0530
Message-ID: <1485873537-32514-1-git-send-email-stummala@codeaurora.org>
Cc: Sahitya Tummala <stummala@codeaurora.org>
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Below is the synchronization issue between unmount and kjournald2
contexts, which results into use after free issue in kjournald2().
Fix this issue by using journal->j_state_lock to synchronize the
wait_event() done in journal_kill_thread() and the wake_up() done
in kjournald2().

TASK 1:
umount cmd:
   |--jbd2_journal_destroy() {
       |--journal_kill_thread() {
            write_lock(&journal->j_state_lock);
	    journal->j_flags |= JBD2_UNMOUNT;
	    ...
	    write_unlock(&journal->j_state_lock);
	    wake_up(&journal->j_wait_commit);	   TASK 2 wakes up here:
	    					   kjournald2() {
						     ...
						     checks JBD2_UNMOUNT flag and calls goto end-loop;
						     ...
						     end_loop:
						       write_unlock(&journal->j_state_lock);
						       journal->j_task = NULL; --> If this thread gets
						       pre-empted here, then TASK 1 wait_event will
						       exit even before this thread is completely
						       done.
	    wait_event(journal->j_wait_done_commit, journal->j_task == NULL);
	    ...
	    write_lock(&journal->j_state_lock);
	    write_unlock(&journal->j_state_lock);
	  }
       |--kfree(journal);
     }
}
						       wake_up(&journal->j_wait_done_commit); --> this step
						       now results into use after free issue.
						   }

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
---
 fs/jbd2/journal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index a097048..f5cd3c0 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -278,9 +278,11 @@ static int kjournald2(void *arg)
 end_loop:
 	write_unlock(&journal->j_state_lock);
 	del_timer_sync(&journal->j_commit_timer);
+	write_lock(&journal->j_state_lock);
 	journal->j_task = NULL;
 	wake_up(&journal->j_wait_done_commit);
 	jbd_debug(1, "Journal thread exiting.\n");
+	write_unlock(&journal->j_state_lock);
 	return 0;
 }
 
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
