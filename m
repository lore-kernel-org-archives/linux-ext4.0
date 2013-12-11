From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/74] debugfs: fix init_filesys help text
Date: Tue, 10 Dec 2013 17:18:50 -0800
Message-ID: <20131211011850.30655.33307.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42145 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3LKBS7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:18:59 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The help text for debugfs' init_filesys command is incorrect; the
second parameter is the size of the filesystem in blocks, not the size
of an individual filesystem block.  There is in fact no way to set
that parameter.

Reported-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 4ecf474..ea0f2c4 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -280,7 +280,7 @@ void do_init_filesys(int argc, char **argv)
 	int		err;
 
 	if (common_args_process(argc, argv, 3, 3, "initialize",
-				"<device> <blocksize>", CHECK_FS_NOTOPEN))
+				"<device> <blocks>", CHECK_FS_NOTOPEN))
 		return;
 
 	memset(&param, 0, sizeof(struct ext2_super_block));

