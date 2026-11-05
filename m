Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906934;
	b=W4VsGG0YcUFNWt52bEgwnHTTHSXFlWb0c1XUbn0pyIx01bFOJztFqq+U6m/A8HlPAIFx
	 HLRiXdYs7PsiFpal7Ivo056AECN+dBZvtCasaMdNA4BahSP7SRgfb+nIjPxk0M+1N/NCv
	 hqE4q5yt+SUiNkxyoQm1gs5epsyc4epSr8raR6GCVIxklVmjj1GR5FnMrLw22UeseKHi4
	 S3wqhETpkv0ygenGqRIXUwjyTUxXWGJubY1H4i5RbQGzkywbMiZHoyh9AwdQeJH9PMirK
	 LTD4ZdRH6WS3ol/SK1NZx2MVpvj7QnR1DdhG7jS9nwEU8hz+pcNZSn26ClmfAOwrVyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906934;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Dl7+6TE3klHc2brN+bZbN2jvo5bJeOK9y0vggKbBQEw=;
	b=Z+0xtmtj1bzxUfDd1/gPpiFrsuzpUym6eRk65dz/ZPNV9EKKwYlkyrAXI2om9zDUcWh9
	 TYJOjzaXF862EIaqZhnnjwQoeJRy9S3yD8UJDZgpmnmumd5ehIxPFAb3b+dhw9KvBBp1z
	 loXTJAUtiZtj0+E84ojRVtB/UxHFKpbeOokXcFT9owVlRUCKV9z1/SrLNjFmOs2nVC2tg
	 8XHjbxVWhYVNEbtM5D+o9jTbJdO9EBb7sUt9TtCzAhWq+0q5rFL7u5wjSLQ2cZgWgys5h
	 IamwR4oVCSdBkRkemsMX2LVY6N5J9nGCux+xU5OpOHWrOHb78zl/H9lAOfno5bQ7xFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jS5u1c3K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63869606D82D;
	Thu,  5 Nov 2026 19:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jS5u1c3K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A841F00919;
	Thu,  5 Nov 2026 19:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906934;
	bh=Dl7+6TE3klHc2brN+bZbN2jvo5bJeOK9y0vggKbBQEw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jS5u1c3K7ImMy0Crh/Iyk2SB/21MWY/WEpvgJVP8JqocmivL2vqyijNAqT7WiHjiW
	 6Ua6xCh3Ij5H7KLcgaQqR8ixyHADZco61udOB+jlfTExiv59U4z+85rPVir6KFx0I1
	 ObSC7TmsTyRLViUk/SGlKk2mUSVLDinXNea60PUpTBUb3+Z2hC3lUIZS8S2tOJbqUr
	 AKLtI1OGNz8Uwoag5jqRzukuHqTD25SiOWs27vYk4NAWf9jGI4TCW+iBo9EUmmHNnG
	 9mVPo4N3xUODMaacXqbONIqxB5Wjo2lV603RHlVY2XtZFGaIEcNZr1t9RV/1OvaXBn
	 v83WwqOK20reg==
Message-ID: <sashiko-outbox-199866@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 03/51] ALSA: cs46xx: hand the region to the
 region proc files
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-3-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-3-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:28:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> snd_cs46xx_proc_init() stores the chip in the private data of the five
> region entries, but snd_cs46xx_io_read() reads that back as the region,
> so a read of /proc/asound/cardN/CS46xx_BA0 and friends copies from
> whatever sits at the region's offset in struct snd_cs46xx instead of
> the mapped registers. Store the region.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D3

