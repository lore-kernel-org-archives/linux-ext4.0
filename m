From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] jbd2: We shouldnot cap writeback when we are doing a journal commit
Date: Fri, 27 Jun 2008 23:37:45 +0530
Message-ID: <1214590065-26891-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:42133 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763504AbYF0SHv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2008 14:07:51 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5RI7Gmx004513
	for <linux-ext4@vger.kernel.org>; Sat, 28 Jun 2008 04:07:16 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5RI7Pfb4190344
	for <linux-ext4@vger.kernel.org>; Sat, 28 Jun 2008 04:07:25 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5RI7mSf003066
	for <linux-ext4@vger.kernel.org>; Sat, 28 Jun 2008 04:07:49 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A journal commit need to make sure we submit data buffers before
we submit the meta-data buffers in ordered mode. We should
not be looking at BDI_CAP_NO_WRITEBACK when doing a journal commit.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/jbd2/commit.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 32ca3c3..f8b3be8 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -203,9 +203,6 @@ static int journal_submit_inode_data_buffers(struct address_space *mapping)
 		.for_writepages = 1,
 	};
 
-	if (!mapping_cap_writeback_dirty(mapping))
-		return 0;
