Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907338;
	b=Rug1S/bZJjDRoqMgSUMKB2H2ckeGf4tzFEu9SB+q3SeJp/qAAGKes45k4eqxqCKK16i6
	 wf8lwycd99D5EKi3cr5TggJX3mWQ0VDrYE7+LjL0R5k4Z4hzCtfE925mxi2yzWJLq6Kyk
	 nqPPBW1MzijUscgRAKXJWGzHa+MMNbnlpqjK9yk2Qrsn5H31h0A9WspDusEE32DRr1f4+
	 RcgUII+vfN0O1B0m0L0G9Mrm08f7ooQygIgkdjdyLMq7Bl6QRQV0WW3jdWUNRXy3RLnqg
	 ERsuBRS7kpV5Fl8/aA4EJJgtEC0Z3+wpBDPoDb/mmdgOn7jtBI2URq2epVMrWuqh39A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907338;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1DrTL1ac6XN1wKtHpceRQArmb2bB9IIZ8TJ6poNHDCM=;
	b=dxGPqZHbQqKIZ2fLEcaKWKeQyL59a/yZlpQXT/PpPyk2dAXLbWtyAJBihDePZYkQlN2j
	 8S8sKLhogcT73KDcdzTWYQO/ikjAWUeFFoNDYVVoLRYf/1KT6yUJaiiiIh7fRgzKfn5la
	 wqpSSPfV1zq3uWZ3hLaQl5+ATDBQlX8PLGoj129qTjhfgl3AIzhItT6FhhIEziJmaowrF
	 yGaQn3aH/aHh7XYIOEzjCAMl6Jiv6M1VSWwKJvOAxA8+o2fkKXv6uBs/Q5tH1PZnj62FJ
	 mBLG8s4/zd4ZW6rfFuCpD1MXSBIiZNAMI/qBV4WZXnYiO6SZSYMAiQx7yrePsfJ5dMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HfWNy4Y5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC03B60A2609;
	Thu,  5 Nov 2026 19:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HfWNy4Y5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1946E1F0089E;
	Thu,  5 Nov 2026 19:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907337;
	bh=1DrTL1ac6XN1wKtHpceRQArmb2bB9IIZ8TJ6poNHDCM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HfWNy4Y5RPfNBoKBQHLyyjYyTxbbnjJDdOqRHr0CwmBLc51x1jcm75ZAAgEad1VZu
	 tS6QZvZfn8sUpNi6mOF5f5DFfUZLIhS4vvvi+iGswUv6KjXZx0o+EpcIZvbbxZe+4c
	 w+eyoQ8QFIDLRMjiWYtJN8zfopCPPudrCbntig5HUXMXa/Rmrt2bn8OYImFZC4VNa2
	 R+83Zs+Eu4feiqusBCRRhe6e1B6nEi14J/AHyHRRYVVXAOiMjE6L8AhoiK91X8uzKE
	 CLf8tyLGMi9vrUilCTGfT/2QMby2aoyrPQEHnvKWwCxXAzjQDLba28dyRTo132ATHY
	 jJoKKmYLJAz8A==
Message-ID: <sashiko-outbox-199941@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 11/23] selftests/proc: check that a faulting
 reader doesn't hold up removal
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
In-Reply-To: <20261104-work-procfs-core-v2-11-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-11-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:35 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Read /proc/net/dev_snmp6/<dev> of a tun device into a buffer whose first
> page is backed by userfaultfd and remove the device while the reader
> sleeps in its copy to userspace:
>=20
> - removing the entry doesn't wait for the reader
>=20
> - the reader still gets what was printed before the removal
>=20
> - and the next read fails with -EIO
>=20
> The entry is removed under RTNL, so a regression stalls the test for
> five seconds before it fails.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D11

