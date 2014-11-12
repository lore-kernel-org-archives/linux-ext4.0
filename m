From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v2 3/3] e2fsprogs/tune2fs: fix memory write overflow
Date: Wed, 12 Nov 2014 17:49:40 +0800
Message-ID: <1415785780-3832-3-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <1415785780-3832-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <darrick.wong@oracle.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57573 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751679AbaKLJxJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2014 04:53:09 -0500
In-Reply-To: <1415785780-3832-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we apply this patch 'e2fsprogs/tune2fs: rewrite metadata checksums when resizing inode size',
we will trigger a segfault, this is because of the inode cache issues.

Firstly we should notice that in expand_inode_table(), we have change the super block's s_inode_size
to new inode size(for example, 256).

Then we re-compute metadata checksums, see below code flow:
|-->rewrite_metadata_checksums
|----->rewrite_inodes
|-------->ext2fs_write_inode_full
In ext2fs_write_inode_full(), if an inode cache is hit, the below code will be executed:
	/* Check to see if the inode cache needs to be updated */
	if (fs->icache) {
		for (i=0; i < fs->icache->cache_size; i++) {
			if (fs->icache->cache[i].ino == ino) {
				memcpy(fs->icache->cache[i].inode, inode,
				       (bufsize > length) ? length : bufsize);
				break;
			}
		}
	}

Before executing rewrite_inodes(), actually the inode in inode cache is allocated by
old inode size(for example, 128), but here the memcpy will obviously write overflow,
'(bufsize > length) ? length : bufsize' here will return 256(new inode size), so this is
wrong, we need to fix this.
I think we should call ext2fs_free_inode_cache() in expand_inode_table(), to drop the
inode cache, because inode size has changed, if necessary, we will re-create this inode cache.

Steps to reproduce this bug(apply 'e2fsprogs/tune2fs: rewrite metadata checksums when resizing inode size' first).
	dd if=/dev/zero of=file.img bs=1M count=128
	device_name=$(/sbin/losetup -f)
	/sbin/losetup -f file.img
	mkfs.ext4 -I 128 -O ^flex_bg $device_name
	tune2fs -I 256 $device_name

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 misc/tune2fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 91dc7c1..34d2cd9 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2244,6 +2244,8 @@ static int expand_inode_table(ext2_filsys fs, unsigned long new_ino_size)
 
 	/* Update the meta data */
 	fs->inode_blocks_per_group = new_ino_blks_per_grp;
+	ext2fs_free_inode_cache(fs->icache);
+	fs->icache = 0;
 	fs->super->s_inode_size = new_ino_size;
 
 err_out:
-- 
1.8.2.1

