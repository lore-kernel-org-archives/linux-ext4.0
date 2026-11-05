Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908652;
	b=5uDoZSN2Z6kCvqOev7rNTh+LutEv8PY9DETDw+nv92n4g0ZDWMzmXNlUZ56dMq06eU9b
	 /SCfFGiRuN5jh9SjOYF3/ZTHO6x17n8Yp9LVlrQFxGLSKpXVHVOK85w2YY0TSxVMALFCu
	 8QToTFWPe2Krn9OrcLe+KUvJnqE9shos+rNuVlAzAsEJJUOe7cEoGRBwlrJmS/6w+4Uci
	 mD/L8szpgEBVe6Byes/soOgcqeC7UMxOGdPE8BIjbO+nIJ/g27JjXu1xCdROC3ZIz4Q/7
	 Ud4YUNYAKmzM014fPIt+i+YzoHunkwFFu02k3nfc/T1MnOE32VlkdoKHpnODuiVkrvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908652;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SxyrM1+J7zWNaAN4jPGBV/DEjP5xQaaeFrdy3WUKUys=;
	b=SG7r4E+IjXspNVta6350Mib0HjhT/Wnu4fOewINAv9KC3IDqsTzVZbKp67bQhF2Vww+Z
	 3fChjR+cRyWrZ8jg4hMlVAmYgsTZVLk1B5+lXNtuYhNE/zUUIVRP8W5Pcu78SIvqmuT2t
	 m6EYcgy29cN3XT8wr7Fv0dutVWXuDyF6eU7O1pWfH/QAkFlbDiTwf8b0tu/+HVfpr2tW1
	 amp4JWcVRiqYxSP0pKxK7U5LFMV8wXwBCS7wvF7W/osplwLv1AMBCvcYswgSxCn/q/AOi
	 MCceWZpcWFPjtDxikmjOszwGw8e9NbAJJudRfSs58cEWtmljJE7MFaayMO/XqVqz7/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMPP9FqN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD94606A33F;
	Thu,  5 Nov 2026 19:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMPP9FqN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918E51F008A4;
	Thu,  5 Nov 2026 19:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908651;
	bh=SxyrM1+J7zWNaAN4jPGBV/DEjP5xQaaeFrdy3WUKUys=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TMPP9FqNNmqBY13gma3CLWIVL0EF17Y7rpEjR5oEtGu8j0/5nAccodRqSOAY0XBIK
	 sWJFde8ze/z0E32EKWqSoDwi/VCmGat6qgxYytX30wWPuJ5SIiDpHhjRJsD74+9x5o
	 JbjYd13OPdEf42ZbXWoC2XJfP9LTH73IGdLeCWa/7hWVMAHtgvK8/autJqBhcRPIsc
	 HwHm90YRFACVFy6xgtlWMbABooCDLz+b12aaY+VaZIQmAyZQN3Oia9FdjSnnqXxPC8
	 kKxtPdbYwzMOzpXGVD4u93aDu71XJTcefextyGS5ABeE+dKLGe0TSBdc8Xgtms7//W
	 OBkBLaioaeE9w==
Message-ID: <sashiko-outbox-200036@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 02/30] jfs: let procfs copy in writes to the
 loglevel file
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
In-Reply-To: <20261104-work-procfs-fs-v2-2-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-2-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and take the level from that copy. Writes larger than
> PAGE_SIZE - 1 bytes fail with -EINVAL now and so do empty writes, which
> looked at a byte that wasn't written before.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D2

