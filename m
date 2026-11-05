Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908168;
	b=Fmv0JR+7EadzDO8MiyFOuKiqfzaw8I2Tn3eXCoieczgPoU6J8lLKzjH6AHkoYQbt9x3a
	 DT2Cn2LVlrnHOZBnyoG3gmmywxAEeJMPVrKSJuRdriYmbCCqhKEnArb2KWlmsSldQ2EZR
	 dz63VfjB0rEGhK1enQ8XSUK6apb5u1qav0jceomtXqsbPOo74ujVb6XxlmBG3IXDIJzo8
	 Oh7zwdrdROGw8RXDe/4E8wrHUaw/KGqCP5qpVruaEN/s1uEtojJYEKFnMCjb/O3MbkzGP
	 56xeZcNEA6K0VW/GUSs8d1vV2qZpvW1lvk3fp+n3SLOw+FzfmQZH3FbfFtGarIjZxlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908168;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9gUuwRbjNCWvszkKrVQPv2hvkpneI8ksA3RSUuxs2Ic=;
	b=Np6gs8wG5cC5lir+vUqld4uFeHiAE3VZpn+tVoSyAPFgBgEK/TsZtdO0uo0sffHkWFxL
	 0dOB64Uwr1cA/d0RwD75wkg4Ie87dOiCaB09AIWCEy9+Eod2zGREra+E7XBMhQ2SjK5mH
	 sOCgtcPHhaDa+4tqxoJFF0gdWyiRamHXQl+oH1P8tBqHTNrFGO49VfqBA5FfmZjr4zhEL
	 BJS4PGO/8JAapfeIAbvjl3T6I+eXXsprBaBUH5FoT1ldL772mZnHNiegZlrER0Dpcv7Ej
	 3uK/+8Bja53AIXZzJnNKdoiDK3zjovZJXwlRlmlvBDigbI/OQf/ByN0yniSVQz9GczA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PU4f5WnX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D206071F91;
	Thu,  5 Nov 2026 19:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PU4f5WnX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E146C1F0089F;
	Thu,  5 Nov 2026 19:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908167;
	bh=9gUuwRbjNCWvszkKrVQPv2hvkpneI8ksA3RSUuxs2Ic=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PU4f5WnXQqbu2ros5eSzI0HoD++fGry80hTlakGFCv543QdE9RIR9N1nfJdO1KVvR
	 WlKHb7SAAG4ZNzG7YcIvrtw2YbcuHl9NxsC+Ry9ZH5u2A67KR3SHRiB1+qIThnXmvD
	 +e7+sOx53NUfD233kgOcnm8ngO0U1WkIITZi2L7zE9BRD+7Z1PMQjtuLjHjTgEpvcz
	 qNzcsCjCNxebuksa5ERjy7TcK7HkPvop0GlZBd65yGx122qWgbaW/s5Rdk/NgmYZdf
	 9memhwmnIL19lEfr0LQmOsjvY//yByOLUV8CZx6MBvkb6egGaMxFR33H6U2T2D+oIU
	 6AAcZfSosMTGQ==
Message-ID: <sashiko-outbox-199996@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 10/26] scsi: let procfs own the seq_file of
 the host files
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
In-Reply-To: <20261104-work-procfs-drivers-v2-10-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-10-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:25 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the show function and let procfs open and free the seq_file of
> /proc/scsi/<driver>/<host>. ->proc_open() only preallocates the buffer
> now. Reading the file then no longer holds up its removal when the host
> goes away.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D10

