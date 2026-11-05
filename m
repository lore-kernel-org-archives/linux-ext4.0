Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908198;
	b=0TqgLJ5eQEXdG9tLih/EiZ7clHLw4ISWC3FCPVYj5+BCqo1xr4AHW1IE93M8aTOPX4po
	 75Bkt47nA85rpmamKFAhuACYYP60qCSuWks+FcjhXDiOo43sRfNuq3WWAvyhf/mJSS6RV
	 YpsZEhUlP3QF0+3SQ+vTv46wBeFHObhL8JGUfvmHFUcdeeYDKKVZ4Qkyskn2E1mZwQRTe
	 pGZB+VutyeAutcJjm+GB3RNA57BrfxuUZEHqH432HBnC+ep/ras3L9a0GZmQ+fF1ds8fH
	 4S5Q0iJhifUf/s9T6RDLMJWKfhzPTvDMKdhfj9dBK4eUiX7WmxXHwqwsnAaRez0Wnbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908198;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=g8VIx/O5myc3jTrcBAbF/1LMhr5RQoOacgBMQZch0fY=;
	b=mdyB5H4YMToC/b7briH7p4/4+2mBT3LB+/cmTLWeMlXG3V0EmcWDlycypQK7yeCArDHj
	 DbVFAvg2SnAXjnvtB6CjMG+VczmaXeMTPUWcI6peRIXVC+8X7xjq/+IZQLSMYlnvpTS2i
	 eNykVAsHeCCKzhgjUJ3RWa9cD7JfDVOeGvr91ahRJuTWDIY5B+BcAJtXCw6CYwnaBdjmQ
	 kFw8WBETFYeNpGvMzQO5VYtr0o1tuRo8ONVS2Y4Qblcqc68KdSQzeS7kdjpzI2DlHPMZ0
	 7ZBVSzIkSBrGeMkWAq3NqFTrpXdXMOBKctBecARRtxc/56ExVOTO/aPXKDe7dNuOoxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GbszhkNn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CCA6079C24;
	Thu,  5 Nov 2026 19:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GbszhkNn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC021F0089F;
	Thu,  5 Nov 2026 19:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908197;
	bh=g8VIx/O5myc3jTrcBAbF/1LMhr5RQoOacgBMQZch0fY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GbszhkNnwvO6EsO7Tch1L6T1eoBkSqg9wjmNNLPmyAxG2R9masinYXbJsOTY+WBND
	 YITcHdDZMKJ+ys/om6N2Aw168qXvmq3eUzTRlQnt6fJlpF5HBR49FB7wDRwc5rDV1v
	 Fd8qgHIJaRAOCVy9ZmIJ7vbLdgajX1iuSBveVNu2Sw/RE0P6xePPXblZ1dfK5I0ul8
	 bNf+SDcdrcY/2ABjoRIAYw6DURlIUIpIE9xYQSFZSjaFKJvKrVkzV+9TPZM0E6gxvr
	 yhAlJ8/t7+E9RS123LJSEQWtMe87Kufp4SAioD6JROHJFZz0zySPuvUwc8bjxDts3w
	 U6TRi8lLBZm8A==
Message-ID: <sashiko-outbox-200009@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 23/26] ALSA: info: let procfs copy in writes
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
In-Reply-To: <20261104-work-procfs-drivers-v2-23-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-23-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for data and text entries so procfs copies
> in what is written before it pins the entry.
>=20
> Data entries take writes a page at a time with PROC_ENTRY_SHORT_WRITES.
> They used to get the whole write at once. ->write() of struct
> snd_info_entry_ops gets the kernel copy and opl4, its only user, writes
> it to the sample memory without bouncing it through a vmalloc() buffer
> of its own.
>=20
> Text entries take up to SND_INFO_TEXT_WRITE_MAX bytes at once like
> before. A single write that is larger fails with -EINVAL from procfs
> instead of -EIO now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D23

