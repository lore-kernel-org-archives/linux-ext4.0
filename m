Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639060;
	b=IBI8JYeF+j90Emyt/aG5W5a5Ll553oxS7wa2xRAQuhx4deKhYIIlmukMqMPgRV3NWbM6
	 SN8/9JMRkuVuCYesX3FakWl3+k3hb9Nblc8Gbu0Gdh4QUxBDqPMe0PnnZJnsiD6rzBqcb
	 dgS6NZRde9hZolsfrlS1N59Cwq7D1lftKxaQQPujVr2IUPrvhuWgER+Z131AreZL9AHpG
	 TTjJrauRJshMxVv8tmLBtOEDUvQ2F5Ujo8+FSQ5AEG7h7VouNobzRkOThGV9KA2RMPNz+
	 4i6MG52JnKSqYNvi1DyLtRuotjUYi1RyaeYGTNBo4+k0q5rTliaahyUCcO/zmLZ1sTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639060;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XHilr4ZYzm71A6ybW4DdPhmTDkaYPHxPvtQXkP5Bie0=;
	b=H/rriMtLZ3OGNXrgsiqxxSj7xJo6ag0cp7PNkQps+XZOydTcxSuCRS/ZTLipkmtsFJ61
	 rj7kDM6wgS0ITFygjDlE5ib6jhPZozAtb0Dr1/t9izFjqOmhIaH9ZaRlyY2KkVNzUabqM
	 khoXanSO9wLO4hvAup7a3MTZ0QebRZuzZy1RxvUtIG+9fjB0Qtw+GEVtTe8BYV/Wbuxc0
	 QTVjJzK5rhQ4nq3YM3WBJszc3yhmuXO9ZWzL+3PSBIMgD3OQnOAz7bBvGgGYvogCYamEF
	 uRP8UiopS8eqK8JJXE+2nE5mK+VaEd0aSL1mUIMPm2Enbxw81ol3RXTgdlTVX2Ht4OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gqtoZhEX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F68D60A3822;
	Thu, 22 Oct 2026 03:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gqtoZhEX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EA31F000C4;
	Thu, 22 Oct 2026 03:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639054;
	bh=XHilr4ZYzm71A6ybW4DdPhmTDkaYPHxPvtQXkP5Bie0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gqtoZhEX1q7QVBjbcH4o+vlQYaIJ4Bow71CiX2IW9UO29PBKNz+EFcDPCcaH02Sqo
	 Sdr2XPPrCwwMJYw9wbFpwYEtLwvBE8plemhO9DPV1vOt0Ou8b33DaBCHE+MLdbJ9Rf
	 rOBc+6s8rbQcXQzJXqv1DoceJKHbqgc8E77ZPz8LWRSL0BtN50JfGolvYXCPrQq7hp
	 9LbKlnhe9qxUmI6kRuMIUvdRbcgmYEYqfg4XfLRl0Rvz8t8edbFO5G63vzTnFJe6fM
	 +gkUMMVxPWh4ctEZn4emq1wNE3Z1lUI0kQ5vNz1bDgjj8ARNEhDfAVjpZwyPxeJXME
	 DVy2ofDy8gSGQ==
Message-ID: <sashiko-outbox-180911@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 10/41] uidgid: convert between kernel ids and the
 ids of the *_r system calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <42176587b0491de4d74cc6c8dde7e035ffd44661.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <42176587b0491de4d74cc6c8dde7e035ffd44661.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:33 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] uidgid: get_kuid_r() and get_kgid_r() accept nonzero reserved by=
tes
- [Medium] uidgid: get_kuid_r() and get_kgid_r() accept invalid IDs on !CON=
FIG_MULTIUSER
--

commit 991387abfa396e9352b6de3b866ad79653e997ad
Author: Jan Koester <jan.koester@tuxist.de>

uidgid: convert between kernel ids and the ids of the *_r system calls

This commit adds helper functions to convert between kernel kuid_t/kgid_t
values and the struct __kernel_uid_r representation used by the *_r system
calls, along with helpers to copy them to and from userspace and format
them as strings.

> diff --git a/kernel/uidgid_r.c b/kernel/uidgid_r.c
> new file mode 100644
> index 0000000000000..d71aecddb27e4
> --- /dev/null
> +++ b/kernel/uidgid_r.c
> @@ -0,0 +1,323 @@
[ ... ]
> +/*
> + * Whether @id is well formed: a known type, reserved bytes zero, a UUID=
 of
> + * version 4 with the RFC 9562 variant, a GUID other than the nil GUID.
> + */
> +static bool kid_r_valid(const struct __kernel_uid_r *id)
> +{
> +	switch (id->type) {
> +	case UID_R_LEGACY:
> +		return !memchr_inv(id->uuid + sizeof(id->legacy), 0,
> +				   UID_R_SIZE - sizeof(id->legacy));
> +	case UID_R_UUID:
> +		return (id->uuid[6] >> 4) =3D=3D 4 && (id->uuid[8] & 0xc0) =3D=3D 0x80;
> +	case UID_R_GUID:
> +		return memchr_inv(id->guid, 0, UID_R_SIZE);
> +	}
> +	return false;
> +}
[ ... ]
> +/*
> + * "No id" from userspace: no pointer, UID_R_NONE, or the classic -1. The
> + * set*id_r() and chown_r() calls take it as "leave unchanged".
> + */
> +static bool kid_r_is_none(const struct __kernel_uid_r *id)
> +{
> +	return id->type =3D=3D UID_R_NONE ||
> +	       (id->type =3D=3D UID_R_LEGACY && id->legacy =3D=3D (u32)-1);
> +}

[Severity: Medium]
Does kid_r_is_none() in kernel/uidgid_r.c allow nonzero reserved bytes in
struct __kernel_uid_r to bypass validation in get_kuid_r() and get_kgid_r()?

When userspace passes a struct __kernel_uid_r to get_kuid_r() or
get_kgid_r(), kid_r_is_none(&id) is checked before make_kuid_r() or
make_kgid_r() (which call kid_r_valid(&id)):

	if (kid_r_is_none(&id))
		return 0;
	*kuid =3D make_kuid_r(from, &id);

If userspace passes id->type =3D=3D UID_R_NONE with nonzero bytes in id->uu=
id,
or id->type =3D=3D UID_R_LEGACY with id->legacy =3D=3D (u32)-1 and nonzero =
trailing
bytes in id->uuid + sizeof(id->legacy), kid_r_is_none() returns true and
get_kuid_r() / get_kgid_r() return 0 instead of -EINVAL.

Should kid_r_is_none() also verify that all bytes of id->uuid are zero for
UID_R_NONE and that the trailing reserved bytes are zero for UID_R_LEGACY?

> +
> +/**
> + * get_kuid_r - read a uid of a *_r system call from userspace
> + * @from: user namespace the uid is in
> + * @uid: the uid, or NULL
> + * @kuid: the kuid, INVALID_UID for "no id" (NULL, UID_R_NONE or -1)
> + *
> + * Return: 0, -EFAULT, or -EINVAL if the uid is malformed or has no mapp=
ing
> + * in @from.
> + */
> +int get_kuid_r(struct user_namespace *from,
> +	       const struct __kernel_uid_r __user *uid, kuid_t *kuid)
> +{
> +	struct __kernel_uid_r id;
> +
> +	*kuid =3D INVALID_UID;
> +	if (!uid)
> +		return 0;
> +	if (copy_from_user(&id, uid, sizeof(id)))
> +		return -EFAULT;
> +	if (kid_r_is_none(&id))
> +		return 0;
> +	*kuid =3D make_kuid_r(from, &id);
> +	return uid_valid(*kuid) ? 0 : -EINVAL;
> +}
> +EXPORT_SYMBOL(get_kuid_r);
> +
> +/**
> + * get_kgid_r - read a gid of a *_r system call from userspace
> + * @from: user namespace the gid is in
> + * @gid: the gid, or NULL
> + * @kgid: the kgid, INVALID_GID for "no id" (NULL, UID_R_NONE or -1)
> + *
> + * Return: 0, -EFAULT, or -EINVAL if the gid is malformed or has no mapp=
ing
> + * in @from.
> + */
> +int get_kgid_r(struct user_namespace *from,
> +	       const struct __kernel_uid_r __user *gid, kgid_t *kgid)
> +{
> +	struct __kernel_uid_r id;
> +
> +	*kgid =3D INVALID_GID;
> +	if (!gid)
> +		return 0;
> +	if (copy_from_user(&id, gid, sizeof(id)))
> +		return -EFAULT;
> +	if (kid_r_is_none(&id))
> +		return 0;
> +	*kgid =3D make_kgid_r(from, &id);
> +	return gid_valid(*kgid) ? 0 : -EINVAL;
> +}
> +EXPORT_SYMBOL(get_kgid_r);

[Severity: Medium]
What happens in get_kuid_r() and get_kgid_r() in kernel/uidgid_r.c when
CONFIG_MULTIUSER is disabled?

kernel/Makefile builds uidgid_r.o unconditionally via obj-y. When userspace
passes a malformed struct __kernel_uid_r (such as an unknown type, nonzero
reserved bytes, a non-v4 UUID, or a nil GUID), make_kuid_r() and
make_kgid_r() return INVALID_UID and INVALID_GID, and get_kuid_r() and
get_kgid_r() then check uid_valid(*kuid) and gid_valid(*kgid).

In include/linux/uidgid.h, when !CONFIG_MULTIUSER, __kuid_val() and
__kgid_val() unconditionally return 0:

static inline uid_t __kuid_val(kuid_t uid)
{
	return 0;
}

static inline bool uid_valid(kuid_t uid)
{
	return !uid_is_legacy(uid) || __kuid_val(uid) !=3D (uid_t) -1;
}

Because __kuid_val(INVALID_UID) and __kgid_val(INVALID_GID) return 0 under
!CONFIG_MULTIUSER, uid_valid(INVALID_UID) and gid_valid(INVALID_GID) always
evaluate to true. Will this cause get_kuid_r() and get_kgid_r() to return 0
instead of -EINVAL for malformed IDs on !CONFIG_MULTIUSER builds?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D10
