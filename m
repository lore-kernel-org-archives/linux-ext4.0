From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/12] ext4: Make ext4_bio_writepage() handle unprepared buffers
Date: Fri, 18 Jan 2013 13:00:45 +0100
Message-ID: <1358510446-19174-12-git-send-email-jack@suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab3ARMA7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 07:00:59 -0500
In-Reply-To: <1358510446-19174-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So far ext4_bio_writepage() unconditionally cleared dirty bit on all buffers
underlying the page. That implicitely assumes we can write all buffers. So
far that is true because callers call into ext4_bio_writepage() make sure
all buffers in the page are mapped but
a) it's a data corruption bug waiting to happen
b) in data=ordered mode when blocksize < pagesize we do need to write pages
   that may have only some of dirty buffers mapped.

So change ext4_bio_writepage() to skip buffers that cannot be written without
clearing their dirty bit.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/page-io.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 3fb385c..0290bf8 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -350,14 +350,6 @@ static int io_submit_add_bh(struct ext4_io_submit *io,
 		unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
 	}
 
-	if (!buffer_mapped(bh) || buffer_delay(bh)) {
-		if (!buffer_mapped(bh))
-			clear_buffer_dirty(bh);
-		if (io->io_bio)
-			ext4_io_submit(io);
-		return 0;
-	}
