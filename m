From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/3] ext4: remove obsoleted check
Date: Sun, 13 Apr 2014 19:36:01 +0400
Message-ID: <1397403361-20459-3-git-send-email-dmonakhov@openvz.org>
References: <1397403361-20459-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:21216 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbaDMPgU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 11:36:20 -0400
In-Reply-To: <1397403361-20459-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

BH can not be NULL at this point, ext4_read_dirblock() always return
non null value, and we already have done all necessery checks.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/namei.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1cb84f7..a683f95 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2510,8 +2510,7 @@ static int empty_dir(struct inode *inode)
 		 ext4_rec_len_from_disk(de1->rec_len, sb->s_blocksize);
 	de = ext4_next_entry(de1, sb->s_blocksize);
 	while (offset < inode->i_size) {
-		if (!bh ||
-		    (void *) de >= (void *) (bh->b_data+sb->s_blocksize)) {
+		if ((void *) de >= (void *) (bh->b_data+sb->s_blocksize)) {
 			unsigned int lblock;
 			err = 0;
 			brelse(bh);
-- 
1.7.1

