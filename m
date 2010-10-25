From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Add batched_discard into ext4 feature list
Date: Mon, 25 Oct 2010 18:14:07 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1010251809490.604@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, lczerner@redhat.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab0JYQOM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 12:14:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Should be applied on the top of "lazy inode table initialization"
and "batched discard support" patch-sets.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b1cd3d0..3cba1b9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2456,9 +2456,11 @@ static struct attribute *ext4_attrs[] = {
 
 /* Features this copy of ext4 supports */
 EXT4_INFO_ATTR(lazy_itable_init);
+EXT4_INFO_ATTR(batched_discard);
 
 static struct attribute *ext4_feat_attrs[] = {
 	ATTR_LIST(lazy_itable_init),
+	ATTR_LIST(batched_discard),
 	NULL,
 };
 
-- 
1.7.2.3

