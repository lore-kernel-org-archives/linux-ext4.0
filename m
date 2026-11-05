Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906938;
	b=H/cXtXJ6QloI8XX8nnX6tJu6lHxbBUX3/CBnB2f0HsmoTdWnWs2WZzMQFY49J7st87V9
	 hlmsJan/xogMv1/TBsjEXZTWiqRTxxO8fM8dn8E00/XeV4Pwvwoc8dlJJZqMOEGfY9HtK
	 EE1mL1nHP8xtGEvhFHJH8we5WjL0fU+fP1YK7sB2erRk1VY0ZSvLm4KEshMz319WaVxaR
	 i5ivNacLp/Yok60zwypAPQrQs5PmJ9sGu0ARxDLIE7jdQB9BWn4zFFFuLCiPPciRwZmQl
	 03mC8kJnBjVHcCUYWfU5VtRfo+ZICt9CkOF9ge7koGjOv1MY1B5bFnUWf2cUzEyKhxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906938;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8+PUUisCWtmjpXGFSnEzEH85bwtBLwjRqMOjM3Vmjmk=;
	b=p3Dtm35iJVnkx5GuDvL13D46J87WzRNDyjcphm6KwhqIa+GZsA67Z0QOduE+UjcuSwUA
	 yNlrLslFP1VkH9MYIQ+1t29jI84CTkrBqsFgsBmbqodMlTHjhL2AKMDJucapdKb4mBHVS
	 aAse8y5tqZCf7zHYd+SR4Ak1qtQMy2FLI3/aN/FlB8s9pDXt6xptFUI6RDH3Qqvc+HVUr
	 kU3zyufnOA0josi7IZFSj+OH+pxcYxib7x2y/VDfZBvfNRhHlM6Wm4iTayfd1oDl5db2Z
	 HZr88XRO89pF5X5yG/JvO+U5uKXS5fJt57NMsvKTPnYMq4k+JPtgq1zKmF+uYd2Cvpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGXjVaZA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AE2606D819;
	Thu,  5 Nov 2026 19:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGXjVaZA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680F41F0093A;
	Thu,  5 Nov 2026 19:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906938;
	bh=8+PUUisCWtmjpXGFSnEzEH85bwtBLwjRqMOjM3Vmjmk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JGXjVaZAK0CFDggQJdQ+YxBvHhKA1VCtqeH0C7UlBLv6f9VG7skZu2dEAbXlkszW+
	 sJTw0vxxWmvEmoZ//n7adNnR8rVGdWKpWloXAc/ZnMiIcC1Z7LfAxfJ1lZKXvGWlIS
	 PhuWRh2l7d+X+aiKaVkZ1til7ZTDouBvsGp4ZrUVot4KXntqybtMcWLZq8dMoH9KMN
	 yQdRKjUGTGwZGlm1bL3/t2/RiEaT3aD77Fgz7S3aVXIsJYSEDz2AoydnPR6UJrVtty
	 1L9zuHgLTxVXIrW2mhh+h+95gf4FNjVSdlwVAZRJPDPN2gARWlGlHNxwoYxHNUqah+
	 h0Hn80dmMBTsA==
Message-ID: <sashiko-outbox-199868@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 05/51] xtensa: simdisk: remove the proc entry
 before the disk
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-5-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-5-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:28:56 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> simdisk_teardown() frees the gendisk and only then removes
> /proc/simdisk/<n>. A write to that entry in between attaches the file
> that was written to the disk, and simdisk_attach() sets the capacity of
> the gendisk that is gone. Remove the entry first, remove_proc_entry()
> waits for a writer that is in the middle of that.
>=20
> Fixes: b6c7e873daf7 ("xtensa: ISS: add host file-based simulated disk")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D5

