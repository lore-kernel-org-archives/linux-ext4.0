From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: remove unused ext4_sb_info members
Date: Mon, 27 Sep 2010 12:02:52 -0500
Message-ID: <4CA0CE3C.7050903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759504Ab0I0RDA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Sep 2010 13:03:00 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8RH2xfo028094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Sep 2010 13:02:59 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o8RH2qZq003887
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Sep 2010 13:02:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Not that these take up a lot of room, but the structure is long enough
as it is, and there's no need to confuse people with these various
undocumented & unused structure members...

Signed-off-by: Eric Sandeen <sandeen@redaht.com>
---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 889ec9d..39e8513 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1087,7 +1087,6 @@ struct ext4_sb_info {
 	struct completion s_kobj_unregister;
 
 	/* Journaling */
-	struct inode *s_journal_inode;
 	struct journal_s *s_journal;
 	struct list_head s_orphan;
 	struct mutex s_orphan_lock;
@@ -1120,10 +1119,7 @@ struct ext4_sb_info {
 	/* for buddy allocator */
 	struct ext4_group_info ***s_group_info;
 	struct inode *s_buddy_cache;
-	long s_blocks_reserved;
-	spinlock_t s_reserve_lock;
 	spinlock_t s_md_lock;
-	tid_t s_last_transaction;
 	unsigned short *s_mb_offsets;
 	unsigned int *s_mb_maxs;
 
@@ -1141,7 +1137,6 @@ struct ext4_sb_info {
 	unsigned long s_mb_last_start;
 
 	/* stats for buddy allocator */
-	spinlock_t s_mb_pa_lock;
 	atomic_t s_bal_reqs;	/* number of reqs with len > 1 */
 	atomic_t s_bal_success;	/* we found long enough chunks */
 	atomic_t s_bal_allocated;	/* in blocks */

