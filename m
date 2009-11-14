From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14602] New: JBD2 journal abort / checkpoint creation racy?
Date: Sat, 14 Nov 2009 12:05:15 GMT
Message-ID: <bug-14602-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60822 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbZKNMFJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Nov 2009 07:05:09 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAEC5Foa028977
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2009 12:05:15 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14602

           Summary: JBD2 journal abort / checkpoint creation racy?
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: andi-bz@firstfloor.org
        Regression: No


I was testing a new file system feature that triggered IO errors
on inode read. I did not actually change the abort part here
so I believe this is unrelated to my changes.

I had one case during testing where the journal abort didn't work
and jbd2 journal abort errored out.

<putting some stress on the file system>
EXT4-fs error (device sda1): ext4_iget: triggering IO error
EXT4-fs error (device sda1): ext4_put_super: Couldn't clean up the journal

This happens in
ext4_put_super->jbd2_journal_destroy->jbd2_log_do_checkpoint
and then finally 


  if (journal->j_sb_buffer) {
                if (!is_journal_aborted(journal)) {
                        /* We can now mark the journal as empty. */
                        journal->j_tail = 0;
                        journal->j_tail_sequence =
                                ++journal->j_transaction_sequence;
                        jbd2_journal_update_superblock(journal, 1);
                } else {
                        err = -EIO; <------------ this is triggered
                }

So it looks like jbd2_log_do_checkpoint sometimes does not succeed?
It does a couple of retry, maybe that log is not enough.

The problem is not easy to trigger unfortunately, i only saw it very rarely.
I assume it's some race in the checkpoint creation.

I tried to reproduce it with jbd2 debugging enabled, but no luck so far.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
