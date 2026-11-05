Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908146;
	b=mKZdgmf6HJ2hO83fjjtFJVeaN7DHOjiE3qNuzsUsWGu5GcxNJfv4z41ugEgND9Fv1K9d
	 UG9TcGUMPZa6KLVrD1FMC6c5xRNRFIw0B92N0BkKxYdq8g/lZa1VJOzpUvD6LohqGd3o1
	 /KccrGtUYh72q1XvxNz8mDIq70KEm3vWnyQHCsv3HefHYTcTCzBpRiSU+I0p2DrJccP0V
	 lTycPZBfFjRaWwkxysKZyDbJfAviYH/3ZOZFfxNgf66CHZUVGN069u1zSoLK62qv52F4A
	 QdazNBalRQkDo/1rlHOgIHJIxp9cuZgqDxQSYhOygNKtHA4TVyQ/qUk9rIu7EntNcgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908146;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qAsUIA0sJNC6e1GmhI+cxYDDQcvJjgzrcIvMQ1GtXVU=;
	b=MHFKoYSv91+LPjOu65zWTGE3TlulIJa+1HjX6OTYIPesM3dJ0c5ZPosFxMx/5ElxJ1bB
	 dfMzmQxM+NXI+6e3+dyPi08Y6CLzEtiaG8OjFreZIZ73SGrHAsaR2gMPSv67b9Ov41Iig
	 n+dci0QVQG60MctV92X38mDG9y12lJWDQ2W5gPo25yMpikppvMtcNDDHHLaCvHsx8JV3r
	 lFel+E373WTkiAiwKBRPCTY/uK35EFShxRmo25k8n0NYtXBnBxcRg5z0+4frZQAQctfM5
	 0vbqz6ZrDE3edQ8uvcoYlHgsXAbIDTvmG6jJl0yb5so5XtOBUa6nMOpfQPo2p95Rhyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F7cBXcB2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61D8606D52A;
	Thu,  5 Nov 2026 19:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F7cBXcB2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74E91F0089F;
	Thu,  5 Nov 2026 19:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908146;
	bh=qAsUIA0sJNC6e1GmhI+cxYDDQcvJjgzrcIvMQ1GtXVU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F7cBXcB2CGcv4wv0GxypQPDRPWGhJY8+iPXIIuWPXopYVWlP4LLjgo8s9BW+0AJkl
	 2qXmnh9DA3hSouulPkjS7IHK/WlNM3sesBzffi33UCKagGiEAnYzLjTtm7gmSPxC9N
	 2hxw3SAfosebdwFpwNQ3beH6vTlyrS5FawLVYmvteNZGCQvJae7Z4z+vnEFeIceCV4
	 S257SGAR9gCP3QkTxFVZxqim/O97/pS2SwimLTzs3wmwDlTrdncsNWnFgGwVhPA8Le
	 0OhQGAaBUtsDAIXzFa1j3oogZ/jVk2PR4D01woTHT8+F7FoYVB9+hd4/wxGAP7ZIBr
	 doa7KiQ5i4Qyg==
Message-ID: <sashiko-outbox-199987@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 01/26] nubus: let procfs own the seq_file of
 the resource files
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
In-Reply-To: <20261104-work-procfs-drivers-v2-1-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-1-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:04 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Get the inode from the file instead of ->private, declare the show
> function and let procfs open and free the seq_file.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D1

