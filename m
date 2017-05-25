From: Konstantin Chistyakov <Konstantin.Chistyakov@paragon-software.com>
Subject: RE: libext2fs: don't flush to device opened in read-only mode
Date: Thu, 25 May 2017 12:12:21 +0000
Message-ID: <118AAB5F26BFB34DB5CDA7DA33334DB9B6072B@vmsk-exch-01.paragon-software.com>
References: <118AAB5F26BFB34DB5CDA7DA33334DB9B5FF41@vmsk-exch-01.paragon-software.com>
 <20170524215622.fh7yin4fttggw36f@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relaymsk-01.paragon-software.com ([91.226.210.14]:35470 "EHLO
        relaymsk-01.paragon-software.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1424031AbdEYMMY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 May 2017 08:12:24 -0400
Content-Language: ru-RU
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Updating path:
Subject: [PATCH] e2fsck: don't flush to device opened in read-only mode

If the e2fsck is called with both -f -n options, the checking completing wi=
th a flushing error (retcode 8).
e2fsprogs 1.43.4, builded in CygWin (cygwin1.dll 2.8.0 x64), Windows 8.1 x6=
4 and Windows 10 x64 (not tested on x86).
In path added read-only test for flushing block in 'e2fsck/unix.c';

Catch error from the ext2fs_flush(ctx->fs)  when ctx->fs is opened in read-=
only mode:

...
e2fsck -n -f /dev/sdd1
e2fsck 1.43.4 (31-Jan-2017)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Error flushing writes to storage device: Permission denied

---
(limited to 'e2fsck/unix.c')

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index b602553..ff96148 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1898,15 +1898,17 @@ no_journal:
 		ext2fs_mark_super_dirty(fs);
 	}
=20
-	e2fsck_write_bitmaps(ctx);
-	if (fs->flags & EXT2_FLAG_DIRTY) {
-		pctx.errcode =3D ext2fs_flush(ctx->fs);
+	if (!(ctx->options & E2F_OPT_READONLY)) {
+		e2fsck_write_bitmaps(ctx);
+		if (fs->flags & EXT2_FLAG_DIRTY) {
+			pctx.errcode =3D ext2fs_flush(ctx->fs);
+			if (pctx.errcode)
+				fix_problem(ctx, PR_6_FLUSH_FILESYSTEM, &pctx);
+		}
+		pctx.errcode =3D io_channel_flush(ctx->fs->io);
 		if (pctx.errcode)
-			fix_problem(ctx, PR_6_FLUSH_FILESYSTEM, &pctx);
+			fix_problem(ctx, PR_6_IO_FLUSH, &pctx);
 	}
-	pctx.errcode =3D io_channel_flush(ctx->fs->io);
-	if (pctx.errcode)
-		fix_problem(ctx, PR_6_IO_FLUSH, &pctx);
=20
 	if (was_changed) {
 		int fs_fixed =3D (ctx->flags & E2F_FLAG_PROBLEMS_FIXED);

-----Original Message-----
From: Konstantin Chistyakov=20
Sent: Thursday, May 25, 2017 8:50 AM
To: 'Theodore Ts'o' <tytso@mit.edu>
Cc: 'linux-ext4@vger.kernel.org' <linux-ext4@vger.kernel.org>
Subject: RE: libext2fs: don't flush to device opened in read-only mode

Thanks for suggestion how to fix the bug correctly. Platform for reproducin=
g: CYGWin build (x86, x64, cygwin1.dll v.2.8.0), Windows 8.1 x64 and Window=
s  10 x64 (x86 not tested).

-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu]
Sent: Thursday, May 25, 2017 12:56 AM
To: Konstantin Chistyakov <Konstantin.Chistyakov@paragon-software.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: libext2fs: don't flush to device opened in read-only mode

On Mon, May 22, 2017 at 09:48:00AM +0000, Konstantin Chistyakov wrote:
> From: Konstantin Chistyakov
> <Konstantin.Chistyakov@Paragon-software.com>
> Date: Tue, 19 May 2017 09:23:29 -0600
> Subject: [PATCH] libext2fs: don't flush to device opened in read-only=20
> mode
>=20
> From: Konstantin Chistyakov
> <Konstantin.Chistyakov@Paragon-software.com>
>=20
> If the e2fsck is called with both -f -n options, the checking completing =
with a flushing error (retcode 8).
>=20
> Catch error from the unix_flush() fsync(data->dev) when data->dev is open=
ed in read-only mode:

I can't reproduce this problem.  What storage device or operating system ar=
e you using?

That being said, this is probably the wrong place to fix it.  The better fi=
x is in e2fsck/unix.c, by adding a read-only test.

       	      	 		   	  - Ted
