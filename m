Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908662;
	b=cS/bB2/urwFnmuub8wZTBBvqFEKKa10rMTcLK/VxUUC8bPrVSiUBiaqin3c7T7iePa5b
	 iIVxxsVcsBAy10wp9K36vld1ta37K7xbCQtjjr/7OvPX+hkg8Q8mi8H1+i2y/m+8heq9S
	 bQujVtg0bM5OReQzoOuGKzCTwWaIx3/JpOdsV34pOXYFQr6CUxpfEBieoo8nMfhdsPsGd
	 zo/GQSm0aJM7MyxrMQOF1aLqBinN7E1hTxFZuD4vCrg5mexYwVRhn5554jqqeSOL+QAuN
	 iFntirN2/BzrjThBljW6TwjkGpbycLTzAHafp2fqbJadseh2TXm3Nn0nn8/AdEXVViA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908662;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1ucq80d/HBPFI1YIkIEFNdSOXOIK1pX2sWoSRce4LGk=;
	b=oQQQlFL+gYyT3AlDqdYKA2lAsUm7RrOo4lPB8ujfaCDpNbT6UGL93ULW+DYVyj/kL0GF
	 hF+sz8k8YM0Xb7eLV1esEPaoZxg4fhRiaq6UPIgi1d69fuJWguOZd/BGFHEFIrh+KUkMF
	 zrlgmFmpAeey9if+l6i2te/YDz8OAzzvOmvjJGYH+mGKsEbqMtVQdAtAnc+rufrhLgEK2
	 /MoRFb70FVE24HxqZx+jY3yl8qooH1EVkREYRL32+ywT9X4zQeI7XRxZzSryCXucNnSEh
	 q+F3NGEe64YUyhg3kuenXv71KP/gm8ivNTs7Hvms2c7OpZV8Z2OC+EzVjeN9XeNLKyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cyklZAYd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88232606B06D;
	Thu,  5 Nov 2026 19:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cyklZAYd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CAC1F008A7;
	Thu,  5 Nov 2026 19:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908662;
	bh=1ucq80d/HBPFI1YIkIEFNdSOXOIK1pX2sWoSRce4LGk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cyklZAYdu0ZVZTXCtdmNiCr7HiuHeOQyL+0S7CFmQsIMMFfQNly59rhkWaVoLt25u
	 GJWHmTWEJKwUQ3jEJYZRj8f0gumZIfwawo6h0vxZMknc3/HmVH0Cy+FDJgc4U1e5Jm
	 T7qHR2VsrYj78ByH806qRFBswbz63IekHv3Cvnq52k0GiBF4SJQjnw1YKFUxkcxM7V
	 f8oPRK0Sk4UnkzaejQ6R5LFelnNPmHaMgfodZ9a79DjRBdXTM0VSqVCS2MZtqqfHSG
	 VITqB4tE5wR5v6/XkuPGTmojFSNSLFTaqw3nVHzkB1jGn3Zm8qRlfF/iUUSqvdE60Q
	 I7YHfXHpobwTg==
Message-ID: <sashiko-outbox-200040@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 06/30] nfsd: let procfs own the seq_file of
 /proc/fs/nfs/exports
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
In-Reply-To: <20261104-work-procfs-fs-v2-6-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-6-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:40 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the seq_operations and let procfs open and free the seq_file.
> ->proc_open() and ->proc_release() only set up ->private and take and
> drop the reference to the network namespace now. Reading the file then
> no longer holds up its removal.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D6

