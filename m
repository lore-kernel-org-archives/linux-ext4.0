Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907346;
	b=tZEZ3dbkxFdvFTg5EshxD9gM8FJvkwb103UAhcktghDF5li3ijwTtrN4QA6dce0PBAns
	 NksB78BFv3W4uGG2JjtE9yM7wU+IUb3pY+g1uc3N2ElriaejSsl0reg8IXQaCce6T/vov
	 mUUDMYUj+rzmH0ZFAqE5/GBKgFVcysWdHqx95jXQ5uH2s+uzCHGK/4wJa/Vk8Rd8mmHPM
	 ECh7f9DoSD8Py5xAseQ7/0LHtysjzw6ivM56qRCzcQp6PNwQL/4Dvm3nIeNHxPSmP8PIU
	 gDECVZjrTahdKjAGshZgRNc5uXtxxSdyaRNznnoXvIAmJ/G6Bc8pfPXPltHkjrfEy7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907346;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gJEjJHr+63DkRgcn2DucJbOp2pD2WNeYTaMSKLiQVEU=;
	b=vy6EEKpUOhwpn2107sMtT9ndgO4xOj2giOz8ctiQ3UIqFi6nH5QMdPlFoj7JYGFBS4Xh
	 dDB9eIVDU/1T5ovo//TcEXdEWx3H/2Tq7xZVTxViMwRtwZwsOSkayQXezifxJfvuVSzGE
	 J9u56WVNWeLpMquwmmKVPdRQhA6b3MhcA2TX84QACy+leyRsRcjW/VlqIK+RbS3XYZfqM
	 KnI45T4Fx5zmlulzX2wFqiw5IsdDHNzj2LuEve50ZW9rWLL9ES6Kt6qVRHyORmWL1uuwA
	 whZMhD6QudPXEzmeD28SDhgqO/sa4O/wIfjPW717aHu3fvq8Ge7pCsnoYspenqicN7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lowCxpM8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D98607955C;
	Thu,  5 Nov 2026 19:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lowCxpM8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A151F008A3;
	Thu,  5 Nov 2026 19:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907345;
	bh=gJEjJHr+63DkRgcn2DucJbOp2pD2WNeYTaMSKLiQVEU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lowCxpM80XbQiSSCcFv25ROY9iPwr8AIjymBRSEeCKy3QRBb1FptmRHlNq0Wjq1/k
	 K8/iyufGkzQLPaSJrtMq7r0Q59oLYpv7F1FIe+/GUzbkWybOWjrwtgx6MUmauz5Wt4
	 oV10UyRGTXNAt7W7iafOiQPj3dtAFzUh5XC4pmHZNFWGPa3YcQCFuCi93JRRZ+uDtH
	 jVMDhvp+8GKhMC9jEJ2uzOHXpPQBE2ukBHORlZ+DaGIimf+CjVuQPWP5HCJVMkLor/
	 vhFuj9C4hZBYSNwdm7GtQwF9416SSchhrxNZmyQgRKmmww+fsBfmslktFGiW+AZaab
	 bv76fZfTqneZQ==
Message-ID: <sashiko-outbox-199945@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 15/23] proc: copy in writes to the network
 namespace entries before pinning
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
In-Reply-To: <20261104-work-procfs-core-v2-15-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-15-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:43 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D15

