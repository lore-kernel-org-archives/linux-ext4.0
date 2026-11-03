Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718091;
	b=p8gmC7tSjdl4lfQCHEynRVcSwzIp+xsQuaTLwmI0u86M4LjkYegLLtAsR1/l/8nqbEOd
	 W+SdGeodjKbK60jKvydfjOXmRAEgaTCfbfGsHvP96aXjt+611I17zskWCXkJ1PAockVC5
	 rkhf/W79BgUux4h9FL9yC/3VPaSpjWoW0LA/85OERIeziZpAGsWY+uWBSWZNfzyXFVZE+
	 SecfZZP/WPx0LLXC+0Jn6WSUbCvQznT5KxBFNM3k9bTU/u+3waLYP0tCb5AmU1DDmaopM
	 NclvRH16cd4WpCevigOUFEKRFFBiRrYau83A20Z1ZfrpxMvRRW8XYlYzQgaLaodtBAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718091;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WfzPGb0Mse4d7j/Ua/7Hqcs84ZaSl689mor9HstQNz8=;
	b=MO3qxJA7rglH9oABUCVDB/kT2hqaHmourbCsOKWskqbN/x/Y1Vk5JxJazGjqmM+YEKqx
	 KdnHvpLte5IiDAhp17N8dNPzVLD3THAjZd1OSQWbYSsHdy6tzYJJs2k6+jiEGJV2Cdosk
	 fd+vp9/cZGLyataBP6K49898PuAglWXB8MY1Bqrd35hkiOR/QSeTPKYwy5kjudOVDhjP5
	 wolfGC4UaOiUYMXjcebzM8O6Y1r1pG/1UQlhLD1aICt5ZEqnmxfIW5dvV6RRnVIrl63SO
	 BhZUG7VgSR7KxHaFahOexbdcfLcstet+1fa8Ra02yHVDIAGYqneZvOgDXHFNbd6oYeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VraLAnBB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D66F60A382D;
	Tue,  3 Nov 2026 15:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VraLAnBB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2A41F000C1;
	Tue,  3 Nov 2026 15:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718090;
	bh=WfzPGb0Mse4d7j/Ua/7Hqcs84ZaSl689mor9HstQNz8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VraLAnBB8iEvmuoFb3nDU7FUs/OmRWlZd9pI9El7xtmvFcFjZ+qsTCFtm8qJ9xnTM
	 kZFFNDj4VyO1XZNaC3TdXCV7k2MHalKXAIfEl24qYuy3Q/kp4jATM2kbbUSYelPIDC
	 tyQNwhUsx40ck67Idycq/g4Mx0MXAM8L3yCIUU5aup1rNinI8ezvlj8cI9SIkBs2YI
	 YhTRb9/DSO2hApTFTlEyef8iIRyHggmy1jCTzzV2ScJbqWgWFlD6/4XdOY8PW+tzGA
	 rELCIcGBlWlXAgY4tOu8FssC4VZR00sq7XeG1Rh0Am+N2IMnn6IPB3We00OphZHjDm
	 jWEsDfW5tAAQg==
Message-ID: <sashiko-outbox-195539@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 12/16] proc: copy in writes to the network namespace
 entries before pinning
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
In-Reply-To: <20261102-work-procfs-core-v1-12-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-12-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:28 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_simple_write() already hands ->write() a kernel copy of what was
> written but makes that copy with the entry pinned. Let procfs make it
> before it pins the entry instead. That covers everything created with
> proc_create_net_data_write() and proc_create_net_single_write(), the
> afs files and the rxrpc stats.
>=20
> So a write to a proc_create_net_single() file without ->write() can
> fail with -EINVAL or -EFAULT now before proc_simple_write() gets to
> refuse it with -EACCES.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D12

