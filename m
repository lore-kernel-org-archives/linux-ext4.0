Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719157;
	b=pDU6mN+1uYZ29yyrOaurYbL7mZa0VebQ3tp15FHiJbzuHk4Rd96yCS5HmjbezKki/B39
	 R4N/YVnIxt+kPPOSLBNtqW2Tm4mmwK+rhdFEGZ3T5DLK2TqAEz1gZjtXmqr+5GaGKh0As
	 26JifgKa4dHUNItuYLTSBAAltBy6QaLhkG/xZCnSnqam94moHqW5c6XI+f049Yb1kpxHv
	 2zvDDZDNNpIT/I0te1xoIKmcEpZ38tBjfDC7qduzg1+5Df9BrmlM/A03zl6sIqBkp4Zrm
	 a/LCtLwrrfWMWftB8IqrouipmRQ4nBfSYsBCWc4MqiV8AJc9cKHmSHe8qKyeUxIxb1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719157;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=08+d1qfvreEkjdhfCWoVI27IHQFdkJLNOAr+NI9qWps=;
	b=JyV4Mc/NAOgNmfxu2Q6TMKw6+pNEfQLeWbyjjEqB9YjZFxuB/DO4zEPea9E0hYhSA0yW
	 /DuiH+aZkkivDxR63zVTNIwYs39h90FpJaK07uyTPCuh7bn/L9mv8MrBx9xsuOyAFs6fV
	 X9Adtx+yK8CAv6ZnSg4v1lry2OLDPTIXiO1qLvhf7tkTzpa3sh1P8Ly6iyeW5jZGxhYTC
	 zopifz+lbA8o2zoxvmX10UijRA6+VIGWbEWsE3aVwONLHcwKUH9qjAbPT3FIqHi7Mb3WV
	 DiQ2yW9HTc29AKWD2vT4h16pnfwyMaeC7qAQKeEY8BE3OcSQ3wsHQSXfU3y7C0LGPTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i1r9+8r2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A378260A5BE6;
	Tue,  3 Nov 2026 15:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i1r9+8r2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73B51F000C1;
	Tue,  3 Nov 2026 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719156;
	bh=08+d1qfvreEkjdhfCWoVI27IHQFdkJLNOAr+NI9qWps=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i1r9+8r2Wy5ZjOv4fJ1GoSbUdruq+AKDakXdPym36omcIQj5oI3RDvQXQkk7K2pOH
	 aZOYNjI9zOi+rkLqyjgQUDVNg8zZ4OIRXHIivKTwUb8xi0sYaUhL8HtOq4hFDxlnsC
	 ugaWfdP1eR4O/X8dqLwIEm3+bKrgwf1ndJQeP/YdlN8NK359AzrXxLprhNHYW/1Dpp
	 vL847jEpl/4GoCymsogWvpPgMP5lTJjt0Z9FMjl/iXXQhlwp8eo243i8ta6gWDAkpG
	 R/CGZIXSyz6k4CMqZUTFX4EjDGUfogAbrkZmxlVgTnJiWhIG78B81lpdbWmuce6I3g
	 Nyv+90V+AsLYQ==
Message-ID: <sashiko-outbox-195603@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 23/23] ALSA: info: drop the ioctl hook of data
 entries
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
In-Reply-To: <20261102-work-procfs-drivers-v1-23-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-23-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:19:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> No driver implements ->ioctl() of struct snd_info_entry_ops.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D23

