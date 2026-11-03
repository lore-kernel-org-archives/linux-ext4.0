Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718078;
	b=Vt1znFqYr4w8Iu1N93JVk8J5TljXGmAr96z6SVOAGk8wRwzv3e+XRcqJZKj1ZeTkvjjf
	 eX6aQ9r6+fV4idJI5eYRyFbYs0rKaKgPp3WbVddGwn7Gwz25HU3PftKm851cFlh/9rOIW
	 lMLj5miaAETKils0uOlaATz1tlr+EuLeOkG5FwL+zIcdD95ccj2JBjvzpOjjZNiRlZaC2
	 EZ1rMOaq3nQMF/XVWtji1gcIVcCdmzX8A+Zqc5P5z7FUEHEbVYzZxjxZ5Rvd2edZbcORa
	 5y/T48g2UYH1sC9JeCnI9kU59jK/fIfXQKs8KG2dUltguXJhWF/9zCzIv7mpjm/U7Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718078;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LtZqKTI362maYNzVac7eehRAzsprmajrL5qhala3VHA=;
	b=5Aj6GPx2DxbCwvzNHHiBFh3ErXJbDfftzAJpaj0iRDj5cd1Se4VLdreliiLHWDflWPpV
	 msqg9frH80EbVDeoofVPIqMuTQjYSJqQMXlGEzlj8mg4alvaAgSClQNAagv0BFx0lBQFg
	 TjXZTo6WAiXwmWbgaVWQoSiKj3nfc9/xCeAQ5xsSX+hVNyCLWFo3I9BP6gN33BFqgtc49
	 Nzja7OpAhLEwOC4UKptjo7q8m45+z8knAwa6w4Y/wVaXRZ7emUfzFF54eZaMWldEs0MrO
	 O7bkZ8ZB/EyzCP+YCT/gpYxy9u8DacPPyScI6moDELNMvA+b5T+fKQW8pD0sOrQf7qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eXQpWkc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD5960A2622;
	Tue,  3 Nov 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eXQpWkc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55DF1F00A18;
	Tue,  3 Nov 2026 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718077;
	bh=LtZqKTI362maYNzVac7eehRAzsprmajrL5qhala3VHA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eXQpWkc3uOcqQ5JnVG8GDwDONMut840YqiKHt70+ZChrT9F/gAuTzrJ1MgF+EtTiI
	 pIHnFVjjMPCDE4zUdFv+KrsHUA+gcjSot3YPwOmRUGnBpAxlYE54E4N3J6Y7uuyugZ
	 +n59+5WkWJ15XUosDXPVIaRrh1gNIRU9QWFK1gVFuit7QU1S9OQHEsu0qNCk4nqsd6
	 0O4K8YNuO6zhFE7kHEwN6K8N/CGGW619TSA/cOokl6UTRnf7OmZioRbUlPVGsC7EcF
	 v8E8ffn9nYk0ynAGCilOHRhHf4IJen3hNNMOl3BDkuvr7hr4jJt1eND9Pac/6Y2uUb
	 Iuhk8b32INjKQ==
Message-ID: <sashiko-outbox-195534@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 07/16] treewide: let procfs own the seq_file of
 simple proc entries
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
In-Reply-To: <20261102-work-procfs-core-v1-7-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-7-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:15 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Most proc entries that bring their own struct proc_ops only call
> single_open(), seq_open() or seq_open_private() in ->proc_open() and
> free the seq_file with the matching helper. Declare the show function
> or the seq_operations instead and let procfs open and free the
> seq_file. Reading these files then no longer holds up their removal.
>=20
> Done with the following semantic patch. The new initializers were
> aligned like their neighbours afterwards:
>=20
>   // SPDX-License-Identifier: GPL-2.0-only
>   /// Let procfs open the seq_file of proc entries whose ->proc_open() on=
ly
>   /// calls single_open(), seq_open() or seq_open_private().
>   //
>   // Confidence: High
>   // Options: --no-includes --include-headers
> [ ... ]
>   identifier open_fn =3D {single.open_fn, seq.open_fn, priv.open_fn};
>   @@
>   - static int open_fn(...) { ... }
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D7

