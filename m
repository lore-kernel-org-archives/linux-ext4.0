Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718101;
	b=fJrIR29dS4n2vrnhnQVJHUjmHj0m8SyN8LBzo1xaO6eldtPh/Gxb5wSucUKLCGs01cGZ
	 TVOp9OBbfBBnmcrp1chbTrnvVqRa9UiG0HVpDorS6IKHlOp0sOxD+qAyWNHb+TdppsGLO
	 /tLgP41rNsAdscFB2w0SidWtjrDIEjo8ewX411WYuKSc5PYkRzV1sWB8g/X4wBFNIoxg3
	 uutd6SUpL8uHMKyyO2vOofzvEmjn1nmjD+UgHIY1f6ftpzzOUuDjeGQYebNvF5j+irJtg
	 jNoy6cPGN2o7Nge3tCxjGYPAtDUxDXArnfu0TZZKD37XDJ3gNtiHRv2An+ao5Ef/R4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718101;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/loBqHfb9xyTXY5jVvnLeUezXneNMR139AeDEeuZehA=;
	b=0F9if7JEzgCD4Mkkl0PqetPECphnbEgOZSXFWPJgtJmpbH6XomzbRKFWETBitb7kIVzA
	 a8TRHMsn5X3hDsN7YYhTQFaXEII0TbxKruSZi1BhLTIvLJEHTNSoPzDsK38ggmAnMmbGA
	 aaohWBgup31drVV/A89BZi/MX6fas20rd0y8BFb4+wLN8x3wCAMNh3UxuhborC1GY9lQ0
	 dG+ypJ0gYNGdD/Ebz5PMCey8sZkBYlgOXcRqX4ntDkIx6ft0yk0Tkw//4AFG8PFjaSZFG
	 5Cn6YzptUHdTu+WlRXnaFy+6CSOdM7OkAJIIlNf7RK+xDvz0iM07atN0i+1iY2HJnfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=POgogA4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF320606FCD3;
	Tue,  3 Nov 2026 15:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=POgogA4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0B61F00A17;
	Tue,  3 Nov 2026 15:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718100;
	bh=/loBqHfb9xyTXY5jVvnLeUezXneNMR139AeDEeuZehA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=POgogA4cI5wWOeMz1/cd+H4XvoMVMIqL2V+G+9Xb8VwCCRW83BzcmpLvxyFEpcbxe
	 /mCmUg5eXDwuaxyPwlwAvbKSw9zAx9Xa82K09Vni06bzfAy7YLvu6siA/ipSvBj2rh
	 qF1ewX3Ll1Mq4U/1lE3GqVU9xpuJunXOk7qadUPJ7/+1WlPF9/quSAmT+Y6x/gL7C5
	 3liOSC/FI9jN7BDbCH+iEIkaGanVOlPqZzbv9g0LZ0T+zR7LlVVDb8k8ypBMeF0A0o
	 YrstH3zBltw7mcoX5EIv/3z5moFT7qEVZnlXcgdb6E08qa2zhuTeeC8xgwd0aDyljl
	 khtjX69PBXsaw==
Message-ID: <sashiko-outbox-195543@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 16/16] Documentation: seq_file: describe how a /proc
 file uses seq_file
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
In-Reply-To: <20261102-work-procfs-core-v1-16-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-16-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:38 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The example in seq_file.rst hands proc_create() file operations built
> from an open method that calls seq_open() and from seq_read(),
> seq_lseek() and seq_release(). procfs doesn't work that way anymore. It
> opens and releases the seq_file itself when the entry declares its
> seq_operations or its show function in struct proc_ops. Say so, and
> point the extra-simple version at ->proc_show() for /proc files.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D16

