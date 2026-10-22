Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639065;
	b=c/p6afNNatO9f92xdfLbrEzKgE6vpaGpm2nf/2p0CcRRNwwiUy7vbAJEno2kjNw5h3jt
	 9A6yibIaDQeMy66gOPVqJCxU98JzOdMz3irA74uUEffcVo7Ujsd641MiXtGHhXtLVujEs
	 1bJ/7XLaYUjX0gRqDaHyGKBN5ubdlaUTklFhDnNrvOMnjdx6Yl7vrIfE2qr+7lsiksjSK
	 geVRGEWyh7ygkASOjUhFKYAdOgjNLtjp34AjKdIlHWBQV792wsbfIcdhSYUUgBqpvaRr8
	 zyZDxkVgZvJyuwTCEdYG2fhFBYeCo9bNBKQeIrzrJ8RE5LJVAOdaikOtBPpoaKLOGhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639065;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=n5sfMBMc46bCwlPnwgR2r8aOeUknbjiXXn3azg3y9M8=;
	b=BirDOYbVZxQ6+QIBVp0fYHXIChVJjZ96/EohjNlG2Zbyz8zy5WjdRTgqCYzUoU6602dI
	 Baey9DvzMyWCL6VqaCzOYH/A28Aj/4ppWfsHjNlAcwMDSGzxvGZKsTkDcAjShfRh424O4
	 3VP1Y9e2UNlOPEu/0wfLH/b0Af+AZxWZxrZSLZXGFEPbx3WiRd0fefmF2bB7nX7AlE446
	 j4JcZPIkI/UBLxQgU0TUW1yrwkdzDf5/zEZynjxbmL9oZkSZBnpau/YN7AyANmcbaSNpS
	 gmLYdg/3Yj5H+uWlnJV+FNiNjlZMwwAn04yXhSKqCsHeoM8FWlwliBzLONuhlgqoJLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=keEGoewQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29CC606A321;
	Thu, 22 Oct 2026 03:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=keEGoewQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE651F000C8;
	Thu, 22 Oct 2026 03:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639064;
	bh=n5sfMBMc46bCwlPnwgR2r8aOeUknbjiXXn3azg3y9M8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=keEGoewQt26g54zcGstdJwL50bljDf0Ro5j1SuppsT2SDXO5ZhHct5fs1SM8KiGTL
	 Y5b3w2HTPk9nEffqfOVx+fnrtjH4uNVhhYEwPdAsUZWdWpBD9RJe8g1npd6kr0a1ji
	 n9dROyTWA4spnQ9O9nmyNydCwxk2RWhYFkzoar7abK+kZ1PPcIg/unSW4ZWr/zWc6/
	 2KIp2caPbGj5jbDE5XdtxVmwnkLqX5ihUiCgBNuhpgXBJarv/WeOlHeKTrUXiDjf9B
	 Vo+sbbhY5x/IKNFUqTRLbYbZnxo1Q62V+eAx9BXeK8xa8s3XkzgI+Z4eidiiY6ftZN
	 GrKabTOPumbyA==
Message-ID: <sashiko-outbox-180920@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 19/41] cred: add the *_r variants of the
 get/set*id() system calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <86c66380f2654c560e747b9075edbddd610975ca.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <86c66380f2654c560e747b9075edbddd610975ca.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:43 +0000
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
- [Medium] cred: setfsuid_r() and setfsgid_r() commit creds before copying =
old id
--

commit ce14b103e65ee744fe87b48cff6d5ebb9dda8c50
Author: Jan Koester <jan.koester@tuxist.de>

cred: add the *_r variants of the get/set*id() system calls

This patch adds *_r variants of the get/set*id() system calls that accept
and return pointers to __kernel_uid_r so processes can use UUID or GUID
user and group identifiers. It also splits the classic syscall
implementations into argument conversion helpers and shared do_*()
functions operating on kuid_t and kgid_t.

> diff --git a/kernel/sys.c b/kernel/sys.c
> index 35b538ba843c7..fad55732345de 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c

[ ... ]

> @@ -901,40 +933,44 @@ SYSCALL_DEFINE3(getresgid, gid_t __user *, rgidp, g=
id_t __user *, egidp, gid_t _
>   * whatever uid it wants to). It normally shadows "euid", except when
>   * explicitly set by setfsuid() or for access..
>   */
> -long __sys_setfsuid(uid_t uid)
> +/*
> + * Sets the fsuid to @kuid, unless it is invalid; 0 or -EPERM. The fsuid
> + * before the call goes to @old.
> + */
> +static long do_setfsuid(kuid_t kuid, kuid_t *old_fsuid)
>  {
>  	const struct cred *old;
>  	struct cred *new;
> -	uid_t old_fsuid;
> -	kuid_t kuid;
> =20
>  	old =3D current_cred();
> -	old_fsuid =3D from_kuid_munged(old->user_ns, old->fsuid);
> +	*old_fsuid =3D old->fsuid;
> =20
> -	kuid =3D make_kuid(old->user_ns, uid);
> -	if (!uid_valid(kuid))
> -		return old_fsuid;
> +	if (!uid_valid(kuid) || uid_eq(kuid, old->fsuid))
> +		return 0;
> =20
>  	new =3D prepare_creds();
>  	if (!new)
> -		return old_fsuid;
> +		return -ENOMEM;
> =20
>  	if (uid_eq(kuid, old->uid)  || uid_eq(kuid, old->euid)  ||
> -	    uid_eq(kuid, old->suid) || uid_eq(kuid, old->fsuid) ||
> +	    uid_eq(kuid, old->suid) ||
>  	    ns_capable_setid(old->user_ns, CAP_SETUID)) {
> -		if (!uid_eq(kuid, old->fsuid)) {
> -			new->fsuid =3D kuid;
> -			if (security_task_fix_setuid(new, old, LSM_SETID_FS) =3D=3D 0)
> -				goto change_okay;
> -		}
> +		new->fsuid =3D kuid;
> +		if (security_task_fix_setuid(new, old, LSM_SETID_FS) =3D=3D 0)
> +			return commit_creds(new);
>  	}
> =20
>  	abort_creds(new);
> -	return old_fsuid;
> +	return -EPERM;
> +}

[ ... ]

> @@ -945,46 +981,214 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
>  /*
>   * Samma p=C3=A5 svenska..
>   */
> -long __sys_setfsgid(gid_t gid)
> +/*
> + * Sets the fsgid to @kgid, unless it is invalid; 0 or -EPERM. The fsgid
> + * before the call goes to @old.
> + */
> +static long do_setfsgid(kgid_t kgid, kgid_t *old_fsgid)
>  {
>  	const struct cred *old;
>  	struct cred *new;
> -	gid_t old_fsgid;
> -	kgid_t kgid;
> =20
>  	old =3D current_cred();
> -	old_fsgid =3D from_kgid_munged(old->user_ns, old->fsgid);
> +	*old_fsgid =3D old->fsgid;
> =20
> -	kgid =3D make_kgid(old->user_ns, gid);
> -	if (!gid_valid(kgid))
> -		return old_fsgid;
> +	if (!gid_valid(kgid) || gid_eq(kgid, old->fsgid))
> +		return 0;
> =20
>  	new =3D prepare_creds();
>  	if (!new)
> -		return old_fsgid;
> +		return -ENOMEM;
> =20
>  	if (gid_eq(kgid, old->gid)  || gid_eq(kgid, old->egid)  ||
> -	    gid_eq(kgid, old->sgid) || gid_eq(kgid, old->fsgid) ||
> +	    gid_eq(kgid, old->sgid) ||
>  	    ns_capable_setid(old->user_ns, CAP_SETGID)) {
> -		if (!gid_eq(kgid, old->fsgid)) {
> -			new->fsgid =3D kgid;
> -			if (security_task_fix_setgid(new,old,LSM_SETID_FS) =3D=3D 0)
> -				goto change_okay;
> -		}
> +		new->fsgid =3D kgid;
> +		if (security_task_fix_setgid(new, old, LSM_SETID_FS) =3D=3D 0)
> +			return commit_creds(new);
>  	}
> =20
>  	abort_creds(new);
> -	return old_fsgid;
> +	return -EPERM;
> +}

[ ... ]

> +/*
> + * Unlike setfsuid(), which returns the old fsuid whatever happens,
> + * setfsuid_r() reports failure: 0, or -EPERM if the caller may not use
> + * @uid. The fsuid before the call goes to @old_uid unless it is NULL; a
> + * NULL @uid only queries it.
> + */
> +SYSCALL_DEFINE2(setfsuid_r, const struct __kernel_uid_r __user *, uid,
> +		struct __kernel_uid_r __user *, old_uid)
> +{
> +	struct user_namespace *ns =3D current_user_ns();
> +	kuid_t kuid, old_fsuid;
> +	int err;
> +
> +	err =3D get_kuid_r(ns, uid, &kuid);
> +	if (err)
> +		return err;
> +	err =3D do_setfsuid(kuid, &old_fsuid);
> +	if (!err && old_uid)
> +		err =3D put_kuid_r(ns, old_fsuid, old_uid);
> +	return err;
> +}
> +
> +SYSCALL_DEFINE2(setfsgid_r, const struct __kernel_uid_r __user *, gid,
> +		struct __kernel_uid_r __user *, old_gid)
> +{
> +	struct user_namespace *ns =3D current_user_ns();
> +	kgid_t kgid, old_fsgid;
> +	int err;
> +
> +	err =3D get_kgid_r(ns, gid, &kgid);
> +	if (err)
> +		return err;
> +	err =3D do_setfsgid(kgid, &old_fsgid);
> +	if (!err && old_gid)
> +		err =3D put_kgid_r(ns, old_fsgid, old_gid);
> +	return err;
> +}

[Severity: Medium]
In kernel/sys.c, if a caller invokes setfsuid_r() or setfsgid_r() with a
valid, permitted uid or gid that differs from the current fsuid or fsgid and
passes a non-NULL old_uid or old_gid pointer that faults during
copy_to_user(), will the syscall return -EFAULT after the new credentials
have already been irreversibly installed?

Specifically, setfsuid_r() calls do_setfsuid(), which updates new->fsuid,
runs security_task_fix_setuid(new, old, LSM_SETID_FS), and calls
commit_creds(new) before put_kuid_r() copies old_fsuid to old_uid (and
similarly for setfsgid_r(), do_setfsgid(), and put_kgid_r()).

If copy_to_user() inside put_kuid_r() or put_kgid_r() fails, the task is le=
ft
with its mutated fsuid or fsgid, altered filesystem capabilities, updated
dumpability, and updated thread keyrings even though the syscall reports
failure and the previous ID is lost. Could old_fsuid and old_fsgid be copied
to userspace before committing the new credentials?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D19
