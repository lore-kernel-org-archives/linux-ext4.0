Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717300;
	b=5Tm0iVJ4zCJ+8CQzmW+6Fvyc9/g5zWaEJ4kyrSXMKtFrj/TFyeVJ/AxSXlNEslO2acNW
	 xXVEk2HpktG+Y/i8lV3FUj06S8ELUV1JwmR9xhjw4R5M/sUhtp/vcUL1T9ktkgiRYUZ0y
	 qu82PGbFsTM7AzcZXoDpJ/j7Gjl2yjBVMTbqXNsLacntkvjuvdJWJhCqIpYzocPpHImEE
	 Bdje4KD0ALNBe4SXj9+tyaAMqSgZIy+J5YxChusou0pCATVaM7FToZUu9yaf7ZRjGwd9g
	 aQWEmcKlNMmzb944DsSX7RdA7JqRIoOX7Tn0v7VyeuJD2B/R4UauaCEpr1N9Mw08Ojw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717300;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/kElDKkabdJCRO6xnlGV31zxVfj0y3IarZ4wubDtz0o=;
	b=zGcTJdpQw115apLDXs21JEP85JxCRiQ50LFcexoGVtt0aqMXVRaHQEtX4R7B4S2t6++Q
	 qJmiQwxe5EugIAXaK2UK2wnU/g1HFDBkBbbBkfsAKLOSG7puvLf9j+YHfRMX3ZVzkCi9p
	 a9nKV8Uq+BPnODMsA1IfcU/EmGW30SM4vHaiNZTCiRYyHhIaV+loYO+JjRjz8bL6jySIn
	 4lzNM5QFsezQAtrnwO1TL/Mnac/i0VzRqVmwVZLcGOFvpgaBldvqe6+yA9BE8YX/HOer0
	 TMYJHCSAn0QX0kevuVxcCPv9VJHUOiQEtXy51hai0Kl/0TNASdgx8bJJtM99Pno3oow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LexbkyPl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8558C6071C31;
	Tue,  3 Nov 2026 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LexbkyPl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41511F00A18;
	Tue,  3 Nov 2026 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717300;
	bh=/kElDKkabdJCRO6xnlGV31zxVfj0y3IarZ4wubDtz0o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LexbkyPlz2zQIYc8bF2pRjKX/AkvfQPkVIaTn+eJLpPY+XRILitZ5nAWg6f3Tusuh
	 HQNETtvJbmEhM0aoKtzkgu0kgjOexpa4LlDw0I6/3+mwhTU3usX4A/HlO3gr8J6oLM
	 IgH6VaEhvysagiE3cAOglcKn4CUmS6tVKtwMnQexbp3BGK7R3zHHh+uU933vnYx9Ua
	 HvERM1FpNfN9QoeRRHMNLIBS3U06l9Wt5PRzW5n7A08d1qMfsTfUwwoEI1pq6/YOvV
	 5vPuxcrk8/zjzD9bphuDNnUp+Mj8VlIBw+rT8egZkVw3b5mCtS0M+aGGgGqwKCSnhr
	 y91xEUDL0eaDg==
Message-ID: <sashiko-outbox-195498@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 26/38] powerpc/crash_dump: recover from a machine
 check in copy_oldmem_page()
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-26-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-26-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:18 +0000
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
> vmcore does itself.
>=20
> Copy with _copy_mc_to_iter() instead. PPC64 selects ARCH_HAS_COPY_MC
> and there it uses copy_mc_generic() for kernel and user destinations
> alike, which has the exception table entries. Everywhere else it is
> _copy_to_iter().
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 4a22fd20379c ("vmcore: convert __read_vmcore to use an iov_iter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D26

