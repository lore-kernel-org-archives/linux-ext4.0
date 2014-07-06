From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: reopen the file system with saved flags after a journal replay
Date: Sat,  5 Jul 2014 23:09:57 -0400
Message-ID: <1404616198-315-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	=?UTF-8?q?=D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9=20=D0=92=D0=B0=D1=81=D0=B8=D0=BB=D0=B8=D1=88=D0=B8=D0=BD?=
	<a.vasilishin@kpi.ua>, Jon Severinsson <jon@severinsson.net>,
	744953@bugs.debian.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47206 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaGFDKP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 23:10:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After a journal replay, we close and reopen the file system so that
any changes in the superblock can get reflected in the libext2fs's
internal data structures.  We need to save the flags passed to
ext2fs_open() that we used when we originally opened the file system.

Otherwise we could end up triggering the following error message when
checking a large (or bigalloc) file system after an unclean shutdown:

fsck.ext4: Filesystem too large to use legacy bitmaps while trying to r=
e-open

Addresses-Debian-Bug: 744953
Cc: =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 =D0=92=D0=B0=D1=81=D0=B8=D0=BB=
=D0=B8=D1=88=D0=B8=D0=BD <a.vasilishin@kpi.ua>
Cc: Jon Severinsson <jon@severinsson.net>
Cc: 744953@bugs.debian.org
---

Distributions will almost certainly want to backport this patch, since
it breaks running e2fsck on file system with the 64-bit or bigalloc
feature enabled=20

 e2fsck/e2fsck.h  | 1 +
 e2fsck/journal.c | 2 +-
 e2fsck/unix.c    | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index c71a0a5..998abdc 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -232,6 +232,7 @@ struct e2fsck_struct {
 	blk64_t free_blocks;
 	ino_t	free_inodes;
 	int	mount_flags;
+	int	openfs_flags;
 	blkid_cache blkid;	/* blkid cache */
=20
 #ifdef HAVE_SETJMP_H
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 905c0bf..9be52cd 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -903,7 +903,7 @@ errcode_t e2fsck_run_ext3_journal(e2fsck_t ctx)
=20
 	ext2fs_mmp_stop(ctx->fs);
 	ext2fs_free(ctx->fs);
-	retval =3D ext2fs_open(ctx->filesystem_name, EXT2_FLAG_RW,
+	retval =3D ext2fs_open(ctx->filesystem_name, ctx->openfs_flags,
 			     ctx->superblock, blocksize, io_ptr,
 			     &ctx->fs);
 	if (retval) {
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index b265c99..03848c7 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1274,6 +1274,7 @@ restart:
 			flags &=3D ~EXT2_FLAG_EXCLUSIVE;
 	}
=20
+	ctx->openfs_flags =3D flags;
 	retval =3D try_open_fs(ctx, flags, io_ptr, &fs);
=20
 	if (!ctx->superblock && !(ctx->options & E2F_OPT_PREEN) &&
--=20
2.0.0

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
