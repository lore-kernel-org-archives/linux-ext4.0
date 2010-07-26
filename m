From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] jbd2: Make barrier messages less scary
Date: Mon, 26 Jul 2010 14:42:13 -0500
Message-ID: <4C4DE515.5020307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab0GZTmO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jul 2010 15:42:14 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6QJgE3F023456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 15:42:14 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o6QJgDxm016799
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 15:42:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Saying things like "sync failed" when a device does
not support barriers makes users slightly more worried than
they need to be; rather than talking about sync failures,
let's just state the barrier-based facts.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 75716d3..3d15b28 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -150,8 +150,8 @@ static int journal_submit_commit_record(journal_t *journal,
 	 */
 	if (ret == -EOPNOTSUPP && barrier_done) {
 		printk(KERN_WARNING
-		       "JBD: barrier-based sync failed on %s - "
-		       "disabling barriers\n", journal->j_devname);
+		       "JBD2: Disabling barriers on %s, "
+		       "not supported by device\n", journal->j_devname);
 		spin_lock(&journal->j_state_lock);
 		journal->j_flags &= ~JBD2_BARRIER;
 		spin_unlock(&journal->j_state_lock);
@@ -180,8 +180,8 @@ retry:
 	wait_on_buffer(bh);
 	if (buffer_eopnotsupp(bh) && (journal->j_flags & JBD2_BARRIER)) {
 		printk(KERN_WARNING
-		       "JBD2: wait_on_commit_record: sync failed on %s - "
-		       "disabling barriers\n", journal->j_devname);
+		       "JBD2: %s: barriers no longer supported on %s - "
+		       "disabling barriers\n", __func__, journal->j_devname);
 		spin_lock(&journal->j_state_lock);
 		journal->j_flags &= ~JBD2_BARRIER;
 		spin_unlock(&journal->j_state_lock);

