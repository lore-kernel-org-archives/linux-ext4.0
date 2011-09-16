From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 16/25] e2fsck: remove extraneous memset
Date: Fri, 16 Sep 2011 15:49:31 -0500
Message-ID: <1316206180-6375-17-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46753 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab1IPUtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:46 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsck_allocate_memory() already sets allocated memory to 0,
so remove the explicit memset.

Especially since it was setting the wrong size (iter not *iter)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/dirinfo.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/e2fsck/dirinfo.c b/e2fsck/dirinfo.c
index 901235c..ace5b4d 100644
--- a/e2fsck/dirinfo.c
+++ b/e2fsck/dirinfo.c
@@ -318,7 +318,6 @@ extern struct dir_info_iter *e2fsck_dir_info_iter_begin(e2fsck_t ctx)
 
 	iter = e2fsck_allocate_memory(ctx, sizeof(struct dir_info_iter),
 				      "dir_info iterator");
-	memset(iter, 0, sizeof(iter));
 
 	if (db->tdb)
 		iter->tdb_iter = tdb_firstkey(db->tdb);
-- 
1.7.4.1

