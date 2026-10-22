Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639047;
	b=Kb3ChGnVf2bznKDrX6v18AiZcCSHMDczi1hcyoTrzz/c5WawzBYS0gqQnTa0x2rzEqlr
	 hN2hpLLvpv91T9JaxPQNAmbKuzp+CAsJMvYsx1pGK7kAGP3MKmuU7XUMaoE14mCD9VfBg
	 XovxWCeS15uwIV0ZXib3RC3znT223d4ApKRgbqjFjEd9qahZd6eV4ZaEbpt2wZnP05YMC
	 MKQH6OQ8IKR2GrGUW1zMv8TDZBl4ac3xvzBhFWZD5aUNcgJmP9ho4o1xB45Cqwcfw+Org
	 aVuzhVOi/0mw9rkTpKa6j/dWX/ntuU1mzYr4k7E9judh3aBtPD6ZpxjwociHHEyq0uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639047;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yjFMi5sa8IiRoww7lpTyifwMtADCmpAmjtuNVHhpd2Y=;
	b=T5IZjwOlu6+6WGiiSDVu1GA0fFyOnuEFkbzgvJEAIy471XcTDDlm896zAK6a3QqkktZ+
	 MzHpyB1T+BnI2LZ9wJWDIT5uejL2rGme7WxUPbWwDKail6w9lBquMjC9zo7H43I4dii/w
	 RQ2/aSibPgFNCq0eUNJQngv6PzrrfPweMrVo6sj36dVjjLlah53zTDrwQDeS/aCtPkI2k
	 nnuimFJqtngghgYiWBJAutsWtlBtiuIfEt09A0jPiydV4C+QEQBocD+T1wsgO6T56Kx9i
	 7zMILLjw7/OJho7/RVrSJJ5oQjZMugYS+CSHQwD9yITnbLeqqvjQiVTe0u1yI91X8uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ocPFPO0b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A4A606A33A;
	Thu, 22 Oct 2026 03:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ocPFPO0b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5DD1F000C4;
	Thu, 22 Oct 2026 03:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639046;
	bh=yjFMi5sa8IiRoww7lpTyifwMtADCmpAmjtuNVHhpd2Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ocPFPO0biOmku3gfL7tlqYJDxMIiW3MHPyfKc/5JStwEE9UuFxP2y+OVJwhJRBs5l
	 H1eTwvww7R8HUeFFLW9jrQZm+Jufv31sCHk+UXKoF1i+493hTdhDksct0BInziFBm/
	 hJS+PD7cAOe9DRKSQHcJ+A5Bh4ZQdpZsSmPk2IYiZ3U8ow6bkLOspxqe1iDNs1n5vh
	 G3Mxw6jxYnGCeCHfL701q9oykDvfzCMtozI7ICMzqICfD4JWrei3kzdeQ7lKyMM1bc
	 lHV6QK886HiAqL8CekLc2CidMRRX/gtNeLz/ZKa4KSPT5AwDUnyVJCOOk+vLS7ssgt
	 vv/S0F8HeTkrA==
Message-ID: <sashiko-outbox-180904@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 03/41] uidgid: add uid_is_legacy() and
 gid_is_legacy()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <acd7e5be521cc2ba0526c45212e0c7b0010a6d16.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <acd7e5be521cc2ba0526c45212e0c7b0010a6d16.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:25 +0000
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
- [High] uidgid: uid_is_legacy() and gid_is_legacy() bifurcate kernel UID/G=
ID model
--

commit 89bf063fd971bc3a6a5e091bc2ca038531384166
Author: Jan Koester <jan.koester@tuxist.de>

uidgid: add uid_is_legacy() and gid_is_legacy()

This commit adds the uid_is_legacy() and gid_is_legacy() predicate helpers =
in
include/linux/uidgid.h to check whether a kuid_t or kgid_t holds a 32-bit id
in preparation for storing 128-bit ids in those types.

> diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
> index 2dc767e08f544..182c682458cb6 100644
> --- a/include/linux/uidgid.h
> +++ b/include/linux/uidgid.h
> @@ -22,6 +22,20 @@ struct uid_gid_map;
>  #define KUIDT_INIT(value) (kuid_t){ value }
>  #define KGIDT_INIT(value) (kgid_t){ value }
> =20
> +/*
> + * Whether an id is a classic 32 bit id. All of them are for now; code t=
hat
> + * needs one (to store it in 32 bits, for example) checks with these.
> + */
> +static inline bool uid_is_legacy(kuid_t uid)
> +{
> +	return true;
> +}
> +
> +static inline bool gid_is_legacy(kgid_t gid)
> +{
> +	return true;
> +}
> +
>  #ifdef CONFIG_MULTIUSER
>  static inline uid_t __kuid_val(kuid_t uid)
>  {

[Severity: High]
Introducing uid_is_legacy() and gid_is_legacy() in include/linux/uidgid.h to
bifurcate kernel code paths for 20-byte tagged union kuid_t, kgid_t, vfsuid=
_t,
and vfsgid_t types raises several architectural and correctness regressions.

kuid_t and kgid_t are designed as zero-overhead 32-bit wrappers passed by
value in a single register and embedded in core structures including struct
inode, struct cred, struct group_info, struct user_struct, struct
posix_acl_entry, and struct kstat. Expanding each id from 4 bytes to 20 byt=
es
grows struct cred by 128 bytes and struct inode by 32 bytes for every cached
inode, while turning pass-by-value helpers and equality checks into 20-byte
struct copies and __builtin_memcmp() calls.

Expanding inode->i_uid and inode->i_gid beyond 32 bits also breaks the
single-word access assumption required by lockless readers in
acl_permission_check() during rcu pathwalk and in generic_fillattr() during
statx() when racing with updates in setattr_copy() and i_uid_update(), which
can result in torn reads.

Furthermore, splitting kernel subsystems with uid_is_legacy() and
gid_is_legacy() so that __kuid_val() and from_kuid() return (uid_t)-1 and
from_kuid_munged() collapses non-legacy ids into overflowuid and overflowgid
breaks the invariant that every valid kuid_t and kgid_t maps uniformly acro=
ss
the vfs, filesystems, user namespaces, quotas, netlink credentials, and
userspace interfaces.

Should mapping external 128-bit directory ids to 32-bit ids be handled by
userspace identity daemons and existing kernel id-mapping facilities instead
of bifurcating kuid_t and kgid_t with uid_is_legacy() and gid_is_legacy()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D3
