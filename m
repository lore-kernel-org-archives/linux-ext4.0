Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639090;
	b=zzOm31yvw18cUQu/ZD/I7RmXunz41fuNJA9fu2pZeEV2+Vc3Cw5YhHd1/Pd56orm8RW5
	 pKB/6j8jz6xMFnG8izTF9F/aAfXgS898QFxxOIYVoV4fX5DHnUqG9mhJowgBigsFfT6j8
	 TGsa9yRQar+zeC+hnk2f7DXdSjzyIx63b1+3vjXGPqEFSKoJHgs94KytFzpHUEfOqmKaS
	 EjpoYqLOFOQqf5N5XURxGNi23w6tbHe8+NuslA4l8IFX03trC1ObsgkqW2zfUeG3Er2l2
	 bcYgNPVbWo/brll4l0El1s2MVItUKbWXSPoCWrWuvkqicdDyUz6tjD9oQiB0udGXyhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639090;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pzfC2TRKX43ni705/BEtqpWMIkNynbXTbNKUDVSHj4g=;
	b=cHLPvFCAP14TdpEDbod6PC/mpgD47xIwP2vXUGsao1vlA63EGebU3MpeA/YsgdYz235R
	 IhopBOHqF7idDql/zHClGGDaQI1CA6eFgrfcIejBqJw+qkJ7T8r/GkqlI010fsROUyRIN
	 sByaj2n9Gx5VCe94/9835zZU/vfJEg0gPsbm1mTm2Y3dbpRFt4gGPUqlBbTPLGNBbILxc
	 Bss0IEIoFZPeKtgt/T+ZwKQ5lRe2nLQJUY+l1C2I/C7Wg8CCG1cNJ9dHzLNmW89CoJtB/
	 HCcDy+WAWyI7O0zCJZd2hwWJTwJenaGHYihzyeqswnBnhO7iWBu3gbtUKAnn+D62OsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EBTbdg+A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9155F606A339;
	Thu, 22 Oct 2026 03:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EBTbdg+A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C391F000C1;
	Thu, 22 Oct 2026 03:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639090;
	bh=pzfC2TRKX43ni705/BEtqpWMIkNynbXTbNKUDVSHj4g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EBTbdg+ASZGDBFp7uKscAcUGNmTJ9u+g0xNIuHTl+3ZgDhNZxKg9qmpZVaM742fRL
	 zo1ah+13vQIX8x/FB8AmWFgqxPHhm1B6umoCWh88QQzCgS62Xg6OfAMshgkwCJRoCF
	 LI2NX/BZdVTJVKWTVHJEF3+qWsHOfW7OPAg06bj21WJk86vk7mJ5TKA5JCPa0oKkns
	 drC2jBkhuoZLsNTbiEQvP/mzjjO5BEHSdKb5yBSHgiDU/IrggCEzmfrIzMPa//pveZ
	 P8skIS1f8RuJSrCHkhff6WXQwar0bhzpi8epXWmhg1Y8jszjfbHCJ14Ocl6RkmtIZW
	 iXuSFi8m4xJnw==
Message-ID: <sashiko-outbox-180941@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 40/41] nfsd, nfs: carry UUID and GUID owners as
 their text form
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <f444dffc8e6bf98bf44c02456adc2de40e4ecd95.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <f444dffc8e6bf98bf44c02456adc2de40e4ecd95.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:18:09 +0000
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
- [High] nfsd: unmapped -EOVERFLOW in nfserrno() on UUID/GUID setattr and A=
CLs
- [High] nfs: silent overflowuid munging on UUID chown when idmap user_ns i=
s non-init
- [Medium] nfs: rejected UUID/GUID chown clears NFS_CAP_UIDGID_NOMAP for en=
tire mount
--

commit 651e121e99cc1fc974fd455542b8ff4a2ecaa7ac
Author: Jan Koester <jan.koester@tuxist.de>

nfsd, nfs: carry UUID and GUID owners as their text form

This commit encodes and decodes non-legacy UUID and GUID user and group
IDs in their text form for NFSv4 owners and ACL principals on both the
client and server. It also sets SB_I_UID_R on NFSv4 client superblocks
so userspace can set UUID and GUID owners via chown_r().

> diff --git a/fs/nfs/nfs4idmap.c b/fs/nfs/nfs4idmap.c
> index bc397110d977f..0ca50bf8f3fc6 100644
> --- a/fs/nfs/nfs4idmap.c
> +++ b/fs/nfs/nfs4idmap.c

[ ... ]

> @@ -769,6 +812,11 @@ int nfs_map_uid_to_name(const struct nfs_server *ser=
ver, kuid_t uid, char *buf,
>  	int ret =3D -EINVAL;
>  	__u32 id;
> =20
> +	if (!uid_is_legacy(uid) && kuid_has_mapping(idmap_userns(idmap), uid)) {
> +		char str[KID_STR_LEN];
> +
> +		return nfs_id_r_to_string(kuid_str(uid, str), buf, buflen);
> +	}
>  	id =3D from_kuid_munged(idmap_userns(idmap), uid);
>  	if (!(server->caps & NFS_CAP_UIDGID_NOMAP))
>  		ret =3D nfs_idmap_lookup_name(id, "user", buf, buflen, idmap);
> @@ -783,6 +831,11 @@ int nfs_map_gid_to_group(const struct nfs_server *se=
rver, kgid_t gid, char *buf,
>  	int ret =3D -EINVAL;
>  	__u32 id;
> =20
> +	if (!gid_is_legacy(gid) && kgid_has_mapping(idmap_userns(idmap), gid)) {
> +		char str[KID_STR_LEN];
> +
> +		return nfs_id_r_to_string(kgid_str(gid, str), buf, buflen);
> +	}
>  	id =3D from_kgid_munged(idmap_userns(idmap), gid);
>  	if (!(server->caps & NFS_CAP_UIDGID_NOMAP))
>  		ret =3D nfs_idmap_lookup_name(id, "group", buf, buflen, idmap);

[Severity: High]
What happens here when an NFSv4 superblock has SB_I_UID_R set by
nfs_fill_super(), but idmap_userns(idmap) is not init_user_ns?

Because nfs4_fs_type sets FS_USERNS_DELEGATABLE in fs/nfs/fs_context.c,
an nfs4 context created via fsopen() in a non-initial user namespace
sets idmap->user_ns to that namespace in nfs_idmap_new() (and
nfs_match_client() in fs/nfs/client.c can also share that cl_idmap with
a subsequent mount in init_user_ns).

When a process in init_user_ns calls chown_r() with a UUID or GUID on
that mount, notify_change() in fs/attr.c checks vfsuid_has_fsmapping()
(where from_vfsuid() in fs/mnt_idmapping.c returns AS_KUIDT(vfsuid)
immediately for nop_mnt_idmap without checking fs_userns) and
sb_can_own_kuid(), then calls nfs_setattr() -> nfs4_proc_setattr() ->
encode_attrs().

In nfs_map_uid_to_name() and nfs_map_gid_to_group(), kuid_has_mapping()
and kgid_has_mapping() return false for non-initial user namespaces, so
execution falls through to from_kuid_munged() and from_kgid_munged(),
silently sending overflowuid or overflowgid in the SETATTR RPC instead
of the requested UUID/GUID.

If overflowuid or overflowgid is not mapped in idmap->user_ns,
decode_attr_owner() and decode_attr_group() in fs/nfs/nfs4xdr.c also
fail to map the post-op GETATTR owner, so nfs_setattr_update_inode() in
fs/nfs/inode.c caches the requested UUID/GUID in inode->i_uid or
inode->i_gid while the file on the server is owned by overflowuid or
overflowgid:

fs/nfs/inode.c:nfs_setattr_update_inode() {
    ...
		if ((attr->ia_valid & ATTR_UID) !=3D 0)
			inode->i_uid =3D attr->ia_uid;
		if ((attr->ia_valid & ATTR_GID) !=3D 0)
			inode->i_gid =3D attr->ia_gid;
    ...
}

Should nfs_fill_super() only set SB_I_UID_R when idmap_userns(idmap) is
init_user_ns, or should nfs_setattr() and nfs_map_uid_to_name() reject
unmapped non-legacy IDs rather than munging them to overflowuid?

> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index cb19f1540d984..2d292e44186e7 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -1100,6 +1100,8 @@ static void nfs_fill_super(struct super_block *sb, =
struct nfs_fs_context *ctx)
>  		break;
>  	case 4:
>  		sb->s_iflags |=3D SB_I_NOUMASK;
> +		/* owners are strings: UUIDs and GUIDs in their text form */
> +		sb->s_iflags |=3D SB_I_UID_R;
>  		sb->s_time_gran =3D 1;
>  		sb->s_time_min =3D S64_MIN;
>  		sb->s_time_max =3D S64_MAX;

[Severity: Medium]
Can setting SB_I_UID_R unconditionally on all NFSv4 mounts cause a
rejected UUID or GUID chown_r() to disable numeric UID/GID support for
the entire mount?

When a user calls chown_r() with a UUID or GUID on a sec=3Dsys mount where
NFS_CAP_UIDGID_NOMAP is set, notify_change() delegates permission checks
to the server and calls nfs_setattr() -> nfs4_proc_setattr() ->
nfs4_do_setattr().

During XDR encoding, nfs_map_uid_to_name() and nfs_map_gid_to_group()
encode the UUID or GUID as its text string even when
NFS_CAP_UIDGID_NOMAP is set. If the server does not support UUID/GUID
owners and returns NFS4ERR_BADOWNER (which nfsd4_decode_fattr4() in
fs/nfsd/nfs4xdr.c returns during XDR decode before nfsd4_setattr()
checks file ownership or CAP_CHOWN), nfs4_do_setattr() passes
-NFS4ERR_BADOWNER to nfs4_do_handle_exception() in fs/nfs/nfs4proc.c:

		case -NFS4ERR_BADOWNER:
			/* The following works around a Linux server bug! */
		case -NFS4ERR_BADNAME:
			if (server->caps & NFS_CAP_UIDGID_NOMAP) {
				server->caps &=3D ~NFS_CAP_UIDGID_NOMAP;
				exception->retry =3D 1;

This clears NFS_CAP_UIDGID_NOMAP permanently on server->caps for the
mount and retries with the identical UUID/GUID string, forcing all
subsequent classic UID/GID setattr calls through idmapd (similar to the
regression fixed for ACLs in commit f8849e206ef52b).

Should nfs4_do_setattr() avoid clearing NFS_CAP_UIDGID_NOMAP when the
setattr request carried a non-legacy kuid_t or kgid_t?

> diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
> index e9faf8b78f74a..8c3e908b323ed 100644
> --- a/fs/nfsd/nfs4idmap.c
> +++ b/fs/nfsd/nfs4idmap.c

[ ... ]

> @@ -672,6 +699,16 @@ __be32 nfsd_map_name_to_uid(struct svc_rqst *rqstp, =
const char *name,
>  	if (name =3D=3D NULL || namelen =3D=3D 0)
>  		return nfserr_inval;
> =20
> +	{
> +		char buf[KID_STR_LEN];
> +
> +		if (id_r_name(name, namelen, buf)) {
> +			*uid =3D make_kuid_str(nfsd_user_namespace(rqstp), buf);
> +			if (uid_valid(*uid) && !uid_is_legacy(*uid))
> +				return nfs_ok;
> +		}
> +	}
> +
>  	status =3D do_name_to_id(rqstp, IDMAP_TYPE_USER, name, namelen, &id);
>  	if (status)
>  		return status;
> @@ -709,6 +746,16 @@ __be32 nfsd_map_name_to_gid(struct svc_rqst *rqstp, =
const char *name,
>  	if (name =3D=3D NULL || namelen =3D=3D 0)
>  		return nfserr_inval;
> =20
> +	{
> +		char buf[KID_STR_LEN];
> +
> +		if (id_r_name(name, namelen, buf)) {
> +			*gid =3D make_kgid_str(nfsd_user_namespace(rqstp), buf);
> +			if (gid_valid(*gid) && !gid_is_legacy(*gid))
> +				return nfs_ok;
> +		}
> +	}
> +
>  	status =3D do_name_to_id(rqstp, IDMAP_TYPE_GROUP, name, namelen, &id);
>  	if (status)
>  		return status;

[Severity: High]
Could accepting UUID and GUID strings here trigger a kernel warning in
nfserrno() when the exported filesystem does not support SB_I_UID_R?

nfsd_map_name_to_uid() and nfsd_map_name_to_gid() decode 36-byte UUID
and 38-byte GUID strings into non-legacy kuid_t and kgid_t values in
nfsd4_decode_fattr4(), nfsd4_decode_nfsace4(), and
nfsd4_decode_posixace4() before the target export's superblock is
checked.

When nfsd4_setattr(), nfsd4_create(), or do_open_lookup() (via
nfsd_create_setattr()) then calls nfsd_setattr() in fs/nfsd/vfs.c on an
exported filesystem without SB_I_UID_R (or on ext4 when
ext4_make_room_for_id_r() cannot expand an existing inode),
notify_change() in fs/attr.c:

	if (ia_valid & ATTR_UID &&
	    !sb_can_own_kuid(inode->i_sb, vfsuid_into_kuid(attr->ia_vfsuid)))
		return -EOVERFLOW;
	if (ia_valid & ATTR_GID &&
	    !sb_can_own_kgid(inode->i_sb, vfsgid_into_kgid(attr->ia_vfsgid)))
		return -EOVERFLOW;

and set_posix_acl() in fs/posix_acl.c:

		if (posix_acl_has_id_r(acl) &&
		    !(inode->i_sb->s_iflags & SB_I_UID_R))
			return -EOVERFLOW;

return -EOVERFLOW.

nfsd_setattr() and nfsd4_setattr() pass that error to nfserrno() in
fs/nfsd/vfs.c:

	for (i =3D 0; i < ARRAY_SIZE(nfs_errtbl); i++) {
		if (nfs_errtbl[i].syserr =3D=3D errno)
			return nfs_errtbl[i].nfserr;
	}
	WARN_ONCE(1, "nfsd: non-standard errno: %d\n", errno);
	return nfserr_io;

Because nfs_errtbl[] has no entry for EOVERFLOW, this triggers
WARN_ONCE() and returns nfserr_io instead of nfserr_badowner (and for
OPEN(CREATE) or CREATE with initial UUID/GUID attributes, leaves the
newly created file or directory on disk after nfsd_create_setattr()
fails).

Should nfsd check whether the export's superblock supports SB_I_UID_R
(and map EOVERFLOW to nfserr_badowner in nfsd_setattr() / nfserrno())?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D40
