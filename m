From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 0/5] jbd: possible filesystem corruption fixes (take 2)
Date: Mon, 02 Jun 2008 19:40:21 +0900
Message-ID: <4843CE15.6080506@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50709 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYFBKkl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 06:40:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Subject: [PATCH 0/5] jbd: possible filesystem corruption fixes (take 2)

This patch set is the take 2 of fixing error handling problem in
ext3/JBD.  The previous discussion can be found here:
http://lkml.org/lkml/2008/5/14/10

The same problem should also be in ext4/JBD, but I haven't prepared
it yet.


Problem
=======
Currently some error checkings are missing, so the journal cannot abort
correctly.  This causes breakage of the ordered mode rule and filesystem
corruption.  Missing error checkings are:

(1) error check for dirty buffers flushed before the commit
    (addressed by PATCH 1/5 and 2/5)
(2) error check for the metadata writes to the journal before the
    commit (addressed by PATCH 3/5)
(3) error check for checkpointing and replay (addressed by PATCH 4/5
    and 5/5)


Changes from take 1
===================
[PATCH 1/5]
o not changed

[PATCH 2/5]
o rewrite my coment in journal_dirty_data() comprehensibly

[PATCH 3/5]
o check for errors and abort the journal just before
  journal_write_commit_record() instead of after writing metadata
  buffers

[PATCH 4/5 and 5/5]
o separate the ext3 part from the jbd part in a patch
o use JFS_ABORT for checkpointing failures instead of introducing
  JFS_CP_ABORT flag
o don't update only the journal super block, but also j_tail and
  j_tail_sequence when the journal has aborted (at least we only
  have to avoid updating the super block, but keeping j_tail*'s
  values will be good thing because it may protect someone from
  adding bugs in the future)
o journal_destroy() returns -EIO when the journal has aborted so that
  ext3_put_super() can detect the abort
o journal_flush() uses j_checkpoint_mutex to avoid a race with
  __log_wait_for_space()

The last item targets a newly found problem.  journal_flush() can be
called while processing __log_wait_for_space().  In this case,
cleanup_journal_tail() can be called between
__journal_drop_transaction() and journal_abort(), then 
the transaction with checkpointing failure is lost from the journal.
Using j_checkpoint_mutex which is used by __log_wait_for_space(),
we should avoid the race condition.  But the test is not so sufficient
because it is very difficult to produce this race.  So I hope that
this locking is reviewed carefully (including a possibility of
deadlock.)

Regards,

-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


