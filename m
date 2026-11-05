Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906932;
	b=JHpkX9VbkZ0bl1NlaFWDCT6yGltysKgvkSxWXiZIJXn8YcMPsuArz5Wuwf0WcGB2TwLC
	 2xZUE3fQmEn0lbmUlRayGa46TNJVIVipjp0tgS6aS5wqFxXC0r9cZrHQdnuSK3XBlapEK
	 XOPc9lmWNWBp1ecxy3iwiEfDiR0vnsqYVsx52JpTMs5tAyCCR9FV4JYL3FHdYGQr4DVFC
	 Sg+RcbjScc5UgNBIIN3uOrdhvXKrNI4iLpi/f98Bsv6JxAyo0L+T+JOlFA94FMQjmOTxS
	 zOSiSeJI3k/amYtkay52r7IGyUkfO5vnJ8FOZ3neQbbzXPRP+5gZm9y1XOlpTfA4JyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906932;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VSHZyt2HX6jrf2329Ijyz/9CIcWqtdZcAyFYcq/4Bq8=;
	b=Y13naW4aVV4A6cNCUSpOKaWlg2RPTdoaT4NHZ3dRFzn/dnG/NQ3n8KOsnqaywYt13daV
	 40y7AVrCMyiHnV4tpFpI1cjHPftj/A6Wf16PEGEA6Mxp0wpHLYTagXqAZYMqkJo5h7nrd
	 cSxqopi+UuHEaugF4WcHoDNYGiZPvpsnJjz/Yz5l6ygkvsIeqCE1hBvB+VfbcF489lMnr
	 HEnAARKXU0d4qt9MIDOL/hf6bvcOUXqrSh3oApYTgWbTwpu++EQxfJZxEqkZEKP94YOqg
	 BlRyO8MgzhwQ2NB6md86EXCHklOFGFuTIbqTexzCKb1CQJ0Fg7heUEwcnREQlTDpzNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bw/WUc87";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51774606A331;
	Thu,  5 Nov 2026 19:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bw/WUc87
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BD71F00A1A;
	Thu,  5 Nov 2026 19:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906932;
	bh=VSHZyt2HX6jrf2329Ijyz/9CIcWqtdZcAyFYcq/4Bq8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bw/WUc87dAK9OgwLDerM/G7Pe9RKageq/S7vyIMIV+dxKfDT/6+AqyOaZ6Fy24Sf5
	 xZ0+NlTB1ife40KhyEO8/2i3RZt4uYwfQUof6r8FI5lnRq/LcyHfWASkm3/MjWrdRi
	 BgQ8a/ZYKTrhKL/NQvAtS4X8/cdEouDrtzAKSt2JTd0adgchhl1YlumOBJltoAEeGN
	 vYbB+LfXceHt3UW6QGLdXHtaAnZDe7rNdeXAjPjeo8fIdhcgFV0G7rwEhhGvDXSfkE
	 wVgK162apTb1SAAInG0qnJMlwH5s5bUi5ICww4nLneNlWhcy3veuvsSne6hkFWvg7u
	 jpKMdfeHfDQsw==
Message-ID: <sashiko-outbox-199865@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 02/51] scsi: esas2r: don't copy kernel
 pointers out in EXPRESS_IOCTL_GET_MOD_INFO
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-2-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-2-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:28:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> EXPRESS_IOCTL_GET_MOD_INFO fills in the addresses of the adapter, its
> pci_dev and its Scsi_Host and copies the whole struct back to userspace.
> Nothing in userspace can do anything with those addresses, and the
> ioctl is reachable through /proc/scsi/esas2r/ATTONode, which is created
> with mode 0444. Only pass the host number.
>=20
> Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SA=
TA RAID Adapter Driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D2

