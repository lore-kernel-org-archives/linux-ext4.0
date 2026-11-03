Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717290;
	b=r+H4LFXfOVzVhRWMlZ10Lv1XXCPIdG0cqNqPFNV9/VrIu8uNdJuXmyfpmQopSGNc0Jgm
	 3CEZXTg9BrPmuEAZTae3fErmvV1hpVr2wfdg1cedyNwmlgyossn6WecIpkpDvhX3FVL4U
	 WYdSHP6g0cx5KumWHvzbU33zZS/QrqwTPliHiqb8lvY0yznCDpUrGOcxN2XDYPKzbKf5K
	 aEgt0c4h7EyevjCAgztE980w3Aporw6GiyP9Iw7rwVDyMRrDBcLvqxqaINgINUhAcFkRn
	 8jqdJi7ILp3jOZKU6vK9RWGB3vUYX/LmTlqHfEwI17Q/oi+W/kUyee//Hm8PXV6aBuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717290;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8mbFNT8lVL2nvpVsUKgASJ1yFuw1L2kPoKsCbuWRO+8=;
	b=Lrct8dxy2sMSCDZ2Ov3dGFentbXSUOa0yYni/0YuXXGpIflLmMcDTpoqIfAnLyfkvw1a
	 XecfZIxLcodpZvZ6X8VvvsmO5R8v5eQ++XniphGlsbtOlmBIEqZ3bmMEvc4LQCapFVZVi
	 bh3SmWF71aBwJVxrNiRco3H9ZY+JQNs9WJaRjLDNT1UeNlwcdfbifkie7WkUPzGy1Q8BK
	 fJuND5GiTPvrBxbTjqg2lKQTaKwsPGfg0yeia7tsjF1Mg0jS7Tm5f1gU6JH78dYZLfrts
	 A9imVIPB/LJUhsNC+p6XK00VZK1XNsX8TbolZaJm8d1NOFWCbt/UCqrxpClME2G0Nqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=epjMvs1d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB90060A5BD4;
	Tue,  3 Nov 2026 14:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=epjMvs1d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6791F000C1;
	Tue,  3 Nov 2026 14:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717289;
	bh=8mbFNT8lVL2nvpVsUKgASJ1yFuw1L2kPoKsCbuWRO+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=epjMvs1dEdIwrI2DpgBsZGQorVKIJHhwUyrikWAHBc6Kk4cu+6mzN1OvGvUEUPhEM
	 B6AUhqEbvZnjd+L44ByeppapXiuprgTdI5dgYBGzcuPQ4mliSoBdYo9ya2AhybeQeS
	 hLysf5uAjAy1Ce1fGawoITmQs42q0WmndS/BpCcBJHCfp5/P5rgpN0KUvtsPXZ/tyI
	 1RZJZQTcjxHQ3TMgT1oAPoFy9LwZ7R59bQU8SwJTbZ2VhKizlrum4kIdEP7KLjnN/f
	 n8AAaCBb12w0yRYObxfiHCa2z0CKocMdytuZrknD7LG7ju9D/FRUqPhOPy2fc6VOrS
	 AnhnaOeX0gTFQ==
Message-ID: <sashiko-outbox-195493@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 21/38] proc: let proc_remove() remove the entry it
 was given
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-ext4@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, tytso@mit.edu, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-21-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-21-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:07 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_remove() looks the entry up by its name in its parent and removes
> whatever it finds there:
>=20
>   remove_proc_subtree(de->name, de->parent);
>=20
> If the entry was removed already, say along with its parent, that is
> either nothing or a different entry that got the same name in the
> meantime, and de->parent may well be gone. Two removals of the same
> entry are a bug in the caller, but going by the name turns it into
> removing an entry that belongs to somebody else.
>=20
> Since commit 895b4c0c79b0 ("fs/proc: fix uaf in proc_readdir_de()")
> an entry that was unlinked has an empty rb node. So check for that
> under proc_subdir_lock and otherwise remove the entry itself, with the
> loop of remove_proc_subtree() moved into a helper both of them use.
> Nothing can help a caller that passes an entry that has been freed
> already.
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: a8ca16ea7b0a ("proc: Supply a function to remove a proc entry by P=
DE")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D21

