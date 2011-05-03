From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: [PATCH] Prevent dirtying a page when ext4 F.S is frozen
Date: Tue,  3 May 2011 16:08:37 +0300
Message-ID: <1304428117-6195-2-git-send-email-surbhi.palande@canonical.com>
References: <4DBFE09E.5070805@canonical.com>
Cc: toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: jack@suse.cz
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DBFE09E.5070805@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Prevent dirtying a page when ext4 F.S is frozen. Also take the write semaphore
sb->s_umount to prevent a F.S freeze from racing with the page dirtying
process. Without this we can end up dirtying a page while a F.S freeze
happened because of preemption.

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
---
 fs/ext4/inode.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..db3f99d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3827,8 +3827,41 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
  */
 static int ext4_journalled_set_page_dirty(struct page *page)
 {
+	int ret=0;
+	struct inode * inode = NULL;
+	 struct super_block * sb = NULL;
+
+	if(likely((page->mapping) && (page->mapping->host))){
+		inode = page->mapping->host;
+		if(likely(inode->i_sb)){
+			sb = inode->i_sb;
+			/* we do not want a freeze to start now if F.S is not
+			 * already frozen*/
+			down_write(&sb->s_umount);
+			if(sb->s_frozen != SB_UNFROZEN) {
+				/* F.S is frozen.
+				 * we dont want to sleep with s_umount held.
+				 * Or else we might race with thaw_super */
+				up_write(&sb->s_umount);
+				vfs_check_frozen(sb, SB_FREEZE_WRITE);
+				/* F.S is no more frozen. We do not want the
+				 * FS freeze to begin after this point
+				 */
+				down_write(&sb->s_umount);
+			}
+		}
+	}
 	SetPageChecked(page);
-	return __set_page_dirty_nobuffers(page);
+	ret = __set_page_dirty_nobuffers(page);
+	if(likely((page->mapping) && (page->mapping->host))){
+		if(likely(inode->i_sb)){
+			up_write(&sb->s_umount);
+			/* If we freeze after this point, the dirtied page can
+			 * be flushed out!
+			 */
+		}
+	}
+	return ret;
 }
 
 static const struct address_space_operations ext4_ordered_aops = {
-- 
1.7.1

