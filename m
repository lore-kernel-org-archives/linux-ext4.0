From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext4: Fix error handling ext4_ind_get_blocks
Date: Tue, 27 Oct 2009 13:48:48 +0100
Message-ID: <1256647729-29834-4-git-send-email-jack@suse.cz>
References: <1256647729-29834-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbZJ0Msq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Oct 2009 08:48:46 -0400
In-Reply-To: <1256647729-29834-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When an error happened in ext4_splice_branch we failed to notice that
in ext4_ind_get_blocks and mapped the buffer anyway. Fix the problem
by checking for error properly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5c5bc5d..9105f40 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1020,7 +1020,7 @@ static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 	if (!err)
 		err = ext4_splice_branch(handle, inode, iblock,
 					 partial, indirect_blks, count);
-	else
+	if (err)
 		goto cleanup;
 
 	set_buffer_new(bh_result);
-- 
1.6.0.2

