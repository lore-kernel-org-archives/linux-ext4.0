Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639067;
	b=KKHZPuY4XWfgGp0Ee7MMbxyqR67X0mV0H49p/Jg0hc0Dau5sfjcMKe0RoSGr0UjAjADX
	 Nhz45Dn0Dal3cKaqYnsYuJ1IuR6jjqeGd6YqTy2fSZX2vCBTz7uWIncQXGKI+dJ68JFRs
	 T0j0+BFK7L6Ugw+o7JUVP8OFywnTnIO4P5MGM71H9VDkWsMWa8GJUOsGM59p5K08p44Dj
	 XM1Mi46ln0qg1of/LLRePgsu6B6q/GF6vMmUhpjlvnr19upXG2rAjzsA58h0BWs40e0uT
	 gNJiueRFfje5R9fy5Qu0SmgUwFPOqumDAUWx4/Z/ZyibHzdWxd5oZQh0sLLh1OinvKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639067;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9WgeSOC/ETIz6TLo6mYJZMYoYM0OrBvgYoBWcu61W20=;
	b=LfKQiCFY/8XzrXbeYlr+nYxlNpXscmvTtlU2BbUzNOUZS5TVZVCnJMQFoXVm7TFNiCg0
	 2YZL0BjUuyy3a9tM+0aNe6+hxpBE/Sk6aYKUPmCsBbdrD4O/qVtUHl2N3yalLk9v53qAh
	 JalWHf154YSp5+tMvZeX/Hi3uw2zyi3T5b5cL/QDIIFznfPRvXrKtx2sclCX7fyJ52Hku
	 z+8CQAE6VBkZ/Cf1XdkGGs4HfA1UwJLsXW5l3pFd6styBsbEgcO9m/dgaKemoCaruYSM8
	 YQN9QBlf3buPHvwY5p1kJbEzId2s94URO/0yLB5L+5Kki315FRuuM2B4I6GcXECs/Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H32lF2OF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB6260A380A;
	Thu, 22 Oct 2026 03:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H32lF2OF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C661F000C5;
	Thu, 22 Oct 2026 03:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639066;
	bh=9WgeSOC/ETIz6TLo6mYJZMYoYM0OrBvgYoBWcu61W20=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H32lF2OFIzjL5WlFpYm9SAZdeTgDsJIGwKcnHd+zmQJ9dmgr0Na9s7DEK7+0euGme
	 AaqlinY6cGKCot5KzDETQI844PRtZupLlpQJs/nF8XByJ2t0DzZIfUghTQ+wBjzEPi
	 ifPJPWpXrJTF3GNlfylqOnIErEtMPURBo9xgEWMZHGbfOHvX2SYlyXrTdElxTBJyDU
	 aE8dgDXP4GwRPdaXoJRRIt1QOZkb1DyNgoavjYcher4OZys2OyCWTgF2Lz4ruABprZ
	 SFb2XygsE6pIJYQ46HgBTEHd470t7Rq/hyuedl5RK9PJnLWD6P9U8Avv9uD44o2ICi
	 6zDLhnxf+QMBA==
Message-ID: <sashiko-outbox-180922@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 21/41] fs: add chown_r(), lchown_r(), fchown_r()
 and fchownat_r()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <54f57a7ac52b6b2b130b5a6e911e0998c9630da8.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <54f57a7ac52b6b2b130b5a6e911e0998c9630da8.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:45 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] fs: broken unchanged and malformed ID handling in chown_path() for=
 !MULTIUSER
- [High] fs: missing s_user_ns mapping check for UUID/GUID in chown_path()
- [Medium] fs: chown_ids_r() accepts nonzero reserved bytes for UID_R_NONE =
and -1
--

commit c1c7ee0a217eb922615794b81d3b58341468ee6f
Author: Jan Koester <jan.koester@tuxist.de>

fs: add chown_r(), lchown_r(), fchown_r() and fchownat_r()

This commit adds the chown_r(), lchown_r(), fchown_r(), and fchownat_r()
system calls accepting struct __kernel_uid_r owners and groups, and refacto=
rs
the classic chown paths to share lookup and setattr logic via struct
chown_ids and chown_path().

> diff --git a/fs/open.c b/fs/open.c
> index 6b1c14e684a93..26175b5aa8aa6 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -785,7 +785,46 @@ static inline bool setattr_vfsgid(struct iattr *attr=
, kgid_t kgid)
>  	return true;
>  }
> =20
> -int chown_common(const struct path *path, uid_t user, gid_t group)
> +/*
> + * The new owner and group of a chown. Invalid ids stand for "unchanged";
> + * @err is an error of their conversion, reported once the path is found,
> + * which keeps the classic calls' order of errors.
> + */
> +struct chown_ids {
> +	kuid_t uid;
> +	kgid_t gid;
> +	int err;
> +};
> +
> +static struct chown_ids chown_ids_classic(uid_t user, gid_t group)
> +{
> +	struct user_namespace *ns =3D current_user_ns();
> +	struct chown_ids ids =3D {
> +		.uid =3D make_kuid(ns, user),
> +		.gid =3D make_kgid(ns, group),
> +	};
> +
> +	if ((user !=3D (uid_t)-1 && !uid_valid(ids.uid)) ||
> +	    (group !=3D (gid_t)-1 && !gid_valid(ids.gid)))
> +		ids.err =3D -EINVAL;
> +	return ids;
> +}
> +
> +static int chown_ids_r(const struct __kernel_uid_r __user *user,
> +		       const struct __kernel_uid_r __user *group,
> +		       struct chown_ids *ids)
> +{
> +	struct user_namespace *ns =3D current_user_ns();
> +	int err;
> +
> +	ids->err =3D 0;
> +	err =3D get_kuid_r(ns, user, &ids->uid);
> +	if (!err)
> +		err =3D get_kgid_r(ns, group, &ids->gid);
> +	return err;
> +}

[Severity: Medium]
When userspace calls sys_chown_r(), sys_lchown_r(), sys_fchown_r(), or
sys_fchownat_r() with a struct __kernel_uid_r whose type is UID_R_NONE or
UID_R_LEGACY with legacy =3D=3D (u32)-1, can non-zero bytes in the reserved=
 union
area bypass validation?

In include/uapi/linux/uidgid_r.h, struct __kernel_uid_r documents:

    /*
     * Bytes past the member .type selects are reserved and must be zero.
     */

However, chown_ids_r() delegates to get_kuid_r() and get_kgid_r() in
kernel/uidgid_r.c, which return 0 as soon as kid_r_is_none(&id) matches,
before make_kuid_r() or make_kgid_r() calls kid_r_valid(&id):

    static bool kid_r_is_none(const struct __kernel_uid_r *id)
    {
            return id->type =3D=3D UID_R_NONE ||
                   (id->type =3D=3D UID_R_LEGACY && id->legacy =3D=3D (u32)=
-1);
    }

    int get_kuid_r(struct user_namespace *from,
                   const struct __kernel_uid_r __user *uid, kuid_t *kuid)
    {
            ...
            if (kid_r_is_none(&id))
                    return 0;
            *kuid =3D make_kuid_r(from, &id);
            return uid_valid(*kuid) ? 0 : -EINVAL;
    }

Because kid_r_is_none() does not check the 16 union bytes for UID_R_NONE or
the 12 trailing bytes (id->uuid + sizeof(id->legacy)) for UID_R_LEGACY with
legacy =3D=3D (u32)-1, shouldn't those reserved bytes be verified to be zer=
o so
that non-zero trailing bytes are rejected with -EINVAL?

> +
> +static int chown_path(const struct path *path, const struct chown_ids *i=
ds)
>  {
>  	struct mnt_idmap *idmap;
>  	struct user_namespace *fs_userns;
> @@ -793,11 +832,9 @@ int chown_common(const struct path *path, uid_t user=
, gid_t group)
>  	struct delegated_inode delegated_inode =3D { };
>  	int error;
>  	struct iattr newattrs;
> -	kuid_t uid;
> -	kgid_t gid;
> =20
> -	uid =3D make_kuid(current_user_ns(), user);
> -	gid =3D make_kgid(current_user_ns(), group);
> +	if (ids->err)
> +		return ids->err;
> =20
>  	idmap =3D mnt_idmap(path->mnt);
>  	fs_userns =3D i_user_ns(inode);
> @@ -806,9 +843,9 @@ int chown_common(const struct path *path, uid_t user,=
 gid_t group)
>  	newattrs.ia_vfsuid =3D INVALID_VFSUID;
>  	newattrs.ia_vfsgid =3D INVALID_VFSGID;
>  	newattrs.ia_valid =3D  ATTR_CTIME;
> -	if ((user !=3D (uid_t)-1) && !setattr_vfsuid(&newattrs, uid))
> +	if (uid_valid(ids->uid) && !setattr_vfsuid(&newattrs, ids->uid))
>  		return -EINVAL;
> -	if ((group !=3D (gid_t)-1) && !setattr_vfsgid(&newattrs, gid))
> +	if (gid_valid(ids->gid) && !setattr_vfsgid(&newattrs, ids->gid))
>  		return -EINVAL;

[Severity: High]
How does chown_path() handle unchanged IDs (-1, NULL, or UID_R_NONE) and
malformed IDs when CONFIG_MULTIUSER is disabled?

Previously, chown_common() checked (user !=3D (uid_t)-1) and
(group !=3D (gid_t)-1) before calling setattr_vfsuid() and setattr_vfsgid().
With this change, chown_ids_classic() and chown_ids_r() encode an unchanged
owner or group as INVALID_UID / INVALID_GID, and chown_path() uses
uid_valid(ids->uid) and gid_valid(ids->gid) to decide whether to set ATTR_U=
ID
and ATTR_GID.

In include/linux/uidgid.h, when !CONFIG_MULTIUSER, __kuid_val() and
__kgid_val() always return 0:

    static inline uid_t __kuid_val(kuid_t uid)
    {
            return 0;
    }

    static inline bool uid_valid(kuid_t uid)
    {
            return !uid_is_legacy(uid) || __kuid_val(uid) !=3D (uid_t) -1;
    }

As a result, uid_valid(INVALID_UID) and gid_valid(INVALID_GID) always return
true on !CONFIG_MULTIUSER builds:

1. Calling chown(), lchown(), fchown(), or fchownat() with -1, or calling
   chown_r(), lchown_r(), fchown_r(), or fchownat_r() with NULL, UID_R_NONE,
   or legacy -1 causes chown_path() to call setattr_vfsuid() and
   setattr_vfsgid() with INVALID_UID and INVALID_GID. That sets ATTR_UID and
   ATTR_GID in newattrs.ia_valid and copies VFSUIDT_INIT(INVALID_UID) and
   VFSGIDT_INIT(INVALID_GID) (with .legacy =3D -1) into newattrs.ia_vfsuid =
and
   newattrs.ia_vfsgid, causing notify_change() -> may_setattr() to reject
   no-op chown calls on immutable/append-only files with -EPERM and causing
   setattr_copy() to write INVALID_UID / INVALID_GID into inode->i_uid and
   inode->i_gid.

2. In chown_ids_r() -> get_kuid_r() / get_kgid_r(), malformed
   struct __kernel_uid_r inputs for which make_kuid_r() or make_kgid_r()
   returns INVALID_UID / INVALID_GID pass uid_valid(*kuid) / gid_valid(*kgi=
d)
   and return 0 instead of -EINVAL.

3. In chown_path(), because setattr_vfsuid() and setattr_vfsgid() only retu=
rn
   false when !uid_valid() or !gid_valid(), gating them with
   uid_valid(ids->uid) and gid_valid(ids->gid) also makes the two
   return -EINVAL branches unreachable.

>  	error =3D inode_lock_killable(inode);
>  	if (error)

[Severity: High]
What prevents chown_path() from setting a UUID or GUID owner or group on a
non-idmapped mount of a filesystem mounted in a non-initial user namespace
(inode->i_sb->s_user_ns !=3D &init_user_ns)?

When a process in init_user_ns calls chown_r(), lchown_r(), fchown_r(), or
fchownat_r() with a UUID or GUID on a regular mount (idmap =3D=3D &nop_mnt_=
idmap)
of a filesystem with SB_I_UID_R mounted in a child user namespace (such as
tmpfs, ramfs, devpts, or overlayfs), chown_path() calls security_path_chown=
()
with from_vfsuid() / from_vfsgid() and then calls notify_change().

In fs/attr.c:notify_change(), the superblock namespace check uses
vfsuid_has_fsmapping() and vfsgid_has_fsmapping():

    if (ia_valid & ATTR_UID &&
        !vfsuid_has_fsmapping(idmap, inode->i_sb->s_user_ns,
                              attr->ia_vfsuid))
            return -EOVERFLOW;

However, vfsuid_has_fsmapping() in include/linux/mnt_idmapping.h simply
checks uid_valid(from_vfsuid(idmap, fs_userns, vfsuid)), and from_vfsuid() =
in
fs/mnt_idmapping.c returns early for nop_mnt_idmap before checking
kuid_has_mapping(fs_userns, ...):

    kuid_t from_vfsuid(struct mnt_idmap *idmap,
                       struct user_namespace *fs_userns, vfsuid_t vfsuid)
    {
            uid_t uid;

            if (idmap =3D=3D &nop_mnt_idmap)
                    return AS_KUIDT(vfsuid);
            if (idmap =3D=3D &invalid_mnt_idmap)
                    return INVALID_UID;
            if (!vfsuid_is_legacy(vfsuid))
                    return kuid_has_mapping(fs_userns, AS_KUIDT(vfsuid)) ?
                           AS_KUIDT(vfsuid) : INVALID_UID;

Because UUID and GUID identities only have mappings in init_user_ns,
shouldn't non-legacy IDs also be checked against fs_userns when
idmap =3D=3D &nop_mnt_idmap so that notify_change() rejects them with -EOVE=
RFLOW
instead of writing an unmapped UUID or GUID to the inode?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D21
