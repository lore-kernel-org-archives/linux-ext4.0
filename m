From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/2] ext4: let ext4_bio_write_page handle EOF correctly
Date: Wed,  7 Dec 2011 13:21:27 +0800
Message-ID: <1323235287-29806-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1323235287-29806-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, hughd@google.com, tytso@mit.edu,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43508 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab1LGIX4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2011 03:23:56 -0500
Received: by ghbz2 with SMTP id z2so248849ghb.19
        for <linux-ext4@vger.kernel.org>; Wed, 07 Dec 2011 00:23:56 -0800 (PST)
In-Reply-To: <1323235287-29806-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to zero out part of a page which beyond EOF before setting uptodate,
otherwise, mapread or write will see non-zero data beyond EOF.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/page-io.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 235b79d..9e145b8 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -385,6 +385,18 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 
 		block_end = block_start + blocksize;
 		if (block_start >= len) {
+			/*
+			 * Comments copied from block_write_full_page_endio:
+			 *
+			 * The page straddles i_size.  It must be zeroed out on
+			 * each and every writepage invocation because it may
+			 * be mmapped.  "A file is mapped in multiples of the
+			 * page size.  For a file that is not a multiple of
+			 * the  page size, the remaining memory is zeroed when
+			 * mapped, and writes to that region are not written
+			 * out to the file."
+			 */
+			zero_user_segment(page, block_start, block_end);
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
 			continue;
-- 
1.7.5.1

