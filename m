From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: free bh on csum verify error in do_one_pass
Date: Thu, 17 Jul 2014 16:11:59 -0500
Message-ID: <53C83C1F.8020303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbaGQVMA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jul 2014 17:12:00 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6HLC0SH019305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2014 17:12:00 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s6HLBxXJ021921
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2014 17:12:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Coverity (re-)spotted this; it was triaged as a false positive,
but it seems pretty clear that the bh (which was just checked)
isn't currently freed before the function exits.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 54579c2..66d02b2 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -523,6 +523,7 @@ static int do_one_pass(journal_t *journal,
 			    !jbd2_descr_block_csum_verify(journal,
 							  bh->b_data)) {
 				err = -EIO;
+				brelse(bh);
 				goto failed;
 			}
 

