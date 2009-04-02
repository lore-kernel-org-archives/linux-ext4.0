From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Fix chain verification in ext3_get_blocks()
Date: Fri,  3 Apr 2009 01:36:39 +0200
Message-ID: <1238715399-22172-2-git-send-email-jack@suse.cz>
References: <n>
 <1238715399-22172-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbZDBXgm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2009 19:36:42 -0400
In-Reply-To: <1238715399-22172-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chain verification in ext3_get_blocks() has been hosed since it called
verify_chain(chain, NULL) which always returns success. As a result readers
could in theory race with truncate. On the other hand the race probably cannot
happen with the current locking scheme, since by the time ext3_truncate() is
called all the pages are already removed and hence get_block() shouldn't be
called on such pages...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 4a09ff1..4bab705 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -820,7 +820,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 		while (count < maxblocks && count <= blocks_to_boundary) {
 			ext3_fsblk_t blk;
 
-			if (!verify_chain(chain, partial)) {
+			if (!verify_chain(chain, chain + depth - 1)) {
 				/*
 				 * Indirect block might be removed by
 				 * truncate while we were reading it.
-- 
1.6.0.2

