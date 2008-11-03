From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 17:01:44 -0500
Message-ID: <20081103220144.GD18117@mit.edu>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081103123750.67c96224.akpm@linux-foundation.org> <20081103205854.GC30565@ajones-laptop.nbttech.com> <20081103131313.e9ae2f93.akpm@linux-foundation.org> <20081103211929.GA18117@mit.edu> <20081103132735.9e63a3d0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ajones@riverbed.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53316 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752655AbYKCWB4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 17:01:56 -0500
Content-Disposition: inline
In-Reply-To: <20081103132735.9e63a3d0.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's the ext4 version of the patch.  It's slightly altered from the
ext3 version in that we do reflect the errors up to sync_fs's callers
(which then throw it on the floor, but we might as well take away some
of the fun from all of those academic researchers who like to write
papers complaining about how often Linux doesn't do appropriat eerror
checking :-).

After doing some testing, I plan to carry it in the ext4 patch queue.
I think similar changes should be made to the ext3 version of the
patch; agreed?

						- Ted

commit 8106ea5364c2680a385ed240e8f898611babf661
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Nov 3 17:01:22 2008 -0500

    ext4: wait on all pending commits in ext4_sync_fs()
    
    In ext4_sync_fs, we only wait for a commit to finish if we started it,
    but there may be one already in progress which will not be synced.
    
    In the case of a data=ordered umount with pending long symlinks which
    are delayed due to a long list of other I/O on the backing block
    device, this causes the buffer associated with the long symlinks to
    not be moved to the inode dirty list in the second phase of
    fsync_super.  Then, before they can be dirtied again, kjournald exits,
    seeing the UMOUNT flag and the dirty pages are never written to the
    backing block device, causing long symlink corruption and exposing new
    or previously freed block data to userspace.
    
    To ensure all commits are synced, we flush all journal commits now
    when sync_fs'ing ext4.
    
    Signed-off-by: Arthur Jones <ajones@riverbed.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: Eric Sandeen <sandeen@redhat.com>
    Cc: <linux-ext4@vger.kernel.org>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 97cb896..e199773 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2899,8 +2899,9 @@ int ext4_force_commit(struct super_block *sb)
 		return 0;
 
 	journal = EXT4_SB(sb)->s_journal;
-	sb->s_dirt = 0;
 	ret = ext4_journal_force_commit(journal);
+	if (!ret)
+		sb->s_dirt = 0;
 	return ret;
 }
 
@@ -2922,15 +2923,16 @@ static void ext4_write_super(struct super_block *sb)
 
 static int ext4_sync_fs(struct super_block *sb, int wait)
 {
-	tid_t target;
+	int ret;
 
 	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
-	sb->s_dirt = 0;
-	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
-		if (wait)
-			jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
-	}
-	return 0;
+	if (wait)
+		ret = ext4_force_commit(sb);
+	else
+		ret = jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
+	if (!ret)
+		sb->s_dirt = 0;
+	return ret;
 }
 
 /*
