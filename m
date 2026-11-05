Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908693;
	b=uGAAdxGIQdco+vQAMIU2YNkuFt5al6x2Sqqb+k835sGPPIgc8nYWakNsQ5HFFBZtyLxw
	 nB6C7L9EG7FW3ps91P+mxBfg/rMwbaIhH/t5T5bfgDO/AXtKld9kbsV00Bw6u9yRuB1r4
	 mDnV1aaquyCG/o/4DEY5WLDv/2/Png5NeYTXxPjxHQaf984Hz3Ml27BExfeEF6lLmMnDx
	 eRvPLcMzatVxkzY4LZvkac+q9ekBkhzYmgF75ggkRGU949jAmaNAgEJmUUtsx6yBmUCJu
	 B9g5PwvUxjqIJ7cm7tGEiXBGG/Rz6tPne78BvlPFx7r6B5AAN2O6bVXQPrndV5kM2RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908693;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YYAZKkMFX6DHW8NngSlh8ql7fjU785sF7HqECiCsMnE=;
	b=pHlv3m25lqq8atCn70ThvGWyCSAfo7kPRBXKWAmlOujv0m4jthhc2hTtHzUeEBIdb3Os
	 1v2bRicF+ZMVP7jDYPei4I8AXbVElaxif79/Z2D0072ZNmzy57pSWEqKU8oBJkvroN/IT
	 0nZaj9kGQzxlEo+HFlJyaFjskaNU+3wV9QNz7MX2GQC9kq3dcNnyec6wu0N85/OKrkj1P
	 yA36ZowE90uqObBwgi+XpjtYM3CeTQRPqvv6ymz34iDWp79bk1LFj4NUh79r2BeBOb8Og
	 aECgp5KU/k7LNi5iH1p5GTkXeP1feVtdAfJDfAyNbTlj99BU7Q0QMJhN1gcBraiWt7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghRyAMem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16317606A6DA;
	Thu,  5 Nov 2026 19:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghRyAMem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF031F0089F;
	Thu,  5 Nov 2026 19:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908692;
	bh=YYAZKkMFX6DHW8NngSlh8ql7fjU785sF7HqECiCsMnE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ghRyAMemqCpDi7g7rwz8fZ2fD4rQ64uE3KXgrCCHOvgfk5ulfB39FlQp35/h4yLvz
	 dJdBvRlAWS/PTN7GeRmMV78w7VqDHy1yw1SgfdLtFs5/ro8pCEevp9I5o2mEV4hsre
	 QbUCFmiC0JedW6U3cu7OBk36CzsUKVdpFd8AlKrLBUaNINm0Rq05xkuO59vGhcKc2W
	 MbZC6M0cbvo1WoSsE5wbuIKHahbDptO0PVuWiY8t7K6A87m6Vc4FyueopwrwYcHZaN
	 KqSAWANwgQUzptp7Pyc6sWx7RRBy4Y1o0Tz3+nWkyqFbUtHlNjL5USIuJJe5DNfQ2k
	 Q92b2uhcE9aIg==
Message-ID: <sashiko-outbox-200055@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 21/30] kallsyms: let procfs own the seq_file
 of /proc/kallsyms
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
In-Reply-To: <20261104-work-procfs-fs-v2-21-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-21-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:11 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the seq_operations and the size of the iterator and let procfs
> open and free the seq_file. ->proc_open() only initializes the iterator
> now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D21

