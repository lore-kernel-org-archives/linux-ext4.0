Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908700;
	b=PJue1AyvEP/T7U4VwwcvoolMkWKRZQLHsA6K7CHsINaOg5enAI2+4JOFP4hLyToSmqVo
	 /8DoG+kTsX1keqlzW1uxJh2xAZHgf3nLn8Bgv72VSFhYMFaY4/g6IbeFnpkzc2fhXFbTe
	 g5skuFPbKdkWfe1PvENqFWDPe2ENrL/t399O9kchqUV1Gyjb/CvkQx/gcsGVWpK7TRebl
	 KM+do//uecmCnJgPKJmunit6/OOJbO1OrYt4IxeaWye4SC7Uc57xJnSbH6+jszzuRia/d
	 13CMm0I+I4N9gzwb/GzosKQL0gar5RkwtYIYKHqN8c49Q5vDQ03rLRgeUcJ6+FoU0sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908700;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8t0QfyFe1liiONBCTMlez4ytrK71Ift17tTGikupoLg=;
	b=Q+72LgR4WeC2hMC1xhlV1LNYWma4JYxFvlAo5aS3kK1hiJJ/2/WzPUWo90UdYoP/F2kT
	 j7Ms8clvxpeo6aqV7fC7FppNlQZv2jBupzMJL8ONPKs6h/6R2AmIrkeAXK3LTL1NzyTUm
	 TrKMO58PplcS62y3YJzLwUJd5OUd7wFsT2oyMGX0lwCb0RAA6pVhqk7Muut/vIKoyTZtk
	 +sNPdNtNDWZgctwJR6GU+k2s2o8DbLFpw8o/rek+320Ca0nMdnSpj9NXkfH4a57L1T2/w
	 yT5jLT+dangWHtwBo00Ubcz5ZFhbIwkDsZRfegAAv4oSZCE6ayg5uqtt9U/yiLRA3HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEI4ikOB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23814606E42D;
	Thu,  5 Nov 2026 19:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEI4ikOB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FBE1F0089F;
	Thu,  5 Nov 2026 19:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908699;
	bh=8t0QfyFe1liiONBCTMlez4ytrK71Ift17tTGikupoLg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QEI4ikOBif0YdvyG9c/JXg4UAq9wzCRJ2tUoh6l/SSa/2WVnkH9hA1BIgInSHg+q2
	 S8MvRGxkNSNXeuU2pdWx9vvH0/lHO3YLlTf6RuF/k3KGo9inmQ02djE8tGI4R3WRbh
	 txHlJHD83suRog63eGHl9b4pAooaygbYrXCtctmo+LhJDYyu9dd/pCL7jRfwULqqke
	 j9Bx2xSO9aU33IFh9Z3L7G/WC3b46VQxhi9nXsVu1DjCd0eZWp0eUtjYoBK4e3NJ/A
	 it3OWfn2/g+uGUcrJxiU+iwqJ1q0DhVeE7jszj0KGvPIQ8UbvkE8cLU9aPDbbTqcHq
	 m4sMfyWesJ+Rg==
Message-ID: <sashiko-outbox-200058@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 24/30] ipc: let procfs own the seq_file of the
 sysvipc files
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
In-Reply-To: <20261104-work-procfs-fs-v2-24-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-24-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:17 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the seq_operations and the size of the iterator and let procfs
> open and free the seq_file of /proc/sysvipc/*. ->proc_open() only fills
> in the iterator now and ->proc_release() drops the references it holds.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D24

