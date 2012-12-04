From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Fix a build warning in __ext4_journalled_writepage.
Date: Tue,  4 Dec 2012 21:39:38 +0800
Message-ID: <1354628379-3047-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:49326 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751545Ab2LDNj7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2012 08:39:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

smatch complains:
fs/ext4/inode.c:1953 __ext4_journalled_writepage() error: potential NULL dereference 'page_bufs'.

So add the check for it.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inode.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dbc5784..431201b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1956,7 +1956,7 @@ static int __ext4_journalled_writepage(struct page *page,
 	struct buffer_head *page_bufs = NULL;
 	handle_t *handle = NULL;
 	int ret = 0;
-	int err;
+	int err = 0;
 	struct buffer_head *inode_bh = NULL;
 
 	ClearPageChecked(page);
@@ -1987,8 +1987,7 @@ static int __ext4_journalled_writepage(struct page *page,
 		ret = ext4_journal_get_write_access(handle, inode_bh);
 
 		err = ext4_handle_dirty_metadata(handle, inode, inode_bh);
