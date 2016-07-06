From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] weirdness in ext4_sync_file()
Date: Wed, 6 Jul 2016 14:00:49 +0200
Message-ID: <20160706120049.GI14067@quack2.suse.cz>
References: <20160624043604.GU14480@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160624043604.GU14480@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 24-06-16 05:36:05, Al Viro wrote:
> Could somebody explain when would the second part of that test _not_ be true?
> 
>                 if (!ret && !hlist_empty(&inode->i_dentry))
>                         ret = ext4_sync_parent(inode);
> 
> inode is that of an opened file; how could it possibly _not_ have a dentry
> alias?  Is that code actually supposed to check if the sucker is not
> unlinked?

Yes, that's what the test was supposed to do I believe.

> If so, it's not what we are actually checking - pinned dentry remains
> positive (and unhashed) after unlink(2).  What's more, the loop in
> ext4_sync_parent() is vulnerable to races with rmdir(2) - if you get
> unlink and rmdir of ancestors between
>
>                 next = igrab(d_inode(dentry->d_parent));
> and
>                 inode = next;
>                 ret = sync_mapping_buffers(inode->i_mapping);
>                 if (ret)
>                         break;
>                 ret = sync_inode_metadata(inode, 1);
>                 if (ret)
>                         break;
> you are risking interesting things done in the middle of rmdir and/or
> unlink; that might be actually safe, but in that case it's worth a comment
> explaining that.

You are right and it should be harmless. I'm now testing the patch below.
Thanks for your comments.

>From 3dbea3e4e58d9ad81f38e8f89f9f569daef5a800 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 6 Jul 2016 13:55:58 +0200
Subject: [PATCH] ext4: Cleanup ext4_sync_parent()

A condition !hlist_empty(&inode->i_dentry) is always true for open file.
Just remove it. Also ext4_sync_parent() could use some explanation why
races with rmdir() are not an issue - add a comment explaining that.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/fsync.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 8850254136ae..9b9335796fbc 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -61,6 +61,13 @@ static int ext4_sync_parent(struct inode *inode)
 			break;
 		iput(inode);
 		inode = next;
+		/*
+		 * The directory inode may have gone through rmdir by now. But
+		 * the inode itself and its blocks are still allocated (we hold
+		 * a reference to the inode so it didn't go through
+		 * ext4_evict_inode()) and so we are safe to flush metadata
+		 * blocks and the inode.
+		 */
 		ret = sync_mapping_buffers(inode->i_mapping);
 		if (ret)
 			break;
@@ -107,7 +114,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!journal) {
 		ret = generic_file_fsync(file, start, end, datasync);
-		if (!ret && !hlist_empty(&inode->i_dentry))
+		if (!ret)
 			ret = ext4_sync_parent(inode);
 		goto out;
 	}
-- 
2.6.6



-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
