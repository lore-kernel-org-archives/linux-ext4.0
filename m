From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] ext4: fix race in xattr block allocation path
Date: Mon, 24 Oct 2011 17:30:26 -0500
Message-ID: <4EA5E702.8030303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab1JXWa3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Oct 2011 18:30:29 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p9OMUS7H025663
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 24 Oct 2011 18:30:29 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p9OMURbV004544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 24 Oct 2011 18:30:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ceph users reported that when using Ceph on ext4, the filesystem
would often become corrupted, containing inodes with incorrect
i_blocks counters.

I managed to reproduce this with a very hacked-up "streamtest"
binary from the Ceph tree.

Ceph is doing a lot of xattr writes, to out-of-inode blocks.
There is also another thread which does sync_file_range and close,
of the same files.  The problem appears to happen due to this race:

sync/flush thread               xattr-set thread
-----------------               ----------------

do_writepages                   ext4_xattr_set
ext4_da_writepages              ext4_xattr_set_handle
mpage_da_map_blocks             ext4_xattr_block_set
        set DELALLOC_RESERVE
                                ext4_new_meta_blocks
                                        ext4_mb_new_blocks
                                                if (!i_delalloc_reserved_flag)
                                                        vfs_dq_alloc_block
ext4_get_blocks
	down_write(i_data_sem)
        set i_delalloc_reserved_flag
	...
	up_write(i_data_sem)
                                        if (i_delalloc_reserved_flag)
                                                vfs_dq_alloc_block_nofail


In other words, the sync/flush thread pops in and sets
i_delalloc_reserved_flag on the inode, which makes the xattr thread
think that it's in a delalloc path in ext4_new_meta_blocks(),
and add the block for a second time, after already having added
it once in the !i_delalloc_reserved_flag case in ext4_mb_new_blocks

I think this can be as simple as taking i_data_sem before we
go down the new metablock path, so that we won't be testing
i_delalloc_reserved_flag in a race with xt4_get_blocks setting it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This seems like slight abuse of i_data_sem though, since we are
not modifying i_data[] in the inode on the xattr path.  But nothing
else protects readers of i_delalloc_reserved_flag in other
threads.  Thoughts?

p.s. this almost feels like it needs quite a rework, I'm trying
to remember why we set a "we are in a delalloc path" in an inode
flag rather than as something passed through the callchain
arguments, but I'm fuzzy on these twisty paths.

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e4d0fca..dcebdbd 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -819,8 +819,14 @@ inserted:
 			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 				goal = goal & EXT4_MAX_BLOCK_FILE_PHYS;
+			/*
+			 * take i_data_sem because we will test
+			 * i_delalloc_reserved_flag in ext4_mb_new_blocks */
+			 */
+			down_read((&EXT4_I(inode)->i_data_sem));
 			block = ext4_new_meta_blocks(handle, inode,
 						  goal, NULL, &error);
+			up_read((&EXT4_I(inode)->i_data_sem));
 			if (error)
 				goto cleanup;
 



