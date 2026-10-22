Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639062;
	b=E7Enr7D/gBXCvXFiCKIV9wJZarU4eDSuCh3HNqVjkmobRWppmspsEmLoLoWm8JRMWg//
	 1mdUnfbhPPD2SwPUZPO4YF2Vziio+S1gE3GT9A+oYbSHH4m/h3SZw4rinZeyLQ3vjfEHo
	 evu9Z5fljrx5RfmWE/nBhask5fwfNwdYSAEmD2M9Kmp0X5Ew9a9WxxLzm+MPnpbGEsRJZ
	 2jPQtV0IxuBn2Ovn42MVfsQx6ST8PCfn8S2ud7igIoW494gnvvqer8EZV6Hbwg5J1OueY
	 Q/Nc9yrijoFjiGl9muAoKQPkCWdEMhIppZ6DFoNPPV/fGoG9jsmCSjZqDNCRWP4cZeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639062;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QOawM3rFdBAgigV4OLRqKiF84W5lxuZvAK3BO0YfWBA=;
	b=3VRU5bm5a6+kJbFhkFla3mugexgbH+awSTEBDZ+XW7SjX8G9rB82jeRK7okKkrfo4L9o
	 ZPJ5FOIwVmL+WoXxEH1916gjO0QHsb6JnKh45whekKXgvk23xJFX61vfsvHboB/O3vTkE
	 O42sSGF16EHLIEb8SbmXDsvLsGmLr9hDiGg+AtGbdkIk/Tc+6G+ZaZOyYbvc7m415BHn9
	 OgWncPEIEeqcvQJxttYguyVytYaPYSpg70GlJJMB02FdqXjcTgn1bYDdeyQLwxtddZ9gf
	 1vp2b4kRdQftl4MU/LPiBUbzcNjsVzGwhHWk2+7t20uQp6/RIN1MJQPa8qqY0IOGICw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bZMEAXgC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2507860A4AF0;
	Thu, 22 Oct 2026 03:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bZMEAXgC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8121F000C2;
	Thu, 22 Oct 2026 03:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639061;
	bh=QOawM3rFdBAgigV4OLRqKiF84W5lxuZvAK3BO0YfWBA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bZMEAXgCqqu0Xu1XFZ2QGNvTeLx69FimISppnt26YgXiZdk7ciZmichF9b8F+MAzL
	 o3jIzF4eWOqknL0xx5vVrboESkLwsmYNLoAO8eH9/5GXy7lOxx24Aczs7O+uEgCIq9
	 tikN4RmnMytdSZW0oxrq2lPDKj73dWmc/owcB/Bzd9XP8AKIgEBiDkcnhhEeCLw9TO
	 1cmOvaoTmPID8ciKkItglZuQa3nORQoqaxY+qgD0QA7WyROY0Zk1x6w3nn6iwQwpjM
	 wEBsRt2CzQIT05stUr5AL5hgIzgV4RP3MXXZuxT4gpcGMoOoaDn/gPWLTJ23UYms1j
	 qdzLfcWtoaGxw==
Message-ID: <sashiko-outbox-180918@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 17/41] quota: don't account UUID and GUID owners
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <3c65c1107a1f9e634b35f59566f6ed70f217c85e.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <3c65c1107a1f9e634b35f59566f6ed70f217c85e.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:41 +0000
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
- [High] quota: dqget() checks qid_has_mapping() before qid_is_legacy()
- [High] quota: stale dquot retention in dquot_transfer() for UUID and GUID=
 owners
- [Medium] quota: dquot_initialize_needed() stays true for UUID and GUID ow=
ners
--

commit 56b2ebaac3515c69a008f64fd7b2eb53fda044a8
Author: Jan Koester <jan.koester@tuxist.de>

quota: don't account UUID and GUID owners

This commit adds a qid_is_legacy() helper and updates dqget() to return
-ESRCH for UUID and GUID owners so that non-legacy 128-bit identifiers are
not accounted in 32-bit quota files.

> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 1c78c695d0ddf..62f333f8243f1 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -954,6 +954,9 @@ struct dquot *dqget(struct super_block *sb, struct kq=
id qid)
> =20
>  	if (!qid_has_mapping(sb->s_user_ns, qid))
>  		return ERR_PTR(-EINVAL);
> +	/* Quota files hold 32 bit ids: like quota off for UUIDs and GUIDs */
> +	if (!qid_is_legacy(qid))
> +		return ERR_PTR(-ESRCH);
> =20
>          if (!sb_has_quota_active(sb, qid.type))
>  		return ERR_PTR(-ESRCH);

[Severity: High]
Can the !qid_is_legacy(qid) check here ever be reached for a UUID or GUID
owner?

Prior to this check, dqget() calls qid_has_mapping(sb->s_user_ns, qid):

include/linux/quota.h:qid_has_mapping()
	return from_kqid(ns, qid) !=3D (qid_t) -1;

from_kqid() delegates to from_kuid() and from_kgid(), which unconditionally
return (uid_t)-1 and (gid_t)-1 for non-legacy identifiers even in
init_user_ns:

kernel/user_namespace.c:from_kuid()
	if (!uid_is_legacy(kuid))
		return (uid_t) -1;

Because qid_has_mapping() always returns false for UUID and GUID owners,
dqget() returns ERR_PTR(-EINVAL) before reaching !qid_is_legacy(qid).
Callers such as __dquot_initialize() and dquot_transfer() only treat -ESRCH
as non-fatal and propagate -EINVAL, causing file creation, open for write,
and ownership changes involving UUID or GUID owners to fail on
quota-enabled filesystems.

Should the !qid_is_legacy(qid) check be placed before qid_has_mapping()?

[Severity: High]
When an inode is chowned from a legacy 32-bit owner to a UUID or GUID owner,
will leaving the inode charged to the previous owner in dquot_transfer()
leak quota accounting once the inode is evicted from the icache?

In dquot_transfer() -> __dquot_transfer(), returning -ESRCH from dqget()
sets transfer_to[cnt] =3D NULL:

fs/quota/dquot.c:__dquot_transfer()
	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++) {
		/*
		 * Skip changes for same uid or gid or for turned off quota-type.
		 */
		if (!transfer_to[cnt])
			continue;

This skips uncharging transfer_from[cnt] and leaves i_dquot(inode)[cnt]
pointing to the previous owner's dquot while inode->i_uid or inode->i_gid is
updated to the UUID or GUID.

While the inode remains cached, subsequent block allocations by the new
owner are still charged to the previous owner's dquot via
__dquot_alloc_space() and can fail with -EDQUOT against the previous
owner's limits.

Once the inode is evicted from memory, dquot_drop() -> __dquot_drop() drops
the in-memory i_dquot(inode)[cnt] reference without uncharging the quota.
When the inode is later re-read from disk, __dquot_initialize() sees the
UUID or GUID owner and leaves i_dquot(inode)[cnt] as NULL. Subsequent
truncation or unlink (__dquot_free_space(), dquot_free_inode()) will then
never decrement the previous owner's dquot, permanently leaking those blocks
and inodes in the on-disk quota file (or double-charging if chowned back to
a legacy owner).

Should __dquot_transfer() uncharge transfer_from[cnt] and clear dquots[cnt]
when transferring ownership to an unquoted UUID or GUID owner?

[Severity: Medium]
How does returning -ESRCH for UUID and GUID owners interact with
dquot_initialize_needed()?

When dqget() returns -ESRCH while sb_has_quota_active(sb, qid.type) is true,
__dquot_initialize() leaves i_dquot(inode)[cnt] as NULL. However,
dquot_initialize_needed() (as well as dqinit_needed()) assumes that any NULL
slot for an active quota type means the inode still needs quota
initialization:

fs/quota/dquot.c:dquot_initialize_needed()
	dquots =3D i_dquot(inode);
	for (i =3D 0; i < MAXQUOTAS; i++)
		if (!dquots[i] && sb_has_quota_active(inode->i_sb, i))
			return true;

For an inode with a UUID or GUID owner or group, dquot_initialize_needed()
remains permanently true even after dquot_initialize() has been called.

In ext4, this causes __ext4_expand_extra_isize() to always bail out with
-EAGAIN:

fs/ext4/inode.c:__ext4_expand_extra_isize()
	if (dquot_initialize_needed(inode))
		return -EAGAIN;

It also triggers WARN_ON_ONCE(dquot_initialize_needed(inode)) in
ext4_xattr_block_set() when EXT4_XATTR_DEBUG is enabled, and causes every
call to __dquot_initialize() on the inode to bypass the fast path and
acquire dq_data_lock.

Should dquot_initialize_needed(), dqinit_needed(), and the loop in
__dquot_initialize() also account for non-legacy identifiers?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D17
