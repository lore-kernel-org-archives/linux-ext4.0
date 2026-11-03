Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719135;
	b=kfU290hcJbgikTANxAUix0rHzwufQpjPbDHMavrwQWWM39OHX1LCJ6urAMd2G1e76Aqo
	 pH+4uACq+kOeRm77q43Jddi4PnkSA5YgkzkIjUF4W7c3zPtoAVDLKvgTyCwbSD4+KQiDx
	 1geRNs4ymnKmBvw7yLywN+EfGKjsbKjDyzkJH/cMqRJdQX+xEdwiIQUupMPVwT/vH7o+/
	 bDFjaMQeeOHMrpuf65D4k6/vwHtNUORCuznjDCCHki7wZtL12xNYbMlh+a96tflmWK5Cs
	 Tfbbi1mMg74wSQ5r6YBL55/u3dtxulHJAol6Ii7XglvAPrYA5tAKgFfgBcwor8Yz6nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719135;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iYYDAQ4EAaFTojHj2S/IS/DlVIcz9P9xTbXP/dOtwJQ=;
	b=L3UhEqGlzy0tYexYaFJiSmffwPLGNwHcN3TrKn6rPtRSomybR3nKNPiSZo0Z/VsPghxp
	 V1YGFTuF+GIxo9Y2qmGHYnN1ztZEDmGOxw+vBFr82aea9zuEcnciBPv6uA7z+oDWZCEoC
	 IGuABAE0S7t9K/Dp8fSgxS5VYO4Xqw5MHHkdltMhu2eMbO6Mpj6AzwaCf7D8lmPawOD78
	 7gmGm4tpNRUuOlXWoEm9A2jeJt6fYPuX6Pz5210ik3tPBdTwhAom8nadzXrzYe+TA1TKp
	 E0Q8nFXZPdvBgdTn4cS8FFD4lJGGIPY+fwTCl9Jvfr2XzLAPAyPN5QeC813JMa3Iwag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E+3F0H5K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC17D6082BEF;
	Tue,  3 Nov 2026 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E+3F0H5K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363BC1F00A15;
	Tue,  3 Nov 2026 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719134;
	bh=iYYDAQ4EAaFTojHj2S/IS/DlVIcz9P9xTbXP/dOtwJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E+3F0H5KbEJBZo1I24LPwaX+Na4LHasmV3v4LtadaUaTQD3umUuYdZ8ca+KGfkDAP
	 qNrBUn7y9LjD/oybvflZdkENEKMguqn2R1IipnoivrEj21pGQL6d8oVnm4Wp6n41QG
	 I1WY6ZGFPNQVGJvuZZ2fT+xSlwX5FrZygE0DGw1KiLlprDoSQ68MdVoXik0agD95Df
	 YT883GFnPCcBmGGBRCDtBQan08iKSCeJT9s0may3cbwXZTQ9qXWgpU3QOTOqeSphOQ
	 RLFiG9EFcDDjvp+V5Qc+pKgtdVL7R/TU5Ji0CHKr0CSHpBLxQSyDoBcXjRSt0XfCLc
	 ncHjXD9/H2xIA==
Message-ID: <sashiko-outbox-195593@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 13/23] scsi: sg: let procfs copy in writes
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
In-Reply-To: <20261102-work-procfs-drivers-v1-13-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-13-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for allow_dio and def_reserved_size so
> procfs copies in what is written before it pins the entry, and parse
> the number from that copy.
>=20
> kstrtoul_from_user() looked at the first 66 bytes of whatever was
> written. Now the whole write is parsed, and anything larger than
> PAGE_SIZE - 1 bytes fails with -EINVAL from procfs before the
> capability check.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D13

