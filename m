From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] fs/ext4: create ext4_kset dynamically
Date: Mon, 27 Nov 2017 16:44:35 -0700
Message-ID: <7CD43048-B60A-43B2-BB18-F2B1432C111D@dilger.ca>
References: <20171127231801.27652-1-sirmy15@gmail.com>
 <20171127231801.27652-4-sirmy15@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_4E2CE268-9281-4C2B-B432-AED4DABC2693";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Riccardo Schirone <sirmy15@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:40909 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751731AbdK0Xok (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Nov 2017 18:44:40 -0500
Received: by mail-it0-f65.google.com with SMTP id t1so6068623ite.5
        for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2017 15:44:39 -0800 (PST)
In-Reply-To: <20171127231801.27652-4-sirmy15@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_4E2CE268-9281-4C2B-B432-AED4DABC2693
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Nov 27, 2017, at 4:18 PM, Riccardo Schirone <sirmy15@gmail.com> wrote:
> 
> ksets contain a kobject and they should always be allocated dynamically,
> because it is unknown to whoever creates them when ksets can be
> released.
> 
> Signed-off-by: Riccardo Schirone <sirmy15@gmail.com>
> ---
> fs/ext4/sysfs.c | 37 +++++++++++++++++++++++--------------
> 1 file changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index c447f23cc876..a33b406b8feb 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -329,6 +329,13 @@ static void ext4_sb_release(struct kobject *kobj)
> 	complete(&sbi->s_kobj_unregister);
> }
> 
> +static void ext4_kset_release(struct kobject *kobj)
> +{
> +	struct kset *kset = container_of(kobj, struct kset, kobj);
> +
> +	kfree(kset);
> +}
> +
> static const struct sysfs_ops ext4_attr_ops = {
> 	.show	= ext4_attr_show,
> 	.store	= ext4_attr_store,
> @@ -342,11 +349,10 @@ static struct kobj_type ext4_sb_ktype = {
> 
> static struct kobj_type ext4_ktype = {
> 	.sysfs_ops	= &ext4_attr_ops,
> +	.release	= ext4_kset_release,
> };
> 
> -static struct kset ext4_kset = {
> -	.kobj   = {.ktype = &ext4_ktype},
> -};
> +static struct kset *ext4_kset;
> 
> static struct kobj_type ext4_feat_ktype = {
> 	.default_attrs	= ext4_feat_attrs,
> @@ -391,7 +397,7 @@ int ext4_register_sysfs(struct super_block *sb)
> 	const struct ext4_proc_files *p;
> 	int err;
> 
> -	sbi->s_kobj.kset = &ext4_kset;
> +	sbi->s_kobj.kset = ext4_kset;
> 	init_completion(&sbi->s_kobj_unregister);
> 	err = kobject_init_and_add(&sbi->s_kobj, &ext4_sb_ktype, NULL,
> 				   "%s", sb->s_id);
> @@ -429,13 +435,16 @@ int __init ext4_init_sysfs(void)
> {
> 	int ret;
> 
> -	kobject_set_name(&ext4_kset.kobj, "ext4");
> -	ext4_kset.kobj.parent = fs_kobj;
> -	ret = kset_register(&ext4_kset);
> -	if (ret) {
> -		kset_unregister(&ext4_kset);
> -		return ret;
> -	}
> +	ext4_kset = kzalloc(sizeof(*ext4_kset), GFP_KERNEL);
> +	if (!ext4_kset)
> +		return -ENOMEM;
> +
> +	kobject_set_name(&ext4_kset->kobj, "ext4");
> +	ext4_kset->kobj.parent = fs_kobj;
> +	ext4_kset->kobj.ktype = &ext4_ktype;
> +	ret = kset_register(ext4_kset);
> +	if (ret)
> +		goto kset_err;
> 
> 	ext4_feat = kzalloc(sizeof(*ext4_feat), GFP_KERNEL);
> 	if (!ext4_feat) {
> @@ -443,7 +452,7 @@ int __init ext4_init_sysfs(void)
> 		goto kset_err;
> 	}
> 
> -	ext4_feat->kset = &ext4_kset;
> +	ext4_feat->kset = ext4_kset;
> 	ret = kobject_init_and_add(ext4_feat, &ext4_feat_ktype,
> 				   NULL, "features");
> 	if (ret)
> @@ -455,14 +464,14 @@ int __init ext4_init_sysfs(void)
> feat_err:
> 	kobject_put(ext4_feat);
> kset_err:
> -	kset_unregister(&ext4_kset);
> +	kset_unregister(ext4_kset);


It would be prudent in this case to set "ext4_kset = NULL" here
so that it isn't cleaned up again somewhere else.  Otherwise,
it seems possible that ext4_kset could be cleaned up twice.

Otherwise, the whole premise of this patch seems flawed.

> 	return ret;
> }
> 
> void ext4_exit_sysfs(void)
> {
> 	kobject_put(ext4_feat);
> -	kset_unregister(&ext4_kset);
> +	kset_unregister(ext4_kset);

Same here.

> 	remove_proc_entry(proc_dirname, NULL);
> 	ext4_proc_root = NULL;
> }
> --
> 2.14.3
> 


Cheers, Andreas






--Apple-Mail=_4E2CE268-9281-4C2B-B432-AED4DABC2693
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaHKNjpIg59Q01vtYRAqnMAKC/bZxtWLWSiI/uwgTwdzb+mewx4QCg5Kfr
onYkSpK9yTSe8O6oUgJQ180=
=e8kO
-----END PGP SIGNATURE-----

--Apple-Mail=_4E2CE268-9281-4C2B-B432-AED4DABC2693--
