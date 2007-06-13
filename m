From: Mingming Cao <cmm@us.ibm.com>
Subject: ext4 patch queue updated
Date: Wed, 13 Jun 2007 13:20:59 -0700
Message-ID: <1181766059.3887.22.camel@dyn9047017103.beaverton.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-2dbl5D2SkVEIMjkRrwgm"
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, "Jose R. Santos" <jrs@us.ibm.com>,
	alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:53408 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbXFMUVX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2007 16:21:23 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5DKLKvm005714
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2007 16:21:20 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5DKLC8w237750
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2007 14:21:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5DKL68w020917
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2007 14:21:12 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-2dbl5D2SkVEIMjkRrwgm
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Just updated the ext4 patch queue

http://repo.or.cz/w/ext4-patch-queue

Changes:

Added these three patches from Jose Santos:
ext4_set_jbd2_64bit_feature.patch
jbd2_config_jbd2_debug_fix.patch
jbd2_move_jbd2_debug_to_debugfs.patch

Reordered the series, move 
jbd-stats-through-procfs and ext4_remove_subdirs_limit.patch before
delayed allocation patches


Run checkpatch.pl http://lwn.net/Articles/237451/
I fixed coding style issues for most patches by hand except the delayed
allocation patch ext4-delayed-allocation.patch.  That need a bit more
work and requires someone family with the code better. Alex, can you
help on this? Attached is the checkpatch.pl output, thanks.


Mingming



--=-2dbl5D2SkVEIMjkRrwgm
Content-Disposition: attachment; filename=a.out
Content-Type: text/plain; name=a.out; charset=UTF-8
Content-Transfer-Encoding: 7bit

printk() should include KERN_ facility level
#275: FILE: fs/ext4/writeback.c:73:
+#define wb_debug(fmt, a...)	printk(fmt, ##a);

do not use assignment in condition
#338: FILE: fs/ext4/writeback.c:136:
+		while (!bio && (nr_vecs /= 2))

printk() should include KERN_ facility level
#826: FILE: fs/ext4/writeback.c:624:
+			printk("no mem for ext4_wb_pages!\n");

#if 0 -- if this code redundant remove it
#946: FILE: fs/ext4/writeback.c:744:
+#if 0

line over 80 characters
#948: FILE: fs/ext4/writeback.c:746:
+					printk("#%u: wow! short extent %d for flush on #%lu\n",

printk() should include KERN_ facility level
#948: FILE: fs/ext4/writeback.c:746:
+					printk("#%u: wow! short extent %d for flush on #%lu\n",

line over 80 characters
#949: FILE: fs/ext4/writeback.c:747:
+						(unsigned) current->pid, wc.len, inode->i_ino);

line over 80 characters
#950: FILE: fs/ext4/writeback.c:748:
+					printk("#%u: done = %d, nr_to_write %ld, sync = %d\n",

printk() should include KERN_ facility level
#950: FILE: fs/ext4/writeback.c:748:
+					printk("#%u: done = %d, nr_to_write %ld, sync = %d\n",

line over 80 characters
#951: FILE: fs/ext4/writeback.c:749:
+						(unsigned) current->pid, done, wbc->nr_to_write,

printk() should include KERN_ facility level
#953: FILE: fs/ext4/writeback.c:751:
+					printk("#%u: written %d, extents %d\n",

line over 80 characters
#954: FILE: fs/ext4/writeback.c:752:
+						(unsigned) current->pid, written, extents);

printk() should include KERN_ facility level
#955: FILE: fs/ext4/writeback.c:753:
+					printk("#%u: cur %lu, prev %lu\n",

#if 0 -- if this code redundant remove it
#985: FILE: fs/ext4/writeback.c:783:
+#if 0

line over 80 characters
#991: FILE: fs/ext4/writeback.c:789:
+				atomic_inc(&EXT4_SB(inode->i_sb)->s_wb_congested);

printk() should include KERN_ facility level
#1370: FILE: fs/ext4/writeback.c:1168:
+	printk("EXT4-fs: writeback: %d blocks %d extents in %d reqs (%d ave)\n",

line over 80 characters
#1375: FILE: fs/ext4/writeback.c:1173:
+	printk("EXT4-fs: writeback: %d nr_to_write, %d congestions, %d singles\n",

printk() should include KERN_ facility level
#1375: FILE: fs/ext4/writeback.c:1173:
+	printk("EXT4-fs: writeback: %d nr_to_write, %d congestions, %d singles\n",

printk() should include KERN_ facility level
#1379: FILE: fs/ext4/writeback.c:1177:
+	printk("EXT4-fs: writeback: %d collisions, %d single-page collisions\n",

printk() should include KERN_ facility level
#1382: FILE: fs/ext4/writeback.c:1180:
+	printk("EXT4-fs: writeback: %d allocated, %d dropped\n",

Missing Signed-off-by: line(s)
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

--=-2dbl5D2SkVEIMjkRrwgm--
