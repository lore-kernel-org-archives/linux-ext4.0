Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719146;
	b=OysCpz06//A8i5SL52PKPvRLuY0hnRibCO8E8mcDCY2ay2ffxwoAc7x2mKK0IdqKpeUY
	 oi4MlguJmHzPOkjOtvnGOjYXRsPlYxxYtloqVWjm45wVArrhic8yMVEez4Vx2hJqU/Q3A
	 jAmGFiPIkzJWrhvpYYSNt0uZ9Pv1SsUB2qeQ7r/hL+j+agyOQCNVqxG1cE0DN4tEIBTcg
	 WhRiyP9poSrAhMclillZSQCji8lr4TVq9Jc5vtTO5azxIt4oFBYi7uW3ZuvGEEcM3k0uz
	 5VJ5WnF3G0m9EpEOKyAGmMM69hJioh1kPRXItUSE4vx8M36LGYATRfNbS1PRqtvazXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719146;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9VM4VycIJxG9B23kFs1jpcDVPOgTfnwXyJOXznUgmT0=;
	b=IAS4XEQDxmmh0PlWaxDZZYUMV+NOnCn2VjyBaEET0hnEJUgnJggCnIyRIlzM0mi71EqB
	 /VdKTJlnk6mmKHvRPPI2zZ+qN0TwQzawP2qeaiA8cdPGiGdiufqN2cshUG55IxCeuUJiX
	 17q96uRf1jdGBb6jRoFKHjk1CpEmWiWGqfCXQwsFemQL9D3SVtUfmq8HjZbIAGCXJpD0A
	 P5xVDyiWlvnu8kZI0cyVtOgZw1FhI8vpDIefv9P+Qt4mcBsNW2x03l/o9i78AwHWd3R1V
	 mJQjRIJWf6Qt65/G8IkpKtC+V7N/kK2sAVQsnFILhtYLC15mBiaVL5iObW4AJ3SHq6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TXLZhHtB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D148C60A380C;
	Tue,  3 Nov 2026 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TXLZhHtB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0E71F00A15;
	Tue,  3 Nov 2026 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719145;
	bh=9VM4VycIJxG9B23kFs1jpcDVPOgTfnwXyJOXznUgmT0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TXLZhHtBBQ/MwOWloq1a719SQTAPon23w6JmMKZCt88Jd96TH83Ml+nM4Ur+GAwBf
	 HIGjyq9tA314fRNV+6HTEn7xJ5G+/lUkqqaajiwpVTla9zE2ZdMK9TN9R05B1lhMTL
	 gG7iev8TBAZ1R6LRWHTADcOV/KA8ODBmZ6NAAseQrwJ8cTF7zrs5wQjrg8m7amlIy2
	 a5D05LqkfrZGcwMdNoPisCJwwcI8ZAno6RdiJNlyxhj5f3WJeUVTRcW/XBb2wOgDBz
	 C1Qe+80yXKtcjrTSgvFLmh4nF9st0qRHA6dP8yeGfACHozhzWrcxJDaIto8ZtRYuHc
	 drplGlm4GLlUA==
Message-ID: <sashiko-outbox-195598@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 18/23] wifi: ipw2x00: let procfs copy in writes to
 the debug level
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
In-Reply-To: <20261102-work-procfs-drivers-v1-18-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-18-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:19:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and parse the level from that copy. Writes larger
> than PAGE_SIZE - 1 bytes fail with -EINVAL now, and a buffer that can't
> be read fails with -EFAULT instead of looking like it was written.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D18

