From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH v3] direct-io: fix direct write stale data exposure from concurrent buffered read
Date: Sat, 14 May 2016 00:25:28 +0800
Message-ID: <1463156728-13357-1-git-send-email-guaneryu@gmail.com>
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com,
	viro@ZenIV.linux.org.uk, Eryu Guan <guaneryu@gmail.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently direct writes inside i_size on a DIO_SKIP_HOLES filesystem are
not allowed to allocate blocks(get_more_blocks() sets 'create' to 0
before calling get_block() callback), if it's a sparse file, direct
writes fall back to buffered writes to avoid stale data exposure from
concurrent buffered read. But there're two cases that can result in
stale data exposure are not correctly detected.

1. The detection for "writing inside i_size" is not sufficient, writes
can be treated as "extending writes" wrongly. For example, direct write
1FSB to a 1FSB sparse file on ext2/3/4, starting from offset 0, in this
case it's writing inside i_size, but 'create' is non-zero, because
'block_in_file' and '(i_size_read(inode) >> blkbits' are both zero.

2. Direct writes starting from or beyong i_size (not inside i_size) also
could trigger block allocation and expose stale data. For example,
consider a sparse file with i_size of 2k, and a write to offset 2k or 3k
into the file, with a filesystem block size of 4k. (Thanks to Jeff Moyer
for pointing this case out in his review.)

The first problem can be demostrated by running ltp-aiodio test ADSP045
many times. When testing on extN filesystems, I see test failures
occasionally, buffered read could read non-zero (stale) data.

ADSP045: dio_sparse -a 4k -w 4k -s 2k -n 1

dio_sparse    0  TINFO  :  Dirtying free blocks
dio_sparse    0  TINFO  :  Starting I/O tests
non zero buffer at buf[0] => 0xffffffaa,ffffffaa,ffffffaa,ffffffaa
non-zero read at offset 0
dio_sparse    0  TINFO  :  Killing childrens(s)
dio_sparse    1  TFAIL  :  dio_sparse.c:191: 1 children(s) exited abnormally

The second problem can also be reproduced easily by a hacked dio_sparse
program, which accepts an option to specify the write offset.

What we should really do is to disable block allocation for writes that
could result in filling holes inside i_size.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

v3:
- Kill unnecessary cleanup patch
- Update comments a bit accordingly

v2:
- Fix the case Jeff pointed out as well
- Update commit log

 fs/direct-io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 4720377..62921ce 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -627,11 +627,11 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 		map_bh->b_size = fs_count << i_blkbits;
 
 		/*
-		 * For writes inside i_size on a DIO_SKIP_HOLES filesystem we
-		 * forbid block creations: only overwrites are permitted.
-		 * We will return early to the caller once we see an
-		 * unmapped buffer head returned, and the caller will fall
-		 * back to buffered I/O.
+		 * For writes that could fill holes inside i_size on a
+		 * DIO_SKIP_HOLES filesystem we forbid block creations: only
+		 * overwrites are permitted. We will return early to the caller
+		 * once we see an unmapped buffer head returned, and the caller
+		 * will fall back to buffered I/O.
 		 *
 		 * Otherwise the decision is left to the get_blocks method,
 		 * which may decide to handle it or also return an unmapped
@@ -639,8 +639,8 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 		 */
 		create = dio->rw & WRITE;
 		if (dio->flags & DIO_SKIP_HOLES) {
-			if (sdio->block_in_file < (i_size_read(dio->inode) >>
-							sdio->blkbits))
+			if (fs_startblk <= ((i_size_read(dio->inode) - 1) >>
+							i_blkbits))
 				create = 0;
 		}
 
-- 
2.5.5

