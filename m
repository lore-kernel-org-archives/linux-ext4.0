Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906956;
	b=rDTulH9prtHpT9YocdGYKGjpNVQFDNAKrpxcGlCWfZbIVHxDnQdj6ZfYTFkwuD1Lx66N
	 ASXEHMGR8OW8F2DzUm8rIEyLaCImsu+H0zNVEdsjqKAAhw1+inLjuFfXtVzBMMD9S0bWE
	 bEjmR2kYAdB0dRBniVi39qj9BMQy7zhyTG5+ofO49PrA/4eAj4Amv9AcIuKXVAniIwyIb
	 vGuwsclhplVCQln1hyk7el8j6yxdWvzfZWsOA1AOGRCa92vjcv+tDVtsX1iQlBUcYuxpC
	 xzAJf8atvtk9A6qzCD37/HWUebS8pfdyC6YJtCQFViddGNEqFYmp7aN9VVPODVwxHxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906956;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Nyk6A7Xm43ba6GqhnkPuqyLDv4V2ioid2McoXcJIDec=;
	b=gj2mNxlfLw3MoH6E0N1dMFPQ0nletsV7/nLK+9hCpiTh26/1qHNofbxVm0bORs7yUqg5
	 ohZz46aJwlAwYvAFxRKj2L/vX7Y++lDQyib6Fbkh6WOUqtv9aMD0j+GhhirSogFLVr05j
	 BL+rG80uu8zgyvWcB53kS7wlHhbytvhy5Q+2Ou5QTL8fi7WcY8oCnygsTHrxK+gKBXfBK
	 2CENwgsij1F3lSXyyySImzEqnfuiO8IOctVGjeJZkojoPh69rFYqx4sDjCAmttDuLK0Ze
	 C2RPEgfdbyfTpCTELv4aVGIDzk7ixbGO8GcFr+4t9kWNhiTz9Eq7teJGlT0nzr99xsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FKfmSIG1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C62606EE8D;
	Thu,  5 Nov 2026 19:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FKfmSIG1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB75C1F000C1;
	Thu,  5 Nov 2026 19:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906956;
	bh=Nyk6A7Xm43ba6GqhnkPuqyLDv4V2ioid2McoXcJIDec=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FKfmSIG1UN/LwBVQXjOkvO7J6MY6CD67myw1qrW+OIpPGU2VpRAVBUgr+00ywjUWT
	 wLAm/Bi+zzx7OZ9FQjICLzYsmc1028tuWSIQeurLxH8ygiIABX308i+7xPLywURc/W
	 7ILU32xExlaMpEA2rjZnORa7iwKiD+dh6YvkbgZ7JZXLtf1bwIEbU7n8vEFRB7/ma6
	 Tswhvw73a0gcOElR+tDfQALqyP4oqfrfBTv8JnT2i6bX4N7GoCW5irT/YJ10btLD9v
	 GZ/E7p4fjablgkPiTgV19jmiyQHA7eshOJIpKb/a+kzle33JJ/83PDvWIIc14A1u69
	 eI/S8mKdJSVKA==
Message-ID: <sashiko-outbox-199876@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 13/51] sched/psi: don't drop the last byte of
 a trigger write
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-13-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-13-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:13 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> psi_write() copies at most 32 bytes of the write into its buffer and
> terminates the buffer by overwriting its last byte. For a write shorter
> than 32 bytes that is the last byte the writer sent. A trigger written
> without a trailing newline loses its last digit then, "some 150000
> 1000000" turns into "some 150000 100000", and a shorter one like
> "some 150 10000" fails with -EINVAL because the window doesn't fit
> anymore. Only writes that end in a newline parse as intended.
>=20
> Copy at most 31 bytes and terminate behind them.
>=20
> Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D13

