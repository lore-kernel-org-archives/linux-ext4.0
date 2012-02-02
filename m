From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [PATCH] ext4: s_dirtyclusters_counter should tranform to unit of
 cluster before assigning to "dirty_clusters" in ext4_has_free_clusters()
Date: Thu, 2 Feb 2012 15:48:49 +0800
Message-ID: <CAFZ0FUUNRrSa0RvqXcmp_JoZpefDd5pSyx=5LCz5jwDUhUd=_w@mail.gmail.com>
References: <1328066270-4461-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56553 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661Ab2BBHsu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Feb 2012 02:48:50 -0500
Received: by obcva7 with SMTP id va7so2409101obc.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Feb 2012 23:48:49 -0800 (PST)
In-Reply-To: <1328066270-4461-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/2/1 Robin Dong <hao.bigrat@gmail.com>:
> From: Robin Dong <sanbai@taobao.com>
>
> Creating 4-byte files until ENOSPC in a delay-allocation and bigalloc=
 ext4 fs and then sync it, the dmseg will report like:
>
> =A0 =A0 =A0 =A0[ =A0482.154538] EXT4-fs (sdb6): delayed block allocat=
ion failed for inode 1664 at logical offset 0 with max blocks 1 with er=
ror -28
> =A0 =A0 =A0 =A0[ =A0482.154540] EXT4-fs (sdb6): This should not happe=
n!! Data will be lost
>
> The reason is ext4_has_free_clusters reporting wrong result. Actually=
, the unit of sbi->s_dirtyclusters_counter is block, so we should tranf=
orm it to cluster for argument "dirty_clusters", just like "free_cluste=
rs".

Sorry, the description is in confusion, the correct version is:

The reason is ext4_has_free_clusters reporting wrong result. Actually,
the unit of argument "dirty_clusters" is block, so we should tranform
the
sbi->s_dirtyclusters_counter to block , just like "free_clusters".

>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Reported-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
> =A0fs/ext4/balloc.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index f9e2cd8..8ff10c4 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -427,7 +427,7 @@ static int ext4_has_free_clusters(struct ext4_sb_=
info *sbi,
> =A0 =A0 =A0 =A0if (free_clusters - (nclusters + root_clusters + dirty=
_clusters) <
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0EXT4_FREECLUSTERS_WATERMARK) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0free_clusters =A0=3D EXT4_C2B(sbi, per=
cpu_counter_sum_positive(fcc));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dirty_clusters =3D percpu_counter_sum_p=
ositive(dcc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dirty_clusters =3D EXT4_C2B(sbi, percpu=
_counter_sum_positive(dcc));
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0/* Check whether we have space after accounting for cu=
rrent
> =A0 =A0 =A0 =A0 * dirty clusters & root reserved clusters.
> --
> 1.7.4.1
>



--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
