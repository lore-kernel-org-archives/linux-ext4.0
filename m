Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908678;
	b=bghvKY1mnOmv0mlJ4fwX8SC333jNK+HiLDakCeyrYJJ5lX5BEzCQqprA3f6+AM9VrhGd
	 38HJDbbsj+qXociujzdeTmCGWAQ9wS4wJHQjVrfvYNeN0jEeTY2+gPYPISFmlD2gjgYlC
	 8XodsSnotHi5BWZICYbONy+G6tH92AGkjCbwcrHuX14w/hOg/PrIK9oq8ouaEDdSwe7tF
	 fgdn/vyaREPTEmTKzBVS7vYvS5sycNXuykAeBhWNJEXh7lSJ7vbIKBwBUS5XuAmBjORpQ
	 bFBa4bF/NTUfXD+G5FPtXgx8n77QRnQMyhgcoiSvSQn5yyyJ8yKIoJMRjgjPuyUWSwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908678;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Q42XyBK1Bo1UPboqeH08upoo4muH+m6/vw8nLMpS0Pk=;
	b=KKNPbpSwqbW3nZJr/uuiALO6acmY732VtjOvbfmzUzx98IIXuLyYk7/1qs8YgksRBL4b
	 isikBzdmPvNIorY5IMihskv8kH5MDdAUS3ZNuNN+ffCKvNKBAM/mvq7icyMX5+Wj+QoXu
	 T26j96ZcCzSfUqbYJjPaq6p413fjfjVd+uE93r1oai/XfSP1Qdy5QuCXGieT0KSv2O3ME
	 SEab7qwPuYCHw0qqMCtHJjjeY+bdmUXP16+w94yEN9DnW/uy1E+M3BeR2PvXU+/woHpFX
	 /RKkA4oj90IT2ajl82eugvzWY8LfSg0sCtrmYsAz6yLT3sJ47Ld7yUAYi5zep+SvY5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="fSi/szdb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EB9606A6C5;
	Thu,  5 Nov 2026 19:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSi/szdb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573781F008A5;
	Thu,  5 Nov 2026 19:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908677;
	bh=Q42XyBK1Bo1UPboqeH08upoo4muH+m6/vw8nLMpS0Pk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fSi/szdbjktVrgoUr62B1bGTBvTg/JXYR5HsAaNjPMAKPu/DFgJ5LU7EVq3LbauBI
	 OV7laZ5WHx/owfqUsSmgh/LiGdgMWJSvQ51LPQmP6Exgz1iuYkBqMs8RObI4sSEK1E
	 rai89FD/sZhBqT8ufpSLaHhgg9AxbvXedvNqVjnXXUu4yHIzFYTk39p2ftt4QSuWYI
	 k/z/QOJ+B5PP+E/QNeQ1OoIxGFDQpSWRVe/kByJRYDZbPCn+jitoJsAHH3BrAPvGv0
	 JhwqlLAYll8A0fQ91VWgRy34TFB9XZM0s5Xn4mfFoe5NZteWT8DZRZULqWUF0VpE/t
	 iGL8DBqA2a6fQ==
Message-ID: <sashiko-outbox-200048@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 14/30] profiling: let procfs copy in writes to
 /proc/profile
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
In-Reply-To: <20261104-work-procfs-fs-v2-14-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-14-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and take the multiplier from that copy. Writes
> larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D14

