From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 1/2] ext4: unlock group before returning on error
Date: Mon,  3 Nov 2008 13:32:14 +0530
Message-ID: <1225699335-28813-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:38647 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbYKCICT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 03:02:19 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id mA382GqN015371
	for <linux-ext4@vger.kernel.org>; Mon, 3 Nov 2008 13:32:16 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA382GEM1945680
	for <linux-ext4@vger.kernel.org>; Mon, 3 Nov 2008 13:32:16 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id mA382Fdc029551
	for <linux-ext4@vger.kernel.org>; Mon, 3 Nov 2008 19:02:16 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

with errors=continue we need to make sure we need
to unlock the group before returning.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d523e42..0643f9c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4446,6 +4446,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		else if (block >= (entry->start_blk + entry->count))
 			n = &(*n)->rb_right;
 		else {
+			ext4_unlock_group(sb, group);
 			ext4_error(sb, __func__,
 			    "Double free of blocks %d (%d %d)\n",
 			    block, entry->start_blk, entry->count);
-- 
1.6.0.3.514.g2f91b

