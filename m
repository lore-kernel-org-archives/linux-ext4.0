Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908152;
	b=j7sDTDSai1u/goFcOrFbKctl5ixjcPHt39Rne5ZVRxg1/sf/O/9vJA+DGNITGdN2AmzK
	 Gx0v7ZVEBo+e70MOlFnvxQRSOpwrdSMUEjWU1mxQghpK5bhIOfTzPeOEjTGYntg7VpX02
	 Jff76dKICy7+JhOtsEv0lgbhY23a4OP0LjhuGvt6E4dH4Qx4+rK+OIARF23EOPmisDEhg
	 iPUqqCZJuNDTDiBq+cRSZi+8zTMaj95YKbsY7aKp+Pmh2/j5MRRD3qBq2u5iOpFlr+zAK
	 cm0ulbtNR3uZkYo2uwoaf+qr50ZUHtlVrMqAV8Pj+0IhVjlk1fI/qjx24hmqtnsE/wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908152;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=13OVfMTrikaZUTOk6+ejChRIRHwQsK2sfHV0GLAx2hw=;
	b=d6t5qFxQUaIklUXDhYs4idHUKNel1NrVAWjxVOhgIh8cBhhfdAcxA01o9mq6h04Vh4nn
	 HR5/7JyRappYUaaqL6NrZnHsGMEzzm0TzJ0QWm6WpxDZ9yk553xYF6WgS5+tSxg3t5hjx
	 159n56W5JYXuP6VmoJ9YGQEgSFQZuSKmGzCuvmhlxqtupdWcqH2QO/1wUm6u9DJy4V5Br
	 fbwprsBVf7r4vAmmMuJf7g/ydHJs6L+sSfCLT92jrpqXE+rbIh6Cs1DXbaaTJ/+8l4Sfd
	 wqrOkW2m/hS+eTbLbsGrx14lRk9qVRkKSxB1t0T9AQKW+CU0sgVzpUcfBYA4ZbSNgSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSi2J4pz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D47606E41B;
	Thu,  5 Nov 2026 19:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSi2J4pz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C177C1F008A1;
	Thu,  5 Nov 2026 19:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908152;
	bh=13OVfMTrikaZUTOk6+ejChRIRHwQsK2sfHV0GLAx2hw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BSi2J4pzlBHAxuUAmYn9Unewqg1B6u8/oGNlJMu5HkD934fId18GQmiA6lQyKNwke
	 lBN5Ww0MnstCp2jFb/4vUdwGs4j4bBIqSdJxXQ9kBUV7X73Gp9kCtxZq7YWAiZNJJE
	 RLxtodWp6/+YZGahtAlv7ukZN5aZyEOCfXVWBUwaCIhBw0oDDN8hWCicNrL8GXktJS
	 vN6UcCM7eiG+2pWqK6ysHkui7JLuuOdSXsxjafjv2HX7CSO7+M5DZGKZCAJ6QpEB+R
	 j7XCjr5KXgY7bDsNnRKFEvIsliJ67HY+j8VEOQ95F7n+t7hL1xzYGGMnglfe0MfyZu
	 Wd8Ez7mWqOSZA==
Message-ID: <sashiko-outbox-199989@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 03/26] PCI/proc: let procfs copy in config
 space writes
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
In-Reply-To: <20261104-work-procfs-drivers-v2-3-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-3-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:10 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and write the config space from that copy with
> get_unaligned_le16() and get_unaligned_le32() instead of get_user().
>=20
> The copy holds at most PCI_CFG_SPACE_EXP_SIZE bytes. Larger writes come
> up short with PROC_ENTRY_SHORT_WRITES, like they did before because
> they were cut at the end of the config space.
>=20
> A buffer that can't be read used to write zeroes to the config space and
> report success. It fails with -EFAULT now and nothing is written.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D3

