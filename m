From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/34] misc: zero s_jnl_blocks when adding journal online or
 removing external journal
Date: Sat, 13 Sep 2014 15:11:32 -0700
Message-ID: <20140913221132.13646.78435.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, thomas_reardon@hotmail.com
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24232 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaIMWLh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:11:37 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Erase s_jnl_blocks when removing an external journal, or adding an
internal journal online.  We can't add the backup for the internal
journal because we have no good way to get the indirect block or ETB
addresses, so the best we can do is hope that the user runs e2fsck,
which will correct that.  We are motivated to erase during external
journal removal to state emphatically that there's no journal.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: thomas_reardon@hotmail.com
---
 lib/ext2fs/mkjournal.c |    2 ++
 misc/tune2fs.c         |    1 +
 2 files changed, 3 insertions(+)


diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 0a7cd18..6f3a862 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -585,6 +585,8 @@ errcode_t ext2fs_add_journal_inode2(ext2_filsys fs, blk_t num_blocks,
 			goto errout;
 		}
 		journal_ino = st.st_ino;
+		memset(fs->super->s_jnl_blocks, 0,
+		       sizeof(fs->super->s_jnl_blocks));
 	} else {
 		if ((mount_flags & EXT2_MF_BUSY) &&
 		    !(fs->flags & EXT2_FLAG_EXCLUSIVE)) {
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 80debe7..510e936 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -308,6 +308,7 @@ no_valid_journal:
 		return 1;
 	}
 	fs->super->s_journal_dev = 0;
+	memset(fs->super->s_jnl_blocks, 0, sizeof(fs->super->s_jnl_blocks));
 	uuid_clear(fs->super->s_journal_uuid);
 	ext2fs_mark_super_dirty(fs);
 	fputs(_("Journal removed\n"), stdout);

