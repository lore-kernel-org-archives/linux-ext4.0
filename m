From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH v2 1/2] ext4: Include forgotten start block on fallocate insert range
Date: Fri,  6 Jan 2017 21:26:00 +0100
Message-ID: <20170106202601.32722-2-roman.penyaev@profitbricks.com>
References: <20170106202601.32722-1-roman.penyaev@profitbricks.com>
Cc: Roman Pen <roman.penyaev@profitbricks.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wj0-f170.google.com ([209.85.210.170]:35466 "EHLO
        mail-wj0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938430AbdAFU0R (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jan 2017 15:26:17 -0500
Received: by mail-wj0-f170.google.com with SMTP id i20so42055003wjn.2
        for <linux-ext4@vger.kernel.org>; Fri, 06 Jan 2017 12:26:16 -0800 (PST)
In-Reply-To: <20170106202601.32722-1-roman.penyaev@profitbricks.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While doing 'insert range' start block should be also shifted right.
The bug can be easily reproduced by the following test:

    ptr = malloc(4096);
    assert(ptr);

    fd = open("./ext4.file", O_CREAT | O_TRUNC | O_RDWR, 0600);
    assert(fd >= 0);

    rc = fallocate(fd, 0, 0, 8192);
    assert(rc == 0);
    for (i = 0; i < 2048; i++)
            *((unsigned short *)ptr + i) = 0xbeef;
    rc = pwrite(fd, ptr, 4096, 0);
    assert(rc == 4096);
    rc = pwrite(fd, ptr, 4096, 4096);
    assert(rc == 4096);

    for (block = 2; block < 1000; block++) {
            rc = fallocate(fd, FALLOC_FL_INSERT_RANGE, 4096, 4096);
            assert(rc == 0);

            for (i = 0; i < 2048; i++)
                    *((unsigned short *)ptr + i) = block;

            rc = pwrite(fd, ptr, 4096, 4096);
            assert(rc == 4096);
    }

Because start block is not included in the range the hole appears at
the wrong offset (just after the desired offset) and the following
pwrite() overwrites already existent block, keeping hole untouched.

Simple way to verify wrong behaviour is to check zeroed blocks after
the test:

   $ hexdump ./ext4.file | grep '0000 0000'

The root cause of the bug is a wrong range (start, stop], where start
should be inclusive, i.e. [start, stop].

This patch fixes the problem by including start into the range.  But
not to break left shift (range collapse) stop points to the beginning
of the a block, not to the end.

The other not obvious change is an iterator check on validness in a
main loop.  Because iterator is unsigned the following corner case
should be considered with care: insert a block at 0 offset, when stop
variables overflows and never becomes less than start, which is 0.
To handle this special case iterator is set to NULL to indicate that
end of the loop is reached.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 fs/ext4/extents.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3e295d3350a9..4d3014b5a3f9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5343,8 +5343,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	if (!extent)
 		goto out;
 
-	stop = le32_to_cpu(extent->ee_block) +
-			ext4_ext_get_actual_len(extent);
+	stop = le32_to_cpu(extent->ee_block);
 
        /*
 	 * In case of left shift, Don't start shifting extents until we make
@@ -5383,8 +5382,12 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	else
 		iterator = &stop;
 
-	/* Its safe to start updating extents */
-	while (start < stop) {
+	/*
+	 * Its safe to start updating extents.  Start and stop are unsigned, so
+	 * in case of right shift if extent with 0 block is reached, iterator
+	 * becomes NULL to indicate the end of the loop.
+	 */
+	while (iterator && start <= stop) {
 		path = ext4_find_extent(inode, *iterator, &path, 0);
 		if (IS_ERR(path))
 			return PTR_ERR(path);
@@ -5412,8 +5415,11 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 					ext4_ext_get_actual_len(extent);
 		} else {
 			extent = EXT_FIRST_EXTENT(path[depth].p_hdr);
-			*iterator =  le32_to_cpu(extent->ee_block) > 0 ?
-				le32_to_cpu(extent->ee_block) - 1 : 0;
+			if (le32_to_cpu(extent->ee_block) > 0)
+				*iterator = le32_to_cpu(extent->ee_block) - 1;
+			else
+				/* Beginning is reached, end of the loop */
+				iterator = NULL;
 			/* Update path extent in case we need to stop */
 			while (le32_to_cpu(extent->ee_block) < start)
 				extent++;
-- 
2.10.2

