From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext4: don't read blocks from disk after extents being swapped in move_extent_per_page()
Date: Wed, 10 Feb 2016 23:16:45 +0800
Message-ID: <1455117406-15497-1-git-send-email-guaneryu@gmail.com>
Cc: tytso@mit.edu, Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34250 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbcBJPSK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Feb 2016 10:18:10 -0500
Received: by mail-pf0-f177.google.com with SMTP id x65so13472096pfb.1
        for <linux-ext4@vger.kernel.org>; Wed, 10 Feb 2016 07:18:09 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I notice ext4/307 fails occasionally on ppc64 host, reporting md5
checksum mismatch after moving data from original file to donor file.

The reason is that move_extent_per_page() calls __block_write_begin()
and block_commit_write() to write saved data from original inode blocks
to donor inode blocks, but __block_write_begin() not only maps buffer
heads but also reads block content from disk if the size is not block
size aligned. At this time the physical block number in mapped buffer
head is pointing to the donor file not the original file, and that
results in reading wrong data to page, which get written to disk in
following block_commit_write call.

This also can be reproduced by the following script on 1k block size ext4
on x86_64 host:

    mnt=/mnt/ext4
    donorfile=$mnt/donor
    testfile=$mnt/testfile
    e4compact=~/xfstests/src/e4compact

    rm -f $donorfile $testfile

    # reserve space for donor file, written by 0xaa and sync to disk to
    # avoid EBUSY on EXT4_IOC_MOVE_EXT
    xfs_io -fc "pwrite -S 0xaa 0 1m" -c "fsync" $donorfile

    # create test file written by 0xbb
    xfs_io -fc "pwrite -S 0xbb 0 1023" -c "fsync" $testfile

    # compute initial md5sum
    md5sum $testfile | tee md5sum.txt
    # drop cache, force e4compact to read data from disk
    echo 3 > /proc/sys/vm/drop_caches

    # test defrag
    echo "$testfile" | $e4compact -i -v -f $donorfile
    # check md5sum
    md5sum -c md5sum.txt

Fix it by creating & mapping buffer heads only but not reading blocks
from disk, because all the data in page is guaranteed to be up-to-date
in mext_page_mkuptodate().

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

I tested this patch with ext4/307 and my reproducer more than 100 times on
x86_64 and ppc64 hosts, also survived ext4 4k/2k/1k xfstests on both x86_64 and
ppc64 host.

 fs/ext4/move_extent.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index fb6f117..e032a04 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -265,11 +265,12 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	ext4_lblk_t orig_blk_offset, donor_blk_offset;
 	unsigned long blocksize = orig_inode->i_sb->s_blocksize;
 	unsigned int tmp_data_size, data_size, replaced_size;
-	int err2, jblocks, retries = 0;
+	int i, err2, jblocks, retries = 0;
 	int replaced_count = 0;
 	int from = data_offset_in_page << orig_inode->i_blkbits;
 	int blocks_per_page = PAGE_CACHE_SIZE >> orig_inode->i_blkbits;
 	struct super_block *sb = orig_inode->i_sb;
+	struct buffer_head *bh = NULL;
 
 	/*
 	 * It needs twice the amount of ordinary journal buffers because
@@ -380,8 +381,16 @@ data_copy:
 	}
 	/* Perform all necessary steps similar write_begin()/write_end()
 	 * but keeping in mind that i_size will not change */
-	*err = __block_write_begin(pagep[0], from, replaced_size,
-				   ext4_get_block);
+	if (!page_has_buffers(pagep[0]))
+		create_empty_buffers(pagep[0], 1 << orig_inode->i_blkbits, 0);
+	bh = page_buffers(pagep[0]);
+	for (i = 0; i < data_offset_in_page; i++)
+		bh = bh->b_this_page;
+	for (i = 0; i < block_len_in_page; i++) {
+		*err = ext4_get_block(orig_inode, orig_blk_offset + i, bh, 0);
+		if (*err < 0)
+			break;
+	}
 	if (!*err)
 		*err = block_commit_write(pagep[0], from, from + replaced_size);
 
-- 
2.5.0

