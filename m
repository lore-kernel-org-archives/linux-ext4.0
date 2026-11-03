Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717250;
	b=NoqgYgIaYDIjEgJLJh2iRU1YWLSbYmCh6K3XCxe9jGyJQPDncXEW0fFhep6II1VsDYdI
	 9iJbkLm4+ff8LgbgbaP9hmtqkvAZs4qxiyvm9Hz2gRvSDhuR05cNw2OgEnKKjRY25GVV/
	 wpogIrEAW+Eem+OV5u94PTgM69Ik68Wmd3B9mUoI825neofeDzNpAjG46y2FzzbiWGy0J
	 9huNlS3yMXak3s8KgB2SmfFfrksJ0p/goyKBCqFAV/tCr86sFr5BKqqi0/2YB72W8C+ss
	 D31vNrFtcwmM5G7LjrbMxTTpwk3bqsUz5iMKypdePHa+NWVJUNkxA4ULPu0N7nTNPZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717250;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CcwQtKt8p98z3nZ6v7GVVoJYg9XQ/4wAmXztnPTRoMM=;
	b=jzRXmdNlPq//ttm+9RwHF0NdGiAbnff70sCRbspbFHBgGgTNW28GS3gsSSBBg0aFNWAc
	 RUbjUeNjZeUFC0mMF0atUM0pzfIpa8T8ke/+3e/iDqlclxV69J9aHosXPlqu67ifdGFiZ
	 5cYB6xkmuahR77uAm/QmYRGMakwiy8yuMd8gLQxflta+0wrziuUjcoQtJS5m+thE5lpw4
	 5kGBe3ehwcdC0fJ2BSE3TxMfw+DS75I9CR0be3h+cbkWCO7HQXZYyqZv/rMJqpp9gqZfY
	 Yo0nEodokPKIoMQKmV1Va92x8RqjnB1JLYj/4GCZwpkTWPpyUno2NwY4d7jlNm+JRig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iq9eyMHs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA2B606A324;
	Tue,  3 Nov 2026 14:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iq9eyMHs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7B51F000C1;
	Tue,  3 Nov 2026 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717249;
	bh=CcwQtKt8p98z3nZ6v7GVVoJYg9XQ/4wAmXztnPTRoMM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Iq9eyMHstCQbbT4lxVLStphZgJXCXZr1LD+8HR6zoL6SI3XDnTvNIL7/IDGpiWoGp
	 6LRT+Jf2/rw2ZagpH0lSWUv8gDqvFkOho1ggYUba4Zt/1LHRWciRdIZRjWztqUNVxr
	 Gy5Z8RmZ/iuH+xhZaiYaZPzNzQsw6jFgukUstj9zpOX3Xo50vy1HO6bgCkwskOaFTa
	 8furxKuxrl5c3bNBuHpiiGPAiANnExVG5tU1aQQd6AWUt1g45eCWa3KG+rhy8MieOn
	 t6P70wg04vvmSk1BoQp4Tq9a7jvOLdGxp0nvIUBUxQGtmJ/JQPHcuWhvMX3cPcoloy
	 y+Nze7fZpewzA==
Message-ID: <sashiko-outbox-195473@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 01/38] PCI/proc: don't truncate the position of
 config space accesses
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_bus_pci_write() truncates the file position to an int. A pwrite()
> at an offset like 0xfffff000 turns it negative, the check against the
> size of the config space passes and the count it clamps to ends up
> larger than what was written. The loop then reads past the end of the
> caller's buffer and writes all of it into config space at negative
> offsets, which pci_user_write_config_*() pass on to the config
> accessors unchecked. The write also returns more than it was asked to
> write.
>=20
> An offset above 4G that truncates to a small positive value writes to
> the start of config space instead. proc_bus_pci_read() keeps the
> position in an unsigned int, so a read at such an offset returns the
> start of config space instead of hitting EOF.
>=20
> Check the position against the size of the config space before
> narrowing it.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D1

