From: Tao Ma <tm@tao.ma>
Subject: Re: [ext4:dev 40/60] fs/ext4/inode.c:1953 __ext4_journalled_writepage() error: potential NULL dereference 'page_bufs'.
Date: Tue,  4 Dec 2012 21:25:45 +0800
Message-ID: <1354627545-2792-1-git-send-email-tm@tao.ma>
References: <20121204111011.GD22569@mwanda>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: dan.carpenter@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:47923 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752423Ab2LDNZ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2012 08:25:58 -0500
In-Reply-To: <20121204111011.GD22569@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dan,
	Thanks for the report. Can you check whether this patch
works for you?

Thanks
Tao

From: Tao Ma <boyu.mt@taobao.com>
Subject: [PATCH] ext4: Fix a build warning in __ext4_journalled_writepage.

smatch complains:
fs/ext4/inode.c:1953 __ext4_journalled_writepage() error: potential NULL dereference 'page_bufs'.

So add the check for it.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
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
