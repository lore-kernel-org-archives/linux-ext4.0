From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: Fix thinko in ext2fs_initialize bigalloc case
Date: Mon, 03 Oct 2011 17:01:18 -0500
Message-ID: <4E8A30AE.10805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668Ab1JCWBT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 18:01:19 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p93M1JsV005198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 3 Oct 2011 18:01:19 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p93M1ImR012446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 3 Oct 2011 18:01:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Surely we should be setting s_clusters_per_group, not
s_blocks_per_group, to EXT2_MAX_CLUSTERS_PER_GROUP here.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 47f0b1c..2875f97 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -218,7 +218,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 		else
 			super->s_clusters_per_group = fs->blocksize * 8;
 		if (super->s_clusters_per_group > EXT2_MAX_CLUSTERS_PER_GROUP(super))
-			super->s_blocks_per_group = EXT2_MAX_CLUSTERS_PER_GROUP(super);
+			super->s_clusters_per_group = EXT2_MAX_CLUSTERS_PER_GROUP(super);
 		super->s_blocks_per_group = EXT2FS_C2B(fs,
 				       super->s_clusters_per_group);
 	} else {

