From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fake direct I/O mode for data=journal
Date: Sun, 14 Aug 2011 22:19:14 -0400
Message-ID: <1313374754-1958-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40247 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1HOCTS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Aug 2011 22:19:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently attempts to open a file with O_DIRECT in data=journal mode
causes the open to fail with -EINVAL.  This makes it very hard to test
data=journal mode.  So we will let the open succeed, but then always
fall back to O_DSYNC buffered writes.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

With this commit applied ext4 in data=journal mode passes nearly all
of the xfstests -g auto tests:

BEGIN TEST: Ext4 4k block w/data=journal Sun Aug 14 20:10:23 EDT 2011
Ran: 001 002 005 006 007 011 013 014 015 053 069 070 074 075 076 077 079 083 088 089 100 105 112 113 117 120 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213 214 215 221 223 224 225 226 228 236 237 239 240 243 245 246 247 248 249 256
Failures: 223
END TEST: Ext4 4k block w/data=journal Sun Aug 14 20:24:18 EDT 2011

The #223 failure is a stripe alignment failure; it's interesting that
data=journal is affecting our block allocation, but since ext4's RAID
stripe alignment happens mostly by luck, it's not a huge deal....

 fs/ext4/file.c  |   10 ++++++++++
 fs/ext4/inode.c |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index e4095e9..f92981a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -98,6 +98,16 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 	int ret;
 
 	/*
+	 * If O_DIRECT is set and we are doing data journalling we
+	 * don't support O_DIRECT so force it off.
+	 */
+	if ((iocb->ki_filp->f_flags & O_DIRECT) &&
+	    ext4_should_journal_data(inode)) {
+		iocb->ki_filp->f_flags &= ~O_DIRECT;
+		iocb->ki_filp->f_flags |= O_DSYNC;
+	}
+
+	/*
 	 * If we have encountered a bitmap-format file, the size limit
 	 * is smaller than s_maxbytes, which is for extent-mapped files.
 	 */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7dd6981..49ebd3b9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2914,6 +2914,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
+	.direct_IO		= ext4_direct_IO,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 };
-- 
1.7.4.1.22.gec8e1.dirty

