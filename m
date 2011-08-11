From: Steven Liu <lingjiujianke@gmail.com>
Subject: Re: [PATCH 05/13] ext4: add a structure which will be used by
 64bit-resize interface
Date: Thu, 11 Aug 2011 18:57:24 +0800
Message-ID: <CADxeRwkB+Mx_bg_etdwb8qzfSKPtnnEE3T_XiupRHwXGotVosQ@mail.gmail.com>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
	<1313033308-882-6-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, aedilger@gmail.com, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34952 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1HKK5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 06:57:25 -0400
Received: by bke11 with SMTP id 11so886145bke.19
        for <linux-ext4@vger.kernel.org>; Thu, 11 Aug 2011 03:57:24 -0700 (PDT)
In-Reply-To: <1313033308-882-6-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

TO: Yongqiang

2011/8/11 Yongqiang Yang <xiaoqiangnk@gmail.com>:
> This patch adds a structure which will be used by 64bit-resize interf=
ace.
> Two functions which allocate and destroy the structure respectively a=
re
> added.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext4/resize.c | =A0 56 ++++++++++++++++++++++++++++++++++++++++=
++++++++++++++
> =A01 files changed, 56 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 14be865..c586e51 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -134,6 +134,62 @@ static int verify_group_input(struct super_block=
 *sb,
> =A0 =A0 =A0 =A0return err;
> =A0}
>
> +/*
> + * ext4_new_flex_group_data is used by 64bit-resize interface to add=
 a flex
> + * group each time.
> + */
> +struct ext4_new_flex_group_data {
> + =A0 =A0 =A0 struct ext4_new_group_data *groups; =A0 =A0 /* new_grou=
p_data for groups
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in the flex group */
> + =A0 =A0 =A0 __u16 *bg_flags; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0/* block group flags of groups
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in @groups */
> + =A0 =A0 =A0 ext4_group_t count; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /* number of groups in @groups
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> +};
> +
> +/*
> + * alloc_flex_gd() allocates a ext4_new_flex_group_data with size of
> + * @flexbg_size.
> + *
> + * Returns NULL on failure otherwise address of the allocated struct=
ure.
> + */
> +static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned long =
flexbg_size)
> +{
> + =A0 =A0 =A0 struct ext4_new_flex_group_data *flex_gd;
> +
> + =A0 =A0 =A0 flex_gd =3D kmalloc(sizeof(*flex_gd), GFP_NOFS);
> + =A0 =A0 =A0 if (flex_gd =3D=3D NULL) {
                    printk( KERN_WARNING "not enough memory for flex_gd=
\n" );
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out3;
             }
> +
> + =A0 =A0 =A0 flex_gd->count =3D flexbg_size;
> +
> + =A0 =A0 =A0 flex_gd->groups =3D kmalloc(sizeof(struct ext4_new_grou=
p_data) *
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fle=
xbg_size, GFP_NOFS);
> + =A0 =A0 =A0 if (flex_gd->groups =3D=3D NULL) {
                    printk( KERN_WARNING "not enough memory for
flex_gd->groups\n" );
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out2;
            }
> +
> + =A0 =A0 =A0 flex_gd->bg_flags =3D kmalloc(flexbg_size * sizeof(__u1=
6), GFP_NOFS);
> + =A0 =A0 =A0 if (flex_gd->bg_flags =3D=3D NULL) {
                    printk( KERN_WARNING "not enough memory for
flex_gd->bg_flags\n" );
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out1;
             }
> +
> + =A0 =A0 =A0 return flex_gd;
> +
out1:
 =A0 =A0 kfree(flex_gd->groups);
> +out2:
> + =A0 =A0 =A0 kfree(flex_gd);
 out3:
> + =A0 =A0 =A0 return NULL;
> +}
> +
> +void free_flex_gd(struct ext4_new_flex_group_data *flex_gd)
> +{
> + =A0 =A0 =A0 kfree(flex_gd->bg_flags);
> + =A0 =A0 =A0 kfree(flex_gd->groups);
> + =A0 =A0 =A0 kfree(flex_gd);
> +}
> +
> =A0static struct buffer_head *bclean(handle_t *handle, struct super_b=
lock *sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ex=
t4_fsblk_t blk)
> =A0{



What about add some message for kmalloc failure, and  goto the label
looks like the above ?
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
