Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717273;
	b=yhds9YEdgRYF+3BIjQ/1mXWXmgaD8EcGTqtSH9N9vzhTq/V5rTDWxPSs+dH3vfmVYN9/
	 8hmjdcjkSq3futZ3U0bvL34WMrTVwmRG83zddn2adnC8kWgW5iAWj7uCMI2M6vP3YgSSU
	 bQba9sd20XGoHIx59ROX66Pgu289wxdf2Tl9nYUOEwooMvySeuK9ID4NAcsTDrjPja8wW
	 +0iHuOV5zFTEjZJ1E2PfX2YsIqll7vEvxZc1oLXwYolmjqVZ4TWdcNVaLP+CZAaTQHBn+
	 th2vkWFfOdrWmTn2cc2rGbWjZYnIPfO1KJqTZBYE13YjtEg5zBYFeKloKU9jBEQnZYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717273;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VXMUtsHfQTM8ehBaoiCzItOpo0wlFMHyP4KpaoP+TJw=;
	b=rifEp6W+LbdLAIa5Ih1aDsZxfGfLXG3damcSu5PtXuiMKmSIZGIOkeeco26Syg5w5LzB
	 N8M471k2fuyYJXqfNH6ytm3d3pxpoU/NCBphvAsGHuSKCvj/82yeBV7FlyCiQUyrHspl8
	 Lbc6NOisUI1jtFow1Su9xWf1dE4WhWMxSvApJW79q0/nPTDsWjiKbFaWHKj8r/mm4fk8N
	 ifeBpq4z4S0N1ckdoA44Uvn3K74u4tOLodjKleWwKg6FS0F2wEIdgjGwrn3bYYVLsgUJy
	 fweHQiPZm356XJ3Sy9yKC5Xjwms0K/tysBHcSZHUwLur8hvJ2SqJf7zkMWyqRMoOZbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BhIDX50f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6C1606A329;
	Tue,  3 Nov 2026 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BhIDX50f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8581F00A1A;
	Tue,  3 Nov 2026 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717273;
	bh=VXMUtsHfQTM8ehBaoiCzItOpo0wlFMHyP4KpaoP+TJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BhIDX50fZD3GGyEzS/ikmaR8zeMkB5OGeMIgm/tbgOhzPWrBZdWsC+tbrpR28AdYr
	 y3gIAbA9tORdQwifVX097HrJTcxhg5Ti4Kg4bqcyLx0KxPC3OdQlaAqq+EsL5DzLEy
	 y9ezT0t+gH5B6gfU6yBTJLut1mMFzWSgEkEMq984oe69utPAyOufz+c5qMd0DsJKJi
	 4chNM7WJ/pwpiLiKwaDsdXRchxMXpLXv3rTqFY5iprInrROKqH4oGU7pwml/nW6r5m
	 XaOnNRmGJOyEf+eVhyWOUyj2w45ZXuucOBUsC1wdU5xDQHfLFXoZkbzuNGGkUHo7vl
	 BkrM8qAOk4TnQ==
Message-ID: <sashiko-outbox-195485@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 13/38] scsi: core: NUL-terminate what is written to
 the host proc files
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-13-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-13-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_scsi_host_write() copies what is written into a page and hands it
> to ->write_info() without terminating it. ppa and imm parse it with
> strncmp() and simple_strtoul(), which read on past what was written into
> whatever the page held before. Terminate the copy. A write is at most
> PROC_BLOCK_SIZE bytes, so the page always has room for that.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D13

