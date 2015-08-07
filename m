From: Jan Kara <jack@suse.com>
Subject: [PATCH 03/19] ext2fs: Add pointer to allocator private data into ext2_filsys
Date: Fri,  7 Aug 2015 12:51:13 +0200
Message-ID: <1438944689-24562-4-git-send-email-jack@suse.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbbHGKvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:42 -0400
In-Reply-To: <1438944689-24562-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/ext2fs/ext2fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 613f0d1bcc91..13cbe567b19c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -279,6 +279,8 @@ struct struct_ext2_filsys {
 
 	io_channel			journal_io;
 	char				*journal_name;
+	/* Private data for use by get_alloc_block() function */
+	void				*alloc_data;
 };
 
 #if EXT2_FLAT_INCLUDES
-- 
2.1.4

