Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908686;
	b=thSrLeXogCKcP0pUh28VPqgC58tXRK2U9221pcIRp7dSRFj7f95nnOt6zXVjxMaBlZ1O
	 GeRYuQTVUS6MJuypqciKCxVdxjMVdMkbHxhX/sZkUKmdMgFOR4vxRU8IX2hHaXK4l8voJ
	 UPXNs8fvfu/L8ITWkLBhL4xIEhusHE8jz25NRHVCFbEJKd06HZ3UyFo3PTI3urLYDsryj
	 IrQfZLcLmQqv9EKlHT/VutqVYHJloeXcUIAeEbVRJv3n5yZviMG9U3zBZJFjfNFmkqDzy
	 xmFXoNMgtNQr+IeotYw6KxXzE34wFd6KoP7WW+EFnr+IVa9eLjD5WWTHBzq+srrktPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908686;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BB5sJR9C7Zx/9Pk3o44DtUSAxu92dNwmvstpQumGNJA=;
	b=txk9LHR4ZIY1k8nF4/FcVq4nKhGDX5dvbao/626fExJsI2tfFTng8s6cOmv1MP8XUCqW
	 tS2LF3RJqUoOyY3E0YueDehDBMVOrs3xkS/F+xOmQVv85zoxcMFJz+PvKAR0xJZkdr58Q
	 HbCkZ08KkTN/Tpw/3OaQtyYpHIvcIuXcDE5f05s5tDMRRIJVN3I++JKNKpl0Z32zan0RD
	 nd9PRsZsIQV15bk0H2q5kpTMaLF9VHQcmJT1rWSSca95mktgXakKdxjZ2rEeM8w3LMPNW
	 dW+h05E01X8aSO4qr8gPiewpfMl6KyyNmVchNmycF1jh1QmcT8dU2l1JuddG3X9ughg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddZWhmtY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2E5606A6C1;
	Thu,  5 Nov 2026 19:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddZWhmtY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A401F008A1;
	Thu,  5 Nov 2026 19:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908685;
	bh=BB5sJR9C7Zx/9Pk3o44DtUSAxu92dNwmvstpQumGNJA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ddZWhmtYBTIjf16jcYyGuxkBHMP752cDre+YlbjE8K+pVsumLJ8cuoV8TN+HdBxjY
	 0HL/wMxsPD9cDiEJ8ml8GmDV8iXPn1Ljx0/Mbh4eTVFT4Ps/yYu4X08RdE9yor95Xm
	 NuoqE+Twd9eWDq17omIHGvd8uduh6YXldarMHP0FxHZ49T3VqEGy9CjMVJiLafNZ4q
	 crkTm3bGTJeqOEjZuZhyTPgE93yIG7wSXYRHJTke0ePJIwoq11jQIi8x0dAUWr1jPU
	 6dWitI2BDr+qt4m712CrJfv0OpT4tmwX9rbzOOpgVyVyJTCJ6SFDofjIfM0DhjSDjJ
	 fhaCI95uj6cEg==
Message-ID: <sashiko-outbox-200052@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 18/30] sched/psi: let procfs copy in trigger
 writes
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
In-Reply-To: <20261104-work-procfs-fs-v2-18-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-18-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for the files in /proc/pressure so procfs
> copies in what is written before it pins the entry, and take the
> trigger from that copy. Only the first 31 bytes were ever looked at.
> Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D18

