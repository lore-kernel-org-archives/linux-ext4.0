From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: jbd: Add fixed tracepoints
Date: Wed, 18 Mar 2015 11:05:33 +0300
Message-ID: <20150318080532.GA9399@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: lczerner@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51935 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbbCRIFu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Mar 2015 04:05:50 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Lukas Czerner,

The patch 99cb1a318c37: "jbd: Add fixed tracepoints" from May 23,
2011, leads to the following static checker warning:

	fs/jbd/commit.c:1016 journal_commit_transaction()
	warn: 'commit_transaction' was already freed.

fs/jbd/commit.c
   993          spin_unlock(&journal->j_state_lock);
   994  
   995          if (commit_transaction->t_checkpoint_list == NULL &&
   996              commit_transaction->t_checkpoint_io_list == NULL) {
   997                  __journal_drop_transaction(journal, commit_transaction);
                                                            ^^^^^^^^^^^^^^^^^^
Freed here.

   998          } else {
   999                  if (journal->j_checkpoint_transactions == NULL) {
  1000                          journal->j_checkpoint_transactions = commit_transaction;
  1001                          commit_transaction->t_cpnext = commit_transaction;
  1002                          commit_transaction->t_cpprev = commit_transaction;
  1003                  } else {
  1004                          commit_transaction->t_cpnext =
  1005                                  journal->j_checkpoint_transactions;
  1006                          commit_transaction->t_cpprev =
  1007                                  commit_transaction->t_cpnext->t_cpprev;
  1008                          commit_transaction->t_cpnext->t_cpprev =
  1009                                  commit_transaction;
  1010                          commit_transaction->t_cpprev->t_cpnext =
  1011                                  commit_transaction;
  1012                  }
  1013          }
  1014          spin_unlock(&journal->j_list_lock);
  1015  
  1016          trace_jbd_end_commit(journal, commit_transaction);
                                              ^^^^^^^^^^^^^^^^^^
Dereferenced here.

  1017          jbd_debug(1, "JBD: commit %d complete, head %d\n",
  1018                    journal->j_commit_sequence, journal->j_tail_sequence);
  1019  
  1020          wake_up(&journal->j_wait_done_commit);
  1021  }

regards,
dan carpenter
