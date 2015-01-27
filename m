From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 46/54] contrib: script to create minified ext4 image from a
 directory
Date: Mon, 26 Jan 2015 23:40:35 -0800
Message-ID: <20150127074035.13308.79172.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47857 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbbA0Hkk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:40:40 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The dir2fs script converts a directory into a minimized ext4 filesystem.
FS creation parameters are tweaked to reduce as much FS overhead as
possible, and to leave as few unused blocks and inodes as possible.
Given that mke2fs -d lays out files linearly from the beginning of the
FS, using resize2fs -M is not as horrible as it usually is.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 contrib/dir2fs |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100755 contrib/dir2fs


diff --git a/contrib/dir2fs b/contrib/dir2fs
new file mode 100755
index 0000000..abcecb3
--- /dev/null
+++ b/contrib/dir2fs
@@ -0,0 +1,66 @@
+#!/bin/sh
+
+dir="$1"
+dev="$2"
+
+if [ "$1" = "--help" ] || [ ! -d "${dir}" ]; then
+	echo "Usage: $0 dir [mke2fs args] dev"
+	exit 1
+fi
+
+shift
+
+# Goal: Put all the files at the beginning (which mke2fs does) and minimize
+# the number of free inodes given the minimum number of blocks required.
+# Hence all this math to get the inode ratio just right.
+
+bytes="$(du -ks "${dir}" | awk '{print $1}')"
+bytes="$((bytes * 1024))"
+inodes="$(find "${dir}" -print0 | xargs -0 stat -c '%i' | sort -g | uniq | wc -l)"
+block_sz=4096
+inode_sz=256
+sb_overhead=4096
+blocks_per_group="$((block_sz * 8))"
+bytes_per_group="$((blocks_per_group * block_sz))"
+inode_bytes="$((inodes * inode_sz))"
+
+# Estimate overhead with the minimum number of groups...
+nr_groups="$(( (bytes + inode_bytes + bytes_per_group - 1) / bytes_per_group))"
+inode_bytes_per_group="$((inode_bytes / nr_groups))"
+inode_blocks_per_group="$(( (inode_bytes_per_group + (block_sz - 1)) / block_sz ))"
+per_grp_overhead="$(( ((3 + inode_blocks_per_group) * block_sz) + 64 ))"
+overhead="$(( sb_overhead + (per_grp_overhead * nr_groups) ))"
+used_bytes="$((bytes + overhead))"
+
+# Then do it again with the real number of groups.
+nr_groups="$(( (used_bytes + (bytes_per_group - 1)) / bytes_per_group))"
+tot_blocks="$((nr_groups * blocks_per_group))"
+tot_bytes="$((tot_blocks * block_sz))"
+
+ratio="$((bytes / inodes))"
+mkfs_blocks="$((tot_blocks * 4 / 3))"
+
+mke2fs -i "${ratio}" -T ext4 -d "${dir}" -O ^resize_inode,sparse_super2,metadata_csum,64bit,^has_journal -E packed_meta_blocks=1,num_backup_sb=0 -b "${block_sz}" -I "${inodesz}" -F "${dev}" "${mkfs_blocks}" || exit
+
+e2fsck -fyD "${dev}"
+
+blocks="$(dumpe2fs -h "${dev}" 2>&1 | grep 'Block count:' | awk '{print $3}')"
+while resize2fs -f -M "${dev}"; do
+	new_blocks="$(dumpe2fs -h "${dev}" 2>&1 | grep 'Block count:' | awk '{print $3}')"
+	if [ "${new_blocks}" -eq "${blocks}" ]; then
+		break;
+	fi
+	blocks="${new_blocks}"
+done
+
+if [ ! -b "${dev}" ]; then
+    truncate -s "$((blocks * block_sz))" "${dev}" || (e2image -ar "${dev}" "${dev}.min"; mv "${dev}.min" "${dev}")
+fi
+
+e2fsck -fy "${dev}"
+
+dir_blocks="$((bytes / block_sz))"
+overhead="$((blocks - dir_blocks))"
+echo "Minimized image overhead: $((100 * overhead / dir_blocks))%"
+
+exit 0

