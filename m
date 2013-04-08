From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/29] ext4: Clear buffer_uninit flag when submitting IO
Date: Mon,  8 Apr 2013 23:32:08 +0200
Message-ID: <1365456754-29373-4-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936271Ab3DHVdB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:01 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently noone cleared buffer_uninit flag. This results in writeback
needlessly marking io_end as needing extent conversion scanning extent
tree for extents to convert. So clear the buffer_uninit flag once the
buffer is submitted for IO and the flag is transformed into
EXT4_IO_END_UNWRITTEN flag.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/page-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index da8bddf..efdf0a5 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -377,7 +377,7 @@ submit_and_retry:
 	if (ret != bh->b_size)
 		goto submit_and_retry;
 	io_end = io->io_end;
-	if (buffer_uninit(bh))
+	if (test_clear_buffer_uninit(bh))
 		ext4_set_io_unwritten_flag(inode, io_end);
 	io_end->size += bh->b_size;
 	io->io_next_block++;
-- 
1.7.1

