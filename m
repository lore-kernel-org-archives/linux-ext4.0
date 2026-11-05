Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907010;
	b=gQ4gSW7Y+D/K+mhIov09TnK9EqDZJPpnDYQMXGqidyivRWN1Guv9yPNmB+PHzJhSvHtO
	 iXvQATu+X6yZZBky2JBxFQt9dVPhuvAasXtUT5SKa45uAxUETlR9ZttIuc7YaQrdJ0tIB
	 oeSLO7Icdj8UKzH2XYPeAnYZ08iJy+tFqYe0oSRCWWjtoD09+9OYCB3pdm31IjlrDIuLu
	 F5m14nr78Mv3cs5LuEbaaCUcKlSKC2e92h37OU4HkYRd2kW39uRy8nCA6MudobkElFcCw
	 dAH41phFBiVhGCA/j27uQTpHpsxA62bOIrgglTTKf9uaIE/uTNOI6jTsiX5AK+/7n0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907010;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=A/5VT3V/dJzwpelYcF9cS6x7xpOutBaEMG5KLkPXIhM=;
	b=BES7OpMQ42jey6HjKpttwPexgMn8l3pnT4i7LUZn4kDJ/1+ppln6jb04ld/FshmlVwxJ
	 Zm3J7zgxhhGtwrhNagZ0r0+QTOTWc8Pnhe2mplA+jDnr+1ghHHt9O0qQoxXfAWiG6fJ5L
	 KuiS9BYZas2rcu6j8Fv96aiAmjUlDqlt55L0Nx1Jl0fwTNaLM9AyOX/Q9T/AwP9WUJMbV
	 7ASJQ39DPrQy8oe6O+XVdVXNqh729u7xvp0KGpAR5mEfqdisZFX87Do6TYX3OwnT8ZUQD
	 QdUAEOCY7c7kCI/Rvhwl0Cn6B/7MkBTKUT8sCp8ZVYzvwgjBTv3tWGCMWjRVi0zPrtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NCMd5EQd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAE560A6F79;
	Thu,  5 Nov 2026 19:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NCMd5EQd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A439D1F000C1;
	Thu,  5 Nov 2026 19:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907010;
	bh=A/5VT3V/dJzwpelYcF9cS6x7xpOutBaEMG5KLkPXIhM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NCMd5EQduKiSLAcILn4CM/ObnRlBb+kiiI+/5ab849SU4+HjXc1QOgHqSAh7M6E27
	 b+FiWMO6CLjTXf1Nj4CyvKUhbV9P2lO6Ravfz73arpAD6MqZyaeurUt1DmNcp2r1xg
	 UEtfUQQPAMqtvXYriH4kf04yzM1YNYSXVxflhjmEiLm3NIsLubCTc7B6pP89rAaYC7
	 vRhscV5ISjyZDOGiESm5OMRWASt0Bg48G9OtHsxwoa1X79Gw2jkS0KmKoFwLBKiagJ
	 sc5Nah8PodeqHU5rOOtjTf5ulsejQkKKP0tx0YH8oCfD6kQ7LV1Lc6tg+oT5rHUsp4
	 dLpYzKAb3IJeA==
Message-ID: <sashiko-outbox-199902@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 39/51] powerpc/crash_dump: recover from a
 machine check in copy_oldmem_page()
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-39-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-39-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:07 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A capture kernel reads the memory of the crashed kernel, and that memory
> may well have uncorrectable errors. On powerpc a machine check in the
> kernel is only recovered from if the instruction that took it has an
> exception table entry (cf. mce_common_process_ue()). copy_oldmem_page()
> copies with copy_to_iter(). For a read() of /proc/vmcore that is a user
> copy, all of whose loads have exception table entries, so the machine
> check turns into a short copy and read_from_oldmem() returns -EFAULT.
>=20
> But since commit 4a22fd20379c ("vmcore: convert __read_vmcore to use an
> iov_iter") /proc/vmcore can be spliced too, and splice(), sendfile()
> and copy_file_range() copy into kernel pages with memcpy(), which has
> no exception table entries. A machine check there panics the capture
> kernel. The same goes for the reads of the ELF headers and notes that
> vmcore does itself, and those have been memcpy() for as long as
> copy_oldmem_page() has had its kernel buffer branch, since commit
> 54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_page").
>=20
> Copy with _copy_mc_to_iter() instead. PPC64 selects ARCH_HAS_COPY_MC
> and there it uses copy_mc_generic() for kernel and user destinations
> alike, which has the exception table entries. Everywhere else it is
> _copy_to_iter().
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_pag=
e")
> Fixes: 4a22fd20379c ("vmcore: convert __read_vmcore to use an iov_iter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D39

