From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: [PATCH] e2fsck: fix quota accounting to use cluster units
Date: Tue, 4 Apr 2017 21:03:53 +0300
Message-ID: <965F24ED-3B91-4D89-B25D-F547208FE909@gmail.com>
References: <20170402165705.GA8705@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36246 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932379AbdDDSD5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Apr 2017 14:03:57 -0400
Received: by mail-it0-f67.google.com with SMTP id a140so5698997ita.3
        for <linux-ext4@vger.kernel.org>; Tue, 04 Apr 2017 11:03:57 -0700 (PDT)
In-Reply-To: <20170402165705.GA8705@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

> 2 =D0=B0=D0=BF=D1=80. 2017 =D0=B3., =D0=B2 19:57, Eric Whitney =
<enwlinux@gmail.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> The quota accounting code in e2fsck's pass 1 and pass 3 uses block =
units
> rather than cluster units when recording the allocated space consumed =
by
> files and directories.  In pass 1, this causes a large undercount of
> actual quota results and test failures for xfstests generic/383, /384,
> /385, and /386 on bigalloc file systems.  In pass 3, this results in
> quota accounting errors when the lost+found directory is either =
extended
> or recreated on a bigalloc file system.
>=20
> Use clusters rather than blocks when accounting for allocated space,
> and correct a related header comment in the quota code.
>=20
> Note that pass 1b also contains call sites for quota_data_sub() that
> also need to be addressed.  However, it appears that more than just
> unit conversion may be needed, so that will be left to a future patch.
>=20
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
> e2fsck/pass1.c        | 3 ++-
> e2fsck/pass3.c        | 5 +++--
> lib/support/quotaio.h | 2 +-
> 3 files changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 1714897..188cc56 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -3174,7 +3174,8 @@ static void check_blocks(e2fsck_t ctx, struct =
problem_context *pctx,
> 	if (ino !=3D quota_type2inum(PRJQUOTA, fs->super) &&
> 	    (ino =3D=3D EXT2_ROOT_INO || ino >=3D =
EXT2_FIRST_INODE(ctx->fs->super))) {
> 		quota_data_add(ctx->qctx, (struct ext2_inode_large *) =
inode,
> -			       ino, pb.num_blocks * fs->blocksize);
> +			       ino,
> +			       pb.num_blocks * =
EXT2_CLUSTER_SIZE(fs->super));
> 		quota_data_inodes(ctx->qctx, (struct ext2_inode_large *) =
inode,
> 				  ino, +1);
> 	}
I think it part may rewrite easy.

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 98125bf..cd83156 100644 (file)
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2700,6 +2700,8 @@ static void check_blocks(e2fsck_t ctx, struct =
problem_context *pctx,
               }
       }

+       pb.num_blocks *=3D EXT2FS_CLUSTER_RATIO(fs);
+
       if (ino =3D=3D EXT2_ROOT_INO || ino >=3D =
EXT2_FIRST_INODE(ctx->fs->super)) {
               quota_data_add(ctx->qctx, inode, ino,
                              pb.num_blocks * fs->blocksize);
@@ -2710,7 +2712,7 @@ static void check_blocks(e2fsck_t ctx, struct =
problem_context *pctx,
             EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
           !(inode->i_flags & EXT4_HUGE_FILE_FL))
               pb.num_blocks *=3D (fs->blocksize / 512);
-       pb.num_blocks *=3D EXT2FS_CLUSTER_RATIO(fs);
+
