Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908659;
	b=gSEm6yik85l/LIf3Krd2HqcMYFdqQM9Wq0lToODMSVHlt01DZ1yCRqmdV6bU7u85vHvH
	 mgHEKPi7ZvNMds8J/bZsIghJyq5xeRJpgLmvbOn6wG6tKfOR2ln0ziT2DFKsXhR4bRbKa
	 CtmD/g1zR+aa27+3imWK2LLSdLQBzpXPVJXTIZTgJNQ6iR2RJXI1dZnyNeBDXx6X7e3w5
	 z5JiuDyy7hg3K0IYxWtY6vR3KbHz3mNXAFitIBdfs6UdrivxsmMq5LuRmtdY+2eJutSfQ
	 +Dghj851cQYNg5++0Z/bVNVRMv+vYVWrleSPwQpUHIieGfq2Vq9jxFZ6AuTzCA2yqAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908659;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=q36wdAfT3M4q+Cutem6dQ8ae+d9ONuWCi9SleDJwiW0=;
	b=lFHRr9xQV4XbRHRxE1a4Wcb+ckS7s10dkoAwWb/MDjajPdXvho6PfkSeeHhZbMw2soJT
	 FQuErQClCd6M/Qe9iiK0/x9PxBP4R5I5hArKmw8IvtBu9QZATquXI3QM7LaNjKoW5y6RY
	 M+FrWcYJvRWLXq80SHO5ydoxoX9SV7upgi9pmwkG3jBrzQaW9FtNIkUdSaZz0isFrmT/k
	 0qbOxKAK74d/6r/hVkWt7Hh56ehcQW/FGuCQiWmlRfATWaK053MX6vHyTcpcapN8I+V8z
	 aOA0UglU2mMLDyyMZUGcq5iQkjhQC0dUXbv3zPnbg2EqSflQGISMjYMkrpX0aVPTAtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=injc9oEb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B42606A6DB;
	Thu,  5 Nov 2026 19:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=injc9oEb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351841F008A2;
	Thu,  5 Nov 2026 19:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908658;
	bh=q36wdAfT3M4q+Cutem6dQ8ae+d9ONuWCi9SleDJwiW0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=injc9oEbe5u0rMyptfS9zP82jPa6RN+/mt43pW4RrzZ4fqV8lFqqaZay7tq+gFrUt
	 mJbkmSaacLkGWg5NplOvP3NFE2t9+pKrWjd1QvRc/1a2pMaieaiwQ/9iDjsjHM/XFk
	 zSXzZ3RWVG43ppIECUCewZhgzmIHnC4nKqAkFBRHgj3pL3JWPmyNgTX+QXXiEaTfoL
	 Vfq2AQ9lOdZ2AVPzmO6pMyuEBv8Sfd2kD+IBIi2mDxQw+GwgkVOpZCsu5rYAp1zUX7
	 rHoRcWqVKztUt4jkkOAMRq59T+ccqw+Xfuexii4BpQBB+uZsgkAIFsedXfWIExYz3f
	 lrOwI/QAJ+4mw==
Message-ID: <sashiko-outbox-200039@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 05/30] nfsd: factor out setting up the exports
 seq_file
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
In-Reply-To: <20261104-work-procfs-fs-v2-5-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-5-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:35 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Move setting up ->private and taking the reference to the network
> namespace into exports_net_init() and dropping it into
> exports_net_put(). The procfs file needs them without the seq_open()
> and seq_release() around them.
>=20
> No functional changes.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D5

