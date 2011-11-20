From: NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v2] ext4: group info caches set to SLAB_MEM_SPREAD flags.
Date: Sun, 20 Nov 2011 14:45:32 +0900
Message-ID: <CAKYAXd_YXUymFjbxgXwV+pXJNvPhq-W_Pi96mU3NodO3yyNTrg@mail.gmail.com>
References: <1321747359-1919-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55957 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1KTFpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Nov 2011 00:45:35 -0500
In-Reply-To: <1321747359-1919-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/11/20 Namjae Jeon <linkinjeon@gmail.com>:
> I try to set to SLAB_MEM_SPREAD flags in groups info caches accoding =
to http://lwn.net/Articles/173654/.
> And other filesystems have already set to this flags when using slab =
caches in fs.
> I believe that it is useful by original Paul jackson's patch and othe=
r fs is currently using this flags.
> Ted's opinion is that theoretically it would be sound to have that fl=
ag set with groups info slab cache.
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
> =C2=A0fs/ext4/mballoc.c | =C2=A0 =C2=A03 ++-
> =C2=A01 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e2d8be8..7aacbbe 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2407,7 +2407,8 @@ static int ext4_groupinfo_create_slab(size_t si=
ze)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bb_counters[blocksize_bits + =
2]);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cachep =3D kmem_cache_create(ext4_groupinf=
o_slab_names[cache_index],
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 slab_si=
ze, 0, SLAB_RECLAIM_ACCOUNT,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 slab_si=
ze, 0, SLAB_RECLAIM_ACCOUNT |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 SLAB_ME=
M_SPREAD,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0N=
ULL);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_groupinfo_caches[cache_index] =3D cac=
hep;
> --
> 1.7.4.4
>
>
Hi. Ted.
This patch is not really meaningful ? or you need to see performance
data although cpuset mem spread flags patch is proved before.
I am waiting for your decision.
Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
