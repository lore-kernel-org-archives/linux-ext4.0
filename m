From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: More buffer head reference leaks
Date: Fri, 17 Jul 2009 12:55:49 -0700
Message-ID: <6601abe90907171255i5eb2199er4f5ec883b42cc2f7@mail.gmail.com>
References: <6601abe90907141358w3b16cdb0rb429f8d67d65dc9a@mail.gmail.com>
	 <20090715055227.GA17310@skywalker>
	 <6601abe90907150800m4924e35fi13dd4eea6fe7f327@mail.gmail.com>
	 <6601abe90907150853m73654d6dlfbdb47eb26e7d498@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:18686 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZGQTzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jul 2009 15:55:55 -0400
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id n6HJtq5l029076
	for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2009 20:55:53 +0100
Received: from pzk35 (pzk35.prod.google.com [10.243.19.163])
	by wpaz1.hot.corp.google.com with ESMTP id n6HJtoxI001286
	for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2009 12:55:50 -0700
Received: by pzk35 with SMTP id 35so777075pzk.33
        for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2009 12:55:50 -0700 (PDT)
In-Reply-To: <6601abe90907150853m73654d6dlfbdb47eb26e7d498@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Any comment on the patch below?  Ted?

Thanks,
Curt


On Wed, Jul 15, 2009 at 8:53 AM, Curt Wohlgemuth<curtw@google.com> wrot=
e:
> I've cleaned up the patch to
> =A0 - fix the comment in ext4_alloc_branch()
> =A0 - change ext4_add_entry() to remove the gotos and label
>
>
> =A0 =A0 =A0 Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>
> ---
> diff -Naur orig/fs/ext4/inode.c new/fs/ext4/inode.c
> --- orig/fs/ext4/inode.c =A0 =A0 =A0 =A02009-07-14 11:19:01.000000000=
 -0700
> +++ new/fs/ext4/inode.c 2009-07-15 08:12:15.000000000 -0700
> @@ -758,8 +758,9 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUFFER_TRACE(bh, "call get_create_acce=
ss");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_journal_get_create_access=
(handle, bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Don't brelse(bh) her=
e; it's done in
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ext4_journal_forge=
t() below */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unlock_buffer(bh);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> diff -Naur orig/fs/ext4/namei.c new/fs/ext4/namei.c
> --- orig/fs/ext4/namei.c =A0 =A0 =A0 =A02009-07-14 11:19:46.000000000=
 -0700
> +++ new/fs/ext4/namei.c 2009-07-15 08:12:09.000000000 -0700
> @@ -1518,8 +1518,12 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return retval;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (blocks =3D=3D 1 && !dx_fallback &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_HAS_COMPAT_FEATURE(sb, EXT=
4_FEATURE_COMPAT_DIR_INDEX))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return make_indexed_dir=
(handle, dentry, inode, bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_HAS_COMPAT_FEATURE(sb, EXT=
4_FEATURE_COMPAT_DIR_INDEX)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D make_indexed=
_dir(handle, dentry, inode, bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retval =3D=3D -ENOS=
PC)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(=
bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return retval;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brelse(bh);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0bh =3D ext4_append(handle, dir, &block, &retval);
> @@ -1528,7 +1532,10 @@
> =A0 =A0 =A0 =A0de =3D (struct ext4_dir_entry_2 *) bh->b_data;
> =A0 =A0 =A0 =A0de->inode =3D 0;
> =A0 =A0 =A0 =A0de->rec_len =3D ext4_rec_len_to_disk(blocksize, blocks=
ize);
> - =A0 =A0 =A0 return add_dirent_to_buf(handle, dentry, inode, de, bh)=
;
> + =A0 =A0 =A0 retval =3D add_dirent_to_buf(handle, dentry, inode, de,=
 bh);
> + =A0 =A0 =A0 if (retval =3D=3D -ENOSPC)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(bh);
> + =A0 =A0 =A0 return retval;
> =A0}
>
> =A0/*
> @@ -1657,7 +1664,8 @@
> =A0 =A0 =A0 =A0if (!de)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cleanup;
> =A0 =A0 =A0 =A0err =3D add_dirent_to_buf(handle, dentry, inode, de, b=
h);
> - =A0 =A0 =A0 bh =3D NULL;
> + =A0 =A0 =A0 if (err !=3D -ENOSPC)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D NULL;
> =A0 =A0 =A0 =A0goto cleanup;
>
> =A0journal_error:
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
