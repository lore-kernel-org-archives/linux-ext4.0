Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908669;
	b=PLsjOBMo2AKRt96+sQ7a61PUNED6Jq0XwB/qFQIpnDqRJEOaNmS4t2uIySBjvvAm+mmU
	 nFevR5oXJ+J5V7sS8JNj9wmiM3pnxeYe6YDn9oqvhx43T5r726Sforj+peJuZAvkEWNJZ
	 R4X1RoBdNCkQLr9k1iduvAUY4J/0P8MQ1QFKr6RC0GvoYmgrCBlkm/jibvZg/9Wmiv/6D
	 ziCbOf7sSYaZiUina8X0kSsZfLMb8u62jlIvG6OeBMoAFgj84/OzmisO//Qn4h9yGHjxU
	 dBA1xokTaREz9kqFt1jHiT8Atgd99xvO3maU/UCqviwtAmBmsSwebnOM3HsvLojZA3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908669;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MzwEajn5EQQ0Ibuj4NNySLRm5jpl51Rmvl6LxJvcYPc=;
	b=or7PnnQx2KOyYo/6bGKNqyehDj8mnTAC68bJ/D6LE8hwirm6x4yrKocHAFKkV6JxsHMY
	 BhQdvRSD/0fzhNO9VOBy8NgIFjPFgOKP9C8xOSI5CbTd1XTWy3GJ33x5HDTMyfEZHdARD
	 OCKRoR3zI2hiJHchX9vF5HlpnkVldz0KhaW60Qt9IphHpvAvcT4vCJEET8mhozZmujiBQ
	 CMSKtgQ7B+52pRgHBGcj3tT7MwdXSEpErAmdebLcoCdIDaImVKsBPWNsYIemlALd8yqZp
	 tZh8ilbdhUSXanL9SldK3WfupFR0IeWYEIdCkfxARGCzuutgHl3ojOXGnp3AJuxOPxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S2ObnK8J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC18D606A6FA;
	Thu,  5 Nov 2026 19:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S2ObnK8J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A547A1F0089F;
	Thu,  5 Nov 2026 19:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908668;
	bh=MzwEajn5EQQ0Ibuj4NNySLRm5jpl51Rmvl6LxJvcYPc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S2ObnK8JRINAflJyKIXSK2w1/pSi8u0iSg/Cm9cXg/GKcCS3V5T3ETX6w/TXIgGXx
	 gdgVtIYSN2JEUxzaneOepIMQQZ7VLzsMP0Y7hbLLwupBmIcMyyElFV+gIO51zr4uMr
	 TQCPiuRqepME+qeBElkRBw7GR2h1SJgr4RWR5IqIOeRAzmyo1SoD3423ujzAceCZ+2
	 cJaFGGjw8nxcKkQ9Jlfoucsu0xvZpakmHDU5mBr8gpr8AFrjlZvWEbwak7GxPsVTvG
	 uel1QhMad+WBTXzIAKEerBzEA9SFbbSpWXd3k1aM3Lznnt4WSnG+vs9iYwjubuAZgu
	 1x7l6iw5jmWmw==
Message-ID: <sashiko-outbox-200043@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 09/30] smb: client: let procfs copy in writes
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
In-Reply-To: <20261104-work-procfs-fs-v2-9-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-9-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:46 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for the files in /proc/fs/cifs so procfs
> copies in what is written before it pins the entry, and parse what was
> written from that copy. Writes larger than PAGE_SIZE - 1 bytes fail with
> -EINVAL now, SecurityFlags never took more than 11 bytes. Empty writes
> to cifsFYI and dfscache fail with -EINVAL too, they looked at a byte
> that wasn't written before. kstrtoint_from_user() looked at the first
> 34 bytes of a write to cifs_debug_dirs and the smbdirect files, now the
> whole write is parsed.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D9

