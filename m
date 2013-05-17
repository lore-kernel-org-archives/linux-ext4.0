From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/4] ext4: Fix fsync error handling after filesysteb abort.
Date: Fri, 17 May 2013 11:10:28 +0400
Message-ID: <87y5beaxp7.fsf@openvz.org>
References: <20130517032416.5110@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Yuan Fu <yuan.fu@gmx.cn>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:57521 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab3EQHKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 May 2013 03:10:32 -0400
Received: by mail-la0-f48.google.com with SMTP id fs12so3824884lab.7
        for <linux-ext4@vger.kernel.org>; Fri, 17 May 2013 00:10:31 -0700 (PDT)
In-Reply-To: <20130517032416.5110@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 17 May 2013 05:24:15 +0200, "Yuan Fu" <yuan.fu@gmx.cn> wrote:
> Dear Dmitry Monakhov,=C2=A0
>=20
>  =C2=A0I see a race condition, =C2=A0
> =C2=A0 =C2=A0=C2=A0 =C2=A0__ext4_abort() =C2=A0=C2=A0 =C2=A0
>  =C2=A0 =C2=A0=C2=A0 =C2=A0 =C2=A0 ... =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=
=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0EXT4_SB(sb)->s_mount_=
flags |=3D EXT4_MF_FS_ABORTED;
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 smp_wmb()
> =C2=A0
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [if scheduled at this poin=
t ]
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_flags |=3D MS_RDONLY=
;
> =C2=A0
>=20
> =C2=A0 =C2=A0if schedule occur above point(in red). There comes=C2=A0=
race condition
> =C2=A0 =C2=A0the s_mount_flags=C2=A0set to=C2=A0EXT4_MF_FS_ABORTED. O=
n the other hand =C2=A0=20
>  =C2=A0 sb->s_flags is not set to MS_RDONLY. Now if ext4_fsync_file()=
 is=20
>  =C2=A0 called from =C2=A0 some process, the check s_flags to MS_RDON=
LY will fail,
>  =C2=A0 and it will flush =C2=A0 unwritten io and not return -EORFS.
If flush_unwritten_io() was called after fs was aborted it will return
appropriate code (EROFS or EIO) so fsync(2) will fail as expected.
>=20
>  =C2=A0thanks =C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0
>=20
>  =C2=A0----- Original Message -----
> From: Dmitry Monakhov
> Sent: 05/16/13 05:58 PM
> Subject: [PATCH 1/4] ext4: Fix fsync error handling after filesysteb =
abort.
> =C2=A0If filesystem was aborted after inode's write back complete=20
> but before it's metadata was updated we may return success=20
> due to (sb->s_flags & MS_RDONLY) which is incorrect and=20
> result in data loss.=20
> In order to handle fs abort correctly we have to check=20
> fs state once we discover that it is in MS_RDONLY state=20
>=20
> Test case: http://patchwork.ozlabs.org/patch/244297/=20
>=20
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>=20
> ---=20
>  fs/ext4/fsync.c | 8 ++++++--=20
>  fs/ext4/super.c | 13 ++++++++++++-=20
>  2 files changed, 18 insertions(+), 3 deletions(-)=20
>=20
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c=20
> index e0ba8a4..d7df2f1 100644=20
> --- a/fs/ext4/fsync.c=20
> +++ b/fs/ext4/fsync.c=20
> @@ -129,9 +129,13 @@ int ext4_sync_file(struct file *file, loff_t sta=
rt, loff_t end, int datasync)=20
>  return ret;=20
>  mutex_lock(&inode->i_mutex);=20
> =20
> - if (inode->i_sb->s_flags & MS_RDONLY)=20
> + if (inode->i_sb->s_flags & MS_RDONLY) {=20
> + /* Make shure that we read updated s_mount_flags value */=20
> + smp_rmb();=20
> + if (EXT4_SB(inode->i_sb)->s_mount_flags & EXT4_MF_FS_ABORTED)=20
> + ret =3D -EROFS;=20
>  goto out;=20
> -=20
> + }=20
>  ret =3D ext4_flush_unwritten_io(inode);=20
>  if (ret < 0)=20
>  goto out;=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c=20
> index dbc7c09..6c91c8e 100644=20
> --- a/fs/ext4/super.c=20
> +++ b/fs/ext4/super.c=20
> @@ -398,6 +398,11 @@ static void ext4_handle_error(struct super_block=
 *sb)=20
>  }=20
>  if (test_opt(sb, ERRORS_RO)) {=20
>  ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");=20
> + /*=20
> + * Make shure updated value of ->s_mount_flags will be visiable=20
> + * before ->s_flags update=20
> + */=20
> + smp_wmb();=20
>  sb->s_flags |=3D MS_RDONLY;=20
>  }=20
>  if (test_opt(sb, ERRORS_PANIC))=20
> @@ -552,6 +557,7 @@ void __ext4_std_error(struct super_block *sb, con=
st char *function,=20
>  *=20
>  * We unconditionally force the filesystem into an ABORT|READONLY sta=
te,=20
>  * unless the error response on the fs has been set to panic in which=
=20
> +=20
>  * case we take the easy way out and panic immediately.=20
>  */=20
> =20
> @@ -570,8 +576,13 @@ void __ext4_abort(struct super_block *sb, const =
char *function,=20
> =20
>  if ((sb->s_flags & MS_RDONLY) =3D=3D 0) {=20
>  ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");=20
> - sb->s_flags |=3D MS_RDONLY;=20
>  EXT4_SB(sb)->s_mount_flags |=3D EXT4_MF_FS_ABORTED;=20
> + /*=20
> + * Make shure updated value of ->s_mount_flags will be visiable=20
> + * before ->s_flags update=20
> + */=20
> + smp_wmb();=20
> + sb->s_flags |=3D MS_RDONLY;=20
>  if (EXT4_SB(sb)->s_journal)=20
>  jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);=20
>  save_error_info(sb, function, line);=20
> --=20
> 1.7.1=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in=20
> the body of a message to majordomo@vger.kernel.org=20
> More majordomo info at http://vger.kernel.org/majordomo-info.html =C2=
=A0 =C2=A0 =C2=A0
>  =C2=A0=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
