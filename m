Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719113;
	b=17DlNIAqPd0n15Xt8CY2xvQ6kYNW95+bEvlHtLgLeKlGN0MHgIOqOFg5t948kygtllCL
	 YL9+b7KlGmyRveamyvc0IHBKY4Hmzd7er7YE78qi0ex3mmzV+JgUmYYW7oLoObDaTg7ZY
	 MQLGrgKFP7ce1Xf4fRDksZPOlzxENKW/orA9UCt+J4g7ALblZ6QWtfTeXOtUTx4fKv0aX
	 rKu0i0flM3Wt5iWGO7Tsd764iUm2GXc26jiQo3tBOi9p6U92S9IFIdi0bZBlakoQ1XGdv
	 wbQ/KXwjqw+egc8PTY+YT9DGNDbRinr+7jvP0lNOGaTUUst7qExTfhXzpS1MHx3+4kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719113;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nuG+HoslXVqgC4BtSCGH4CAYwdyBqlwjqRu8aNivsSg=;
	b=eY2gUpC/Qf+Z3Yt2NvP4BaQcO0dNrMNcbZE0K2v18K0crlRcMEfSfJKOWf4HQvy+tE+V
	 BNzjsbc2ZWHi0R+C32BOG+rOk6xrFX01zzk8n7KHByntAjx+soNQdnkt56/2JB09o+7RV
	 Rb5GHIvl9wX6WNxk5avQheXNWT9uIFPizdWV9dLDOlWm0NtAgEgETuKc56R29fQqGIKX6
	 TD3uwWaQT+HeZIVgq86WdbpohlT1KZk8HLxiVwpMRmeDMJTpe3JJCfKbM719CRlkeMQ19
	 ha6TxhQxHX1MEkZGTOxuKTKe7C7uZB9l6Lfl3IJT7fQg1npv25NT1MksjbLibm4TnHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JfXbUGlb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6964E606F603;
	Tue,  3 Nov 2026 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JfXbUGlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A371F00A15;
	Tue,  3 Nov 2026 15:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719113;
	bh=nuG+HoslXVqgC4BtSCGH4CAYwdyBqlwjqRu8aNivsSg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JfXbUGlbvISf8zKQVvmPeH7ogBauIaWPB+eTLP4FmHFU2NwqFU4DKL8ypk7Ux6mf0
	 gWh03iGMVC4HC0spyzQoLzUAhOUm1D8aZBt0IEBTrp1vzV/eyz2ttWkBahOXZ1jdDM
	 bF7l8JbcCU4WdpekYFK5RkGFPYb06/MtBCIdfY5wL6E9B972eWQ4Jt8sqM73HWB744
	 FRmkQPByZErjf4SpqiFbdtppIJezhzfc6o4zUlNKVldgtxJJ0F2xJrpbqDKUhS9g+O
	 aCCXO1MJqJ0Usnfho11AdOJXIk9MakMNQl6YJ71siIXnfOPILI08yBzL9lAyQ8T9HM
	 fvUE2tPgCHfig==
Message-ID: <sashiko-outbox-195584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 04/23] PCI/proc: let procfs copy out config space
 reads
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
In-Reply-To: <20261102-work-procfs-drivers-v1-4-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-4-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry, and read the config space into procfs'
> buffer with put_unaligned_le16() and put_unaligned_le32() instead of
> put_user(). A read into a buffer that can't be written used to report
> success. It fails with -EFAULT now. A page holds all of the config
> space, so a single read of it still works, libpci treats a short read as
> an error.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D4

