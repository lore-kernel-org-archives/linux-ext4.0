Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639082;
	b=DBaHkS97MDe8nGrGcktKYAKY7mwmk9Jr672k7WMlL/clmLg9edmSDaINk8n7r5Zia+tu
	 Z9WO9famtY0pyZv9+UUxWiNN8rMxSJEr7N589uXjGVG501AaOP/52IaPD7lO+6/L/+6Eb
	 xH/Nq4I2DG4+58GyUsCbxxYN+/v2BI+pBbrGaZVTYzAkRg1l/4l27vPfk1tu/e/DLUpfT
	 8sYe3N2ARL3v6GuYVueDOCUCWNS7/OQJkhJ5xi9sa0AwIvONlyjDWlPSYo6TFBkcmFaq+
	 pOV5RPprsMe70Vifm0cPk5HkAU2HotabvJ9Tra5Z8Q9OgQNsBErXMaJFslT/CoPKqdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639082;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bl+QywlGZRcChNq3vDT1cVgudrcauuzh0lhRVYy8w38=;
	b=WkXblvT0OvXOncZY+pfSrUVVJq55zeductD3AVqe4qtVKje1foakwZwPCH3KMvdQFwj1
	 4ScHGslBIizPDGmykTf6GS4qZiz27qhh+VeF+S1wsBgy1wmTq4p2wtmhYk5a0WTy4PpLz
	 WpfRu+SOCdGMLrKslQUYS4lzbePZ1CdgxvXZMJqDxbdW8DmkbhhBAyvJFC2ssB2F/9zic
	 0EV4DW0YSsbQd45E0Qh5vFqsp59ffKa7mnivfa8Vykndqadl3T3d6+uHP1MUaqOZU/1a5
	 7ZBB267+pafW4D9hOn5UhIjwjjgAQ3iVs31pbHeyAyk/U2X0g1V1/leKiXy5wv0HbnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tm4Dr8l+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1A860A2630;
	Thu, 22 Oct 2026 03:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tm4Dr8l+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A68E1F000CA;
	Thu, 22 Oct 2026 03:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639082;
	bh=bl+QywlGZRcChNq3vDT1cVgudrcauuzh0lhRVYy8w38=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tm4Dr8l+gHjUNt49bPT2yvCS2ABrmaVwZo8zF8QsqFKZzNXmhBrDUyudGS5Awsq/I
	 E1xmLW2IeSWtUMHDDxZVuh929nBb2qiQRcDGcLcykUak8g1TO9pjsNsIrrZDPNmHIN
	 lNQQnqV2OI/JNuor9z55csCzYiCfT14EwUVruZ5a7H7Gv/V3oZjrQDo/AvaWCW00fd
	 Bvmvs08Z5qmKRtE2JWQAFHOsTc9LioKL7t3y22vwWuLDCqzlGS7s3cB4Cw0sFqpljN
	 hilMbbt2TNu4bG+83qt9aZNnogUSmiFnoFnEiq3q5GouKDcxzWVemUDQzs/CubSKOv
	 fiJrYoYt2LZ+Q==
Message-ID: <sashiko-outbox-180934@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 33/41] posix_acl: support UUID and GUID entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <d8a3b0587e8123c56058d097fbd2d5fa00cf7bd6.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <d8a3b0587e8123c56058d097fbd2d5fa00cf7bd6.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:18:00 +0000
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
- [Medium] posix_acl: version 3 ACLs accepted by posix_acl_from_xattr() cor=
rupt on writeback
--

commit 2e207d2596cd01ebad6cf100258b3d1483a2d6a6
Author: Jan Koester <jan.koester@tuxist.de>

posix_acl: support UUID and GUID entries

This commit adds version 3 of the POSIX ACL xattr format to support 16-byte
UUID and GUID entries in ACL_USER and ACL_GROUP tags. It updates setxattr()=
 to
accept both version 2 and version 3, getxattr() to emit version 3 when need=
ed,
and set_posix_acl() to reject UUID and GUID entries with -EOVERFLOW on
filesystems without SB_I_UID_R.

> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index 18b302f941743..bcb0663fe2c83 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c

[ ... ]

> @@ -795,6 +843,13 @@ struct posix_acl *posix_acl_from_xattr(struct user_n=
amespace *userns,
>  		return ERR_PTR(-ENOMEM);
>  	acl_e =3D acl->a_entries;
> =20
> +	if (header->a_version =3D=3D cpu_to_le32(POSIX_ACL_XATTR_VERSION_R)) {
> +		if (posix_acl_from_xattr_r(userns, (const void *)(header + 1),
> +					   acl))
> +			goto fail;
> +		return acl;
> +	}

[Severity: Medium]
Can accepting POSIX_ACL_XATTR_VERSION_R unconditionally in
posix_acl_from_xattr() corrupt ACLs on writeback for filesystems that do not
set SB_I_UID_R?

posix_acl_from_xattr() is used both by the VFS setxattr() path in do_set_ac=
l()
and by filesystems that store POSIX ACLs in the uapi xattr format (such as
btrfs, fuse, 9p, ceph, erofs, gfs2, jfs, ntfs, ntfs3, and orangefs) in their
->get_acl() and ->get_inode_acl() callbacks.

If a backing store returns a version 3 xattr containing UUID or GUID entries
(for example, a fuse/virtiofs or 9p server exporting a host directory where
getxattr() returns version 3, or a filesystem image with a version 3 xattr),
posix_acl_from_xattr() will load and cache a struct posix_acl with non-lega=
cy
kuid_t or kgid_t entries on a filesystem without SB_I_UID_R.

When chmod() (via posix_acl_chmod()) or file creation under a directory wit=
h a
default ACL (via posix_acl_create()) later writes the ACL back, it invokes
->set_acl() or filesystem init_acl directly without going through the
SB_I_UID_R check in set_posix_acl(). Those filesystems serialize the ACL wi=
th
posix_acl_to_xattr(), which only emits version 2:

fs/posix_acl.c:posix_acl_to_xattr() {
	...
	ext_acl->a_version =3D cpu_to_le32(POSIX_ACL_XATTR_VERSION);

	for (n=3D0; n < acl->a_count; n++, ext_entry++) {
		const struct posix_acl_entry *acl_e =3D &acl->a_entries[n];
		ext_entry->e_tag  =3D cpu_to_le16(acl_e->e_tag);
		ext_entry->e_perm =3D cpu_to_le16(acl_e->e_perm);
		switch(acl_e->e_tag) {
		case ACL_USER:
			ext_entry->e_id =3D
				cpu_to_le32(from_kuid(user_ns, acl_e->e_uid));
			break;
		case ACL_GROUP:
			ext_entry->e_id =3D
				cpu_to_le32(from_kgid(user_ns, acl_e->e_gid));
			break;
	...
}

Because from_kuid() and from_kgid() return (uid_t)-1 and (gid_t)-1 for
non-legacy IDs, posix_acl_to_xattr() writes a version 2 xattr with e_id set=
 to
ACL_UNDEFINED_ID (-1). When that xattr is subsequently read back by
posix_acl_from_xattr(), make_kuid() and make_kgid() produce INVALID_UID and
INVALID_GID, causing subsequent get_inode_acl(), getxattr(), and
generic_permission() calls on the inode to fail with -EINVAL.

Should version 3 xattr decoding be restricted to the VFS userspace xattr pa=
th
(or gated on filesystems that support version 3 / SB_I_UID_R), rather than
enabled for all posix_acl_from_xattr() callers whose writeback path uses
posix_acl_to_xattr()?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D33
