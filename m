Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908193;
	b=o0Mf5SdWkKdJNbQb37Cq5LH2JrkYPgDrfuIHL8uGrDiH6YhUmMV97EUNo6WEXEgrH4yZ
	 I2r7Rh8KHp3chFnaqb9wEBoHR+R+LE/Zmmoox8vyNNhj9hWeNYU+gE+wqnPxxCE5bWh61
	 TiRznfsLjk9971U/+kPu2rNSmhN0/6LURUeB5rE2G0QoSavUD5xD7dbHWzsxOhFDTJc1D
	 E/VKUGuY71Lb3D/vD0oraqHcTIChC9YPwz6MT7CjS78rqr9+uerJMvAqf3Ort4tKreiKV
	 vovW5wsXpcnb+GktZ0rRUUmgqSNuAfCl41S3i89JUN9sb3tFy/nEtOq486rBIEPrGjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908193;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qIp99IO+gNwKI0Zdc0Aql+IacK3KngpUDJck0yFiZBE=;
	b=iv+Ddqxo11UQXrTZk1Bu+aQ+hgzWXcML7zWhNnWtu5lzPxB7EcqE8Lq1RBYn8ETw9ZKw
	 rQeTz8xl+2BmGoB99xsaRiLxQ4VO9mBol6ZTRcY++EKv7FObHCNjsC6CvOINTi2Obv1it
	 l9iG5dHGfp2USgLC4OTTRttd+wc+pW4U94N9jNEksVSv1H+NMmsqUZqVjcahC/aMWnG8w
	 40kcyqZ+iqmZ5ncxqORWwlvo9mJiYXRo96eEqAZMvglaHQA0W+sb7+BdqlIVAGtWZD9LM
	 o+zamtSOAskGhz6oL3vVkKhSMGjhnMi4qJrhpJYcpKYqRHae53XvH/lEqbqhpsCihZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfRGTcvC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A575E6077B5B;
	Thu,  5 Nov 2026 19:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfRGTcvC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3AB1F008A2;
	Thu,  5 Nov 2026 19:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908193;
	bh=qIp99IO+gNwKI0Zdc0Aql+IacK3KngpUDJck0yFiZBE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lfRGTcvCEjW1gWGiNrd238DspqkbshDpQm/7ZrTBiY33r3aIzQWnw1bFldseUpf0J
	 62T9Z+rgvSnzDUjQ1R+vmOIGeviwUG/81T47/fg3pCJGo+dAsOMmYtvwb6RPJE5PJz
	 PVAELLiaEV3AAM/IBb4QhbhAm4nIpCbxOhVAsmXOirWg+Ja2+GWNXMvOrmMg9ogvMu
	 71EEpW+ntYUt8dF+XpHJJPkxOHHOLCpNVuxb2GV6NwhxHQX2MluIGnoC37MtbGPEpb
	 pWvFUBjEPes5aghGFuknUaBHTmQX1P3Xrx7+dp1nnBbdYhdTM7wd6JyCHdd5cOaphB
	 de4PoOJA8WHQg==
Message-ID: <sashiko-outbox-200007@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 21/26] Input: let procfs own the wait queue of
 /proc/bus/input/devices
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
In-Reply-To: <20261104-work-procfs-drivers-v2-21-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-21-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> input_proc_devices_poll() sleeps the poller on a queue of its own.
> procfs owns the queue poll() uses now, so leave the poll_wait() to it
> and wake its pollers instead.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D21

