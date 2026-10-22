Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639049;
	b=Hd0XXHF01LlpGEUB5wiW894kTaSZGFgC/3FXo5C1NhE41IoN5WLAqP/oaY2Uagng6dCx
	 Qj2QecO39pMn3JEvNfboQwqqhcm6PDA7NiSDv3fL70sckgwMnzYctUPzsHzazxfCm1mET
	 dr1sUtp0GQegxe+7Z66/JZ0trKG94+oQC/3IowPD5Wd6PbLNDSvArn3krK8Q/PqPyCGg8
	 NaX/obcKHX27jFvTD4eB28ShAQXQI/WU0uploQCaUnhXyyVHwAAF9HiXqD9eZbqHwunkv
	 tjU3bD3Kl9T8qi2MxPjf3aGGxRT7AV+er4adT3TTt14KhH5oLg0ibEidOwv9vDG2tYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639049;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KfIg0qarfQjQQQcYGqnUvKyB7iBXTvtIewmONs6C+Ww=;
	b=zZrGPVkq5vF0cBTx0GIKGNkOjCgnyVhn1qhJTtxOlnniOBoqqXjIi/gF/4/bjxPVgOTQ
	 e6A8hTomJDYRn//NDiBKXaYwuUORviOyzxIpfUlriOqAnwQauGpemVmGMF8gxNb+srJ+R
	 rBqTuf8bSabDWqETNuV0MJ/hjNyDaUHIOHZIrDaQspnTxZCCqk7RuMUgrPVSniaX8P5eU
	 4MZJC+AYfq3H6ZLBGn6W1dRagcN5ZAFy5LbXagIEVgB7652Ic7oyeHZ/kFcD96JocvFz8
	 jbKj5mXMNuvem/+klXBLGqEOsXBvtjiuOmUynuLRh4iTCqEfwXxst1ZVY5WMClcpvfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nR5t/6+1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891F6606A31F;
	Thu, 22 Oct 2026 03:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nR5t/6+1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07B51F000C4;
	Thu, 22 Oct 2026 03:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639049;
	bh=KfIg0qarfQjQQQcYGqnUvKyB7iBXTvtIewmONs6C+Ww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nR5t/6+1IjOFiy3d+pqnPLb0MJm+P7vCZ/CqjoBKsckDBwQC1eLnQ1wpTuZrfM+W+
	 ShLvdGAl8/vAD+MP5uDzHkW6eFdomErDM/sO7/32gDTF/rwuw4NBxGxXXM+pO4E9I9
	 ueJmdfyZsNqW/HWTHDg0wp93DqYmBGMc8BxqXRFX4zZmbMHNbXYsGAgCs1dZJDnHRl
	 ZD8/PyMI+N9mshNKsaPZKiiJ5CCs1mPXcURGyPJfYZvEyGMFImridEQSfNHcPpDWZx
	 IqhC+zai2jJ0jyoVxfwKKlsZkloaudNEIucKm+bWInxXKVlfsVYk9KisynGUBGCPyO
	 aoew7bUdd9Ugw==
Message-ID: <sashiko-outbox-180906@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 05/41] af_unix: keep sender ids in skb->cb only
 when they are classic ids
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <ec61dbb90e69bf33d17565d628ff59eaad8837f3.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <ec61dbb90e69bf33d17565d628ff59eaad8837f3.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:28 +0000
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
- [Low] af_unix: unix_skb_parms can exceed skb->cb size under CONFIG_RANDST=
RUCT
--

commit 9d78c8ae60dfc024139d5c6d850877e3acd5d5ea
Author: Jan Koester <jan.koester@tuxist.de>

af_unix: keep sender ids in skb->cb only when they are classic ids

This commit keeps classic 32-bit sender uid and gid values inline in
unix_skb_parms while dynamically allocating a struct unix_skb_ids for
non-legacy ids so that unix_skb_parms continues to fit within the
48-byte skb->cb buffer.

> diff --git a/net/unix/af_unix.h b/net/unix/af_unix.h
> index 8119dbeef3a3c..e861a430cf37e 100644
> --- a/net/unix/af_unix.h
> +++ b/net/unix/af_unix.h
> @@ -10,10 +10,17 @@
> =20
>  struct sock *unix_peer_get(struct sock *sk);
> =20
> -struct unix_skb_parms {
> -	struct pid		*pid;		/* skb credentials	*/
> +/* The sender's ids, when either is a UUID or GUID */
> +struct unix_skb_ids {
>  	kuid_t			uid;
>  	kgid_t			gid;
> +};
> +
> +struct unix_skb_parms {
> +	struct pid		*pid;		/* skb credentials	*/
> +	struct unix_skb_ids	*ids;		/* uid and gid, or NULL	*/
> +	uid_t			uid;		/* for ids NULL: legacy	*/
> +	gid_t			gid;		/* uid and gid		*/
>  	struct scm_fp_list	*fp;		/* Passed files		*/
>  #ifdef CONFIG_SECURITY_NETWORK
>  	u32			secid;		/* Security ID		*/

[Severity: Low]
Can this cause a build regression on 64-bit kernels when CONFIG_RANDSTRUCT
and CONFIG_SECURITY_NETWORK are enabled?

In net/unix/af_unix.h, struct unix_skb_parms is marked with
__randomize_layout:

struct unix_skb_parms {
	struct pid		*pid;		/* skb credentials	*/
	struct unix_skb_ids	*ids;		/* uid and gid, or NULL	*/
	uid_t			uid;		/* for ids NULL: legacy	*/
	gid_t			gid;		/* uid and gid		*/
	struct scm_fp_list	*fp;		/* Passed files		*/
#ifdef CONFIG_SECURITY_NETWORK
	u32			secid;		/* Security ID		*/
#endif
	u32			consumed;
} __randomize_layout;

Adding the ids pointer while keeping uid and gid as separate 4-byte
members gives struct unix_skb_parms three 8-byte pointers (pid, ids, fp)
and four 4-byte integers (uid, gid, secid, consumed) on 64-bit builds
with CONFIG_SECURITY_NETWORK=3Dy.

When a randstruct seed shuffles these seven members into an alternating
order of 4-byte integers and 8-byte pointers (u32, ptr, u32, ptr, u32,
ptr, u32), each 8-byte pointer is preceded by 4 bytes of alignment
padding and the trailing 4-byte integer is followed by 4 bytes of tail
padding.

That pads sizeof(struct unix_skb_parms) to 56 bytes, exceeding the
48-byte skb->cb buffer and triggering the compile-time assertion in
net/unix/af_unix.c:af_unix_init():

static int __init af_unix_init(void)
{
	int i, rc =3D -1;

	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, =
cb));

Would placing ids and the legacy uid/gid pair in a union (since uid and
gid are only used when ids is NULL), or grouping uid and gid into an
unnamed struct so they are randomized as a single 8-byte unit, avoid this
padding overhead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D5
