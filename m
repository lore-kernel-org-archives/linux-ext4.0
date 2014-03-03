From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 24/30] e2fsck: check inline_data in pass1
Date: Mon, 3 Mar 2014 17:18:40 -0500
Message-ID: <20140303221840.GB4452@thunk.org>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
 <1386323897-2354-25-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36552 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbaCCWSn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2014 17:18:43 -0500
Content-Disposition: inline
In-Reply-To: <1386323897-2354-25-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 06, 2013 at 05:58:11PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

With my change to patch 11/30, the following change is needed to this
patch.

						- Ted

diff --git a/lib/ext2fs/dblist_dir.c b/lib/ext2fs/dblist_dir.c
index 1e36584..2fbb772 100644
--- a/lib/ext2fs/dblist_dir.c
+++ b/lib/ext2fs/dblist_dir.c
@@ -78,9 +78,7 @@ static int db_dir_proc(ext2_filsys fs, struct ext2_db_entry2 *db_info,
 		return DBLIST_ABORT;
 	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
 		ctx->flags = DIRENT_FLAG_INCLUDE_INLINE_DATA;
-		ext2fs_inline_data_dir_iterate(fs, ctx->dir,
-					       ext2fs_process_dir_block,
-					       ctx);
+		ret = ext2fs_inline_data_dir_iterate(fs, ctx->dir, ctx);
 	} else {
 		ret = ext2fs_process_dir_block(fs, &db_info->blk,
 					       db_info->blockcnt, 0, 0,
