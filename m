From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 9/9] ext4: advertise the fact that the kernel supports meta_bg resizing
Date: Thu, 13 Sep 2012 18:49:16 -0400
Message-ID: <1347576556-5725-10-git-send-email-tytso@mit.edu>
References: <1347576556-5725-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50580 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab2IMW4P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 18:56:15 -0400
In-Reply-To: <1347576556-5725-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b8de488..eb7722a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2585,10 +2585,12 @@ static struct attribute *ext4_attrs[] = {
 /* Features this copy of ext4 supports */
 EXT4_INFO_ATTR(lazy_itable_init);
 EXT4_INFO_ATTR(batched_discard);
+EXT4_INFO_ATTR(meta_bg_resize);
 
 static struct attribute *ext4_feat_attrs[] = {
 	ATTR_LIST(lazy_itable_init),
 	ATTR_LIST(batched_discard),
+	ATTR_LIST(meta_bg_resize),
 	NULL,
 };
 
-- 
1.7.12.rc0.22.gcdd159b

