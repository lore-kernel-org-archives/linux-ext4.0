From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51571] Assertion of j_running_transaction on
 jbd2_journal_flush()
Date: Wed, 12 Dec 2012 00:01:04 +0000 (UTC)
Message-ID: <20121212000104.75D4D11F993@bugzilla.kernel.org>
References: <bug-51571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42476 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab2LLABG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Dec 2012 19:01:06 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5DE64202AC
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2012 00:01:05 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7AF9E2028E
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2012 00:01:04 +0000 (UTC)
In-Reply-To: <bug-51571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51571


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #1 from Jan Kara <jack@suse.cz>  2012-12-12 00:01:04 ---
Thanks for detailed report! I presume you have a crash dump when you could
provide such details? Can you have a look at what
journal->j_running_transaction->t_handle_count is? I can see the transaction
has been started some 14 ms ago. That's not too long but still plenty in terms
of CPU time.

What I think is happening is:
Process A                                    Process B
start_this_handle().
  if (journal->j_barrier_count) # false
  if (!journal->j_running_transaction) { #true
    read_unlock(&journal->j_state_lock);
                                           jbd2_journal_lock_updates()
                                           jbd2_journal_flush()
                                            
write_lock(&journal->j_state_lock);
                                             if
(journal->j_running_transaction) {
                                               #false
                                             ... wait for committing trans ...
                                            
write_unlock(&journal->j_state_lock);
    ...
    write_lock(&journal->j_state_lock);
    jbd2_get_transaction(journal, new_transaction); # Sets
j_running_transaction
    write_unlock(&journal->j_state_lock);
    goto repeat; # eventually blocks on j_barrier_count > 0

I will attach here a patch that should fix this...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
