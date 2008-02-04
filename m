From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use the right macro for testing the incompat feature.
Date: Mon,  4 Feb 2008 21:17:19 +0530
Message-ID: <1202140039-7560-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1202140039-7560-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, Girish.Shilamkar@Sun.COM,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:43162 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYBDPrZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 10:47:25 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m14FlErK028883
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 02:47:14 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m14FlNYX3862766
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 02:47:23 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m14FlN0f001370
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 02:47:23 +1100
In-Reply-To: <1202140039-7560-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Incompat feature need to be checked using JBD2_HAS_INCOMPAT_FEATURE

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/jbd2/commit.c   |    2 +-
 fs/jbd2/recovery.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 2b88ab0..9cd9288 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -142,7 +142,7 @@ static int journal_submit_commit_record(journal_t *journal,
 	bh->b_end_io = journal_end_buffer_io_sync;
 
 	if (journal->j_flags & JBD2_BARRIER &&
-		!JBD2_HAS_COMPAT_FEATURE(journal,
+		!JBD2_HAS_INCOMPAT_FEATURE(journal,
 					 JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
 		set_buffer_ordered(bh);
 		barrier_done = 1;
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 9216806..f8ec777 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -641,7 +641,7 @@ static int do_one_pass(journal_t *journal,
 				if (chksum_err) {
 					info->end_transaction = next_commit_ID;
 
-					if (!JBD2_HAS_COMPAT_FEATURE(journal,
+					if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
 					   JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)){
 						printk(KERN_ERR
 						       "JBD: Transaction %u "
-- 
1.5.4.rc3.24.gb53139-dirty
