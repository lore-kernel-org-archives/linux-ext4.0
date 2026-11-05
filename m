Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908173;
	b=5Vl6AiBGwTDwTt8JJvASb4IXZKVQ/ySBIMIkRqDTi3mQec0LPZ2ATANdXiDbg+4tSc18
	 yOxsFGIg5x7cmDLlvf/jr8qYxZT4+IdBlH2zs9+6UBvmITt2epYQTqzVP9dN7CCzGfsjQ
	 HGZWplrW0QY+1HUI6tuBeOAoh1CwEFbyKUHtEqcwOVd50rOmPU9b0dlc58yDB54Y+Hzhg
	 iJdglPo2KMsYAiF4lNbQTiLu/c8NRHM7K8+XmX0NucwEMqIBOwhkHiO79kK4Iff0yB9nN
	 VBONjgB/BBnsIrcC0BJEwswlfMLJJqAfww4YBHRQYIMuQrf+6x4yrTAUqpgPPQn7V+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908173;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lQ8JIZZ5kxkUAmXk+xiS/+ArzA9TFxFnFqVMIk+xVec=;
	b=0xdhcpt6k5RQRoPlasUQlY0gHRLgQJS5H0n76w3eOKRre/0OVqYF54HyJUByLM50fRYg
	 OXhXMurW2lILdqooQ5FtofhyvQiz7NB/cccbOfVEIc3gNlQ+N03dbAPhp5BOduUgK0gIt
	 +QwIkIuldAPv/x/OLsmEi/qDbzHH+6+kP/1tdz+CORE+ApxpzVkjjPikLxspCOlG50nnt
	 oTC2fS1620/EfNLgyQGt6ozCKkBnkiLFxHLku/+M6wUWJkyWbtyLhJXzr0Chv5bw2p/V5
	 60PCay/1Ku9n9YIE1mRauDk0lj7QbMUvADBPXel+z6OpSAgb1LVktzQKi3I8hd7Fkww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j23WgGy3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADE76072C68;
	Thu,  5 Nov 2026 19:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j23WgGy3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52EE1F0089F;
	Thu,  5 Nov 2026 19:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908172;
	bh=lQ8JIZZ5kxkUAmXk+xiS/+ArzA9TFxFnFqVMIk+xVec=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j23WgGy3ZqOpo9kyAHUXU5TgvkUzhD6a54kglnxcdgVHF5WgUmqLTvnUkLSBL02NN
	 ZdW0u6lyXYxXcbzgP4wZH3y1mtnPgrg5z7WwxtjxTC0MXuUY7FZBiGNIJN33actq5M
	 5yEtX7ikb+TeUy83H9n+K05TTJFiakZeU4BBjUvK8gx/zO1ZuKoWzEZSfEaKAkxDJ2
	 KAukZAJBis282pacUrKrUpdcLpMu2c+LVBvHUNQoV0aMN6jIUx+dB0vbXhUvz3bUUN
	 fJ/2AAVIZ6++OWfNDvCq5yu5I3y9gI6EpRYBWpZ5gmuqjIbW8UEqzGQ4UAADKdqsI3
	 MtbtxRO6ZwLEg==
Message-ID: <sashiko-outbox-199998@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 12/26] selftests/proc: check that a faulting
 writer doesn't hold up removal
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
In-Reply-To: <20261104-work-procfs-drivers-v2-12-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-12-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Write to /proc/scsi/scsi_debug/<host> from a buffer whose page is backed
> by userfaultfd and remove the host while procfs copies in what is
> written:
>=20
> - removing the entry doesn't wait for the writer
>=20
> - the write fails with -EIO once the fault is resolved
>=20
> The test loads scsi_debug if it isn't there and skips without it or
> without /proc/scsi.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D12

