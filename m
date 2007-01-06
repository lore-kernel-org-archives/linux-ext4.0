From: chrisw@sous-sol.org
Subject: patch handle-ext3-directory-corruption-better.patch queued to 2.6.19-stable tree
Date: Fri, 05 Jan 2007 17:03:09 -0800
Message-ID: <200701060103.l0613A3j031443@sous-sol.org>
References: <4596F49F.4080406@gentoo.org>
Cc: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53456 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbXAFB0Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jan 2007 20:26:25 -0500
To: dsd@gentoo.org, akpm@osdl.org, chrisw@sous-sol.org,
	linux-ext4@vger.kernel.org, sandeen@redhat.com, torvalds@osdl.org
In-Reply-To: <4596F49F.4080406@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: handle ext3 directory corruption better (CVE-2006-6053) Subject: [PATCH] handle ext3 directory corruption better

to the 2.6.19-stable tree.  Its filename is

     handle-ext3-directory-corruption-better.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org  Sat Dec 30 15:27:45 2006
Message-ID: <4596F49F.4080406@gentoo.org>
Date: Sat, 30 Dec 2006 18:22:07 -0500
From: Daniel Drake <dsd@gentoo.org>
To: stable@kernel.org
Cc: sandeen@redhat.com
Subject: handle ext3 directory corruption better (CVE-2006-6053)

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
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
Date: Thu, 7 Dec 2006 04:36:26 +0000 (-0800)
Subject: [PATCH] handle ext3 directory corruption better
X-Git-Tag: v2.6.20-rc1
X-Git-Url: http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=40b851348fe9bf49c26025b34261d25142269b60

 fs/ext3/dir.c   |    3 +++
 fs/ext3/namei.c |    9 +++++++++
 2 files changed, 12 insertions(+)

--- linux-2.6.19.1.orig/fs/ext3/dir.c
+++ linux-2.6.19.1/fs/ext3/dir.c
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
--- linux-2.6.19.1.orig/fs/ext3/namei.c
+++ linux-2.6.19.1/fs/ext3/namei.c
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


Patches currently in stable-queue which might be from dsd@gentoo.org are

queue-2.6.19/zd1211rw-call-ieee80211_rx-in-tasklet.patch
queue-2.6.19/kbuild-don-t-put-temp-files-in-source.patch
queue-2.6.19/ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry.patch
queue-2.6.19/softmac-fixed-handling-of-deassociation-from-ap.patch
queue-2.6.19/corrupted-cramfs-filesystems-cause-kernel-oops.patch
queue-2.6.19/libata-handle-0xff-status-properly.patch
queue-2.6.19/handle-ext3-directory-corruption-better.patch
queue-2.6.19/ieee1394-ohci1394-add-ppc_pmac-platform-code-to-driver-probe.patch
queue-2.6.19/revert-zd1211rw-removed-unneeded-packed-attributes.patch
queue-2.6.19/ieee80211softmac-fix-mutex_lock-at-exit-of-ieee80211_softmac_get_genie.patch
