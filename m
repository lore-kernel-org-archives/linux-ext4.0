From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH/RFC] - make ext3 more robust in the face of filesystem corruption
Date: Wed, 18 Oct 2006 16:11:05 -0500
Message-ID: <45369869.60400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:6063 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751510AbWJRVLH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 17:11:07 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k9ILB6CP020863
	for <linux-ext4@vger.kernel.org>; Wed, 18 Oct 2006 17:11:06 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id k9ILB6Mm015370
	for <linux-ext4@vger.kernel.org>; Wed, 18 Oct 2006 17:11:06 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id k9ILB5on009017
	for <linux-ext4@vger.kernel.org>; Wed, 18 Oct 2006 17:11:05 -0400
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've been using Steve Grubb's purely evil "fsfuzzer" tool, at
http://people.redhat.com/sgrubb/files/fsfuzzer-0.4.tar.gz

basically it makes a filesystem, splats some random bits over it,
then tries to mount it and do some simple filesystem actions.

At best, the filesystem catches the corruption gracefully.
At worst, things spin out of control.

As you might guess, we found a couple places where things spin 
out of control :)  2, to be exact.

First, we had a corrupted index directory that was never checked
for consistency... it was corrupt, and pointed to another "entry"
of length 0.  The for() loop looped forever, since the length
of ext3_next_entry(de) was 0, and we kept looking at the same
pointer over and over and over and over... I modeled this check
and subsequent action on what is done for non-index directories
in ext3_readdir... but I also see a few places where this check
is deemed "too expensive" - any thoughts?

(also I'm not sure if "offset" is supposed to be offset in the
filesystem, or offset in the block, I think it's called both
ways...)

Index: linux-2.6.18/fs/ext3/namei.c
===================================================================
--- linux-2.6.18.orig/fs/ext3/namei.c
+++ linux-2.6.18/fs/ext3/namei.c
@@ -551,6 +551,15 @@ static int htree_dirblock_to_tree(struct
 					   dir->i_sb->s_blocksize -
 					   EXT3_DIR_REC_LEN(0));
 	for (; de < top; de = ext3_next_entry(de)) {
+		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
+					(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
+						+((char *)de - bh->b_data))) {
+			/* On error, skip the f_pos to the next block. */
+			dir_file->f_pos = (dir_file->f_pos | 
+					(dir_file->i_sb->s_blocksize - 1)) + 1;
+			brelse (bh);
+			return count;
+		}
 		ext3fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
 		    ((hinfo->hash == start_hash) &&

Next we had a root directory inode which had a corrupted size, claimed
to be > 200M on a 4M filesystem.  ext3_get_blocks_handle() was returning 0,
meaning that lookup failed.  (there was only really 1 block in the directory, 
but because the size was so large, readdir kept coming back for more...)

instead of catching the no-block-at-this-offset error, we fell into the
!bh case, which assumed that there had been an IO error, and kept on trying
200M+ of blocks that didn't exist.  I -think- it makes more sense to realize
that if ext3_get_blocks_handle returns 0, there is a hole at this location,
(as described by the on-disk metadata) and something has gone wrong.

Index: linux-2.6.18/fs/ext3/dir.c
===================================================================
--- linux-2.6.18.orig/fs/ext3/dir.c
+++ linux-2.6.18/fs/ext3/dir.c
@@ -141,6 +141,11 @@ static int ext3_readdir(struct file * fi
 					(PAGE_CACHE_SHIFT - inode->i_blkbits),
 				1);
 			bh = ext3_bread(NULL, inode, blk, 0, &err);
+		} else {
+			ext3_error(sb, "ext3_readdir",
+			 "directory #%lu block %lu lookup failed, corrupt dir",
+			 	inode->i_ino, blk);
+                        return -EINVAL;
 		}
 
 		/*

I'm not so sure about this one, though - seems like maybe also it should test
for an actual error case (< 0) from ext3_get_blocks_handle as well.

Comments?

Thanks,

-Eric
