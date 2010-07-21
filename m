From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv2 1/1] jbd2: Fix I/O hang in
	jbd2_journal_release_jbd_inode
Date: Wed, 21 Jul 2010 21:02:52 +0200
Message-ID: <20100721190252.GG1215@atrey.karlin.mff.cuni.cz>
References: <201007141456.o6EEuFe9004519@d01av03.pok.ibm.com> <20100714174458.GA2378@localhost.localdomain> <4C3E08E6.2050203@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tsOsTdHNUZQcU9Ye"
Cc: Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	cmm@linux.vnet.ibm.com, pmac@au1.ibm.com
To: Brian King <brking@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35550 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758872Ab0GUTCx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jul 2010 15:02:53 -0400
Content-Disposition: inline
In-Reply-To: <4C3E08E6.2050203@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> 
> I've been debugging a hang in jbd2_journal_release_jbd_inode
> which is being seen on Power 6 systems quite a lot. When we get
> in the hung state, all I/O to the disk in question gets blocked
> where we stay indefinitely. Looking at the task list, I can see
> we are stuck in jbd2_journal_release_jbd_inode waiting on a
> wake up. I added some debug code to detect this scenario and
> dump additional data if we were stuck in jbd2_journal_release_jbd_inode
> for longer than 30 minutes. When it hit, I was able to see that
> i_flags was 0, suggesting we missed the wake up.
> 
> This patch changes i_flags to be an unsigned long, uses bit operators
> to access it, and adds barriers around the accesses. Prior to applying
> this patch, we were regularly hitting this hang on numerous systems
> in our test environment. After applying the patch, the hangs no longer
> occur. Its still not clear to me why the j_list_lock doesn't protect us
> in this path.
  Thanks for debugging this! I was thinking hard about how it could happen that
wake_up_bit doesn't wake up the waiter but I haven't found any explanation. All
the waitqueue work seems to be properly wrapped inside the j_list_lock so
even the waitqueue_active check in wake_up_bit should be fine.
  I'd really like to understand what in my mind-model of spinlocks etc. is
wrong. So could you maybe run a test with the attached debug patch and
dump 'wait.seen' value in the hung task?
  And one more question - if you remove 'waitqueue_active' check from
kernel/wait.c:__wake_up_bit
  is the problem still present? Thanks a lot in advance.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--tsOsTdHNUZQcU9Ye
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Debug-bit-wait-queues-in-JBD2.patch"

>From 7f305dbbe7cdb2ebfd410956f08ba4244ac578bd Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 21 Jul 2010 20:56:21 +0200
Subject: [PATCH] Debug bit wait queues in JBD2.

---
 fs/jbd2/journal.c |    1 +
 kernel/wait.c     |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0368808..0ecd858 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2211,6 +2211,7 @@ restart:
 	if (jinode->i_flags & JI_COMMIT_RUNNING) {
 		wait_queue_head_t *wq;
 		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
+		wait.seen = 1;
 		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
 		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 		spin_unlock(&journal->j_list_lock);
diff --git a/kernel/wait.c b/kernel/wait.c
index c4bd3d8..46acfae 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -177,8 +177,11 @@ int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *arg)
 		= container_of(wait, struct wait_bit_queue, wait);
 
 	if (wait_bit->key.flags != key->flags ||
-			wait_bit->key.bit_nr != key->bit_nr ||
-			test_bit(key->bit_nr, key->flags))
+			wait_bit->key.bit_nr != key->bit_nr)
+		return 0;
+	if (wait_bit->seen == 1)
+		wait_bit->seen = 2 + test_bit(key->bit_nr, key->flags);
+	if (test_bit(key->bit_nr, key->flags))
 		return 0;
 	else
 		return autoremove_wake_function(wait, mode, sync, key);
-- 
1.6.4.2


--tsOsTdHNUZQcU9Ye--
