From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/4] ext4: don't keep using page if inline conversion fails
Date: Wed, 10 Sep 2014 17:28:45 -0700
Message-ID: <20140911002845.10109.10558.stgit@birch.djwong.org>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42369 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaIKA3B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2014 20:29:01 -0400
In-Reply-To: <20140911002818.10109.51772.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If inline->extent conversion fails (most probably due to ENOSPC) and
we release the temporary page that we allocated to transfer the file
contents, don't keep using the page pointer after releasing the page.
This occasionally leads to complaints about evicting locked pages or
hangs when blocksize > pagesize, because it's possible for the page to
get reallocated elsewhere in the meantime.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Tao Ma <tm@tao.ma>
---
 fs/ext4/inline.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index bea662b..378aadf 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -594,6 +594,7 @@ retry:
 	if (ret) {
 		unlock_page(page);
 		page_cache_release(page);
+		page = NULL;
 		ext4_orphan_add(handle, inode);
 		up_write(&EXT4_I(inode)->xattr_sem);
 		sem_held = 0;
@@ -613,7 +614,8 @@ retry:
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 
-	block_commit_write(page, from, to);
+	if (page)
+		block_commit_write(page, from, to);
 out:
 	if (page) {
 		unlock_page(page);

