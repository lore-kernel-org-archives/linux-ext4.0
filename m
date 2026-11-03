Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717269;
	b=GcQV7wMkU/uE47+XTYG7v9lbEvyyxzgylbszch0AFB7y4yTk6pedkAUw9uBfJsMbEjx2
	 fuo6egeQCHl5iN1gPb2IB1ue7lG5AD31yCuqGSiT/lV35zgYHm8T+FkvpGPokOJuO3YGV
	 DX76Obzm9nLNC+5H5FbOvGT8TB9cuSNPrCbhF8639M1utqLOvWEZY6g4NkRuFTBh4X4hz
	 n+TN/dvNg4DIgAk9EiMxQ5Ih1/PNToXjyDCAU64EnSnAHWj3sr+nrCSTy/rLJR44VOhK5
	 4Y9qBA2Z6HPsixtyVPhJUwtNSiSj54+yTt+QcuJKkUKw1YUw5uathZkBaZywSsoTpXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717269;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zBynH5IZYgyQFUsVAjOAcJ5nfcoP0yn8vY+uG73McmE=;
	b=fgQsFq1wM3Gzp/ZHQX/h+vcgMFlW/mln+HwFUYoh/IKKuxJduI6g2HXiIMCKy/fs9zxr
	 7Q/lwmbV2TSVEZBu2nLslPVACmORj7gAVb6GJZsabEm1VnTNnV8euXgsvn2K+R1h8MSV7
	 g5MN+ttQqFz5pg6z4BL7dvKqZAYvdPRtZ4LbKqjrJwTYviyMhZiOWQloZUn84VYoXd4uj
	 ALxhpW+tq+3U/nj4v3VLE8YkhtHkibIa0mTVBOP1wslZRL74xJE08zxeVoFbNpFzkY2bq
	 kLkeEJWHEe0tLzDdbW3zt1dsR1JfRHde2rwafwCH4smQRcn2fInNRpO5smH9P8Tsc1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="W0+szZ/z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDAB6082BEA;
	Tue,  3 Nov 2026 14:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W0+szZ/z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E265D1F00A18;
	Tue,  3 Nov 2026 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717269;
	bh=zBynH5IZYgyQFUsVAjOAcJ5nfcoP0yn8vY+uG73McmE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W0+szZ/zwo28wV5zF2parBxS+5Nv/kl7A3/bt7jYI1tQbVGOtht65KKFMl44iJlKb
	 2TsWpsLSka7w9uTEaPdP7Iq93P5+V8D+quzXN7cHPAigbIaOZxzDITokPt4uHJaCNg
	 63AB4FZAZv4geP5M1V/KUv6syj9b+HqtMj2eLetkjO/egjQ5GEGunX1BwoJl/O8Ssu
	 bKnmaipZkZoedWba9JzbDTT+nON7C/z/f8ds/5jZpvBiRwvWwJzoQ2MgoQoUa4qgE6
	 52QWD1McR+13+jhrpxi0bhfJwC4UaAH+mXNUbzS3lo7La95FoBwBIRwe6n61kWLXjB
	 nsC1eCFGZzPow==
Message-ID: <sashiko-outbox-195483@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 11/38] scsi: ips: don't return 0 from writes to the
 proc file
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-11-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-11-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ips_write_info() ignores what is written to /proc/scsi/ips/<n> and
> returns 0. Writers that use stdio, echo for example, take that as no
> progress and retry forever. Return the number of bytes that were
> written.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D11

