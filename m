From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] ext4: do not allow journal_opts for fs w/o journal
Date: Fri, 9 Oct 2015 14:53:39 -0600
Message-ID: <04197994-C65B-4B52-9555-795E8B0B7E7B@dilger.ca>
References: <1444381799-10566-1-git-send-email-dmonakhov@openvz.org> <1444381799-10566-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_27605D29-B679-4A29-97CF-3334DDE85F9B"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34006 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbbJIUxp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Oct 2015 16:53:45 -0400
Received: by padhy16 with SMTP id hy16so96030246pad.1
        for <linux-ext4@vger.kernel.org>; Fri, 09 Oct 2015 13:53:45 -0700 (PDT)
In-Reply-To: <1444381799-10566-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_27605D29-B679-4A29-97CF-3334DDE85F9B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 9, 2015, at 3:09 AM, Dmitry Monakhov <dmonakhov@openvz.org> =
wrote:
>=20
> It is appeared that we can pass journal related mount options and such =
options
> be shown in /proc/mounts
>=20
> Example:
> #mkfs.ext4 -F /dev/vdb
> #tune2fs -O ^has_journal /dev/vdb
> #mount /dev/vdb /mnt/  -ocommit=3D20,journal_async_commit
> #cat /proc/mounts  | grep /mnt
> /dev/vdb /mnt ext4 =
rw,relatime,journal_checksum,journal_async_commit,commit=3D20,data=3Dorder=
ed 0 0
>=20
> But =
options:"journal_checksum,journal_async_commit,commit=3D20,data=3Dordered"=
 has
> nothing with reality because there is no jornall at all.

(typo) s/jornall/journal/

but looks reasonable otherwise.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> This patch disallow following options for journalless configurations:
> - journal_checksum
> - journal_async_commit
> - commit=3D%ld
> - data=3D{writeback,ordered,journal}
>=20
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
> fs/ext4/ext4.h  |    3 +++
> fs/ext4/super.c |   31 +++++++++++++++++++++++++++++--
> 2 files changed, 32 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3f248c9..871cdc6 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1019,6 +1019,9 @@ struct ext4_inode_info {
> #define EXT4_MOUNT2_HURD_COMPAT		0x00000004 /* Support =
HURD-castrated
> 						      file systems */
>=20
> +#define EXT4_MOUNT2_EXPLICIT_JOURNAL_CHECKSUM	0x00000008 /* =
User explicitly
> +						specified journal =
checksum */
> +
> #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &=3D \
> 						~EXT4_MOUNT_##opt
> #define set_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt |=3D \
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e91f6d4..a29b32b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1371,10 +1371,10 @@ static const struct mount_opts {
> 	{Opt_nojournal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
> 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
> 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
> -	 MOPT_EXT4_ONLY | MOPT_SET},
> +	 MOPT_EXT4_ONLY | MOPT_SET | MOPT_EXPLICIT},
> 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
> 				    EXT4_MOUNT_JOURNAL_CHECKSUM),
> -	 MOPT_EXT4_ONLY | MOPT_SET},
> +	 MOPT_EXT4_ONLY | MOPT_SET | MOPT_EXPLICIT},
> 	{Opt_noload, EXT4_MOUNT_NOLOAD, MOPT_NO_EXT2 | MOPT_SET},
> 	{Opt_err_panic, EXT4_MOUNT_ERRORS_PANIC, MOPT_SET | =
MOPT_CLEAR_ERR},
> 	{Opt_err_ro, EXT4_MOUNT_ERRORS_RO, MOPT_SET | MOPT_CLEAR_ERR},
> @@ -1506,6 +1506,8 @@ static int handle_mount_opt(struct super_block =
*sb, char *opt, int token,
> 	if (m->flags & MOPT_EXPLICIT) {
> 		if (m->mount_opt & EXT4_MOUNT_DELALLOC) {
> 			set_opt2(sb, EXPLICIT_DELALLOC);
> +		} else if (m->mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) {
> +			set_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM);
> 		} else
> 			return -1;
> 	}
> @@ -3675,6 +3677,31 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 		       "suppressed and not mounted read-only");
> 		goto failed_mount_wq;
> 	} else {
> +		/* Nojournal mode, all journal mount options are illegal =
*/
> +		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
> +			ext4_msg(sb, KERN_ERR, "can't mount with "
> +				 "journal_checksum, fs mounted w/o =
journal");
> +			goto failed_mount_wq;
> +		}
> +		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
> +			ext4_msg(sb, KERN_ERR, "can't mount with "
> +				 "journal_async_commit, fs mounted w/o =
journal");
> +			goto failed_mount_wq;
> +		}
> +		if (sbi->s_commit_interval !=3D =
JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
> +			ext4_msg(sb, KERN_ERR, "can't mount with "
> +				 "commit=3D%lu, fs mounted w/o journal",
> +				 sbi->s_commit_interval / HZ);
> +			goto failed_mount_wq;
> +		}
> +		if (EXT4_MOUNT_DATA_FLAGS &
> +		    (sbi->s_mount_opt ^ sbi->s_def_mount_opt)) {
> +			ext4_msg(sb, KERN_ERR, "can't mount with "
> +				 "data=3D, fs mounted w/o journal");
> +			goto failed_mount_wq;
> +		}
> +		sbi->s_def_mount_opt &=3D EXT4_MOUNT_JOURNAL_CHECKSUM;
> +		clear_opt(sb, JOURNAL_CHECKSUM);
> 		clear_opt(sb, DATA_FLAGS);
> 		sbi->s_journal =3D NULL;
> 		needs_recovery =3D 0;
> --
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_27605D29-B679-4A29-97CF-3334DDE85F9B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVhgpVXKl2rkXzB/gAQiEbg//XlaM8Kd7b+e7TlVsdwxKjguc1T8531vQ
jJiGZBTtBHah0E7+7S83gKUGgz4CjyJnQibG2J4TC2nCYlk4I3Bp1bHjIvfG5T6n
dACdeBrEyKReQdYGV3RN1n4/elhroEI85acQouF80cf/174jnPlkUFf9FsVvCExM
aAjxy0DHYH+BJ9z+GqNwq11m8dZPJkbOQ5se7nf2axe4ypFtiOX85dCYgE3Tqf7G
3kqzDWkX022FSd7ztxksgVCj4GaRfu4taXmCR3Oxy/VeeeISzvqjCQ3vNAfGfY4k
3vn4NrdU6R2pug1bI6q3/yrEAmuB5p+u0Fl4VQY5/Ef9c1wGcfqe4LbWYFv49EjL
0RQbuAkEnuviyx2hAntXfKF4BMd+YdilBuzoUgBQNQjfrd8xPmvXkoqFus7IER0/
TEpG41j8TbzfnieF99JhFJyUuB5DORyxMScsYtGY29ebroeX9kcb3Bj5/yTNIUof
9iOq9S+BiGDWnV8r7tmwKrThb7d70Qzb8uMFMtm99J3Y9nzkUeuxYv5pUo1kGSrT
ufgxv/VowaAo6/gCBXJ9pwKHeKc7fvrNvq+16WWz85l8+qmOkUewG0xl+XonGPIe
5413j3DEabPX3MV51jrnsEfEMcITkN+Y1juDlAipeYHoQoMw9u1WrCVPxBaTPztx
TljLFfqHw0U=
=N6HP
-----END PGP SIGNATURE-----

--Apple-Mail=_27605D29-B679-4A29-97CF-3334DDE85F9B--
