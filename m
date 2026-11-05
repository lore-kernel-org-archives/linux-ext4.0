Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907035;
	b=ipERkEjvF5bX9OayOyGJMjuz0MM/YwXuJ0ge1/GkeNbXwDTS8uAqaBcWvhHGekej3a/+
	 cRTmMO+54bOKdoriel3ebOEwDMvIzB4AusOfeMXPTCtFhzm3EmEAQIE1AyHRx4xtiQQ8Y
	 xCbXgJFYQTwlLJQfA7u+LWBmnfvlz4C1Vk/EjCXrKKjsdN9SPAaiNIXs00ySUT6RiDCrm
	 jjlfa0fj1hcomUCREhQ5oOkvvJ/MNqQF0HUixzVJWqCpDCJJFLzhC2Sqqp4r7YXoXASAV
	 Hm/s02OHnNX+uDxCOgQ+7UrM65lasEpxaOnBFeB7texLohEwMeCzaT5xCM+rKjsEXdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907035;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hhNNwe04L4FKYQylx+fx8GowXeOCuwfY4bU4uoMs+Zk=;
	b=5qZRG8ZhjnST8Dut+8pZwMY9w2VdqAGZiZdERrsnHGqDGBH35NQTTAJuy2ZjCqKu8j4D
	 4Hd90cm0+Rgi0eQYllv8zz+EMxLSsXxJEM470HMoyAYdvBD0IDAFTlSQamb9Cmhzoehu6
	 hmua4rIQYDBYUgvpJuUavRH7ODZWFEXGprO8nfX4+0+C4bDC/l18jNF5p0XBxvf6vAqcu
	 sefLh+7LJEP/ohdiszh4MopvBc2+qrYWIampZH6DNBXDv0EzDyEpeNJ4V5Z5i+ymHQW/u
	 tIXbZE+5AN6HJ+4rZ7EaaVwTkcXAxDlJ5VFciL09tvQo49fr6WFBVLoyWbPwYbd8Uqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="H5d/fGZi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962A1606D804;
	Thu,  5 Nov 2026 19:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H5d/fGZi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA2F1F000C1;
	Thu,  5 Nov 2026 19:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907035;
	bh=hhNNwe04L4FKYQylx+fx8GowXeOCuwfY4bU4uoMs+Zk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H5d/fGZie/GoRN7MHtK+vOB/Ap1IgYNrnS7OIFVYrIl3BAh2twEoWoV2v1D1ANr82
	 Z88cSeALKxyTaNGZMcx6eAjOqVsj7JMMVVHDzaMXh9vzmIx4JwInJVfr9Glo3L+Jbr
	 EcyVSXsNPriCocoRBtla7Tbb+aIbDHKYiN5X3R3O6c36//3BOWw3M4U+PaEq112AWQ
	 9c6EaQ95R7dZEkoNxWPFXpR5y//vT+nN/V5TXpwOF2BZ/cJsAVeFgDgQAnT/m8f7XF
	 3V3fQRCNlNmMpcBNkB0tSssvWsyXhfdHIwU6LUOeywmgh0K3F4lJUnYbrVCAdczb3x
	 LI5cY1vDJVFeA==
Message-ID: <sashiko-outbox-199914@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 51/51] selftests/proc: check that a faulting
 readlink() doesn't hold up removal
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-51-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-51-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:32 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add the symlink case:
>=20
> - readlink() /proc/asound/<id> of a dummy card into a buffer backed by
>   userfaultfd
>=20
> - change the card's id through sysfs while the reader faults, which
>   removes the symlink with snd_card_mutex and info_mutex held
>=20
> - expect that to finish without waiting for the reader
>=20
> Skipped without snd-dummy.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D51

