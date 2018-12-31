Return-Path: <SRS0=7jnN=PI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr750132.outbound.protection.outlook.com ([40.107.75.132]:51328
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727311AbeLaTsq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 31 Dec 2018 14:48:46 -0500
From: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
CC: Theodore Ts'o <tytso@mit.edu>, <stable@vger.kernel.org>
Subject: [PATCH 1/3] ext4: avoid kernel warning when writing the superblock to a dead device
Date: Mon, 31 Dec 2018 14:48:34 -0500
Message-ID: <20181231194836.3761-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The xfstests generic/475 test switches the underlying device with
dm-error while running a stress test.  This results in a large number
of file system errors, and since we can't lock the buffer head when
marking the superblock dirty in the ext4_grp_locked_error() case, it's
possible the superblock to be !buffer_uptodate() without
buffer_write_io_error() being true.

We need to set buffer_uptodate() before we call mark_buffer_dirty() or
this will trigger a WARN_ON.  It's safe to do this since the
superblock must have been properly read into memory or the mount would
have been successful.  So if buffer_uptodate() is not set, we can
safely assume that this happened due to a failed attempt to write the
superblock.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d6c142d73d99..fb12d3c17c1b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4902,7 +4902,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	ext4_superblock_csum_set(sb);
 	if (sync)
 		lock_buffer(sbh);
-	if (buffer_write_io_error(sbh)) {
+	if (buffer_write_io_error(sbh) || !buffer_uptodate(sbh)) {
 		/*
 		 * Oh, dear.  A previous attempt to write the
 		 * superblock failed.  This could happen because the
-- 
2.19.1
