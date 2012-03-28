From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [RESEND][PATCH] ext4: add error handling when discarding is fail
 in FITRIM ioctl.
Date: Wed, 28 Mar 2012 16:20:31 +0530
Message-ID: <CADDb1s3mZNd0GV3P_W1E+5F3UTptqE_mZVjf1yU==SW41a1z8A@mail.gmail.com>
References: <1330863946-3136-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758025Ab2C1Kud convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Mar 2012 06:50:33 -0400
In-Reply-To: <1330863946-3136-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Can you please update us about the status of this patch? Please let us
know in case there are any suggestions about this.
Looking forward to hear your opinion about the same.

Thanks & Regards,
Amit Sahrawat

On Sun, Mar 4, 2012 at 5:55 PM, Namjae Jeon <linkinjeon@gmail.com> wrot=
e:
> Although free extents is proper not trimmed(mmc driver return error c=
ode while sending trim command), currently FITRIM ioctl return success.
> I tried to add exception routine to inform user error code.
>
> #> ./fitrim_test
> end_request: I/O error, dev mmcblk0, sector 27232
> EXT4-fs warning (device mmcblk0): ext4_trim_all_free:4857: Discard co=
mmand returned error -5
> #>
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
> =A0fs/ext4/mballoc.c | =A0 24 ++++++++++++++++--------
> =A01 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index cb990b2..94182d4 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4901,10 +4901,11 @@ error_return:
> =A0* one will allocate those blocks, mark it as used in buddy bitmap.=
 This must
> =A0* be called with under the group lock.
> =A0*/
> -static void ext4_trim_extent(struct super_block *sb, int start, int =
count,
> +static int ext4_trim_extent(struct super_block *sb, int start, int c=
ount,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_group_t =
group, struct ext4_buddy *e4b)
> =A0{
> =A0 =A0 =A0 =A0struct ext4_free_extent ex;
> + =A0 =A0 =A0 int err;
>
> =A0 =A0 =A0 =A0trace_ext4_trim_extent(sb, group, start, count);
>
> @@ -4920,9 +4921,10 @@ static void ext4_trim_extent(struct super_bloc=
k *sb, int start, int count,
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0mb_mark_used(e4b, &ex);
> =A0 =A0 =A0 =A0ext4_unlock_group(sb, group);
> - =A0 =A0 =A0 ext4_issue_discard(sb, group, start, count);
> + =A0 =A0 =A0 err =3D ext4_issue_discard(sb, group, start, count);
> =A0 =A0 =A0 =A0ext4_lock_group(sb, group);
> =A0 =A0 =A0 =A0mb_free_blocks(NULL, e4b, start, ex.fe_len);
> + =A0 =A0 =A0 return err;
> =A0}
>
> =A0/**
> @@ -4951,7 +4953,7 @@ ext4_trim_all_free(struct super_block *sb, ext4=
_group_t group,
> =A0 =A0 =A0 =A0void *bitmap;
> =A0 =A0 =A0 =A0ext4_grpblk_t next, count =3D 0, free_count =3D 0;
> =A0 =A0 =A0 =A0struct ext4_buddy e4b;
> - =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 int ret =3D 0;
>
> =A0 =A0 =A0 =A0trace_ext4_trim_all_free(sb, group, start, max);
>
> @@ -4978,15 +4980,21 @@ ext4_trim_all_free(struct super_block *sb, ex=
t4_group_t group,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0next =3D mb_find_next_bit(bitmap, max,=
 start);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((next - start) >=3D minblocks) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_trim_extent(sb, st=
art,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0next - start, group, &e4b);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count +=3D next - start=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_trim_exten=
t(sb, start,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 next - start, group, &e4b);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret=
 !=3D -EOPNOTSUPP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ext4_warning(sb, "Discard command "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0"returned error %d\n", ret);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count +=
=3D next - start;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0free_count +=3D next - start;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0start =3D next + 1;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (fatal_signal_pending(current)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count =3D -ERESTARTSYS;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ERESTARTSYS;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> @@ -5009,7 +5017,7 @@ out:
> =A0 =A0 =A0 =A0ext4_debug("trimmed %d blocks in the group %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count, group);
>
> - =A0 =A0 =A0 return count;
> + =A0 =A0 =A0 return (ret < 0) ? ret : count;
> =A0}
>
> =A0/**
> --
> 1.7.5.4
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
