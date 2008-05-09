From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] JBD:need hold j_state_lock to updates to transaction
	t_state to T_COMMIT
Date: Fri, 09 May 2008 15:39:43 -0700
Message-ID: <1210372783.3639.63.camel@localhost.localdomain>
References: <20080306174209.GA14193@duck.suse.cz>
	 <1209166706.6040.20.camel@localhost.localdomain>
	 <20080428122626.GC17054@duck.suse.cz>
	 <1209402694.23575.5.camel@badari-desktop>
	 <20080428180932.GI17054@duck.suse.cz>
	 <1209409764.11872.6.camel@localhost.localdomain>
	 <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41539 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYEIWkB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 May 2008 18:40:01 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m49MdwfI004542
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 18:39:58 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m49Mdsfk120136
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 18:39:58 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m49Mds8k030797
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 18:39:54 -0400
In-Reply-To: <1210372072.3639.52.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Updating the current transaction's t_state is being protected by j_state_lock.
We need to do the same when updating the t_state to T_COMMIT.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/jbd/commit.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.26-rc1/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc1.orig/fs/jbd/commit.c	2008-05-09 14:46:25.000000000 -0700
+++ linux-2.6.26-rc1/fs/jbd/commit.c	2008-05-09 15:11:00.000000000 -0700
@@ -478,7 +478,9 @@ void journal_commit_transaction(journal_
 	 * transaction!  Now comes the tricky part: we need to write out
 	 * metadata.  Loop over the transaction's entire buffer list:
 	 */
+	spin_lock(&journal->j_state_lock);
 	commit_transaction->t_state = T_COMMIT;
+	spin_unlock(&journal->j_state_lock);
 
 	J_ASSERT(commit_transaction->t_nr_buffers <=
 		 commit_transaction->t_outstanding_credits);


