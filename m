From: =?utf-8?B?0JHQu9Cw0LPQvtC00LDRgNC10L3QutC+INCQ0YDRgtGR0Lw=?=
        <artem.blagodarenko@gmail.com>
Subject: Re: [PATCH] e2fsck: properly account cluster size
Date: Thu, 15 Feb 2018 17:45:34 +0300
Message-ID: <DC07AF86-4B27-4F94-AC08-096CDA3C8D67@gmail.com>
References: <20180212120040.25441-1-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Andrew Perepechko <anserper@ya.ru>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:42052 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033423AbeBOOpj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Feb 2018 09:45:39 -0500
Received: by mail-lf0-f66.google.com with SMTP id w10so21588444lfc.9
        for <linux-ext4@vger.kernel.org>; Thu, 15 Feb 2018 06:45:39 -0800 (PST)
In-Reply-To: <20180212120040.25441-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry, this patch is duplicate of
[PATCH] e2fsck: fix quota accounting to use cluster units
from Eric W at 5 April.


> On 12 Feb 2018, at 15:00, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Andrew Perepechko <anserper@ya.ru>
>=20
> The patch fixes the quota_data_add() call so that
> not num_blocks * block_size is passed, but instead
> num_blocks * blocks_per_cluster * block_size.
>=20
> Otherwise, any trivial test with -O bigalloc,quota
> filesystem leads to check errors like
>=20
> [QUOTA WARNING] Usage inconsistent for ID 0:actual (8192, 2) !=3D =
expected
> (131072, 2)
> Update quota info for quota type 0<y>? cancelled!
> [QUOTA WARNING] Usage inconsistent for ID 0:actual (8192, 2) !=3D =
expected
> (131072, 2)
> Update quota info for quota type 1<y>? cancelled!
>=20
> Cray-bug-id: LUS-5373
>=20
> Signed-off-by: Andrew Perepechko <anserper@ya.ru>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> e2fsck/pass1.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 5015d938..471162ea 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -3387,6 +3387,8 @@ static void check_blocks(e2fsck_t ctx, struct =
problem_context *pctx,
> 		}
> 	}
>=20
> +	pb.num_blocks *=3D EXT2FS_CLUSTER_RATIO(fs);
> +
> 	if (ino !=3D quota_type2inum(PRJQUOTA, fs->super) &&
> 	    (ino =3D=3D EXT2_ROOT_INO || ino >=3D =
EXT2_FIRST_INODE(ctx->fs->super)) &&
> 	    !(inode->i_flags & EXT4_EA_INODE_FL)) {
> --=20
> 2.14.3 (Apple Git-98)
>=20
