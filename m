From: Greg KH <gregkh@suse.de>
Subject: [patch 095/104] ext4: wait on all pending commits in ext4_sync_fs()
Date: Wed, 3 Dec 2008 11:56:40 -0800
Message-ID: <20081203195640.GR8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Arthur Jones <ajones@riverbed.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56751 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756108AbYLCT6B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:58:01 -0500
Content-Disposition: inline; filename="ext4-wait-on-all-pending-commits-in-ext4_sync_fs.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 14ce0cb411c88681ab8f3a4c9caa7f42e97a3184)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2920,12 +2920,9 @@ int ext4_force_commit(struct super_block
 /*
  * Ext4 always journals updates to the superblock itself, so we don't
  * have to propagate any other updates to the superblock on disk at this
- * point.  Just start an async writeback to get the buffers on their way
- * to the disk.
- *
- * This implicitly triggers the writebehind on sync().
+ * point.  (We can probably nuke this function altogether, and remove
+ * any mention to sb->s_dirt in all of fs/ext4; eventual cleanup...)
  */
-
 static void ext4_write_super(struct super_block *sb)
 {
 	if (mutex_trylock(&sb->s_lock) != 0)
@@ -2935,14 +2932,14 @@ static void ext4_write_super(struct supe
 
 static int ext4_sync_fs(struct super_block *sb, int wait)
 {
-	tid_t target;
+	int ret = 0;
 
 	sb->s_dirt = 0;
-	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
-		if (wait)
-			jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
-	}
-	return 0;
+	if (wait)
+		ret = ext4_force_commit(sb);
+	else
+		jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
+	return ret;
 }
 
 /*

