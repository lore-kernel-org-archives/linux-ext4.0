From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] ext4: Add a missing trace hook
Date: Mon, 24 May 2010 16:25:32 +0800
Message-ID: <4BFA37FC.1000709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57106 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab0EXIXN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 May 2010 04:23:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit f8ec9d6837241865cf99bed97bb99f4399fd5a03 added a
trace event ext4_da_release_space, but didn't add some
corresponding trace hook.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/ext4/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 81d6054..b71f883 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1910,6 +1910,7 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 
+	trace_ext4_da_release_space(inode, to_free);
 	if (unlikely(to_free > ei->i_reserved_data_blocks)) {
 		/*
 		 * if there aren't enough reserved blocks, then the
-- 
1.6.3

