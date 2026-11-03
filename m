Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719108;
	b=Ofc1SKNGD+u6ULzF40CHjGiHcwpKAL8ljbLxSo5bYVRjdQUVz9+XJxuQ/xfrATYCxPZD
	 IvAb2NVM+uyCdbj2OFbwSlkylPfqc2H3aK4/MGLe0fZ/zIlZulSVaLSbAYLuI2qCvQ6v8
	 cOseZRTvLd1bLzVcYLjpiFHrRQN2dl7yutlQ7gGi93GVbe3BhkjTBL1LrXpz1nvENzlNi
	 4cPYwDzb9kmc1aHGcWh5u7ePRIVcaOnBp/UzeCcRZcE9Ey0QSz/7ESWumQWyPAOIxLSc3
	 YJxT9kipfjuAWLbgJlulDe5NaQ5/WUxgC/gu+AsNZ9B67/myTBAP+nPc253d9XxaqeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719108;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=COmy7lgtAJ8HjYnvwZlyatM95Cc/R3fEepPQFsTWDRk=;
	b=BtNgClH5InVS8rbcMzwFb3ned9zynrkWiZmS4B9gUQ4CwUg8Ezow5C19YfYnMS44V85J
	 n7QLBZn9qZxoiP1toIrU7pfBwj1jjmpHZlG9ErWQyajRuJeZaKll8NLAnoSr36fqMTXFt
	 NbGmZ0fpFybyFOAcKaWn8RuLqBYWyzKW3HaRqYqPmed6PJr8hU672ZiEi8biYBpZk5z32
	 ko8aDCcZfQmArZOx7MS5/sk1m8Dzct4om52pYukpJsFLiATTdOI824mMJD/78/U+KbqZN
	 yMwVZfBh8NMNSKs8KswWb/9/is0XH+jWCrMOXZBTEdavrn/CSDhpklAK2q5pv7jM3iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=frDTm6yT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75A4606EE90;
	Tue,  3 Nov 2026 15:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=frDTm6yT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D1F1F00A15;
	Tue,  3 Nov 2026 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719107;
	bh=COmy7lgtAJ8HjYnvwZlyatM95Cc/R3fEepPQFsTWDRk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=frDTm6yT3bevsP4DaCnnVtk66+Bdq9DiCW14YPmrY9E76z+eXmS5xcRY9JtMjZfaK
	 uO3JBh6L5k0M2tbG8prMNfOIalV0NwGUjAwazvLQwfZ0mYE+NeNJAGwoFsAQUyfGXS
	 FV9vek10ph/worG0rqyc4rJJeOwgtzQATT5RIWeEMhQ0jGPYZl+fpGUs8LbexXEUyx
	 uQ8Vcx8fFuyDnqEKZpIbM5XZIVeWMjWfeIs8gpal/kk8xiXemZNch1aUtZNS130AGY
	 Qe9fs4FIXqch3OLvR/m5fPNY/mofwiPPZys9hAALm6BUn55IKNJySBTWoLz6/xziXu
	 HSMSSN5wgys8w==
Message-ID: <sashiko-outbox-195582@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 02/23] zorro: let procfs copy out reads
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
In-Reply-To: <20261102-work-procfs-drivers-v1-2-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-2-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:26 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_read_buf() so procfs copies what is read from
> /proc/bus/zorro/<slot> to userspace after it unpinned the entry.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D2

