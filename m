From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: disable synchronous transaction batching if max_batch_time==0
Date: Mon, 09 Jun 2014 19:10:45 -0500
Message-ID: <53964D05.6000009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933311AbaFJAKq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2014 20:10:46 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5A0AkFH018895
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2014 20:10:46 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s5A0AjMJ020599
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2014 20:10:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The mount manpage says of the max_batch_time option,

	This optimization can be turned off entirely
	by setting max_batch_time to 0.

But the code doesn't do that.  So fix the code to do
that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Lightly tested: it mounts, accepts the mount option == 0,
shows "0" in /proc/mounts, and does basic IO & unmounts
without crashing.  ;)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6f9e6fa..ab5a791 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1524,8 +1524,6 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			arg = JBD2_DEFAULT_MAX_COMMIT_AGE;
 		sbi->s_commit_interval = HZ * arg;
 	} else if (token == Opt_max_batch_time) {
-		if (arg == 0)
-			arg = EXT4_DEF_MAX_BATCH_TIME;
 		sbi->s_max_batch_time = arg;
 	} else if (token == Opt_min_batch_time) {
 		sbi->s_min_batch_time = arg;

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 38cfcf5..6f0f590 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1588,9 +1588,12 @@ int jbd2_journal_stop(handle_t *handle)
 	 * to perform a synchronous write.  We do this to detect the
 	 * case where a single process is doing a stream of sync
 	 * writes.  No point in waiting for joiners in that case.
+	 *
+	 * Setting max_batch_time to 0 disables this completely.
 	 */
 	pid = current->pid;
-	if (handle->h_sync && journal->j_last_sync_writer != pid) {
+	if (handle->h_sync && journal->j_last_sync_writer != pid &&
+	    journal->j_max_batch_time) {
 		u64 commit_time, trans_time;
 
 		journal->j_last_sync_writer = pid;

