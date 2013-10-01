From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/31] libext2fs: Only link an inode into a directory once
Date: Mon, 30 Sep 2013 18:26:55 -0700
Message-ID: <20131001012655.28415.38313.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22319 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3JAB07 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:26:59 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2fs_link helper function link_proc does not check the value of ls->done,
which means that if the function finds multiple empty spaces that will fit the
new directory entry, it will create a directory entry in each of the spaces.
Instead of doing that, check the done value and don't do anything more if we've
already added the directory entry.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/link.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index f715067..e3ff450 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -43,6 +43,9 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	int ret = 0;
 	int csum_size = 0;
 
+	if (ls->done)
+		return 0;
+
 	rec_len = EXT2_DIR_REC_LEN(ls->namelen);
 
 	ls->err = ext2fs_get_rec_len(ls->fs, dirent, &curr_rec_len);

