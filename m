From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] ext4: fix freeze deadlock under IO
Date: Wed, 23 Jun 2010 14:37:27 -0500
Message-ID: <4C226277.4060505@sandeen.net>
References: <4C1A2839.5010407@cfl.rr.com> <20100617142731.GA10071@redhat.com> <4C1A4A74.9070105@cfl.rr.com> <20100617162747.GA21336@redhat.com> <4C1ACBF1.3050603@cfl.rr.com> <4C1BC125.4090902@sandeen.net> <4C1BC6D0.2030203@sandeen.net> <4C1BC7AD.1060900@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mike Snitzer <snitzer@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Dave Chinner <dchinner@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C1BC7AD.1060900@sandeen.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit 6b0310fbf087ad6 caused a regression resulting in deadlocks
when freezing a filesystem which had active IO; the vfs_check_frozen
level (SB_FREEZE_WRITE) did not let the freeze-related IO syncing
through.  Duh.

Changing the test to FREEZE_TRANS should let the normal freeze
syncing get through the fs, but still block any transactions from
starting once the fs is completely frozen.

I tested this by running fsstress in the background while periodically
snapshotting the fs and running fsck on the result.  I ran into
occasional deadlocks, but different ones.  I think this is a
fine fix for the problem at hand, and the other deadlocky things
will need more investigation.

Reported-by: Phillip Susi <psusi@cfl.rr.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e8983a..a45ced9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -241,7 +241,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);
 
-	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+	vfs_check_frozen(sb, SB_FREEZE_TRANS);
 	/* Special case here: if the journal has aborted behind our
 	 * backs (eg. EIO in the commit thread), then we still need to
 	 * take the FS itself readonly cleanly. */
@@ -3491,7 +3491,7 @@ int ext4_force_commit(struct super_block *sb)
 
 	journal = EXT4_SB(sb)->s_journal;
 	if (journal) {
-		vfs_check_frozen(sb, SB_FREEZE_WRITE);
+		vfs_check_frozen(sb, SB_FREEZE_TRANS);
 		ret = ext4_journal_force_commit(journal);
 	}
 

