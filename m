From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/10] libext2fs: add explicit casts to ext2fs.h
Date: Tue, 3 Dec 2013 11:16:08 -0800
Message-ID: <20131203191608.GC9535@birch.djwong.org>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
 <1386047418-32431-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Kit Westneat <kwestneat@ddn.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51656 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3LCTQT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 14:16:19 -0500
Content-Disposition: inline
In-Reply-To: <1386047418-32431-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 12:10:13AM -0500, Theodore Ts'o wrote:
> Add some explicit casts to silence some -Wconversion noise.
>=20
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/ext2fs.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index b7a784e..eb1901e 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1673,14 +1673,14 @@ _INLINE_ int ext2fs_test_bb_dirty(ext2_filsys=
 fs)
>  /*
>   * Return the group # of a block
>   */
> -_INLINE_ int ext2fs_group_of_blk(ext2_filsys fs, blk_t blk)
> +_INLINE_ dgrp_t ext2fs_group_of_blk(ext2_filsys fs, blk_t blk)

The function prototypes up around line 1604 need to be updated:

In file included from inline.c:38:0:
ext2fs.h:1810:17: error: conflicting types for =E2=80=98ext2fs_group_of=
_blk=E2=80=99
ext2fs.h:1604:12: note: previous declaration of =E2=80=98ext2fs_group_o=
f_blk=E2=80=99 was here
ext2fs.h:1817:17: error: conflicting types for =E2=80=98ext2fs_group_of=
_ino=E2=80=99
ext2fs.h:1605:12: note: previous declaration of =E2=80=98ext2fs_group_o=
f_ino=E2=80=99 was here

--D

---
libext2fs: fix function declarations to match definition

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f9b795a..898ad0c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1601,8 +1601,8 @@ extern void ext2fs_mark_ib_dirty(ext2_filsys fs);
 extern void ext2fs_mark_bb_dirty(ext2_filsys fs);
 extern int ext2fs_test_ib_dirty(ext2_filsys fs);
 extern int ext2fs_test_bb_dirty(ext2_filsys fs);
-extern int ext2fs_group_of_blk(ext2_filsys fs, blk_t blk);
-extern int ext2fs_group_of_ino(ext2_filsys fs, ext2_ino_t ino);
+extern dgrp_t ext2fs_group_of_blk(ext2_filsys fs, blk_t blk);
+extern dgrp_t ext2fs_group_of_ino(ext2_filsys fs, ext2_ino_t ino);
 extern blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group);
 extern blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group);
 extern blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
