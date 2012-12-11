From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51571] New: Assertion of j_running_transaction on
 jbd2_journal_flush()
Date: Tue, 11 Dec 2012 09:26:14 +0000 (UTC)
Message-ID: <bug-51571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41405 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab2LKJ0S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Dec 2012 04:26:18 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8637E202AA
	for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2012 09:26:17 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 787B1202A3
	for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2012 09:26:16 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51571

           Summary: Assertion of j_running_transaction on
                    jbd2_journal_flush()
           Product: File System
           Version: 2.5
    Kernel Version: 3.4.0
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: yjwsignal@empal.com
        Regression: No


This BUG is occurred at the remount operations.

[  214.601983] kernel BUG at fs/jbd2/journal.c : 1769

       int jbd2_journal_flush(journal_t *journal)
       {
           < SNIP >
line:1767  mutex_unlock(&journal->j_checkpoint_mutex);
line:1768  write_lock(&journal->j_state_lock);
line:1769  J_ASSERT(!journal->j_running_transaction);
           < SNIP >
       }

The call-stacks of this Procecss-A are below :
  jbd2_journal_flush+0xF4/0x164
  ext4_mark_recovery_complete
  ext4_remount
  do_remount_sb

And, on this situation, the variable of journal is like below:
  j_flags = 0x38
  j_superblock->s_sequence = 0x049F
  j_tail_sequence = 0x049F
  j_transaction_sequence = 0x04A0
  j_commit_sequence = 0x049E
  j_commit_request = 0x049E
  j_head = 0x25DE
  j_tail = 0x25DE
  j_free = 0x7FFF
  j_barrier_count = 0x1
  j_last_sync_writer = 0x0570
  j_running_transaction->t_tid = 0x49F
  j_running_transaction->t_state = T_RUNNING
  j_running_transaction->t_start_time = 0x00000031F66EEAB4
  j_running_transaction->t_updates = 0

And, The call-stacks of other Process-B are below :

   __schedule+0x634
   start_this_handle+0x164
   jbd2__journal_start+0x98
   ext4_journal_start_sb+0x1a4
   ext4_rename+0x38
   vfs_rename+0x28c

i.e The process-B is scheduled at "wait_event()" of the below
"start_this_handle()". 

static int start_this_handle(journal_t *journal, handle_t *handle,
           gfp_t gfp_mask)
{
  < SNIP >
  /* Wait on the journal's transaction barrier if necessary */
  if (journal->j_barrier_count) {
    read_unlock(&journal->j_state_lock);
    wait_event(journal->j_wait_transaction_locked,
        journal->j_barrier_count == 0);
    goto repeat;
  }

  if (!journal->j_running_transaction) {
    read_unlock(&journal->j_state_lock);
    if (!new_transaction)
      goto alloc_transaction;
    write_lock(&journal->j_state_lock);
    if (!journal->j_running_transaction) {
      jbd2_get_transaction(journal, new_transaction);
      new_transaction = NULL;
    }
    write_unlock(&journal->j_state_lock);
    goto repeat;
  }
  < SNIP >
}

Would you tell me about the reason why this bug is occurred??

Thanks

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
