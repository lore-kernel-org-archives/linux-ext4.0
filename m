From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] fuse2fs: set inode's uid/gid when creating inode
Date: Mon, 23 Nov 2015 12:56:20 -0800
Message-ID: <20151123205620.GA10580@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lennart =?iso-8859-1?Q?L=F6vstrand?= <lennart@lovstrand.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33657 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbbKWU4c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2015 15:56:32 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When creating a file in op_create, set the file's uid and gid to the
user's uid and gid.  Do the same in op_mknod.

Reported-by: Lennart L=F6vstrand <lennart@lovstrand.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/fuse2fs.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 7d8bb60..1cbdcb7 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -994,6 +994,8 @@ static int op_mknod(const char *path, mode_t mode, =
dev_t dev)
 	inode.i_links_count =3D 1;
 	inode.i_extra_isize =3D sizeof(struct ext2_inode_large) -
 		EXT2_GOOD_OLD_INODE_SIZE;
+	inode.i_uid =3D ctxt->uid;
+	inode.i_gid =3D ctxt->gid;
=20
 	err =3D ext2fs_write_new_inode(fs, child, (struct ext2_inode *)&inode=
);
 	if (err) {
@@ -2895,6 +2897,8 @@ static int op_create(const char *path, mode_t mod=
e, struct fuse_file_info *fp)
 	inode.i_links_count =3D 1;
 	inode.i_extra_isize =3D sizeof(struct ext2_inode_large) -
 		EXT2_GOOD_OLD_INODE_SIZE;
+	inode.i_uid =3D ctxt->uid;
+	inode.i_gid =3D ctxt->gid;
 	if (ext2fs_has_feature_extents(fs->super)) {
 		ext2_extent_handle_t handle;
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
