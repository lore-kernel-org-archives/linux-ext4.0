Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717299;
	b=MSU0Dt8cFZaa1CyZEzenf4jg6XfvTwKRuMjxPOcb61T6DBKNieAeMNOE8s9kHV+OShtI
	 3lEYQaaWi8rBuqgL51tArVcFS8AL7woIT5aCo6jc++b8ucBCbLPbPQeNx3vajEafp38ko
	 Fps2Cxwq4+yh8Gou5MnC8vzcNRfTbDPmmPC7pUJ5Ynjd0yixGAandW6OXKIc2Wb/hyEDw
	 SV/4qPsWwNDlmWIkQaCs/7HAlnz3OOcqlFDg7BFOMZWIEmWQK2TkYep1qucpWJaXPZ4ar
	 bYUDN4paqGx02sWURVQ2UZpr5uZEpx6cYPrbksTeUl26dYiSrq49JrbuOdFzFvXrbHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717299;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=a7PYmXCvRfg0BwzdfEGz44ga4Pu8BO8P1McRUIl/QmE=;
	b=5ejO6e6ZyctT6IZOJswMLXzfFuiwePOurRpeuYDIE/wEvI58V0FMvyylPkGquyRtanAu
	 aWq2/vbWbMSqbbAfUX1T+I47P9VlmPhBa+Cg0ufd1eKQucW5m3J3hAVeQaZZB3cmvi7gp
	 VTfIBWw1jPizAMpmTyKlOrbyPd3idr3jIKvk56KigOeBYXNLWJcymhPnTStDwqK9fLq5u
	 JDmzA9J/N1DgPlnA9ivkQplAgSHQiavTbLh64xR4NqsX9UTxfnjD8jSnoY1s56MgHPaOZ
	 BwDJ8LdMGjbhqYcio0AckPm7oo67U9llQ0QubG2h64l3Z5SVRqAXLzsVujDJHFonw9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LYcaZ7np;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FF86071C15;
	Tue,  3 Nov 2026 14:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LYcaZ7np
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308B61F00919;
	Tue,  3 Nov 2026 14:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717298;
	bh=a7PYmXCvRfg0BwzdfEGz44ga4Pu8BO8P1McRUIl/QmE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LYcaZ7npTHcFZjRzH7+Fn7MvhHCtX0Mfq+N7asGR7lT4O/D1juNNOdkQoItQPXgYp
	 izFBnUx2NnP6oS7/UFWY3ZtlEiHQGAb8tqYNXHfwpj3k+q8UhKlx3Y4Pg97Y/XyE6C
	 xkIjNo0WOFg/e5GUKQx1UXiaj6PoeUJ8Rmrh0A+WWO6gWPU/v7hy2cXWYqJOtZ4R1f
	 AJe7tJP3tO80byckeYCg7WXwCIl/UiBUMp8jrZdTJOebfpv8qtOWQYXX6ex20nPx2Q
	 aG3CJ/kyI5aKfpxI+HIjIsP6p5FlMEL6CTbtmCCpK2w8UzCSgTGpCSlE70jaIGX3Vm
	 wS/Yy4/2pHR0Q==
Message-ID: <sashiko-outbox-195497@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 25/38] powerpc/crash_dump: check ioremap_cache() in
 copy_oldmem_page()
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-25-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-25-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> copy_oldmem_page() maps a page of the old kernel that isn't in the
> linear mapping with ioremap_cache() and copies from it without checking
> whether the mapping worked. If it didn't, the copy reads from an offset
> into the NULL page. That oopses unless the copy happens to be a user
> copy, whose exception table entries turn the fault into a short copy.
>=20
> Return -ENOMEM like the other architectures do. read_from_oldmem()
> turns that into -EFAULT like any other short copy.
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_pag=
e")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D25

