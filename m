Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717262;
	b=qVElLNp+YOAlH8Hu9yPog5uPGFjEaTTj6wVjyGfRlKZxMBSWgjanKT1eAdYdwgqNRI/7
	 ftFq4sfXmNJKnEeHjiuF5Ppj59NAtIRRM4dbFZcMBybzbLQkS06ZhOFG42RkfnnASKvbS
	 LL5pX9+NyUNTIc3hoVEHDkEgr7baFSHaPtFalrnw+UKZI8V7eN6I0SdxiA5VN10K5JCmo
	 pd2eYt/K4WhsylmS5XWEKUAKln1Zo8kyAO5v6WvCNQEBtsg1avWdPYXcVnYLD+3ti3NO4
	 pQzPgcWgmbBeBn1iuZmS97t8Y0W5ayLiIdwIlfUeZ21twkIw1kfsTe+HZz+d8Cu67Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717262;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qAOPaMWfnZdlwVSHYL+9rw86rJbtw6B991RXjr/ZT6w=;
	b=5ACk6W/DoRILihz83PmnAu5sO73+vR5unGyohjtxgiUuzbwT93kdcxRViXXrsWBLeUq5
	 /W/XMXuBRwqv+56zIvjOL1oB/e059XXhkTVlMMj/GUqRYttd8UeK1YaSby8hayeb1q5A6
	 eqse4u7islwx5r399zayrXKPJ1PhcWUe5SMzElUeg1SpKu8Wj1Y0juj6VH0gufX8FBmEF
	 mbhN8zb8TUFjQKL5OQXWrM0UtPoji6y3KkObwnCBXYWEQYgQ8WoWSD1uWvDveP2wqbOE2
	 4JmXggwbAQql44uEpr3kCM2uAEKE7IEh7Bz1dnMTTg+PYWQZZugNnvryWVACiXoEcjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="A468O/vZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCEC606A324;
	Tue,  3 Nov 2026 14:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A468O/vZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B431F0093A;
	Tue,  3 Nov 2026 14:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717261;
	bh=qAOPaMWfnZdlwVSHYL+9rw86rJbtw6B991RXjr/ZT6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A468O/vZdHBCD7UZ8UlB4cSW6Wo1lS1VWajhi1pTgPoFKYre1RGq69cqrrhcrxsuF
	 k422eyUGzdP7ofPMeyLy6mjVTMbhvybiUdIWqaAx7URHqDYYBVQn6dZGzbDmUfE6un
	 qzuotRGPVzOaL405ACUuj2CaDtKcaw8pCw0kTqtzCJN67C+LtIgWy3OieZgcrwMx2t
	 zcaPbLjrTJ+q8VGMuwdq9ud2hPp8483QXmk3XHJSNg2Z2p61qNJyklOPHI9wXFujkU
	 I6veXuBMM5qIzCu924WMLvJ6+BN/lGnAxoVA5YXv2Dy7ECUP/Z98JhXC/AIwYDtl6B
	 3k+Ju+9+jEFyA==
Message-ID: <sashiko-outbox-195479@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 07/38] powerpc/rtas_flash: don't read past the
 validate message
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-7-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-7-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:39 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> get_validate_flash_msg() adds up what snprintf() returns, which is the
> length of the whole string and not what fit into msg. If the update
> results the firmware hands back don't fit into what is left of the 256
> bytes, the length ends up larger than msg and validate_flash_read()
> copies whatever follows it on the stack to userspace. Use scnprintf().
>=20
> Fixes: a94a14720eaf ("powerpc/rtas_flash: Fix validate_flash buffer overf=
low issue")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D7

