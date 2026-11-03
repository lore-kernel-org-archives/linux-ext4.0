Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717325;
	b=nLvr1zVPV+UmVJxLdECwOGzm9PjGXogS5av9cvcHtauCcN/6dEeF+HG2UGFhF/FgkVJl
	 cs+HrfMmmabUdhjPOcJH4WhGpZaXwzzZ2paovrh/CUTs80R8jIHJjzQTKv5MbPoS0nMRZ
	 DPGJ8Dha0sow3s28j/ZK5WZDsD5+J8cJ16jcxSF+dLmKsCi1l9eH6kKa+poaIWY2ZNG5X
	 vEkAI/vuW2GUN0MfSzOzH2WhHn0mJvlTX29ZtuQVblZEyBvkY7ts4EWY2Afkj5NS0eQb1
	 lYfZuMNF9Ne7YX0PZlKqdImJkwTyUQWRuP/9iRC7p35z2yEatfIf186SAUrVySZLtMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717325;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uDobM7QDj3Lx8HNQ5416tX3+kK/o8mWee2ZveIT1ntg=;
	b=LNrXg9Xdun2b3BtRwQqBEvPI2bRfMwG6+VXh1kgKc0cZvMCm0Y1u27t+Ve5hntBlvnRC
	 hgMmpF9Bf924benDp/Ijle9n6OzDCDvA21toDDigbcfziWOUO1o0awrVs7YccwPuJJyoF
	 Hj9YFI/pzOP6PGyK069UIcjxRhQu3CiHMLjK/UkLg2bmKh2Nlb+rtUFWICIyUC15CuFll
	 0evGdugShvcyQ9bsZ07Yq8R3nidzx26ESo/bUsrZQ1tjH2jvCiWIqBM3Fwmw8hCJ54sCQ
	 pCL2KMcLaovYKKjmTSEmKUCDt54w59a6Pt6NbHHBtW45KaTemK5funhTaeegVwASetA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Na2gJC3W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AE8606D2D6;
	Tue,  3 Nov 2026 14:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Na2gJC3W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04C41F0093A;
	Tue,  3 Nov 2026 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717325;
	bh=uDobM7QDj3Lx8HNQ5416tX3+kK/o8mWee2ZveIT1ntg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Na2gJC3Wod/GFK0uuWDrP4WIt6zGBZoiUHvOVc1vbCqA8NZv6QU85/+Q18TJpfTPa
	 OJyuC1FeqkvW+ARL6u4FjlMjgYVIUzvttMG/Jn3lctETTJNvH2e8k++EUQDqc8cjrS
	 PlTncNci7sIK/n/L4Y1wcClXJ9V68jHW625sylwdyxVH/+hgk0OEcay/SXkoUlSOwu
	 8SxZBhWuURiqG/KXhBCSlYOyUIyG1nMmMczEAHHWOqwIb4KOnr73DHH3TA1dIdrVfb
	 60ZV6surnMaQ4iePDAqdVVlUfTU/XYdZsd5WE2XJyN0J6fosbfAg1RZcuBrpBpR6nt
	 rbyu0Csf5ldgg==
Message-ID: <sashiko-outbox-195509@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 37/38] proc: don't pin a symlink's entry while
 readlink() copies it out
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-37-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-37-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_get_link() pins the entry with use_pde() and the delayed call
> unpins it. vfs_readlink() copies the link to userspace in between. So a
> page fault in that copy holds up remove_proc_entry() just like the
> copies of reads and writes do, and the callers hold locks while they
> wait. /proc/asound/<id> is removed with snd_card_mutex and info_mutex
> held when a card changes its id.
>=20
> The pin doesn't keep anything alive. proc_symlink() copies the target
> and pde_free() frees it with the entry, and the inode holds a reference
> to the entry. What the pin does is keep a removed symlink from being
> followed. So check ->in_use instead and drop the delayed call. That
> also takes an atomic pair off every traversal of /proc/net and
> /proc/mounts.
>=20
> Fixes: 7e0e953bb0cf ("procfs: fix race between symlink removals and trave=
rsals")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D37

