Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43873 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbeLJUS3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2018 15:18:29 -0500
Received: by mail-pl1-f196.google.com with SMTP id gn14so5756101plb.10
        for <linux-ext4@vger.kernel.org>; Mon, 10 Dec 2018 12:18:29 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <C2F1A10B-9035-409F-AF7C-EDCF9C1648C3@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_9EE5F8AA-C1E8-4F4B-A917-1629EA14F85D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2] fs: Convert open-coded "is inode open for write" check
Date: Mon, 10 Dec 2018 13:18:25 -0700
In-Reply-To: <20181210132500.10864-1-nborisov@suse.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>, jmorris@namei.org,
        jlayton@kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
To: Nikolay Borisov <nborisov@suse.com>
References: <20181210131903.4528-1-nborisov@suse.com>
 <20181210132500.10864-1-nborisov@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_9EE5F8AA-C1E8-4F4B-A917-1629EA14F85D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 10, 2018, at 6:25 AM, Nikolay Borisov <nborisov@suse.com> wrote:
>=20
> There is a generic helper inode_is_open_for_write that could be used
> when checking i_writecount. Use it instead of opencoding
> if (i_writecount > 0) check.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>=20
> Changes v2:
> * This time actually compile-tested it, doh...
>=20
>=20
> fs/ext4/inode.c                    | 2 +-
> fs/ext4/mballoc.c                  | 7 +++----
> fs/locks.c                         | 2 +-
> fs/notify/fanotify/fanotify_user.c | 2 +-
> security/integrity/ima/ima_main.c  | 2 +-
> 5 files changed, 7 insertions(+), 8 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 22a9d8159720..04e5bc0b5c8d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -391,7 +391,7 @@ void ext4_da_update_reserve_space(struct inode =
*inode,
> 	 * inode's preallocations.
> 	 */
> 	if ((ei->i_reserved_data_blocks =3D=3D 0) &&
> -	    (atomic_read(&inode->i_writecount) =3D=3D 0))
> +	    !inode_is_open_for_write(inode))
> 		ext4_discard_preallocations(inode);
> }
>=20
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e2248083cdca..b811a9cb896e 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4176,9 +4176,8 @@ static void ext4_mb_group_or_file(struct =
ext4_allocation_context *ac)
> 	isize =3D (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - =
1)
> 		>> bsbits;
>=20
> -	if ((size =3D=3D isize) &&
> -	    !ext4_fs_is_busy(sbi) &&
> -	    (atomic_read(&ac->ac_inode->i_writecount) =3D=3D 0)) {
> +	if ((size =3D=3D isize) && !ext4_fs_is_busy(sbi)
> +	    && !inode_is_open_for_write(ac->ac_inode)) {

If you will note the other cases in this patch, the "&&" operator should =
go
at the end of the previous line, instead of the start of the continued =
line.

Cheers, Andreas

> 		ac->ac_flags |=3D EXT4_MB_HINT_NOPREALLOC;
> 		return;
> 	}
> @@ -4258,7 +4257,7 @@ ext4_mb_initialize_context(struct =
ext4_allocation_context *ac,
> 			(unsigned) ar->goal, ac->ac_flags, =
ac->ac_2order,
> 			(unsigned) ar->lleft, (unsigned) ar->pleft,
> 			(unsigned) ar->lright, (unsigned) ar->pright,
> -			atomic_read(&ar->inode->i_writecount) ? "" : =
"non-");
> +			inode_is_open_for_write(ar->inode) ? "" : =
"non-");
> 	return 0;
>=20
> }
> diff --git a/fs/locks.c b/fs/locks.c
> index 2ecb4db8c840..16ea7d89a67d 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1646,7 +1646,7 @@ check_conflicting_open(const struct dentry =
*dentry, const long arg, int flags)
> 	if (flags & FL_LAYOUT)
> 		return 0;
>=20
> -	if ((arg =3D=3D F_RDLCK) && (atomic_read(&inode->i_writecount) > =
0))
> +	if ((arg =3D=3D F_RDLCK) && inode_is_open_for_write(inode))
> 		return -EAGAIN;
>=20
> 	if ((arg =3D=3D F_WRLCK) && ((d_count(dentry) > 1) ||
> diff --git a/fs/notify/fanotify/fanotify_user.c =
b/fs/notify/fanotify/fanotify_user.c
> index e03be5071362..98b0769e4cf2 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -669,7 +669,7 @@ static int fanotify_add_inode_mark(struct =
fsnotify_group *group,
> 	 */
> 	if ((flags & FAN_MARK_IGNORED_MASK) &&
> 	    !(flags & FAN_MARK_IGNORED_SURV_MODIFY) &&
> -	    (atomic_read(&inode->i_writecount) > 0))
> +	    inode_is_open_for_write(inode))
> 		return 0;
>=20
> 	return fanotify_add_mark(group, &inode->i_fsnotify_marks,
> diff --git a/security/integrity/ima/ima_main.c =
b/security/integrity/ima/ima_main.c
> index 1b88d58e1325..05fbf8a2fa42 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -103,7 +103,7 @@ static void ima_rdwr_violation_check(struct file =
*file,
> 	} else {
> 		if (must_measure)
> 			set_bit(IMA_MUST_MEASURE, &iint->atomic_flags);
> -		if ((atomic_read(&inode->i_writecount) > 0) && =
must_measure)
> +		if (inode_is_open_for_write(inode) && must_measure)
> 			send_writers =3D true;
> 	}
>=20
> --
> 2.17.1
>=20


Cheers, Andreas






--Apple-Mail=_9EE5F8AA-C1E8-4F4B-A917-1629EA14F85D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwOyhEACgkQcqXauRfM
H+DMQRAAlvYnyuEgpMxEvTJjpqOrRviRqc1o/MVYMjG2FYYDvClzOGvN61aptfSi
xHar6ErrCE2a15BIzuhKYBYkTEbYEMo36EzxGz5JGh4P21V3aielddiZ7/JBfjLM
lJ99SelgXxZahH0d7Vh6fDUVY22L3iaJS9D1q45cIc8EcaN8yp7JpDg/0YyWitWf
Mfdtn1mPaNnPYkfRTCFm03kzFRY3tVw3HtikFoVyCJBSdzgscoovfVifjzjtlmt9
LNq6Nd69x7Jwn64KSv/KgZ3QGoCezI5tGbpG9grhgnuPWJTYtshphGW2qMWFPrxA
Xi1ueNhtL/mZb3xskkxlifBl0aj9bY7vpy9OLHlHSue6bVuyhqFbPp+8w4FB8JmV
xT0hlV1uK5y5o4sgQMlwYHPJg2WJtGnSypObukRjT7QZqMkCLT3fEhXSJOrsu84b
nJ3U+6v6uFcHpcguzalzkNqPpvOAWFkQFb9oSKgpUo5hq6cFkW82OJp/v+xm0zSi
pF7DSFAWKGCGkQ2N4gVU86SZLnug8Ao49SuSBrtWT1oLjjhENZfdm1n3DCoj7yPr
hOobSvWo4oRQBmLV4fL47k/k4Gxhkz7S28h9LLyQl6cMGshVb3C2KlB4CTQSeezv
SmoZABr1HScHkyBKUQ4zst8PQt+SedC4aJmkqmPxWEJKvBDD38E=
=zEA3
-----END PGP SIGNATURE-----

--Apple-Mail=_9EE5F8AA-C1E8-4F4B-A917-1629EA14F85D--
