From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix reference counting on buffer head.
Date: Mon,  4 Feb 2008 21:17:18 +0530
Message-ID: <1202140039-7560-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, Girish.Shilamkar@Sun.COM,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:43155 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYBDPrY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 10:47:24 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m14FlDTn028846
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 02:47:13 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m14FoxjL170018
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 02:50:59 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m14FlLNA001339
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 02:47:22 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With journal checksum patch we added asyn commit of journal commit headers.
During the conversion we missed to take a reference on buffer head. Before
the change sync_dirty_buffer did the get_bh(). The associative put_bh is
done by journal_wait_on_commit_record()

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/jbd2/commit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index da8d0eb..2b88ab0 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -136,7 +136,7 @@ static int journal_submit_commit_record(journal_t *journal,
 
 	JBUFFER_TRACE(descriptor, "submit commit block");
 	lock_buffer(bh);
-
+	get_bh(bh);
 	set_buffer_dirty(bh);
 	set_buffer_uptodate(bh);
 	bh->b_end_io = journal_end_buffer_io_sync;
-- 
1.5.4.rc3.24.gb53139-dirty
