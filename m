From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] ext4: hold page lock when checking mapping in ext4_page_mkwrite
Date: Mon, 18 Jul 2011 11:59:32 -0400
Message-ID: <1311004772-14675-1-git-send-email-josef@redhat.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab1GRP7e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jul 2011 11:59:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pages can be evicted from cache outside of truncate, for example when
invalidating pages after writing with O_DIRECT.  The only proper way to check
page->mapping is under the page lock, so fix ext4_page_mkwrite to do this.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ext4/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e3126c0..1ad7d10 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5855,14 +5855,15 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 */
 	down_read(&inode->i_alloc_sem);
 	size = i_size_read(inode);
+	lock_page(page);
 	if (page->mapping != mapping || size <= page_offset(page)
 	    || !PageUptodate(page)) {
+		unlock_page(page);
 		/* page got truncated from under us? */
 		goto out_unlock;
 	}
 	ret = 0;
 
-	lock_page(page);
 	wait_on_page_writeback(page);
 	if (PageMappedToDisk(page)) {
 		up_read(&inode->i_alloc_sem);
-- 
1.7.5.2

