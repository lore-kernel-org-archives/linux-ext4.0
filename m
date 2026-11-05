Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908674;
	b=OWOHr8898AX3yZLTwslFWtjsnmFOsXOGAQq3xsWe/bN5+DzhzYnyVIcXggNtJ6MznnK1
	 ST5pP1K7wUdtQ/yCbxajUMJv03oGvGKdFKSbP6YY2LnQQ1Av4jZiO6M4b9StHWv+A8pgW
	 0vaIuKmpfZ0gBeDaEbtEQnwDPfLIqjc8r5lJ77xQJePF8hNlP3g6UIyzj5BO6LK6iqmo6
	 uOqM/4u48vtnzxGcQ4+S8VFLfQOuNK5lxPcy91wtY8PIEeYncfqdysH6h3F3tnGWVedzr
	 az8xKbYPvVSVH+VzwDkXPmt/mVvcPwmd0wgwZmws2E+hVGcbLE1b0WF134LkUbjrHbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908674;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JeUycd/X3QAMjGkbWRWLv0JHcDa8SO4ZWx3DOn9WWrY=;
	b=xztiUhx77mIHeNTlyyZeo7KQwafXLERvup07crylDUJOIsEVyk+NYrDhzDQJOJ3hVKhX
	 2n41/dLslealxj9wDEczdS1oi/FCfbSsKOaDFCfh32VHSYL9UQeVMYnjGy4ouZmpxfGdT
	 5JQBx340+QAZ+fwn0Fn1vmtHfq/b+dxiLVpxxht+4+hYIU08Vdi0OOpPCz4734fMqwN8p
	 1NC44TcEvtitWKFV+v5svAxvZOUpub8tgQX9H2B1AFVlTMCj1+KODN6nK7MLYTbcn8nlJ
	 rM6JQdq8+4TUigrv+LWHmYsavlEL+bPhaTubDIaV88Ktmldl18aHqXdo6y0lHuk47/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KBygoTPe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F77C606C8AF;
	Thu,  5 Nov 2026 19:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KBygoTPe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782D81F0089F;
	Thu,  5 Nov 2026 19:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908673;
	bh=JeUycd/X3QAMjGkbWRWLv0JHcDa8SO4ZWx3DOn9WWrY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KBygoTPeNolnWEgh8FZs5ViL8Ujmj1WIczSN75XrmLLh8kxMZe5FC5un7pt4khl8d
	 l4f6yhPiJz5zYJe6v+theCb/axVS5RhhYpA/nv5uABjed6cl1Mr8W6vE600aMtwosP
	 u4FzF41WO8SF/z4xVZPrPsrp6oS3edw1bsAa24GmArUDG/OmO3HWmGKoqxCRecln5T
	 w/jecDwFPd24gj+Adp9XEXQQ4nRKmS0imJl4W9dPNxrIMthUNIeVg2Mj4azykbTMn2
	 /UdBPkx9cGZLnkh5r61yrqDUrLdF3g7yYI/unhfTHGXckCblzOGUY+7vDs6k0zETDK
	 KyT+vTJP4O6UA==
Message-ID: <sashiko-outbox-200046@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 12/30] locking/lockdep: let procfs own the
 seq_file of /proc/lock_stat
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
In-Reply-To: <20261104-work-procfs-fs-v2-12-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-12-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the seq_operations and let procfs open and free the seq_file.
> ->proc_open() only takes the snapshot of the statistics now and
> ->proc_release() frees it.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D12

