Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908175;
	b=PGLAds9HKjpR2MJAxnrxkd5e7LI/0M4jTcKhgJA41YMET1nAYsBz0F0m464BcTWWXNOj
	 3cpbRokrEutqFSNQIkAMeG1zFO4CYt42hXKRrlbfRHAeLNYJh2DGGFUi+SOsyO3gazcDp
	 Yzr5+uEPVMtvYeZXviIK6BQiuSwJ1smicjnu9DnLYCwd9oY929CiojgcUvhYOu4Z9qhbd
	 w/4IXayhODik29j5xcjxGg57sZzv7kLnx2x5bJLInV0LDJn31TwlD0RUwlcoVJJCbSnA4
	 rdo9jUEfpPPmJWjRmPUMzQDt9zl63CxhDpx1dyAn1iyJVCGf7Th+/BjlHxm8aftWqgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908175;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sxquOEf8juQSLAzFmlu5IaItGv71yt8v9hs1pwQFBN4=;
	b=M8Fl8bNjafXho52kc/XN86Q0d0baqirCoLCLksz52LknAkOUaA2jlccsK8NHloblNHuO
	 WKm7wAXu7ymd7fT+ffrF7/WWqkHywhuqAsUTLneBUDBx/tWXnrq85WY98tE4Cy+asAp7D
	 4nR30viBkrB+eLCR9v8Vp2FPqC8PjLXP6eKFuZw17jM3nxpkSQO1ymDVis89zLoN3wzLA
	 ShQ5xvO2ENkBr+HON+M+SWKY4o9czrSOvprPrlmQgEFpxaYArYRnv3gLD2B0QL6HUopjW
	 IkXKEHGPSfzKPykqxwmvcWJuL6lo7y1ld7bgq8zpTIOWAoPwz8EgvZ/burOYTnCkrQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="E/XdMXes";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A16E60741C5;
	Thu,  5 Nov 2026 19:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E/XdMXes
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A0F1F0089F;
	Thu,  5 Nov 2026 19:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908174;
	bh=sxquOEf8juQSLAzFmlu5IaItGv71yt8v9hs1pwQFBN4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E/XdMXesPnzqArTQVj/vATbkPn9quAwWR4+QvOPhtuJvzjYcOtcBO9km77xt5leiV
	 S36ywlp96IrE9g21mEHWOGsT1m0Z9aOWEiIXFWbARiBzLKcWhp4eAWsmDEe6zU6OpH
	 6s22Rj0Fz2TXY7KACfjilQeCEgSAyXU8UMGgTUXfxlp2luB6StU6tJ1htLCF3/JA0N
	 ZeVUX86qfj8DTna8IOIQTukgCGNc6dHpxdehzyd/TuYj16FfRUpYgC0TnCxA7pfYZC
	 /oGLJvhxn0mEr8KsQkB3j/eQ+ramUsjt1AdHgzTdj1h9sH6id/6TgB+HEEasDYiBEQ
	 5EAf63o4bAUaw==
Message-ID: <sashiko-outbox-199999@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 13/26] scsi: sg: let procfs own the seq_file
 of allow_dio and def_reserved_size
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
In-Reply-To: <20261104-work-procfs-drivers-v2-13-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-13-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:32 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Pass the integer they show as the data of the entry and declare the
> show function, procfs then opens and frees the seq_file. That makes the
> open functions unnecessary.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D13

