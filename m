From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: enable cache flush in ext3_sync_file
Date: Tue, 8 Sep 2009 15:04:38 +0200
Message-ID: <20090908130438.GA2528@atrey.karlin.mff.cuni.cz>
References: <20090831193712.GB2672@lst.de> <4A9D66C5.4060806@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55251 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZIHNEg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 09:04:36 -0400
Content-Disposition: inline
In-Reply-To: <4A9D66C5.4060806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Christoph Hellwig wrote:
> > We need to flush the write cache unconditionally in ->fsync, otherwise
> > writes into already allocated blocks can get lost.  Writes into fully
> > allocated files are very common when using disk images for
> > virtualization, and without this fix can easily lose data after
> > an fdatasync, which is the typical implementation for a cache flush on
> > the virtual drive.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Given that I tried to do the same thing 1.5 years ago (though not quite
> correctly) ...
> 
> Acked-by: Eric Sandeen <sandeen@redhat.com>
  But would the patch below be better? When we force a transaction
commit we don't have to flush caches again. Or am I missing something?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--0OAP2g/MAC+5xKAE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext3-Flush-disk-caches-on-fsync-when-needed.patch"

>From 4412c3d5cc04849d959e9083d3bdf0b4a058e947 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 8 Sep 2009 14:59:42 +0200
Subject: [PATCH] ext3: Flush disk caches on fsync when needed

In case we fsync() a file and inode is not dirty, we don't force a transaction
to disk and hence don't flush disk caches. Thus file data could be just in disk
caches and not on persistent storage. Fix the problem by flushing disk caches
if we didn't force a transaction commit.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/fsync.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index d336341..451d166 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/blkdev.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/writeback.h>
@@ -73,7 +74,7 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 	}
 
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		goto out;
+		goto flush;
 
 	/*
 	 * The VFS has written the file data.  If the inode is unaltered
@@ -85,7 +86,16 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
 		ret = sync_inode(inode, &wbc);
+		goto out;
 	}
+flush:
+	/*
+	 * In case we didn't commit a transaction, we have to flush
+	 * disk caches manually so that data really is on persistent
+	 * storage
+	 */
+	if (test_opt(inode->i_sb, BARRIER))
+		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 out:
 	return ret;
 }
-- 
1.6.0.2


--0OAP2g/MAC+5xKAE--
