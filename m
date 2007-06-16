From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: [PATCH] ext4:fix invariant checking in ext4_rebalance_reservation
Date: Sat, 16 Jun 2007 12:02:00 +0400
Message-ID: <20070616080200.GA14349@localhost.sw.ru>
References: <20070614072352.GA6517@localhost.sw.ru> <4672202C.4080304@clusterfs.com> <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:14490 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbXFPIBc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Jun 2007 04:01:32 -0400
Content-Disposition: inline
In-Reply-To: <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Variable "free" was declarated as __u64 so conidition (free < 0) always
false, even if free was overflowed during substraction.
---
 fs/ext4/balloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 43ae8f8..a9655f1 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1909,8 +1909,8 @@ void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
 			chunk = free;
 		if (rs[i].rs_reserved || i == smp_processor_id()) {
 			rs[i].rs_reserved = chunk;
+			BUG_ON(free < chunk);
 			free -= chunk;
-			BUG_ON(free < 0);
 		}
 	}
 	BUG_ON(free);
-- 
1.5.2
