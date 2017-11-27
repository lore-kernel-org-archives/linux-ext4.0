From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] fs/ext4: release kobject/kset even when init/register
 fail
Date: Mon, 27 Nov 2017 16:34:49 -0700
Message-ID: <C79E8778-794D-4B40-92EA-65862E290B4B@dilger.ca>
References: <20171127231801.27652-1-sirmy15@gmail.com>
 <20171127231801.27652-2-sirmy15@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_A0F3874A-40E2-4747-B20F-B1216F06113D";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Riccardo Schirone <sirmy15@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:44366 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752244AbdK0Xe6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Nov 2017 18:34:58 -0500
Received: by mail-io0-f196.google.com with SMTP id w127so38243442iow.11
        for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2017 15:34:57 -0800 (PST)
In-Reply-To: <20171127231801.27652-2-sirmy15@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A0F3874A-40E2-4747-B20F-B1216F06113D
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Nov 27, 2017, at 4:17 PM, Riccardo Schirone <sirmy15@gmail.com> wrote:
> 
> Even when kobject_init_and_add/kset_register fail, the kobject has been
> already initialized and the refcount set to 1. Thus it is necessary to
> release the kobject/kset, to avoid the memory associated with it hanging
> around forever.

This seems like a bad programming model.  It doesn't make sense if the
"init" or "register" function returns an error that you would still have
to call "put" or "unregister" on the object.  Why not just handle the
cleanup at the end of "kobject_init_and_add()" or "kobject_register()"
if there is an error instead of putting the burden on every caller?

If open() returns an error, I don't need to call close(), and if malloc()
fails I don't need to call free(), etc.

Cheers, Andreas

> Signed-off-by: Riccardo Schirone <sirmy15@gmail.com>
> ---
> fs/ext4/sysfs.c | 15 +++++++++++----
> 1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index 48c7a7d55ed3..b096e157934f 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -395,8 +395,11 @@ int ext4_register_sysfs(struct super_block *sb)
> 	init_completion(&sbi->s_kobj_unregister);
> 	err = kobject_init_and_add(&sbi->s_kobj, &ext4_sb_ktype, NULL,
> 				   "%s", sb->s_id);
> -	if (err)
> +	if (err) {
> +		kobject_put(&sbi->s_kobj);
> +		wait_for_completion(&sbi->s_kobj_unregister);
> 		return err;
> +	}
> 
> 	if (ext4_proc_root)
> 		sbi->s_proc = proc_mkdir(sb->s_id, ext4_proc_root);
> @@ -429,15 +432,19 @@ int __init ext4_init_sysfs(void)
> 	kobject_set_name(&ext4_kset.kobj, "ext4");
> 	ext4_kset.kobj.parent = fs_kobj;
> 	ret = kset_register(&ext4_kset);
> -	if (ret)
> +	if (ret) {
> +		kset_unregister(&ext4_kset);
> 		return ret;
> +	}
> 
> 	ret = kobject_init_and_add(&ext4_feat, &ext4_feat_ktype,
> 				   NULL, "features");
> -	if (ret)
> +	if (ret) {
> +		kobject_put(&ext4_feat);
> 		kset_unregister(&ext4_kset);
> -	else
> +	} else {
> 		ext4_proc_root = proc_mkdir(proc_dirname, NULL);
> +	}
> 	return ret;
> }
> 
> --
> 2.14.3
> 


Cheers, Andreas






--Apple-Mail=_A0F3874A-40E2-4747-B20F-B1216F06113D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaHKEbpIg59Q01vtYRAvKjAKDuIIxYZ/26PHXMF3ZE8UKrjwQ6ewCghXjJ
Y84YZX2cpiElT2AjZWgGZEM=
=wz8P
-----END PGP SIGNATURE-----

--Apple-Mail=_A0F3874A-40E2-4747-B20F-B1216F06113D--
