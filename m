Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719148;
	b=J0vqF0dzSvr3QnLcpDrKSzsfSxJRG2rBiPOaKMhKEfakqBhwqclc+8i3Tk01lP4Sh3Dj
	 1I9YuVXOFDuPh5nobUdLbHIr41QPzV39kyjpF0leUoGGTuQtdG575ep8Wy1ay9KvVhUkB
	 G5BeXYHtx7HsuXfbQGhiPl97/2rnUNVjrzMkZ/w9+P7QhYrSPW2nUfchce8ChC3I7wu7C
	 prOfF+zLdFnPbeR7PvjR9chnxMZfGxXCIPTWnc23BBsiufgg9cKhzP5If8YDt4iC5+wut
	 cAUrV4D9IS4Uv58pLWKKus8pi3MOmAN+wpCAxNxFwjntbX6cYpruKUSNYW9Jpbv1fWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719148;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1669At5pGJiRDZ9q9xSvM+3vv7+5NMnsw09fzaDlx10=;
	b=mpbTgjFDY92avFfj5TeYe8Gx/HNQUoZYu4zN4Nr4K0SgoY2sBsFXCiol176w5pRLEVB9
	 sTr1KdAca0hTNko161Szz9pwtpWJiqeMTNox5KOhzg3Z4wfjO8R/aSpBkyerRoWeHikCh
	 kG/iC+Nc7U4RtobdQHCWur0o+Wtc8BstX55g4aKE7u35h9gEPbveFXGmS4wSxD4gskDOD
	 j2rKVUDzzS/Q/VnBhxDUDsDw2F/H3b3dEyJ8q1gU6T0MByDvKvB3bqvE8kJXXyB31hO8X
	 nYBzKh1f0RM9gX28vqYQ7V4J8gz1QTWwxlkCHaONS8EtWRVsR4dA1RvdX37gAxMtrlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JZfT8cxp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2C560A382B;
	Tue,  3 Nov 2026 15:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JZfT8cxp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4961F00A15;
	Tue,  3 Nov 2026 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719147;
	bh=1669At5pGJiRDZ9q9xSvM+3vv7+5NMnsw09fzaDlx10=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JZfT8cxpUtmS3Kfu8V8PLYWnJuG3QySVD8DWoG504UE/BwxXpC7dHd7PKrOTZWHmz
	 I6RJLz9S/hhhp8+eQpZpz+oEIOWxmfWCL4bx500g2aQ1hg05iA/9HRVNHvNFfHL/Lu
	 tBIfPhSNRR3m+YTao2Y3H12toeLC5vMYzC3SZN6bbXZOKGGZmByWURolhYAfLYTvaz
	 zimX68IlrTRwQB5vLHbS+EwZ3rJnfI2C495z2dd+hJXKtSlWsTPyKeCr1H7ROdmD8w
	 jA4rMhtSMKdq7Fq20Y5PzuwGOJlfb0TFWxTgVxa0smDFU7J4nuTjB+0C0F7Qu3VQJT
	 86sM7gi4iXHYQ==
Message-ID: <sashiko-outbox-195599@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 19/23] tty: sysrq: let procfs copy in writes to
 /proc/sysrq-trigger
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
In-Reply-To: <20261102-work-procfs-drivers-v1-19-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-19-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:19:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and handle the keys from that copy. Writes larger
> than PAGE_SIZE - 1 bytes fail with -EINVAL now. They used to trigger the
> first key, or all of them in bulk mode. procfs allocates the copy, which
> is as small as the write, opening the file allocated as much already.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D19

