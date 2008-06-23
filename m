From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
Date: Mon, 23 Jun 2008 20:14:54 +0900
Message-ID: <485F85AE.1010704@hitachi.com>
References: <4843CE15.6080506@hitachi.com> <4843CFBD.7040706@hitachi.com>
    <20080602124409.GL30613@duck.suse.cz> <4844CB39.6060409@hitachi.com>
    <20080603080219.GA17936@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42991 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYFWLPG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 07:15:06 -0400
In-Reply-To: <20080603080219.GA17936@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I noticed a problem of this patch.  Please see below.

Jan Kara wrote:

> On Tue 03-06-08 13:40:25, Hidehiro Kawai wrote:
> 
>>Subject: [PATCH 4/5] jbd: fix error handling for checkpoint io
>>
>>When a checkpointing IO fails, current JBD code doesn't check the
>>error and continue journaling.  This means latest metadata can be
>>lost from both the journal and filesystem.
>>
>>This patch leaves the failed metadata blocks in the journal space
>>and aborts journaling in the case of log_do_checkpoint().
>>To achieve this, we need to do:
>>
>>1. don't remove the failed buffer from the checkpoint list where in
>>   the case of __try_to_free_cp_buf() because it may be released or
>>   overwritten by a later transaction
>>2. log_do_checkpoint() is the last chance, remove the failed buffer
>>   from the checkpoint list and abort the journal
>>3. when checkpointing fails, don't update the journal super block to
>>   prevent the journaled contents from being cleaned.  For safety,
>>   don't update j_tail and j_tail_sequence either

3. is implemented as described below.
  (1) if log_do_checkpoint() detects an I/O error during
      checkpointing, it calls journal_abort() to abort the journal
  (2) if the journal has aborted, don't update s_start and s_sequence
      in the on-disk journal superblock

So, if the journal aborts, journaled data will be replayed on the
next mount.

Now, please remember that some dirty metadata buffers are written
back to the filesystem without journaling if the journal aborted.
We are happy if all dirty metadata buffers are written to the disk,
the integrity of the filesystem will be kept.  However, replaying
the journaled data can overwrite the latest on-disk metadata blocks
partly with old data.  It would break the filesystem.

My idea to resolve this problem is that we don't write out metadata
buffers which belong to uncommitted transactions if journal has
aborted.  Although the latest filesystem updates will be lost,
we can ensure the integrity.  It will also be effective for the
kernel panic in the middle of writing metadata buffers without
journaling (this would occur in the `mount -o errors=panic' case.)

Which integrity or latest state should we choose?

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd/commit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc5-mm3/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/fs/jbd/commit.c
+++ linux-2.6.26-rc5-mm3/fs/jbd/commit.c
@@ -486,9 +486,10 @@ void journal_commit_transaction(journal_
 		jh = commit_transaction->t_buffers;
 
 		/* If we're in abort mode, we just un-journal the buffer and
-		   release it for background writing. */
+		   release it. */
 
 		if (is_journal_aborted(journal)) {
+			clear_buffer_jbddirty(jh2bh(jh));
 			JBUFFER_TRACE(jh, "journal is aborting: refile");
 			journal_refile_buffer(journal, jh);
 			/* If that was the last one, we need to clean up
@@ -823,6 +824,8 @@ restart_loop:
 		if (buffer_jbddirty(bh)) {
 			JBUFFER_TRACE(jh, "add to new checkpointing trans");
 			__journal_insert_checkpoint(jh, commit_transaction);
+			if (is_journal_aborted(journal))
+				clear_buffer_jbddirty(bh);
 			JBUFFER_TRACE(jh, "refile for checkpoint writeback");
 			__journal_refile_buffer(jh);
 			jbd_unlock_bh_state(bh);

