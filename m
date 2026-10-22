Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639089;
	b=0dd2VPjmYAJumPmOmIREgcmnWBcL4Zmm79R94HebLEFaxCP40IBAKK6Po64hyPJ3Ypse
	 YnlrnWcr4JAL5fwg/ePRQpxdFsHziJQHKr278Asp4wT98A7bQTnGZC70/OkTTXzWXl+rG
	 jwV45Ej+Xc7TJRdKIVKtDVRoHvk+v3benLEy1CExJaYnooXQV7UtxTX88bihcWBbLVSLP
	 TsbsTCcoSN1zJhfQCNVLka2TatHdXuvymdJAf81oA0Mtrrhurd2P8TLyUsmK2zEKMOVfJ
	 0AgE7aZDCiYO2tsPkE7Jah24tu8wTDaQuTC55hPUizZGovlJ/P9Y8uvNXzBb4I76SqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639089;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZFjaIA/J7e0MzwlmyRRLQRTf1sk/48ff7qMOqEh+5II=;
	b=kHk+AtDDbAakyHg+wF+2EyyIJ25fMROUjWuktNivWENEh75wso7tsR4eDNWrZJBS0c9B
	 EYF6m3PykFovtqjO/wMzw0hPO8OiZLUBoCN11gR2E3dfm6XbjJfUFyHj67J5d4B9geRzx
	 4Kj4IF8x1iWJ/yywayM6PYHH6K6iIo9tIXpHXa442SVbasPZ8IB4R6lx21TaJnZzC6iup
	 BtilVDD57Y6hyxIxkpzTMsoxb3lotlMJNbfDrPVnypXWnePCKR++mKW+mg4tPjXp7eDg6
	 kgEMXOnLjM11z5hTTsQWvUNlkDtwrgnaleOCYHEP59qhIV2WDfNbLeAuk/uecaegkHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j9yJoLZu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3376D606A33E;
	Thu, 22 Oct 2026 03:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j9yJoLZu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA701F000C3;
	Thu, 22 Oct 2026 03:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639089;
	bh=ZFjaIA/J7e0MzwlmyRRLQRTf1sk/48ff7qMOqEh+5II=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j9yJoLZukdK5o1/nV1d+i12HXDEGDNY0GF7DW+VWSkqEMJYlW3oTlALOprksrAga+
	 KBYrUI9/Z6bndnvoeWaBHKyDhzW0hxUHeJq43O37HYEIqHzHXfUYLgd5sMKtzOi0uf
	 5KLRSX3gJPxqjjnE6VPEBAZT/XqijX3WPTuRqWGvr9hJPHn2Z9Qu4Aimmbtyv+o3hT
	 M+KZBsW9v0YHVcuJxFvaxcJg+Pbxuac032Nf4tFFPze7DxbJii7A20afM1kCc0uTo2
	 XENP2wBvx8ysIulbtpeupy79DqL4EHBh9bUA0QQd4tMK88JbM2rh7KEqnkS/B6LHT7
	 RQJDNldhL0JCQ==
Message-ID: <sashiko-outbox-180940@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 39/41] ksmbd: log in UUID and GUID users and map
 them to SIDs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <73dfe9aab6c5dd8152fa494d53f470f3bea53127.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <73dfe9aab6c5dd8152fa494d53f470f3bea53127.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:18:07 +0000
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
- [High] ksmbd: sid_to_id() bypasses make_kuid_r() validation for UUID/GUID=
 SIDs
- [High] ksmbd: ksmbd_alloc_user() falls back to resp uid/gid when resp_ext=
 is NULL
- [Low] ksmbd: unused uid and gid fields and helpers in struct ksmbd_user
--

commit a1ea85f35f595431966b4e9bd815708cd849c5bc
Author: Jan Koester <jan.koester@tuxist.de>

ksmbd: log in UUID and GUID users and map them to SIDs

This commit adds support for logging in UUID and GUID users and groups via
ksmbd_login_response_ext and mapping their kuid_t and kgid_t values to and
from S-1-22-<kind>-w0-w1-w2-w3 SIDs in security descriptors, POSIX ACLs,
and durable handle owners.

[ ... ]

> diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_c=
onfig.c
> index 5efc3d7455b99..cb175a4c78d83 100644
> --- a/fs/smb/server/mgmt/user_config.c
> +++ b/fs/smb/server/mgmt/user_config.c
> @@ -56,6 +56,8 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_=
response *resp,
>  	user->flags =3D resp->status;
>  	user->gid =3D resp->gid;
>  	user->uid =3D resp->uid;
> +	user->kuid =3D make_kuid(&init_user_ns, resp->uid);
> +	user->kgid =3D make_kgid(&init_user_ns, resp->gid);
>  	user->passkey_sz =3D resp->hash_sz;
>  	user->passkey =3D kmalloc(resp->hash_sz, KSMBD_DEFAULT_GFP);
>  	if (user->passkey)
> @@ -68,12 +70,38 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_logi=
n_response *resp,
>  		goto err_free;
> =20
>  	if (resp_ext) {
> -		user->sgid =3D kmemdup(resp_ext->____payload,
> -				     resp_ext->ngroups * sizeof(gid_t),
> +		int i;
> +
> +		if (resp_ext->flags & KSMBD_LOGIN_EXT_ID_R) {
> +			/* the user's ids may be UUIDs or GUIDs */
> +			user->kuid =3D make_kuid_r(&init_user_ns, &resp_ext->uid_r);
> +			user->kgid =3D make_kgid_r(&init_user_ns, &resp_ext->gid_r);
> +			if (!uid_valid(user->kuid) || !gid_valid(user->kgid))
> +				goto err_free;
> +			user->uid =3D from_kuid_munged(&init_user_ns, user->kuid);
> +			user->gid =3D from_kgid_munged(&init_user_ns, user->kgid);
> +		}

[Severity: High]
What happens in ksmbd_alloc_user() in fs/smb/server/mgmt/user_config.c if
resp->status has KSMBD_USER_FLAG_EXTENSION set, but fetching the login
extension via ksmbd_ipc_login_request_ext() fails and returns NULL?

Both callers pass resp_ext directly to ksmbd_alloc_user() without checking
whether the second IPC request succeeded:

fs/smb/server/mgmt/user_config.c:ksmbd_login_user() {
	if (resp->status & KSMBD_USER_FLAG_EXTENSION)
		resp_ext =3D ksmbd_ipc_login_request_ext(account);

	user =3D ksmbd_alloc_user(resp, resp_ext);
}

fs/smb/server/auth.c:ksmbd_krb5_authenticate() {
	if (resp->login_response.status & KSMBD_USER_FLAG_EXTENSION)
		resp_ext =3D ksmbd_ipc_login_request_ext(resp->login_response.account);

	user =3D ksmbd_alloc_user(&resp->login_response, resp_ext);
}

Per the comment on struct ksmbd_login_response_ext in
fs/smb/server/ksmbd_netlink.h, resp->uid and resp->gid in the base login
response are ignored when KSMBD_LOGIN_EXT_ID_R is used. However, if
ksmbd_ipc_login_request_ext() returns NULL (for example on an IPC error,
allocation failure, or validation failure in ipc_validate_msg()), the
if (resp_ext) block is skipped and ksmbd_alloc_user() still succeeds using
user->kuid and user->kgid initialized from resp->uid and resp->gid.

If userspace left resp->uid and resp->gid zeroed in the base response, the
session will log in as GLOBAL_ROOT_UID and GLOBAL_ROOT_GID (keeping
filesystem capabilities in __ksmbd_override_fsids()). If resp->uid or
resp->gid is -1 (or when KSMBD_LOGIN_EXT_ID_R is not set), user->kuid or
user->kgid becomes INVALID_UID or INVALID_GID because uid_valid() and
gid_valid() are only checked inside the KSMBD_LOGIN_EXT_ID_R branch.

Should ksmbd_alloc_user() reject the login when
resp->status & KSMBD_USER_FLAG_EXTENSION is set but resp_ext is NULL, and
also check uid_valid(user->kuid) and gid_valid(user->kgid) when
KSMBD_LOGIN_EXT_ID_R is not set?

[ ... ]

> diff --git a/fs/smb/server/mgmt/user_config.h b/fs/smb/server/mgmt/user_c=
onfig.h
> index cc460b4ff7d39..e55470e008f50 100644
> --- a/fs/smb/server/mgmt/user_config.h
> +++ b/fs/smb/server/mgmt/user_config.h
> @@ -13,13 +13,15 @@ struct ksmbd_user {
> =20
>  	unsigned int		uid;
>  	unsigned int		gid;
> +	kuid_t			kuid;	/* the user: uid, or a UUID or GUID */
> +	kgid_t			kgid;
> =20
>  	char			*name;
> =20
>  	size_t			passkey_sz;
>  	char			*passkey;
>  	int			ngroups;
> -	gid_t			*sgid;
> +	kgid_t			*sgid;
>  };
> =20
>  static inline bool user_guest(struct ksmbd_user *user)

[Severity: Low]
This isn't a bug, but now that smb2_open(), process_query_dir_entries(),
__ksmbd_override_fsids(), ksmbd_vfs_set_durable_owner(), and
ksmbd_vfs_compare_durable_owner() all use user->kuid and user->kgid, are
the 32-bit uid and gid fields in struct ksmbd_user (and the user_uid() and
user_gid() helpers in fs/smb/server/mgmt/user_config.h) still needed, or
could they be dropped now that they have no remaining readers?

[ ... ]

> diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
> index 1fad6ccf3a72a..126264cc0734e 100644
> --- a/fs/smb/server/smbacl.c
> +++ b/fs/smb/server/smbacl.c

[ ... ]

> @@ -279,6 +341,42 @@ static int sid_to_id(struct mnt_idmap *idmap,
>  		return -EIO;
>  	}
> =20
> +	{
> +		u8 id[16];
> +		u32 kind =3D sid_to_id_r(psid, id);
> +
> +		if (kind && sidtype =3D=3D SIDOWNER &&
> +		    (kind =3D=3D SID_UNIX_UUID_USER || kind =3D=3D SID_UNIX_GUID_USER)=
) {
> +			kuid_t uid;
> +
> +			if (kind =3D=3D SID_UNIX_UUID_USER)
> +				uid =3D KUIDT_INIT_UUID(*(uuid_t *)id);
> +			else
> +				uid =3D KUIDT_INIT_GUID(*(guid_t *)id);
> +			uid =3D from_vfsuid(idmap, &init_user_ns, VFSUIDT_INIT(uid));
> +			if (!uid_valid(uid))
> +				return -EINVAL;
> +			fattr->cf_uid =3D uid;
> +			return 0;
> +		}
> +		if (kind && sidtype !=3D SIDOWNER &&
> +		    (kind =3D=3D SID_UNIX_UUID_GROUP || kind =3D=3D SID_UNIX_GUID_GROU=
P)) {
> +			kgid_t gid;
> +
> +			if (kind =3D=3D SID_UNIX_UUID_GROUP)
> +				gid =3D KGIDT_INIT_UUID(*(uuid_t *)id);
> +			else
> +				gid =3D KGIDT_INIT_GUID(*(guid_t *)id);
> +			gid =3D from_vfsgid(idmap, &init_user_ns, VFSGIDT_INIT(gid));
> +			if (!gid_valid(gid))
> +				return -EINVAL;
> +			fattr->cf_gid =3D gid;
> +			return 0;
> +		}
> +		if (kind)
> +			return -EINVAL;
> +	}

[Severity: High]
Can sid_to_id() in fs/smb/server/smbacl.c allow an SMB client to persist
malformed UUIDs or nil GUIDs into inode ownership and POSIX ACLs?

When a client sends an SMB2_SET_INFO or SMB2_CREATE security descriptor
containing an S-1-22-<kind>-w0-w1-w2-w3 SID (via set_info_sec() ->
parse_sec_desc() / parse_dacl() -> sid_to_id()), sid_to_id() builds the
kuid_t or kgid_t directly with KUIDT_INIT_UUID(), KUIDT_INIT_GUID(),
KGIDT_INIT_UUID(), and KGIDT_INIT_GUID() instead of calling make_kuid_r()
and make_kgid_r().

Unlike make_kuid_r() and make_kgid_r(), which validate the 16-byte payload
via kid_r_valid() in kernel/uidgid_r.c:

kernel/uidgid_r.c:kid_r_valid() {
	switch (id->type) {
	...
	case UID_R_UUID:
		return (id->uuid[6] >> 4) =3D=3D 4 && (id->uuid[8] & 0xc0) =3D=3D 0x80;
	case UID_R_GUID:
		return memchr_inv(id->guid, 0, UID_R_SIZE);
	}
	return false;
}

the uid_valid() and gid_valid() checks in include/linux/uidgid.h
unconditionally return true for any KID_UUID or KID_GUID:

include/linux/uidgid.h:uid_valid() {
	return !uid_is_legacy(uid) || __kuid_val(uid) !=3D (uid_t) -1;
}

As a result, a client can pass a non-v4/non-RFC-9562 UUID (such as
S-1-22-3-0-0-0-0) or a nil GUID (S-1-22-5-0-0-0-0) and have it stored on
 the inode or in POSIX ACL xattrs, causing subsequent userspace operations
that validate via kid_r_valid() (such as chown_r() or setxattr() on POSIX
ACLs) to fail with -EINVAL.

Should sid_to_id() construct these IDs via make_kuid_r() and make_kgid_r()
so that invalid UUID and GUID payloads are rejected?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D39
