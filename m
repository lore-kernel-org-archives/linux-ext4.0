Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718064;
	b=he9+gTW8Vw0Suef9CH+ffpZadY1RTKPrZplygd9gFt7sZ/cUxFy8fXI2281xTqVXTM3S
	 TJ9TWe58J6ivmxyemthgkuY43lq9ASPzRk9GU5cjqqYdzlDJCNXx1CRioryceesM+NNoL
	 q8tqL2wkQenxRtzhifKfZSV5L/D+U16Djy15IAt3nbmJieLoGnPdgIOODPKgZ26Pvj7DU
	 pF59yE7kdnchYZIzhNT5Hlq0D0AkfcAaHH5tZNZRiO1O+MfvZ+rfL4DSiMIeMK491fQ6D
	 wtWOTLiKvqA2KzmF29H4Zv03EWqd3sFOQJFSIpPJZNzD4dy8wz6wYY5enooj7g6bpRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718064;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O9ttEEMk5aMI0xnyyX9rHNq+bDAQQVwO4bXVwqZk5oM=;
	b=p/pTmWEKIJdicSQSgqbdVIaH2/sxiWc5iRPg2Vxwds7oG57rReU2ijkCUJUD6Atf4TgB
	 KrPSudP1OWID1IFLX/nWZqESMPgtzUeagceqJaXXJiYrzsoEHCLPsFgFixvVV5j3hFN1+
	 5+Y1F6jHatws6HFob41+C2vBf/+UNod598y8/bvOYZDABGCHESOVbaqVQNzLP7ZI9knu7
	 E+lHO3PBzOuHWCaXr7tqldyMVa2raaS+gZGLIdeEaImLBWtOBDpMkAVpiKlAK1PJEKI4q
	 K123Nd3r2mYe5h2ymPm7mtmvIl5nt23Vc97+9i1gFt5yXXseaqCP40sB1hyAXTYwPVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtKCljk1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F62606A784;
	Tue,  3 Nov 2026 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtKCljk1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057A91F00919;
	Tue,  3 Nov 2026 15:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718063;
	bh=O9ttEEMk5aMI0xnyyX9rHNq+bDAQQVwO4bXVwqZk5oM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZtKCljk1LUvJX7KWDQjGj4wiHw+nMT87rtLCGJRTBYFOnVKhOBYNUS58KOesO+NiT
	 ER2HFmDawKCWeqirKD1bgeaaWLAsw7kaZahNvdMxcZ2A6tubEEU2b+KyISPnVnH3De
	 VlS8UWmQqfvhIjxe0gW/En7sarJ3yWhvP+J+F29JCEifzwOto5rP9bGZe97qhSS6Yi
	 xYFyCbF6HeTNA5fWxqAfDBvJNHBsNOuOBdzH4kWFRyOW2Q6tGuyciAiivU2E0CTx+4
	 6M2yffCJdgdXWLkNu3Ruz21vUDqhU/xAJMYjVWhf2ZqkxGJXsbg8JOCIzeTSiOCTh3
	 /uO8boCh8z46A==
Message-ID: <sashiko-outbox-195529@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 02/16] proc: add pde_pin() and pde_unpin()
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
In-Reply-To: <20261102-work-procfs-core-v1-2-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-2-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:01 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Every call into an entry that can go away is wrapped in use_pde() and
> unuse_pde(), and a permanent entry is called straight away. The read,
> write, poll, ioctl, mmap and lseek methods all spell that out as the
> same if-else. The next patches add a few more callers. So put it into
> pde_pin() and pde_unpin() and use them everywhere.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D2

