Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908672;
	b=zDe2IDpXuyACYKAZuK5hZm0UTTMeQxRtzyyNNnZ5usiGpPVDh04z1EdvjjJ6p7Zc7mYE
	 ZeP21Ib8OnPojky54RogrWpGQNHuMvcUHuxbnaTWBbMbsgUZ51kiW86e7ouhjqVTuEZUO
	 DZYW3j0Ugk6xAyV+nJ452k3/ZqTF2P6xUcVpwZ6tAS9FOyA7yxZZishQxbltjrWDQ8nNe
	 es8I4a82Apyd7GyXqkepKBCoJDtpSYUbtAU6okN3ekJzp1xAR9LpMVmsZIq0wftrTeUmp
	 rlA07KBpVp02XsLj6eYQ8Kv+iwm4TLJp1ru9vvuVnYp3IZ0CyD6Nnm0icdktKhgAB2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908672;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wH1L4MEaZ7mTO1+v+czsA7Bd7wFLluxTEf1+OMXx/G8=;
	b=qsgCR4qWce5rECWWrccARThdcDpekG1pwPjgETVUHguhCjHLD+HLmgRgKoNpzxO+HuYi
	 iAddTZDS8+te4ELjMhojvClh4eGQ8pCT1QQRpKi0awUqXBeCFMWdXEkNCQBavtXAbWu5/
	 IcrCDb/gvdFlSCRqQoEBdc6sX0V31wDHpxiGSKHTXFarbJp9mUkaNiDqQwGn9bhrOhnGJ
	 EgtnPnzhE17w2TyqMoXNGdZz6pwpxlBV1IcBsrogseJVutxlTsyP7JuASLD0JI45f2JyR
	 wkeOythxAl38xAuLdp3lwFTcprZmxLaREN/pR1w/5wCHsMv2fkiOBmGWuXeEHWtVCtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="K7L/GY8E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2C4606A33D;
	Thu,  5 Nov 2026 19:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7L/GY8E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888531F008A2;
	Thu,  5 Nov 2026 19:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908672;
	bh=wH1L4MEaZ7mTO1+v+czsA7Bd7wFLluxTEf1+OMXx/G8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K7L/GY8EBAiMFhQN1jBxInyHUo7dNUqa1zvrbYPCV3cNlvaj0uRTG8m5XSXkg5qBH
	 NxQgrlhnCqVof6ukdE4MBihCdgWAaKYJdSh5pmD/29Ml4etIsfQcRmUKoFVe1cyGDP
	 q11+nFgfYJfO3maFGRlex7SnG2VtLRY23TP7Hza/2OShi8+SVSRRCqK/F/Ot8puN7A
	 BIImj1rK3ldK8sG8OeFyPl3Ecx00bVxpaKA4ZbgnFfd+/z05CVTEd+m93B57VhW2YZ
	 NWYy1/qXl35HEznR9p8aOsKL+D5Ca0SsAiDZCtE/ab89zfKkPK8dJVNfErjO5zAKnp
	 FWuqFZDvwWXBA==
Message-ID: <sashiko-outbox-200045@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 11/30] latencytop: let procfs copy in writes
 to /proc/latency_stats
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
In-Reply-To: <20261104-work-procfs-fs-v2-11-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-11-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry. The write only clears the statistics and doesn't look
> at what was written anyway. Writes larger than PAGE_SIZE - 1 bytes fail
> with -EINVAL now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D11

