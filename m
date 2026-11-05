Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908702;
	b=Z4vFWTUSYRau9Vn34unrsh/775qYNKj+JSAiGn1OpZDBGJsX7S9MnzxNrKvOCK95lHCx
	 v6oJr+H9u0aRlxq+Bs3+9W1qsjoDcFMsGN1/sXjjh2CUCNLld9scLsmtDMxenIRDx/+5b
	 LMtjh5A4dPpEcqzmtGqgZJtvsez3A7UOOr6ZdjC7P85UUFHXFJX8166PuM4BdmDFz8r11
	 /HSBlcaTZv6AvDCoyP0Syo+Gh2ObfPWCEhbt6iks8u68BwlrN2w+GvcsKndJi1F2DC0lk
	 QQZKLi7il2SD+PyeTRQcN3h3Cugs2Os/PxO32nv0e1eLX4PTbNuKkeWNk4ba7NbVMbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908702;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7/aaKuldQgClq8ReLax1ykoSxafbF3ZgLD9HjMju1WU=;
	b=kPiGIccfZZ/+DaSGFdEoYhOQ6cqMR8GucYz9CqoK+5Q+9JjGo0Qnz/iW1bdzpZKF/ufC
	 9bi1sIp1W4PthXYV+I4bRz85N34cCldYHfb6hhQjzAVtFsYK0HAFAHehzSleaDKjJ9yvR
	 xv2CcQpDNethcyxf5i06u5CSgrfsHNhT+0GqrUWtuYLVBLw64osK9OaNHQHnWIHsUaXV5
	 NyaXxC+PHIvtO7hrpOH8DMA4r6+6TjOd5LCf5wEPRgzL1gOLuofqa2jqFTZuTmye+mH4h
	 MFa6L6NsNvmEX8moSFwaEZGHBlfuDJdApbbAefBKCZSvfP1n02+yo73LqQ9mDZ8jDTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=an+GaGrP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4D6606EE81;
	Thu,  5 Nov 2026 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=an+GaGrP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3891F008A1;
	Thu,  5 Nov 2026 19:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908701;
	bh=7/aaKuldQgClq8ReLax1ykoSxafbF3ZgLD9HjMju1WU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=an+GaGrP6TdrpWnLckWrPSepsWmHkQ5XptZk4tHL+HpcEfNPQTKp/wIE0YEjMyswu
	 OrhN9uEyMFoYjQkeHuikFpy3e0zddTttGDFkpuIaMkcA6eGsZ9PG+nZXuKxpHyCsrC
	 SNCEbh0wSxS6z/Jb7uu4cFZEto4+IHTnO2FVyeKD50/Tzzg7HbxicNYxazMsJsheZU
	 1/idVdBK3MZnCoSpbo06TdxRXrO5ag6849zDW70fe0dwn4m5M5QgW3y7jxda2zX6CR
	 doTY9qkj5Jd95Yv6hY1F0fz7SIzfsktjfoFB86+JK9Sn5qjY0BS4iz7RIoQ4TBqsQz
	 j9OtHEdlaVesA==
Message-ID: <sashiko-outbox-200059@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 25/30] alloc_tag: let procfs own the seq_file
 of /proc/allocinfo
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
In-Reply-To: <20261104-work-procfs-fs-v2-25-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-25-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:19 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the seq_operations and the size of the private state and let
> procfs open and free the seq_file. ->proc_open() and ->proc_release()
> only set up and destroy the ioctl lock now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D25

