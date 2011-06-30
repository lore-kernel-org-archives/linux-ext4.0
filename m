From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: remove loop around bio_alloc()
Date: Wed, 29 Jun 2011 21:44:59 -0400
Message-ID: <1309398299-9988-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60220 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab1F3BpC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jun 2011 21:45:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These days, bio_alloc() is guaranteed to never fail (as long as nvecs
is less than BIO_MAX_PAGES), so we don't need the loop around the
struct bio allocation.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/page-io.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 7bb8f76..430c401 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -285,11 +285,7 @@ static int io_submit_init(struct ext4_io_submit *io,
 	io_end = ext4_init_io_end(inode, GFP_NOFS);
 	if (!io_end)
 		return -ENOMEM;
-	do {
-		bio = bio_alloc(GFP_NOIO, nvecs);
-		nvecs >>= 1;
-	} while (bio == NULL);
