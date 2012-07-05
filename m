From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH v2] ext4: fix hole punch failure when depth is greater
 than 0
Date: Thu, 5 Jul 2012 15:22:04 +0530
Message-ID: <CAOiN93mJO6=dV4U=Qyw7myz34EF_doaoLsFHksmu4-n8pOzXBA@mail.gmail.com>
References: <1339638836-19990-1-git-send-email-ashish.sangwan2@gmail.com>
	<CAKYAXd_g_vgAmyD4jyUqz0u=vaSTAKFqZz0sqhM+2+hy1Z85ug@mail.gmail.com>
	<CAOiN93=BKyGKtpLng-ddX0RFUOdHCaxHi2O26GFokdT19xad2g@mail.gmail.com>
	<alpine.LFD.2.00.1207021110530.24050@dhcp-1-248.brq.redhat.com>
	<CAOiN93kzvKVDzSJ13HJZDh9ANt3UaBy0o_QHNKCSHHTizjtY0w@mail.gmail.com>
	<alpine.LFD.2.00.1207041926290.29222@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sandeen@redhat.com, Ted Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61412 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2GEJwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2012 05:52:05 -0400
In-Reply-To: <alpine.LFD.2.00.1207041926290.29222@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 4, 2012 at 11:03 PM, Luk=C3=A1=C5=A1 Czerner <lczerner@redh=
at.com> wrote:
> So I've finally has some time to look at the patch and reproduce the
> problem. Thanks for noticing the problem, the patch seems good,
> though I have one question. Is the p_block setting really necessary
> ? I do not think so, but I might be missing something. Here is
> updated patch I've tested, bellow.
AFAICS, p_block setting is necessary. As mentioned in the patch descrip=
tion,
whether to continue removing extents or not is decided by the return va=
lue
of function ext4_ext_more_to_rm() which checks 2 conditions:
a) if there are no more indexes to process.
b) if the number of entries are decreased in the header of "depth -1".
The p_block setting is important for condition b).

In function ext4_ext_more_to_rm, there is this second check:
if (le16_to_cpu(path->p_hdr->eh_entries) =3D=3D path->p_block)
    return 0;
If the value of p_block would not be correct, the above mentioned
condition could become
true while there are still blocks left to be removed.
>
> Note: there are some indent problems in your patch, like for example
> this:
>
> +                       path[k].p_block =3D
> +                       le16_to_cpu(path[k].p_hdr->eh_entries)+1;
>
>
Before submitting the patch, I run checkpatch.pl with --strict option.
It did'nt show any error or warning. Should I re-submit
the patch with an extra tab before the second line? The call is yours.

> Anyway, what do you think about the modification ?
>
Also there is 1 modification missing from your patch.
    ext4_ext_drop_refs(path);
        kfree(path);
+       path =3D NULL;
        if (err =3D=3D -EAGAIN)
                goto again;
If path is not set to NULL, it will crash in xfstest #13. Ted has
already reported it.

Thanks,
Ashish

> Thanks!
> -Lukas
>
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index b3300eb..94bc1bd 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2570,7 +2570,7 @@ static int ext4_ext_remove_space(struct inode *=
inode, ext4_lblk_t start,
>  {
>         struct super_block *sb =3D inode->i_sb;
>         int depth =3D ext_depth(inode);
> -       struct ext4_ext_path *path;
> +       struct ext4_ext_path *path =3D NULL;
>         ext4_fsblk_t partial_cluster =3D 0;
>         handle_t *handle;
>         int i, err;
> @@ -2606,8 +2606,12 @@ again:
>                 }
>                 depth =3D ext_depth(inode);
>                 ex =3D path[depth].p_ext;
> -               if (!ex)
> +               if (!ex) {
> +                       ext4_ext_drop_refs(path);
> +                       kfree(path);
> +                       path =3D NULL;
>                         goto cont;
> +               }
>
>                 ee_block =3D le32_to_cpu(ex->ee_block);
>
> @@ -2637,8 +2641,6 @@ again:
>                         if (err < 0)
>                                 goto out;
>                 }
> -               ext4_ext_drop_refs(path);
> -               kfree(path);
>         }
>  cont:
>
> @@ -2646,20 +2648,26 @@ cont:
>          * We start scanning from right side, freeing all the blocks
>          * after i_size and walking into the tree depth-wise.
>          */
> -       depth =3D ext_depth(inode);
> -       path =3D kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), =
GFP_NOFS);
> -       if (path =3D=3D NULL) {
> -               ext4_journal_stop(handle);
> -               return -ENOMEM;
> -       }
> -       path[0].p_depth =3D depth;
> -       path[0].p_hdr =3D ext_inode_hdr(inode);
> +       if (path)
> +               i =3D depth;
> +       else {
> +               depth =3D ext_depth(inode);
> +               path =3D kzalloc(sizeof(struct ext4_ext_path) * (dept=
h + 1),
> +                              GFP_NOFS);
> +               if (path =3D=3D NULL) {
> +                       ext4_journal_stop(handle);
> +                       return -ENOMEM;
> +               }
> +               path[0].p_depth =3D depth;
> +               path[0].p_hdr =3D ext_inode_hdr(inode);
>
> -       if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
> -               err =3D -EIO;
> -               goto out;
> +               if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
> +                       err =3D -EIO;
> +                       goto out;
> +               }
> +               i =3D 0;
>         }
> -       i =3D err =3D 0;
> +       err =3D 0;
>
>         while (i >=3D 0 && err =3D=3D 0) {
>                 if (i =3D=3D depth) {
>
> On Mon, 2 Jul 2012, Ashish Sangwan wrote:
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
