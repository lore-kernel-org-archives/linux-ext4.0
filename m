Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908159;
	b=Z8Ar0nhciJxeM0RmgEXbZ5HwnyDhAWDzaad+ruRNBh3UjY+DXnpRvtLOiTLXKWfyzXFH
	 1oaQx+2JYEh1ES4shkfN7tBZ/9rkvDSMue5DG7X+PVD5kI199m1WjB0qpztatldRZ90YG
	 fhX8WhwCMYxGFOc+HRVnOYjcTgs3GJod2Ge/709Js3Tm/9IBnaIHJWgypXI5Kwix/+Sbt
	 c8NLVzabfRGtiIwevzCQPI16WFk1iSEyaqDnYCqTvJUkJbNuET2CgwicY8L2jl/tYlYmV
	 mQFGSx+W29Ghm06A77oOB9r8K+polEU913Bei4Gbzuu0tn5ZrFRZkSPINRU5A+GdQLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908159;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LF8VpmJw4dCUN3dqspTWei3V377XPonyjnxs49cHpOg=;
	b=tLbIdr5brH7RDcXdD7Tv0fIN0/NdK/Ktv6nwPxIVkWJCbDq/ItdUL3Rwh0A9+3rBYeAt
	 9kuy0PUYosaaA2fXr15cLKAhDgaWzjHcudKDyncFH8WDhk/urm774XIqnrhiOeb/i18Jk
	 ejlAJ6kxld2MEqMubmI+mCvwddwGt2JBREvyd4jgVKAO0MnAQULYDJN2f8k2vos92C1tF
	 re6fTkblVMuQyaKHa8dssqN0k5dlcxdWBGbxO08Hy5zRk31QN6iJeeYam6VUeyCh7+y63
	 F0ycxCkTANL4KMInHHio4cPWjT+Y2xm5GKnWii/q6HuF6Vywf8wT4TxAl1vXQBoeD2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4uXMQS0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95A60705C8;
	Thu,  5 Nov 2026 19:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4uXMQS0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7DA1F0089F;
	Thu,  5 Nov 2026 19:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908158;
	bh=LF8VpmJw4dCUN3dqspTWei3V377XPonyjnxs49cHpOg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P4uXMQS0qGvKvjXwimwvNpEP86OSTy+1P03oepuCWi2uHAnixHXsgMAU6QqtIOry3
	 K3QqnkC+misS2LDKVZVl7RGt5gyckxcJdleSix8YLMu65Jc+DdOgSM0oSOd9tUEQ3b
	 Fp4U6JF/uNE8R52gsNWntUcjnDZkqxkce2kcKjifgoBueIcJVGHhk/f9XP4Nk5o26I
	 Eb0/TSjZ8oOdGaJC1+/zDtxAXdUZ8ONcd0qruzsYz7D7ovOHWwNXas4S58DiNRTZha
	 ovqkoGSLcs2Uzae2+RygZDj4AM5s2bRqvh74o9xP5jgHwhTt3uTIudTRbgcITC2H9F
	 XJDGcW2q+s0Lg==
Message-ID: <sashiko-outbox-199992@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 06/26] md: let procfs own the seq_file of
 /proc/mdstat
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
In-Reply-To: <20261104-work-procfs-drivers-v2-6-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-6-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the seq_operations and let procfs open and free the seq_file.
> ->proc_open() only records the event count for ->proc_poll() now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D6

