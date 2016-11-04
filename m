From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/6] ext2: Use clean_bdev_aliases() instead of iteration
Date: Fri,  4 Nov 2016 18:08:14 +0100
Message-ID: <1478279296-6575-5-git-send-email-jack@suse.cz>
References: <1478279296-6575-1-git-send-email-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>,
        linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35629 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936485AbcKDRI1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 4 Nov 2016 13:08:27 -0400
In-Reply-To: <1478279296-6575-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use clean_bdev_aliases() instead of iterating through blocks one by one.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index d831e24dc885..eb11f7e2b8aa 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -732,16 +732,13 @@ static int ext2_get_blocks(struct inode *inode,
 	}
 
 	if (IS_DAX(inode)) {
-		int i;
