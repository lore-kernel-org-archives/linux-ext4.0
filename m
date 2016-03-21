From: Jens Axboe <axboe@fb.com>
Subject: [PATCH] ext4: remove unnecessary bio get/put
Date: Mon, 21 Mar 2016 10:15:23 -0600
Message-ID: <20160321161523.GA12438@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13961 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755534AbcCUQP3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2016 12:15:29 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

ext4_io_submit() use to check for EOPNOTSUPP after bio submission,
which is why it had to get an extra reference to the bio before
submitting it. But since we no longer touch the bio after submission,
get rid of the redundant get/put of the bio. If we do get the extra
reference, we enter the slower path of having to flag this bio as now
having external references.

Signed-off-by: Jens Axboe <axboe@fb.com>

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 349d7aa04fe7..a81939236707 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -351,9 +351,7 @@ void ext4_io_submit(struct ext4_io_submit *io)
 	if (bio) {
 		int io_op = io->io_wbc->sync_mode == WB_SYNC_ALL ?
 			    WRITE_SYNC : WRITE;
-		bio_get(io->io_bio);
 		submit_bio(io_op, io->io_bio);
-		bio_put(io->io_bio);
 	}
 	io->io_bio = NULL;
 }

-- 
Jens Axboe

