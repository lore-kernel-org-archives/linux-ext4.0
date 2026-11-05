Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906944;
	b=Clp4KRKiQ8MDiDyOXR1gSROg+qgHexDCLoS928D66H/Wf0Ch547EVy7L+l51tolNLO6p
	 1AEmqQm4mnvRfWONdg0+lZGEegXSidKQ5a+b8Y9QliOjPkAh8nKcZxyH+xZ//c5EirQSZ
	 hgI+hLWHFJhzO8OStVSM0EXeDdEiEvruO5zCxFVbu4AzuN1ABaRVvOubl3RvcfbBIytiI
	 BfJlwQPfBGEHJb0JQxi3c0wJWcCQ4SzEQuW6X76rym4gsKUHUZk5Rgbs1QWxHRolmsePY
	 1cKQi7r/bq80nCs/LSSv6hScCfc/E9qEAHpkAgA7XAhm8NZwiV072Pw1XHdLLWX5REw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906944;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=r1ycZKD70M2O9nWABnZxAo0Y7x59PNQr/eG96uelaDQ=;
	b=OXPo3IrIjDjerZm9VBZRpviD2V8FYn0l3DKVi4AfpU/JZ3ZHlSPsfQXkeF4lhEAd+jZh
	 3jNw3VoMCov4SCvVKK9fgCoSuDI0aFUPJ+b1D20RGQ+JGyZ+llOqfdDBpB7oSolglsBDi
	 M2PEJIB7hvTywj2InIR0SPNPQHvv6nycMY2AAChmc6LI+8/XbHX686KJrmQHyrDQju216
	 9K/ZJ8mnV/vCkkTrA1FoOcQbaDDwI7oPxGfv1OHAqdYpYFDxkfgpVW/jLk7B/v0JrFzWX
	 RfDt19BqaEkkEqbjZTnHopO2aoas2tKFrec3q/UPnNEqVe8PjxJrYXriR7VH3o1y+Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=necGus7b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85412606A334;
	Thu,  5 Nov 2026 19:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=necGus7b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA70D1F00919;
	Thu,  5 Nov 2026 19:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906944;
	bh=r1ycZKD70M2O9nWABnZxAo0Y7x59PNQr/eG96uelaDQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=necGus7bPU63UQk4B7+jV3XV3fUR+Vt0nlBwWy50VqFwECBf1aibdVwEQjnZEn+Ny
	 Nk1eietSenvm5xqR/gzPNGNzZbvkkvnODaOzH7V35V/oaIZYKDA69EZlf4qtIWl0+y
	 CLJx1JYEb1VEmZX7/x/KIzKFm4AvmAQYSTJwVI3oNBp4hYilo3LyLI/24/DmSHB0xR
	 KeFmM+pyBdtCJHSurwLaWys6yP1tn08WuWeskCI8YOyZaldAhv0TS5sXvEaDm8Qah0
	 JT7nN2+bgKA94sYD+FKbGDigc0ESaJpkTtOL2xP5JtOlGB9U35VVcN7RlPkTRv1UsF
	 KJpyB6HzUFV7w==
Message-ID: <sashiko-outbox-199871@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 08/51] powerpc/pseries/lparcfg: don't drop the
 last byte of a write
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-8-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-8-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> lparcfg_write() terminates its copy of the write by overwriting the
> last byte, so a write without a trailing newline loses its last
> character: "partition_entitled_capacity=3D5" is parsed as an empty value
> and fails with -EINVAL. Terminate behind the copy instead, and refuse a
> write that fills the whole buffer, which can't be terminated.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D8

