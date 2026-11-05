Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907025;
	b=nmu3vc3AQa0/0fkkNylRAdbJ5aiS6+Sc+xrI6YORnVCn9N5GhwzxNxw5xgZfy/vhE/nT
	 i+1fHaW7jGPJJcPXIyQ8VpKwmmgKrLgmjMrhjB6GWkwVyBQEcasVamXNt6VD7csMu6Wnn
	 ajlQ/ay0OtB6/usN5ZUYohT1E6N1HQffOKtSippUwKLtdTZhcOnlWY93qmwdrQyUbo+Mi
	 bOA5PlTMaoKkwONGPo0XX+C4zHoTo9EbUpj0+qRXM/VTy6kM9gk1ad6TUkgthi/M5alz7
	 mDNOq9kIPdmwXA/596hsHTfUkEhKL6CgBVIppUkEmNSvMdW08iD5EaF/AJYh/kNTF1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907025;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2ZEFR6gjnP3wVSksugK0Xi/aHT+AN/UQkRBLfUojuMA=;
	b=Udq8ePYyq2vBnXecrQLvf6Y5YO00oK713LxSo0hSpJTmEGQZOhD1HynX8PwPRmT8rOnL
	 2s9oVlc3+fxXKTWCqMNpAJ5/Vk+xgrxcyhkAi3/qFkwEz1n5fhEzmqlOrE/a6GCvXTAeO
	 yo4Jz8+thkv35rD8eRS16WF2LNrQRpsTQZdJqo1VAlUj5MHkuHk1Io1vZAGhwy7Ft2xVq
	 vbn/rImksLrFAYXMXUwIoT9G7A4/dZqvmUSQY54fLXTqqpYAHuQmIGGrVSJq4o7VSAH9f
	 MzZoHte01/sQ5LqQtzLLdj7TB3ev6NDzuaDZ6JljvJvE2kDmXbMnIaKNyby0bwQ7dCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aFb5Yznl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6AB606B9C7;
	Thu,  5 Nov 2026 19:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aFb5Yznl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2801F00919;
	Thu,  5 Nov 2026 19:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907024;
	bh=2ZEFR6gjnP3wVSksugK0Xi/aHT+AN/UQkRBLfUojuMA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aFb5YznlYnipR19+u+Im8pSQa+/x3WULY7AoYCqTywnkISPlw9ZNAM38Fkr0pYgvi
	 6cp1ijVNCZRYHKjlbb7mp7pruaep/7wtvEt054PrL+Zxw8V6yne8Cd+u9HQSVVaeWR
	 /crGUSwOp+7vR5Uci9LlccyoZkEnJUeSmLK9Ve7s/+EFwq4GsVFjKdQehhVg+5wuGX
	 w0RgAwmJ2guiBQr2AyG8R5mOMd+mWgU2cUDkOUbrm62IVqlgFWh8+X0/UvbreN6eUd
	 orSAqTkhmHMjsXQrmyGsTaiwsc4DUpcbRA79TZz6uGLjaUzMpDTmJ0UWgvZ1kT77o6
	 QnN26MXG0YM6A==
Message-ID: <sashiko-outbox-199909@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 46/51] proc: sysctl: copy to and from
 userspace without holding the table
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-46-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-46-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:23 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_sys_call_handler() grabs the table, copies in what is written,
> calls the handler and copies what it produced out to userspace before
> it lets go of the table again. Unregistering a table waits until nobody
> uses it anymore. So a reader or writer whose copy faults for as long as
> it wants, with userfaultfd or a stalled FUSE mapping, keeps
> unregister_sysctl_table() waiting, and its callers like to hold locks
> while they do that. addrconf unregisters the ipv6 sysctls of a device
> with RTNL held, so a stalled read of /proc/sys/net/ipv6/conf/<dev>/mtu
> holds up every RTNL user until the reader gives up.
>=20
> Copy in before grabbing the table and copy out after letting go of it,
> like procfs and kernfs do for their files. The buffer is ours, nothing
> needs the table for the copies.
>=20
> That moves the allocation and the copy in before the permission check.
> A write that can't be copied in, or a request that is too large, now
> fails with -EFAULT or -ENOMEM where it used to fail with -EPERM.
>=20
> Fixes: 330d57fb98a9 ("[PATCH] Fix sysctl unregistration oops (CVE-2005-27=
09)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D46

