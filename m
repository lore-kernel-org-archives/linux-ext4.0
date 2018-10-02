Return-Path: <SRS0=f65u=MO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49268 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbeJBMRX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Oct 2018 08:17:23 -0400
Date: Tue, 2 Oct 2018 01:35:56 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: syzbot <syzbot+c61979f6f2cba5cb3c06@syzkaller.appspotmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: INFO: task hung in ext4_fallocate
Message-ID: <20181002053556.GB17537@thunk.org>
References: <0000000000003908ec05772ec554@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003908ec05772ec554@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is fixed with the following patch.

						- Ted

>From c4a928ee604e31354c969b461aa9a6171825096a Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 2 Oct 2018 01:34:44 -0400
Subject: [PATCH] ext4: fix argument checking in EXT4_IOC_MOVE_EXT

If the starting block number of either the source or destination file
exceeds the EOF, EXT4_IOC_MOVE_EXT should return EINVAL.

Also fixed the helper function mext_check_coverage() so that if the
logical block is beyond EOF, make it return immediately, instead of
looping until the block number wraps all the away around.  This takes
long enough that if there are multiple threads trying to do pound on
an the same inode doing non-sensical things, it can end up triggering
the kernel's soft lockup detector.

Reported-by: syzbot+c61979f6f2cba5cb3c06@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/move_extent.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index a409ff70d67b..4901e389f847 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -92,16 +92,18 @@ mext_check_coverage(struct inode *inode, ext4_lblk_t from, ext4_lblk_t count,
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent *ext;
-	int ret = 0;
+	int len, ret = 0;
 	ext4_lblk_t last = from + count;
 	while (from < last) {
 		*err = get_ext_path(inode, from, &path);
 		if (*err)
 			goto out;
 		ext = path[ext_depth(inode)].p_ext;
-		if (unwritten != ext4_ext_is_unwritten(ext))
+		len = ext4_ext_get_actual_len(ext);
+		if ((ext->ee_block < from) ||
+		    (unwritten != ext4_ext_is_unwritten(ext)))
 			goto out;
-		from += ext4_ext_get_actual_len(ext);
+		from = ext->ee_block + len;
 		ext4_ext_drop_refs(path);
 	}
 	ret = 1;
@@ -516,9 +518,13 @@ mext_check_arguments(struct inode *orig_inode,
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
-	if (orig_eof < orig_start + *len - 1)
+	if (orig_eof <= orig_start)
+		*len = 0;
+	else if (orig_eof < orig_start + *len - 1)
 		*len = orig_eof - orig_start;
-	if (donor_eof < donor_start + *len - 1)
+	if (donor_eof <= donor_start)
+		*len = 0;
+	else if (donor_eof < donor_start + *len - 1)
 		*len = donor_eof - donor_start;
 	if (!*len) {
 		ext4_debug("ext4 move extent: len should not be 0 "
-- 
2.18.0.rc0
