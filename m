Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717311;
	b=Gn0/6MobQ8oD8ktUK/dsT6wWh+62cJO9IE0N9A+Iv6VcnQS7mOEKE4+vAmJzIM1DxqI5
	 0nb1qph1+WMd3QKC6A/Mimyk49xMo+ig2aMmBzLZ0OrsaGC4LEpRZZa+IVzDa3AHjs7F+
	 Fp8jCH/HrpQZjtrlpVmfV2v7t7gp9K+QSko6CgYyXHxTGFxvvTTXEZ25VhfVavIzAQ94Z
	 7mkPIA+chu8+GYK8J36JDle0J1e2QY33QTP1uN2PtkchdXDQIBrIy3tjzqz+dEAUcUAbd
	 f7kbWqezxx8JA9VCigSXAdl9taHIwrfg6BoAIcIKg+qypDo7M3MZs9oSsV/yjc1R2bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717311;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YPSq1R8mvv3m/ZWA/l/xhrxB9LISO8x35dE2LzyDV9A=;
	b=IYT0w11QuL3Tpxvg2yY9jiyoCiPWdmgt81f4J6LqD+D0IeiWy7FcdBdxbzwjVnwixQDV
	 +R/ZrE41H9+y9vfYYzkD0xlmOFhbH1OLNkGkm5+art1fgAEdNDAsPckEOWoFMWS6tQU6n
	 /FzEECLx4SkEK+T7iJZRXqpbKVEEHiYATbEvkVt8rYEjyhdtcuj47GlljW1xKL1zbMKpH
	 8IYiyAwT2qj0jCBd17W1FjIihi1FgEWsE4UpbMkJrT6I6kd3o+Z84qvOkPteyvb3BwTAs
	 6Dzkon53R2XeLCK/ynjnqiNFxbadLgz11sJoBZULjIj4aI9DVCeBPJIq7U8G1jZncJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oh72y6aD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B0C606BA19;
	Tue,  3 Nov 2026 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oh72y6aD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FC31F00A15;
	Tue,  3 Nov 2026 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717311;
	bh=YPSq1R8mvv3m/ZWA/l/xhrxB9LISO8x35dE2LzyDV9A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oh72y6aDbLhFaPXdBI2yRygfRhwg2WDjGU9Aug43O88w0qr0cxbFG4trwNS0j/8Ev
	 r3EdnMEC8dYVFGPL3Wcol2YUeQfOLab3n/En1SWiK+eGFj7nW7qcJjXcKvZwh0bzbV
	 RNoz4+GhaJ8KyC0GD8TuMTV2UnfppqTuBq2YabUDkZgm0/NdhEq9hKM9qswXM7cQIV
	 3840K5dlCFENAoaul71/Ny6o5tT8/kxIu/OwJtSVoult59fuGjHPNvvwTaeLvVLhWe
	 WiVKYH1JDAxg78SUefAwd/eYv47zsNpa3fqoONjQuFAGyobDs9zKSbT6KgrEXQYbJS
	 oTCDW/6YY7CWA==
Message-ID: <sashiko-outbox-195503@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 31/38] proc: sysctl: resume readdir after the last
 name it returned
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-31-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-31-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_sys_readdir() counts the entries of a directory and resumes a
> listing at the number getdents64() stopped at. The entries are sorted
> by name, so one that is registered or unregistered in between shifts
> everything behind it by one. Listing /proc/sys/net/ipv4/conf with a
> buffer that holds ".", ".." and "all" and registering a device whose
> name sorts before "all" makes the next call return "all" a second time.
> Unregistering one that sorted before the position makes it skip an
> entry instead. So a listing that takes more than one call shows a name
> twice, or not at all. Even the 64k buffer of ls needs a second call to
> find the end of the directory, so a device that comes up right then
> repeats the last entry.
>=20
> So remember the name of the last entry a call emitted in the file and
> resume at the first usable entry after it, like kernfs resumes after
> the node it stopped at. The entry itself can't be pinned across calls,
> unregistering waits for that. If the position was moved by a seek in
> between the listing counts from the start like before, seeking to an
> arbitrary position has never been better than that.
>=20
> That also takes one walk down the tree to resume instead of a walk over
> every entry in front of the position with a round trip through
> sysctl_lock for each of them.
>=20
> Fixes: 77b14db502cb ("[PATCH] sysctl: reimplement the sysctl proc support=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D31

