From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] ext4: make quota as first class supported feature
Date: Thu, 21 Jul 2011 10:24:12 -0700
Message-ID: <CAGr1F2GVuVMcf1Sv4AwBrB5MgXLp8vQmBKXQ=KZyk_GCJcMjdA@mail.gmail.com>
References: <1311187218-30798-1-git-send-email-adityakali@google.com> <561996F3-BC30-4E1A-B405-0A13A966E45A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Johann Lombardi <johann@whamcloud.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:24236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1GURYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jul 2011 13:24:34 -0400
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id p6LHOXXG016741
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jul 2011 10:24:33 -0700
Received: from pzk5 (pzk5.prod.google.com [10.243.19.133])
	by wpaz1.hot.corp.google.com with ESMTP id p6LHNRW5017372
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jul 2011 10:24:32 -0700
Received: by pzk5 with SMTP id 5so6362134pzk.17
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jul 2011 10:24:32 -0700 (PDT)
In-Reply-To: <561996F3-BC30-4E1A-B405-0A13A966E45A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 12:02 AM, Andreas Dilger <adilger@dilger.ca> wr=
ote:
> Why support V1 quota, when it has known limits on some of the usage, =
instead
> of using V2 quotas that are added to ext3/4 already? =C2=A0The Kconfi=
g comment
> for V1 begins:
> =C2=A0=C2=A0=C2=A0=C2=A0This=C2=A0quota=C2=A0format=C2=A0was=C2=A0(is=
)=C2=A0used=C2=A0by=C2=A0kernels=C2=A0earlier=C2=A0than=C2=A02.4.22.
> It would make much more sense to start with V2 for a new feature like=
 this.
>
QFMT_VFS_V1 is actually the format ID of V2 quota format itself. This
is whats in fs/quota/quota_v2.c:

313 static struct quota_format_type v2r1_quota_format =3D {
314         .qf_fmt_id      =3D QFMT_VFS_V1,
315         .qf_ops         =3D &v2_format_ops,
316         .qf_owner       =3D THIS_MODULE
317 };

So this patch does support the V2 format.


> static const struct quotactl_ops ext4_qctl_operations =3D {
> - =C2=A0 =C2=A0.quota_on =C2=A0 =C2=A0=3D ext4_quota_on,
> + =C2=A0 =C2=A0.quota_on_meta =C2=A0 =C2=A0=3D ext4_quota_on,
> =C2=A0 =C2=A0.quota_off =C2=A0 =C2=A0=3D ext4_quota_off,
> =C2=A0 =C2=A0.quota_sync =C2=A0 =C2=A0=3D dquot_quota_sync,
> =C2=A0 =C2=A0.get_info =C2=A0 =C2=A0=3D dquot_get_dqinfo,

> @@ -4658,24 +4679,22 @@ static int ext4_quota_on_mount(struct super_b=
lock
> *sb, int type)
> /*
> =C2=A0* Standard function to be called on quota_on
> =C2=A0*/
> -static int ext4_quota_on(struct super_block *sb, int type, int forma=
t_id,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path *path)
> +static int ext4_quota_on(struct super_block *sb, int type, int forma=
t_id)
> {
> =C2=A0 =C2=A0int err;
> + =C2=A0 =C2=A0struct inode *qf_inode;
>
> - =C2=A0 =C2=A0if (!test_opt(sb, QUOTA))
> + =C2=A0 =C2=A0if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_CO=
MPAT_QUOTA) ||
> + =C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0!EXT4_SB(sb)->s_qf_inums[type])
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;
>
I also wanted to get input on this change to ext4_quota_on. With this
change, its not possible to use quotas at all without the 'quota'
feature flag set, which might break the current userspace. Do we want
to keep supporting current approach (where quotas can be turned on
with user specified files) as well? This change kinda forces users to
update userspace tools (e2fsprogs & quota-tools) as well.

Thanks,
-Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
