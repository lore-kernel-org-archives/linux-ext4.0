Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908183;
	b=qjQYerDbWGwT+0HnKTHsk5soO09gCqdxxlk3g6ZWa5UFvwGSL1fRqNvGgNfGREE0yxxm
	 R7BW7G4RblF+Ozpb6HTbEv8CFqa+d/7j9ezQNjspe+MNEbiK+kOuGiJ4xqc2Zo4ONAESq
	 RF0vVKINsIoCxFUHORyEo4aj8+pobPmsArhOBZmd/ONSwrIBJiJffztUR6zslRTSf1784
	 ROOIFHEfdCTC/xyVwqlCtJPxAWhfwsNV4N5t9CHLLLmYvij0zMxTD7ELI5ppGuJ+0cbnx
	 1Asj31ZRbXZj6gycg+n7Aw4tIxOUqTDaXgvptTTxzQ///CG3NEbHElXEufxKV8TkWLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908183;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=y30rUmZBthh2E7w+0fysBQcYWUpkGcdPObgng4j+tIg=;
	b=SnGnilO6ptC2DMVETJxhp1zbLfC2Zty/SjGboaXDi7unjLzfZUqxMt4lT/2Xms3Pmywf
	 38wTBI/jwA4/6PtMjrEVnLyNPrtBU5D60NGwgW9E6O2GJMPT+ekohwacCvN+lsEt5KSvW
	 +aoYV+yyyoZIMaf18L4sXBl1GUOfr2oX3DLLle7xeV3KHa4VJ3I9XSIs8xcsGIDSDyIdz
	 XxUkz67iKynYKzLH2muarl1wQI3NuMBz9m1Ata4FhN/YsYs1FcSs13BMhMiidOZDTcFbl
	 iRApn5tLpQ3wmCjMFl1t6ZY4vWOBaC8TbJy9VODrxHYpzADIBpMLisxuYf+uAl1uHtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="b/w2E8Lv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AB96075329;
	Thu,  5 Nov 2026 19:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b/w2E8Lv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748201F008A1;
	Thu,  5 Nov 2026 19:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908183;
	bh=y30rUmZBthh2E7w+0fysBQcYWUpkGcdPObgng4j+tIg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b/w2E8LvVx8iHqx7D9Ue0CrcEJDGjUmIXNOxnXqQGdQ8CRIytdZZV0C3FEoMsADj/
	 nJYY3Wvl7EF2S79oY2/r4412cFfniNBCO+blsAIXkdBnMSFelCv83eSKqxIwYS1DBa
	 FPl9MuYwM3scd8uuhT1rCemD0JfzZMYYMzmX1Z0qT2M0a2NUJGjRPdvuZLc4+h5oUx
	 +WIsia2dVnilP+Ymj37NjDa8uQIEaGtGt+DsnH3VmLYTfspWj4RkA0GcSkDRaFFEOH
	 YgWmHOGaCFnkKHRaeEP37l0Lf9NgIcgl4tZVX60AUyS0L+5dBRmBr414+nePdIbpxh
	 ylPy64WGp8cug==
Message-ID: <sashiko-outbox-200003@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 17/26] fbdev: viafb: let procfs copy in writes
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
In-Reply-To: <20261104-work-procfs-drivers-v2-17-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-17-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:41 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for the files in /proc/viafb so procfs
> copies in what is written before it pins the entry, and parse what was
> written from that copy. Writes larger than PAGE_SIZE - 1 bytes fail with
> -EINVAL now, the output device files refused anything over 63 bytes
> already. kstrtou8_from_user() looked at the first 10 bytes of what was
> written to dfph and dfpl, now the whole write is parsed.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D17

