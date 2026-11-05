Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906954;
	b=PU1vPAXeR35sW1CYV/IggLEm9Jm0Xce3H5g0BjVo5Ff4XDhdnHAMh55NVlWX755vglmd
	 /OR1z0eJzHU3sUV+xXYOPGjcLDWvi2kdCDlWax7L9kmWgtZP4n0KpoUrV6w4+7i6UgUwe
	 AbzxPzEQ8Znir1PknfYs2GoY8gOoPe75+njmdxPflVlRVtHnHq/J98ynwOyiuU2bwWIjJ
	 oBVkOuaI+sqIHiqyuPej490ItC14a9gA1oEjXJOZZrn6c5pRbikx6yh9DxTCPJKfyOU6K
	 zB0LBzax7Y0YliJ+6wPfRd0VFnsJ8WXZXKCJRDI6yBkhuVFGpfPiG3pdCr1dCKaVPmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906954;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qYpt67HnextFoZu9a0KvUobhiMrlWn0ba92Ucxvlod0=;
	b=lsdeqi2Cm8LCz9GVj1YSdRbKmOLlElSpJnYUqsRN8Y2x00cyhBmos0rf4cubLifFAMQj
	 8Mi8Q3u7BEEQnIGw/SBwRt51A99PuNHHkdJuIE/vuyJ8vjnpH1eS90bfoXonF4VoLYKtV
	 n6oZ8d1lg4ssdj4vbMSfYawAsepN+SLO2Hr/E5leaF3z9E1/Qjq4oLYD50/RIwB1qHBeC
	 C43LBPEnVbmAuWETz1ySifjPV4QR1KFym/VIrVs4XU8KooS2E27hhCtvu+DyaNeJmsFeY
	 3PlifL8HnDjgSfWJ+mWZTLJ4KZWGPuTdUtOVJ1Tc6LdQySKn3vheld4QjQCTH+Nq0Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9LZ2DKZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9404606D82D;
	Thu,  5 Nov 2026 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9LZ2DKZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4D81F00A02;
	Thu,  5 Nov 2026 19:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906953;
	bh=qYpt67HnextFoZu9a0KvUobhiMrlWn0ba92Ucxvlod0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i9LZ2DKZwHnYK5IpY8mSgV5ajhfjdPLY2QdoXn1KOHQtU3MNPMIIkqzWJ+l61PaHV
	 U4dn1Zre5ud+JMQhyzSRt0SahDPp8PERyeSmTGAPSvYaVGithpx7UUiCiDIS5aP7o8
	 yiknyv3w+lNWb8nJUJPnGF9DnIsx87AjkTzdJfhMDt1aWvCVUScDfBwaHfX8FD/oDj
	 FjUdNKDwK332+g6e7b3tL5KcI0s45HVKxfoQTPNCErl+nxaNU2QdXrNYqhlAfGWWfV
	 VnoGmeqjnxuET0EKbWs+mWU2b1yq1VMOdgFBtgPIpmMZpWj0oHgAkiQaF9fwq+c8bn
	 4Bjmd0UpxAgSw==
Message-ID: <sashiko-outbox-199875@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 12/51] powerpc/rtas: consume the whole write
 to /proc/powerpc/rtas/progress
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-12-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-12-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:11 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ppc_rtas_progress_write() shows the first 255 bytes of a write and
> returns that many, so a writer that loops until everything is written
> shows the rest as a second message. Return the whole count, the rest is
> ignored.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D12

