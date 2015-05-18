From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/14] libext2fs: remove unnecessary undo file flush calls
Date: Mon, 18 May 2015 14:17:00 -0700
Message-ID: <20150518211700.GJ30577@birch.djwong.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46268 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbbERVRE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 May 2015 17:17:04 -0400
Content-Disposition: inline
In-Reply-To: <20150514002108.10785.85860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove all flushes of the undo file except for the one that happens just
prior to the file being closed; it seems that the arbitrary flushes
aren't sufficiently useful.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/undo_io.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index b9294c3..492d226 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -193,7 +193,6 @@ static errcode_t write_undo_indexes(struct undo_private_data *data, int flush)
 			data->keys_in_block = 0;
 			data->key_blk_num = data->undo_blk_num;
 			data->undo_blk_num++;
-			flush = 1;
 		}
 	}
 
