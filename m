Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639057;
	b=L6rfyYgG4bBH52TG51fEZe+oABul5ut5fh1NEXBRb+ujwHct6iFrdag8wmA3zapr74GJ
	 P1YnxqsKNlabENJttL+2sYl3MSJ0zXlsBXOpUzx74RqmfTZw6J0rP6hJhhxWE44p9PttZ
	 /TWwHc9JNrPjqKYvGxEIk/zZHPzzid3NHmOVUIq1cDTsW/WbkJQebk9XPMDW0GN4stCE0
	 +nD2gMU7O/2O/T8rTiK7iUDuHsuCxUUYVQRUYkPwH/2/CjU02FU+oSlkEx0tnjnv3wCCJ
	 A4flYTLDNk/ssPG0UZyGa8tgFNQ4gEz2vaBSxHuvF1bYCr49IbptXPDyuo36IF+KKjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639057;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7kvwWqsc/E3TbB/l8xLpC+qjrTGTmDvI2yVFdHoK7NI=;
	b=WJwdjDjJWKzzp2nsWCphAok97Jfs0Eb9iCkk+3T7bZDZkOAwx/cT/2eOMj7/lTDzucrw
	 /Vas0Qh0dAit3Rc45m0Z6hHBoxMcriHBrhuU1uzsVK282lh7YKOgLxqZmV8J7vQ4oXsJy
	 dORQNmnqqHaWTQTahqXR3okpilHa40dGMeZP2HrVcepK10+d+HsbIO6FhlLRv7kRvPTpR
	 iUuVMfo28SzOknwcsLkqCWFqXCpeY8I3qf2m9JR85+KIYFGNVwcIKVt/uByqeVSrFXsGl
	 p/gPIZWz5OQGnZ7ZFyX+vnVVHJJndyDum6hRTzEcudK5xyOQkOa/o5HasICbgUmWxPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mw2quhdU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D0B60A261A;
	Thu, 22 Oct 2026 03:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mw2quhdU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC831F000C1;
	Thu, 22 Oct 2026 03:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639056;
	bh=7kvwWqsc/E3TbB/l8xLpC+qjrTGTmDvI2yVFdHoK7NI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mw2quhdUleS8h8Z4qZst9qhuQTou49qGBcm2q640OdoGbhJEusGZXW9c3Ey692YJf
	 GlP9D5MmSx5juHjxEMNdegCqXzS3+WFNrbbxhGkwvoPuGaG12BZTq+nvYVom464O86
	 6dctA9jVi+CTuX8MQj/DzKmBtqjZ/5J7/tWB2/0xX44MpwKbTleh2DRaeMrszrc9Wt
	 iiFQyj9vmEllUaTaqepf757o1IhIM6Kr+u82AgYn/FkME1FpDOyI6jdZaw9vC+PAqx
	 zVL+tP84JJn7sU3JdRTaTgNhL2vgN0j+Lz8RafVU+SD7lwc/3HRzSVK9ar6T4bhshy
	 qyTIrfGJq9vlQ==
Message-ID: <sashiko-outbox-180913@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 12/41] keys: name per-user keyrings of UUID and
 GUID users by the whole uid
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <54affe23a0160331a14a3e993ea30b0d5af7df1a.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <54affe23a0160331a14a3e993ea30b0d5af7df1a.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:35 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] keys: uid_valid() and gid_valid() break keyctl_chown_kid() on !M=
ULTIUSER
--

commit c0c4afc7a2fd311f54c5213f50fd53f5acbdc3b8
Author: Jan Koester <jan.koester@tuxist.de>

keys: name per-user keyrings of UUID and GUID users by the whole uid

This commit names per-user and persistent keyrings of UUID and GUID users
using kuid_str() instead of -1, passes the text form to request-key, and
adds KEYCTL_CHOWN_R to support changing key ownership using __kernel_uid_r
identifiers.

> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index d14ace88e529c..984c9c54a51ff 100644
> --- a/security/keys/keyctl.c
> +++ b/security/keys/keyctl.c
> @@ -946,26 +946,17 @@ long keyctl_read_key(key_serial_t keyid, char __use=
r *buffer, size_t buflen)
>   *
>   * If successful, 0 will be returned.
>   */
> -long keyctl_chown_key(key_serial_t id, uid_t user, gid_t group)
> +static long keyctl_chown_kid(key_serial_t id, kuid_t uid, kgid_t gid)
>  {
>  	struct key_user *newowner, *zapowner =3D NULL;
>  	struct key *key;
>  	key_ref_t key_ref;
>  	long ret;
> -	kuid_t uid;
> -	kgid_t gid;
>  	unsigned long flags;
> =20
> -	uid =3D make_kuid(current_user_ns(), user);
> -	gid =3D make_kgid(current_user_ns(), group);
> -	ret =3D -EINVAL;
> -	if ((user !=3D (uid_t) -1) && !uid_valid(uid))
> -		goto error;
> -	if ((group !=3D (gid_t) -1) && !gid_valid(gid))
> -		goto error;
> -
> +	/* invalid ids leave the owner or group unchanged */
>  	ret =3D 0;
> -	if (user =3D=3D (uid_t) -1 && group =3D=3D (gid_t) -1)
> +	if (!uid_valid(uid) && !gid_valid(gid))
>  		goto error;
> =20
>  	key_ref =3D lookup_user_key(id, KEY_LOOKUP_CREATE | KEY_LOOKUP_PARTIAL,
> @@ -985,12 +976,12 @@ long keyctl_chown_key(key_serial_t id, uid_t user, =
gid_t group)
>  		bool is_privileged_op =3D false;
> =20
>  		/* only the sysadmin can chown a key to some other UID */
> -		if (user !=3D (uid_t) -1 && !uid_eq(key->uid, uid))
> +		if (uid_valid(uid) && !uid_eq(key->uid, uid))
>  			is_privileged_op =3D true;
> =20
>  		/* only the sysadmin can set the key's GID to a group other
>  		 * than one of those that the current process subscribes to */
> -		if (group !=3D (gid_t) -1 && !gid_eq(gid, key->gid) && !in_group_p(gid=
))
> +		if (gid_valid(gid) && !gid_eq(gid, key->gid) && !in_group_p(gid))
>  			is_privileged_op =3D true;
> =20
>  		if (is_privileged_op && !capable(CAP_SYS_ADMIN))
> @@ -998,7 +989,7 @@ long keyctl_chown_key(key_serial_t id, uid_t user, gi=
d_t group)
>  	}
> =20
>  	/* change the UID */
> -	if (user !=3D (uid_t) -1 && !uid_eq(uid, key->uid)) {
> +	if (uid_valid(uid) && !uid_eq(uid, key->uid)) {
>  		ret =3D -ENOMEM;
>  		newowner =3D key_user_lookup(uid);
>  		if (!newowner)
> @@ -1042,7 +1033,7 @@ long keyctl_chown_key(key_serial_t id, uid_t user, =
gid_t group)
>  	}
> =20
>  	/* change the GID */
> -	if (group !=3D (gid_t) -1)
> +	if (gid_valid(gid))
>  		key->gid =3D gid;
> =20
>  	notify_key(key, NOTIFY_KEY_SETATTR, 0);
> @@ -1063,6 +1054,39 @@ long keyctl_chown_key(key_serial_t id, uid_t user,=
 gid_t group)
>  	goto error_put;
>  }
> =20
> +long keyctl_chown_key(key_serial_t id, uid_t user, gid_t group)
> +{
> +	kuid_t uid =3D make_kuid(current_user_ns(), user);
> +	kgid_t gid =3D make_kgid(current_user_ns(), group);
> +
> +	if ((user !=3D (uid_t) -1) && !uid_valid(uid))
> +		return -EINVAL;
> +	if ((group !=3D (gid_t) -1) && !gid_valid(gid))
> +		return -EINVAL;
> +	return keyctl_chown_kid(id, uid, gid);
> +}
> +
> +/*
> + * KEYCTL_CHOWN with __kernel_uid_r_t ids, which can be UUIDs and GUIDs.=
 A
> + * NULL pointer, UID_R_NONE or a classic -1 leave the owner or group
> + * unchanged.
> + */
> +long keyctl_chown_key_r(key_serial_t id,
> +			const struct __kernel_uid_r __user *user,
> +			const struct __kernel_uid_r __user *group)
> +{
> +	kuid_t uid;
> +	kgid_t gid;
> +	long ret;
> +
> +	ret =3D get_kuid_r(current_user_ns(), user, &uid);
> +	if (!ret)
> +		ret =3D get_kgid_r(current_user_ns(), group, &gid);
> +	if (ret)
> +		return ret;
> +	return keyctl_chown_kid(id, uid, gid);
> +}

[Severity: Medium]
Does replacing the explicit (uid_t)-1 and (gid_t)-1 checks in
security/keys/keyctl.c:keyctl_chown_kid() with uid_valid() and gid_valid()
introduce a regression when CONFIG_MULTIUSER is disabled?

In include/linux/uidgid.h, when CONFIG_MULTIUSER is not enabled,
__kuid_val() and __kgid_val() unconditionally return 0:

    #ifdef CONFIG_MULTIUSER
    ...
    #else
    static inline uid_t __kuid_val(kuid_t uid)
    {
            return 0;
    }

    static inline gid_t __kgid_val(kgid_t gid)
    {
            return 0;
    }
    #endif

    static inline bool uid_valid(kuid_t uid)
    {
            return !uid_is_legacy(uid) || __kuid_val(uid) !=3D (uid_t) -1;
    }

    static inline bool gid_valid(kgid_t gid)
    {
            return !gid_is_legacy(gid) || __kgid_val(gid) !=3D (gid_t) -1;
    }

Because INVALID_UID and INVALID_GID have type KID_LEGACY and __kuid_val() /
__kgid_val() return 0 under !CONFIG_MULTIUSER, uid_valid(INVALID_UID) and
gid_valid(INVALID_GID) always evaluate to true.

When userspace invokes keyctl(KEYCTL_CHOWN) or keyctl(KEYCTL_CHOWN_R) on a
kernel built with CONFIG_KEYS=3Dy and CONFIG_MULTIUSER=3Dn:

1. Calling keyctl_chown_key() with user =3D=3D -1 and group =3D=3D -1, or c=
alling
   keyctl_chown_key_r() with NULL, UID_R_NONE, or -1 for both arguments,
   passes INVALID_UID and INVALID_GID into keyctl_chown_kid(). Because
   !uid_valid(uid) && !gid_valid(gid) is false, the no-op early return is
   skipped. It then calls lookup_user_key() with KEY_LOOKUP_CREATE (which
   can allocate a keyring or fail with -ENOKEY or -EACCES), overwrites
   key->gid with INVALID_GID, and posts a spurious NOTIFY_KEY_SETATTR watch
   notification.

2. Calling keyctl_chown_key() or keyctl_chown_key_r() to change only the
   owner while leaving the group unchanged (-1, NULL, or UID_R_NONE) passes
   gid =3D INVALID_GID into keyctl_chown_kid(), where if (gid_valid(gid))
   evaluates to true and clobbers key->gid with INVALID_GID.

3. In keyctl_chown_key_r() -> get_kuid_r() / get_kgid_r() in
   kernel/uidgid_r.c:

    *kuid =3D make_kuid_r(from, &id);
    return uid_valid(*kuid) ? 0 : -EINVAL;

   Malformed __kernel_uid_r inputs that cause make_kuid_r() or make_kgid_r()
   to return INVALID_UID or INVALID_GID will pass the uid_valid() /
   gid_valid() check and return 0 instead of -EINVAL.

Would it make sense for uid_valid() and gid_valid() (or __kuid_val() and
__kgid_val()) to preserve the -1 check for INVALID_UID and INVALID_GID when
!CONFIG_MULTIUSER, or to check for unchanged IDs explicitly?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D12
