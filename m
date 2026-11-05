Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908670;
	b=unpM3fga6C8AXcpJ9AdYyJL/P68DY13u2ZjZOwgSCCRwG9t6BhAcU7e/4pbhv9EJ13ur
	 iNGWyV58ouRV8v+pBAubJPFJVyOB4T2AS0qUzA8IlCq90d9rQ3zK7SJHrPWKxOvRonS0J
	 vmyZ8mr12a6g835x6U8KgvPc8acMOPZBXN3ukWNrzxLpV22xu/Lbu1pSZYhdIyhFXDBaH
	 YZZ7kV5OSpm01VPk/zF/D0trbGktyvHUCEZg/BIghg50O7hIWD9CQAkZjlmcfKTduH7Is
	 kW2oZe/XuUBxXfED8ZsgWPM91l7hRyK6pAc6Nzjp94pBuzdJfAc+wOgEAUdkMXAYFFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908670;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NRKKgBaULAjA+HtCrE2b2BaKHLWg/IWOGmXDRpIt4CQ=;
	b=0Z0U5Z+JFPaj+61mJZ9dQSlbkqS7YO6qLZP/f45hQl+ICZhqZnT7WqueLXuDJtaC2caQ
	 fDHOWWLJIg4j2C+XXAVbIjwhbrtrqdHQRdJcdocEDJ3tELEQEQGdxqSmeM0pQmezWcnsW
	 2iRQl3CyKhX+NnHYqKzjZd4epPutc/3O9vePVJssQN//5BnNnhjQZCxXzs9Jj8snWzU23
	 iZk7xo6ubrweWozwY5Ec6LRIIBTvPyiI1E2aXpeJWdTey144DNIXhbPcJn0DWFTTtJCv0
	 HiJywAhyEhda++i2FaaMZ7o8Nnkyvd6JVeg984My6N6zpGPc4qZhBFk1RAq/vAB3ZOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zhykm1PJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1F4606A33B;
	Thu,  5 Nov 2026 19:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zhykm1PJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1571F00904;
	Thu,  5 Nov 2026 19:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908670;
	bh=NRKKgBaULAjA+HtCrE2b2BaKHLWg/IWOGmXDRpIt4CQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zhykm1PJUY5wvMtL/zZjQkbyq1PyvwZC0EOgbc/mXkTXjW5jEDUFBHmJDkJa40t3l
	 GIpVPB7pCfyT4P5CA6CEZXejqjXrq+ic8kl3YEXNxI1//5Q5Py0E0a8kNnqcjW6hPi
	 K09iDwRpN/qRrfyGrXfrtzedYO2f0xYg0e0CVFZSUsUaxT5QaMI//WK8iMNBQsmWUg
	 QYwurgr8Y9JSYLqma2wGeJtJYAI+2EiMBA6btZmAUfr8ngEY8HBKKYPS4KNStW+JAC
	 Nmg8t5UHwTP7n5VK7s22hm26muMFtPD72IEuPBkcb9I0XmHhmyLKRTBgGvV//TFzuF
	 uHK+79shUVmhw==
Message-ID: <sashiko-outbox-200044@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 10/30] genirq/proc: let procfs copy in the
 affinity masks
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
In-Reply-To: <20261104-work-procfs-fs-v2-10-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-10-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:48 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for smp_affinity, smp_affinity_list and
> default_smp_affinity so procfs copies in what is written before it pins
> the entry, and parse the masks from that copy. A list of CPUs can be
> longer than a page on large machines, so the files take as much as
> memdup_user_nul() could copy in before. Anything larger fails with
> -EINVAL instead of -ENOMEM.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D10

