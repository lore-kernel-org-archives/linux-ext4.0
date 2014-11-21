From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH 4/4] ext4: fix end of region partial cluster handling
Date: Fri, 21 Nov 2014 09:59:04 -0500
Message-ID: <20141121145904.GE30246@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:52284 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758420AbaKUO7L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2014 09:59:11 -0500
Received: by mail-qg0-f51.google.com with SMTP id l89so3705853qgf.24
        for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2014 06:59:10 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_remove_space() can incorrectly free a partial_cluster if
EAGAIN is encountered while truncating or punching.  Extent removal
should be retried in this case.

It also fails to free a partial cluster when the punched region begins
at the start of a file on that unaligned cluster and where the entire
file has not been punched.  Remove the requirement that all blocks in
the file must have been freed in order to free the partial cluster.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 841adf0..9eae2f4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3009,16 +3009,18 @@ again:
 	trace_ext4_ext_remove_space_done(inode, start, end, depth,
 			partial_cluster, path->p_hdr->eh_entries);
 
-	/* If we still have something in the partial cluster and we have removed
+	/*
+	 * If we still have something in the partial cluster and we have removed
 	 * even the first extent, then we should free the blocks in the partial
-	 * cluster as well. */
-	if (partial_cluster > 0 && path->p_hdr->eh_entries == 0) {
-		int flags = get_default_free_blocks_flags(inode);
