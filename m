From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext4: Protect ext4_page_mkwrite with sb_start_write - sb_end_write
Date: Thu, 12 Jan 2012 02:20:52 +0100
Message-ID: <1326331253-6497-4-git-send-email-jack@suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab2ALBVG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jan 2012 20:21:06 -0500
In-Reply-To: <1326331253-6497-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since ext4_page_mkwrite() calls into __block_page_mkwrite() it has to
provide freezing protection on it's own.

CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 848f436..fbe998b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4733,11 +4733,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	get_block_t *get_block;
 	int retries = 0;
 
-	/*
-	 * This check is racy but catches the common case. We rely on
-	 * __block_page_mkwrite() to do a reliable check.
-	 */
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_write(inode->i_sb);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
@@ -4805,5 +4801,6 @@ retry_alloc:
 out_ret:
 	ret = block_page_mkwrite_return(ret);
 out:
+	sb_end_write(inode->i_sb);
 	return ret;
 }
-- 
1.7.1

