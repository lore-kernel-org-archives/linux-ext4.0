From: Theodore Ts'o <tytso@mit.edu>
Subject: Saw your commit: Use mutex_lock_io() for journal->j_checkpoint_mutex
Date: Tue, 21 Feb 2017 15:23:24 -0500
Message-ID: <20170221202324.7plxcp22risagxqu@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41344 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751271AbdBUUX2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 21 Feb 2017 15:23:28 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Tejun, I saw your commit 6fa7aa50b2c484: "fs/jbd2, locking/mutex,
sched/wait: Use mutex_lock_io() for journal->j_checkpoint_mutex",
which just landed in Linus's tree.  The change makes sense, but I
wanted to make a comment about this part of the commit description:

    When an ext4 fs is bogged down by a lot of metadata IOs (in the
    reported case, it was deletion of millions of files, but any massive
    amount of journal writes would do), after the journal is filled up,
    tasks which try to access the filesystem and aren't currently
    performing the journal writes end up waiting in
    __jbd2_log_wait_for_space() for journal->j_checkpoint_mutex.

If this happens, it almost certainly means that the journal is too
small.  This was something that grad student I was mentoring found
when we were benchmarking our SMR-friendly jbd2 changes.  There's a
footnote to this effect in the Fast 2017 paper[1] 

[1] https://www.usenix.org/conference/fast17/technical-sessions/presentation/aghayev
    (if you want early access to the paper let me know; it's currently
    available to registered FAST 2017 attendees and will be opened up
    at the start of the FAST 2017 conference next week)

The short version is that on average, with a 5 second commit window
and a 30 second dirty writeback timeout, if you assume the worst case
of 100% of the metadata blocks being already in the buffer cache (so
they don't need to be read from disk), in 5 seconds the journal thread
could potential spew 150*5 == 750MB in a journal transaction.  But
that data won't be written back until 30 seconds later.  So if you are
continuously deleting files for 30 seconds, the journal should have
room for at least around 4500 megs worth of sequential writing.  Now,
that's an extreme worst case.  In reality there will be some disk
reads, not to mention the metadata writebacks, which will be random.

The bottom line is that 128MiB, which was the previous maximum journal
size, is simply way too small.  So in the latest e2fsprogs 1.43.x
release, the default has been changed so that for a sufficiently large
disk, the default journal size is 1 gig.

If you are using faster media (say, SSD or PCie-attached flash), and
you expect to have workloads that are extreme with respect to huge
amounts of metadata changes, an even bigger journal might be called
for.  (And these are the workloads where the lazy journalling that we
studied in the FAST paper is helpful, even on convential HDD's.)

Anyway, you might want to pass onto the system administrators (or the
SRE's, as applicable :-) that if they were hitting this case often,
they should seriously consider increasing the size of their ext4
journal.

						- Ted
