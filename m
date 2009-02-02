From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] ext2: Mark the buffer as unmapped before reading the next
	quota block
Date: Mon, 2 Feb 2009 15:34:27 +0530
Message-ID: <ea11fea30902020204t7a2db3a7tbf3f0b8d22b20cce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:59567 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZBBKE3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Feb 2009 05:04:29 -0500
Received: by ti-out-0910.google.com with SMTP id b6so701164tic.23
        for <linux-ext4@vger.kernel.org>; Mon, 02 Feb 2009 02:04:27 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

This is in continuation with the previous patch
(http://patchwork.ozlabs.org/patch/20275/) . We also need to set the
buffer as unmapped before reading the next block. I don't think quota
files can have holes, but atleast for correctness, otherwise once we
have read a block, tmp_bh is always mapped even for holes.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index da8bdea..b4e7633 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1328,6 +1328,7 @@ static ssize_t ext2_quota_read(struct
super_block *sb, int type, char *data,
 				sb->s_blocksize - offset : toread;

 		tmp_bh.b_state = 0;
+		clear_buffer_mapped(&tmp_bh);
 		err = ext2_get_block(inode, blk, &tmp_bh, 0);
 		if (err < 0)
 			return err;
-- 
1.5.4.3


Thanks -
Manish
