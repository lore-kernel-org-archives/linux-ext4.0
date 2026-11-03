Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719139;
	b=4IwdH3D1MD7gwlDZAz6CJIsUy+GYOZj57tripkY5CLRIjX+LkO87d7oB5Qo4uaUSW+qN
	 k69tnHmunicfwO+rxY73mRZoLfz0h+7qu1iTZSeFKblCjll/9HkxZYqV4U4Xl+DhFfPzc
	 ZIHmsrTbwkG2EaR/nR2MOvEHj+UFECdE1CzTpR/QrumLX466Pcgqs62xnuOTzlgwv1w97
	 AUAWmotjArdKRNQnFYArHcl0cfKa/roVw1+PF5OUFPamPhCztZ2wh1BN7OJ86NEQD2WtD
	 D6hzvxqbFTvLEeAs5B+iZSLJMoDIQsbUg21gVnhmGSpQHcVJTYetPt8y7Hs0mCCBAqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719139;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=y9ivFE+8473vLZC4u44E0uCxK4vp/F+9XJkKNyMDnK4=;
	b=w9fyS/mPgtFuM3kTHTeXM4vFZRtoCKA09KOyYRvxFJgVueT8DK8qZeDHFXjgmsSXKZU6
	 ZlH5quxHn7ppgqEqhPoAYHlI8aQevAZ5br6Tg3gBbMDk68Jy/mVI5rm1i8N2r6VVPkvd+
	 QRYw8RbCqwDZy2Gt30Q2I7lLIIEbeeAY47vxIhc7GHW3ooboUikcAwAfDWQ9nXU/MEu4k
	 Egzc1BHLgGyBQxtqgolmuvLuc3XXIWRCUaGU6NFJJfgvN5yM5srcK1u8lFxpF1UgeQth7
	 BBWfkKk12ge3CEhHE/EvKjesWKfDFwIE+LQijtb5IpaVFJ4CsZl2Q2ObIgMgXwnktPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bmtyXin2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CE96083634;
	Tue,  3 Nov 2026 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bmtyXin2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A541F00A24;
	Tue,  3 Nov 2026 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719139;
	bh=y9ivFE+8473vLZC4u44E0uCxK4vp/F+9XJkKNyMDnK4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bmtyXin2yjAbPM31f4YaReEle+vN1wPD4L+slbEGaUF6hX4+kf+dRrnuROs6GNc6M
	 DRv8HDwijzmWY/67jIDFKq1BlkuwcODaUmGuLQwnpIvt9LjRoXP9PaI8gflmJ8i3wP
	 c86SuDRl9Wm977S+NSsKVjwbigdIWRtwQE8i9H86bD+J23omOL2nXMQrYU7YT8HPQP
	 GH2X2ncA/tHy+HPvYNSWnLpaZkCBCsb8oTwbY54v5R3heuFMWJyAAY4y1Iwt7Y5a72
	 oJfgpcEoXbI+/0/Hn7wyfvMmS2DTYmtRsWGQMfw5jCqWG1J8Z46CbdL/IgCX7u9auF
	 QiW2pizk1QYYQ==
Message-ID: <sashiko-outbox-195595@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 15/23] hwmon: (dell-smm) let procfs copy the i8k
 ioctl arguments
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
In-Reply-To: <20261102-work-procfs-drivers-v1-15-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-15-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:57 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_ioctl_buf() so procfs copies the arguments in before
> it pins the entry and back out after unpinning it. The command numbers
> in <uapi/linux/i8k.h> encode the wrong sizes, so the table lists what
> is really copied: an int or the 16 bytes of the machine id out, and one
> or two ints in.
>=20
> A NULL argument fails with -EFAULT now instead of -EINVAL, and so does
> a bad pointer to SET_FAN from an unprivileged task, which got -EPERM
> before, since procfs copies the argument in before the entry's own
> checks run. 32-bit tasks can use the commands whose numbers don't
> depend on the size of size_t.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D15

