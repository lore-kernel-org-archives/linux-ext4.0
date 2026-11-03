Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717256;
	b=cAmr+vID9xYBs92eeGjjPuTuPgSWY2R7QpJBaIzyWu8r9IocI4bLJ4twVAmqTWxm3xJT
	 kqoKirm2KEkQO20qpkBVM++sB2QfVhV6gBLyEEaNj0/PaXR5DpbWLIbj9kGpumVX/siPx
	 FKSGp++4ttHVl/yDO22afJJbsA7qI4bqh2lp3QF11eu8V0xMRAeeTc4rvF5V4PRJbnp/f
	 arN6dq4/bd1wg23F90Fc8aB/jS+8jv+ci34fxmMUFD5WOn0dZFpH5iN14FkMHeCjeU9Pb
	 SdsVx82ub3T7+Li4o9b61OMYJjGmMuuNAJMGTWWb5o4m2g7AQ8Qzaz0icsazaex8pEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717256;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=q0d4FPmWtZwKMh/sPGL0i6hRLuYL8e+WwbXcE1bGJN4=;
	b=cTt0jR6iNrpyNGRE/DEb4mbsff+HV0V6vPt7UqSoB200gSnC6vIwUr0d5BblsIeqLc3J
	 VcKw5TyFIzxZzOx/QAiTe7zQ7t0j9Y7tt/B2O8xye/I7A8XsaHcBQKoXBUyuj1yrFkl7c
	 dHPD8x7WbrtHOGAFpKOIFH9CJAgoAfZ8j4v1hANPAT/w5FnlFvUVqeU7LFYaK2WHMoFgo
	 icKZ2HfC0xtWSLqfPz/LgtLyd5G+DSCGoKItRFaLauisAO3+YZhisk4cJDLSFsLG0k5Rn
	 6mwvRzxihGrHJfX7ivMozLY0jxVOXKxCmQG05QDjuOGor5NIXTHSVgn3t7EmGZTzuNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ecNUXxnh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1D0606A333;
	Tue,  3 Nov 2026 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ecNUXxnh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75901F00A16;
	Tue,  3 Nov 2026 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717255;
	bh=q0d4FPmWtZwKMh/sPGL0i6hRLuYL8e+WwbXcE1bGJN4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ecNUXxnh2OcVVvSa0U3huTG0L9O+PzIB1xuXCxIUp/GZPPPzipCpRc1/qlsk4J6CA
	 x7U8X9eMczAWPO2ZaCpsl6YNtO0NoBu0+DXnA39JSuS9XY9AjGBFyXlc/Ccq4RTQY0
	 UAugm1HYHytJJ48gGhh5Ikw7HuDNMAn11k6igesT8J9xgHn79oAIaLwhkpwX1VrdQQ
	 +5bvleOIuzZz7sQeEwq2Hki4vo4gTrOnLMNutAIHZebuy2qBXQktzKVc8aWpJCw5wT
	 EMd2yrUC+CDD8BIHuYrdGWQwA/PwlqJVUVRxCdpabP9PdTkesHJyvmQoHa6OBE4VbX
	 e+c9Js8H66prA==
Message-ID: <sashiko-outbox-195476@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 04/38] s390/dasd: don't look in front of the buffer
 on an empty write
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-4-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-4-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:33 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> dasd_get_user_string() strips a trailing newline by looking at the last
> byte that was written. For an empty write that's the byte in front of
> the buffer it just allocated. Only look if something was written.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D4

