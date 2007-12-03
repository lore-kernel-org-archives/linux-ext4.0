From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/4] ext4: minor fix in jbd2 stats kmalloc failure case
Date: Mon, 03 Dec 2007 17:29:43 -0600
Message-ID: <47549167.4000107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXLCX3p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Dec 2007 18:29:45 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lB3NTik4032601
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 18:29:44 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB3NThxU016168
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 18:29:43 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id lB3NThwA022139
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 18:29:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Mingming: these 4 patches can apply after 
jbd-stats-through-procfs-with-external-journal-oops-fix.patch)

---------------------------------------------------------------------

The other instance of this problem was caught, but this one got missed:
Free the correct pointer on s->stats allocation failure in jbd2_seq_info_open

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc3/fs/jbd2/journal.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/jbd2/journal.c
+++ linux-2.6.24-rc3/fs/jbd2/journal.c
@@ -850,7 +850,7 @@ static int jbd2_seq_info_open(struct ino
 		return -EIO;
 	size = sizeof(struct transaction_stats_s);
 	s->stats = kmalloc(size, GFP_KERNEL);
-	if (s == NULL) {
+	if (s->stats == NULL) {
 		kfree(s);
 		return -EIO;
 	}
