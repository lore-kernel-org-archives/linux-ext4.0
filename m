Return-Path: <SRS0=7jnN=PI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr820113.outbound.protection.outlook.com ([40.107.82.113]:59061
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727405AbeLaTsp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 31 Dec 2018 14:48:45 -0500
From: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
CC: Theodore Ts'o <tytso@mit.edu>, <stable@kernel.org>
Subject: [PATCH 3/3] ext4: track writeback errors using the generic tracking infrastructure
Date: Mon, 31 Dec 2018 14:48:36 -0500
Message-ID: <20181231194836.3761-3-tytso@mit.edu>
In-Reply-To: <20181231194836.3761-1-tytso@mit.edu>
References: <20181231194836.3761-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We already using mapping_set_error() in fs/ext4/page_io.c, so all we
need to do is to use file_check_and_advance_wb_err() when handling
fsync() requests in ext4_sync_file().

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/fsync.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 87a7ff00ef62..712f00995390 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -164,6 +164,9 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 			ret = err;
 	}
 out:
+	err = file_check_and_advance_wb_err(file);
+	if (ret == 0)
+		ret = err;
 	trace_ext4_sync_file_exit(inode, ret);
 	return ret;
 }
-- 
2.19.1
