From: akpm@osdl.org
Subject: [patch 160/354] handle ext3 directory corruption better
Date: Wed, 06 Dec 2006 20:36:26 -0800
Message-ID: <200612070436.kB74aQg1029465@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, sandeen@redhat.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46782 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968743AbWLGEgh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:36:37 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

I've been using Steve Grubb's purely evil "fsfuzzer" tool, at
http://people.redhat.com/sgrubb/files/fsfuzzer-0.4.tar.gz

Basically it makes a filesystem, splats some random bits over it, then
tries to mount it and do some simple filesystem actions.

At best, the filesystem catches the corruption gracefully.  At worst,
things spin out of control.

As you might guess, we found a couple places in ext3 where things spin out
of control :)

First, we had a corrupted directory that was never checked for
consistency...  it was corrupt, and pointed to another bad "entry" of
length 0.  The for() loop looped forever, since the length of
ext3_next_entry(de) was 0, and we kept looking at the same pointer over and
over and over and over...  I modeled this check and subsequent action on
what is done for other directory types in ext3_readdir...

(adding this check adds some computational expense; I am testing a followup
patch to reduce the number of times we check and re-check these directory
entries, in all cases.  Thanks for the idea, Andreas).

Next we had a root directory inode which had a corrupted size, claimed to
be > 200M on a 4M filesystem.  There was only really 1 block in the
directory, but because the size was so large, readdir kept coming back for
more, spewing thousands of printk's along the way.

Per Andreas' suggestion, if we're in this read error condition and we're
trying to read an offset which is greater than i_blocks worth of bytes,
stop trying, and break out of the loop.

With these two changes fsfuzz test survives quite well on ext3.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/dir.c   |    3 +++
 fs/ext3/namei.c |    9 +++++++++
 2 files changed, 12 insertions(+)

diff -puN fs/ext3/dir.c~handle-ext3-directory-corruption-better fs/ext3/dir.c
--- a/fs/ext3/dir.c~handle-ext3-directory-corruption-better
+++ a/fs/ext3/dir.c
@@ -154,6 +154,9 @@ static int ext3_readdir(struct file * fi
 			ext3_error (sb, "ext3_readdir",
 				"directory #%lu contains a hole at offset %lu",
 				inode->i_ino, (unsigned long)filp->f_pos);
+			/* corrupt size?  Maybe no more blocks to read */
+			if (filp->f_pos > inode->i_blocks << 9)
+				break;
 			filp->f_pos += sb->s_blocksize - offset;
 			continue;
 		}
diff -puN fs/ext3/namei.c~handle-ext3-directory-corruption-better fs/ext3/namei.c
--- a/fs/ext3/namei.c~handle-ext3-directory-corruption-better
+++ a/fs/ext3/namei.c
@@ -552,6 +552,15 @@ static int htree_dirblock_to_tree(struct
 					   dir->i_sb->s_blocksize -
 					   EXT3_DIR_REC_LEN(0));
 	for (; de < top; de = ext3_next_entry(de)) {
+		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
+					(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
+						+((char *)de - bh->b_data))) {
+			/* On error, skip the f_pos to the next block. */
+			dir_file->f_pos = (dir_file->f_pos |
+					(dir->i_sb->s_blocksize - 1)) + 1;
+			brelse (bh);
+			return count;
+		}
 		ext3fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
 		    ((hinfo->hash == start_hash) &&
_
