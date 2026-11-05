Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907008;
	b=qQmeMlQ3YsLRUqxW8FH0z+IVZjst6RGUds/kyydcunp882+6XrKt0F9YjHKrsjCEmhzt
	 pGB2aY2Gtfpvo+Q4GP89smhjmL7JMGlkPr0eY8ya8KgyywXspdwGfPlVWZ4nd4BwQHijq
	 K3kW+REj19VUEDSyL5cf7rRGukJUqegkXm9dfS/K42exNn0/eWtRteylj7eouuFV0xG6H
	 1eXb/ARyLDczXzPYba+AVF2AG2zfeV0yN6Ha0K4EZISXCaAODtsAltXuGWQ61KHoevu9i
	 80GDB7S8lvfacC4+77zYxfCcmrt3h/ScodLEQjQdy7TIJmT4Sxzr4UDVVbgXKYvKyvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907008;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7PHyXsRCh8nUckWf/52BHUGTboWFHsh+IL6ljZbS9tU=;
	b=aCw5FDdkb7Z718oI5KGPjcbctDAO0D5c+Y+OZ8BiRBV6J6OhWBvrWSDdSdR0Y9GjxsbM
	 2zsSzDZsbUU3oG9GljtEbz7qPU0YZ8vQNBb84/OW07CXv1RtT7rRKVTJxBQ6e9EUWCDri
	 qoKegnwAfXnfE9/sVpwV6xbBYPvHWOYLIYYPzID4jzG+Rp2KV2Ufv+khbARFBT5PoOmT8
	 aeJMR3e79eTecU+IfNpjGHFmjOVaummhoEUNnj+SKClq4wOKWw/yff32402+UARptHYEq
	 /yTEnOWzRQBqSfCFZWvvnn7dsA6tDxgvJHF+NLd0vSABSa2Lz05HKPTH5rJIY29hnVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EzbFf2vH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0904606A335;
	Thu,  5 Nov 2026 19:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EzbFf2vH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058331F00A17;
	Thu,  5 Nov 2026 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907007;
	bh=7PHyXsRCh8nUckWf/52BHUGTboWFHsh+IL6ljZbS9tU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EzbFf2vH4rdYmLSxg3HKN+VvXLe/yE1Tm+i03FhW8mezL4sHWQcUkoSNnFKVwq0bi
	 AzCp++9TnQnkMVuRyQ7av+BkhgA/SJE164Miit54lB2OO3Lai0csSIQhWlpUru6waD
	 +VBsr4BCGwCfqkHgRxJDlwr2XEGmEoMwpsrj5goVIQBSCqw3VOFqGx53PTILkt5ust
	 nbutmvvSCT+eOLEdguPUYLn5ci6I+dEQYyb70GenJ18ODID+H7xgdB1VM3a+sCkvVh
	 WEBmPTJH++5VB3kciDdK1xZpG8yPpTWbkTU6g4v0sBHmmzlPDXWv2561dDq3nEbTxS
	 FmCid2KQ7rxdA==
Message-ID: <sashiko-outbox-199901@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 38/51] powerpc/crash_dump: check
 ioremap_cache() in copy_oldmem_page()
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-38-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-38-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:05 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D38

