Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717284;
	b=1JrnT+Yw9dGQ50acJNC8M28OQymadH58M8dPQwYgukONWv7oFoAoJwq4TReMYYAUwpOm
	 JKb3IIwbPLGeXRS4Q4heCqTeDx8kuIoZ5oh3E73f4YX4jbebypv1zjJSf5Y1+hKJTyw0T
	 ihBwP5gIVelcZVyPb8ib7l8DV1ZFITrpW7NkWDadjk8RGG5iVnY8U9F1HzyCQBRlm/vNu
	 IKRYvsLEhPwevPmHSReyUntHp5qCXuXj7X4ZoWOmyDIcM6937j9oLipRCUGRCuhXtyXda
	 g5w917I5vRocqFc65OKf/EoAFWxpTMJ2NPaIxCNnGK3vHdgt23YdOQ4uDPYSgfK6iIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717284;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4gvOaN3wvXGJv+/IY1E7diuO1bBr8yQTbePx2Vj3hKc=;
	b=AM6eRSN5KM4rEL4DeZ1lqtDKRXYdu370YtotNDr+nuBu5qMz/GRRIftDiqb1qP/Cjqg2
	 RWx7qV+jy0nezywfDK+Uh/H3Yw8zGELNbvFBLOxgRf0GuY4sf7AYZ626Gvpz+36Gs0RoN
	 dzjPcvDyJ+ppsivstEGyX37o+3tdVIKoDejlLRW5/WnvUe19MHVcQjpVUh2LPyxAeWRJF
	 RdjKwZfJ6j85UEWH1Mq6egbdKo6zn/51uVB1LXEyc32AiiHG5Cfr2NE4qM62Y6AEUFD4B
	 kNBIpxNywwD4Oilut8qjHpeRSoBDT2/vm6yvlRL7YBN26yE+ttzYbnQfk4AiLNI60pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YmTKMbVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED41C60A2630;
	Tue,  3 Nov 2026 14:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YmTKMbVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522C41F0093A;
	Tue,  3 Nov 2026 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717283;
	bh=4gvOaN3wvXGJv+/IY1E7diuO1bBr8yQTbePx2Vj3hKc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YmTKMbVB6uRZLjXwEmTGCZh1HbdFcP+8zoHGrBVs3FcW7jqNS/aLVG4BlExyxSsDi
	 38dJvpm2rvf1W7GZ/BeJ3ROdtFFaZsXbBtoCEGTFCOYaKI0Lf6z06i3opj5SfVmYH4
	 ipI9MxfbEk4PvoPknKAXGNPzP1ISdgwyfESt8i+pcLKN52RF6XDNuCpDPwR9Uc9/+1
	 HQqdQmf6H6L8RFmo6HwRaJux2HSFx1o2jASbcWG8qnKo8kDaCAB0CSVzN8mB9vSXlJ
	 T8PYlXW1wwmvUUuV+8j3OkHlmGF3wk7bmeAtlTk04ChojfBfTSX1bouOrIZWxXnqoh
	 yIYT9uP9AsuWQ==
Message-ID: <sashiko-outbox-195490@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 18/38] proc: don't WARN about a name that is already
 registered
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-18-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-18-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:01 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_register() WARNs when the directory already has an entry of the
> same name and fails the registration. Callers that pick their names
> themselves should never get there but some take names from userspace.
> pktgen creates a file for each device a writer of "add_device" adds,
> named after the device. A device can have any name, including "pgctrl"
> or "kpktgend_0", the names of pktgen's own files:
>=20
>   ip link set lo name pgctrl
>   ip link set pgctrl up
>   echo "add_device pgctrl" > /proc/net/pktgen/kpktgend_0
>=20
>   proc_dir_entry 'pktgen/pgctrl' already registered
>   WARNING: fs/proc/generic.c:404 at proc_register+0x555/0x8b0, CPU#0: bas=
h/241
>   Call Trace:
>    proc_create_data+0x9f/0xf0
> [ ... ]
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 6c2f91e077f1 ("proc: use WARN() rather than printk+backtrace")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D18

