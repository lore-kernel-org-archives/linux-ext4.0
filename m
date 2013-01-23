From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext4: Fix possible use-after-free with AIO
Date: Wed, 23 Jan 2013 13:56:17 +0100
Message-ID: <1358945780-23661-2-git-send-email-jack@suse.cz>
References: <1358945780-23661-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, bpm@sgi.com, jlbec@evilplan.org,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1358945780-23661-1-git-send-email-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

CC: linux-ext4@vger.kernel.org
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c   |    2 +-
 fs/ext4/page-io.c |    9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cbfe13b..ba06638 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2977,9 +2977,9 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
 		ext4_free_io_end(io_end);
 out:
+		inode_dio_done(inode);
 		if (is_async)
 			aio_complete(iocb, ret, 0);
-		inode_dio_done(inode);
 		return;
 	}
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 0016fbc..b42d04f 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -103,14 +103,13 @@ static int ext4_end_io(ext4_io_end_t *io)
 			 "(inode %lu, offset %llu, size %zd, error %d)",
 			 inode->i_ino, offset, size, ret);
 	}
-	if (io->iocb)
-		aio_complete(io->iocb, io->result, 0);
-
-	if (io->flag & EXT4_IO_END_DIRECT)
-		inode_dio_done(inode);
 	/* Wake up anyone waiting on unwritten extent conversion */
 	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
 		wake_up_all(ext4_ioend_wq(inode));
+	if (io->flag & EXT4_IO_END_DIRECT)
+		inode_dio_done(inode);
+	if (io->iocb)
+		aio_complete(io->iocb, io->result, 0);
 	return ret;
 }
 
-- 
1.7.1
