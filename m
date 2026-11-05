Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906969;
	b=rjAv4Og7kwIXVU3TeKlhMWXrz/xNtcU4TOU7YkOsiB/ZnUBsf01tA9VQfQJ3f0UxtndS
	 LhnkmgEpapdWA3r2qDPWlnnwC28su3yafQYLC7UQTT66aTfY4nWDpHBCXxQvF/a9RbXsR
	 Owq8kUlVRvX+ZsnMYz5a9x4gISiSBdTpLyxkWifhoNl5pcwN/t4DgcbvP5CF7zW+HIiV5
	 UpzajqYXOrXiu2IBoDdREVY8zf7BtBfV0qkno0jZMk/03YovM0iZSDT3TPimVU8IoRIcy
	 m/MAn9SCQB9krQp7KzCnEv+Sn5otOmfFOS62lNgW8sS7ZkI/lt4e8oLTjc7E9W5W4ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906969;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BQI+a8njiZ/gI4hynXalYGlHTbeuK2z4PeQyurW9I7E=;
	b=XdBbLehEdKQno9CSZxWSdu1dNliuKJ5FXl5orPAUW+XbTXeMVlIZueWzLMeUOTp1gKEc
	 hoJb1v8Z+4/fafwCEMT8spdi3/osBQMrhR8fJKps4i52bxLNAkRvKHe/JSCkzQw2JDdt3
	 59zWPksSJWOGo19zCzh1jwLjpze8oN5zAV9rsE6fAmrPGSMzAWKT5uwpV8vt1APdsHbJg
	 bMamwYqEr+JbVgW0cG7iv4WfqJoim7JNNWCePIgEMLmoov2UZjlm13LdnvpxzguPwl3ma
	 voHsrf3aBn7WE2RZegG/FcQkwzSw2TRjhrLXRGxykrlj/94BuzzO8wrY5Hf6UumIKvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XbZWqE5b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8CF606D81C;
	Thu,  5 Nov 2026 19:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XbZWqE5b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D932E1F000C1;
	Thu,  5 Nov 2026 19:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906968;
	bh=BQI+a8njiZ/gI4hynXalYGlHTbeuK2z4PeQyurW9I7E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XbZWqE5bV1/7AJYMx+wz+v1eHMIKkyE8SQclRs/OPZo9iXZQoLwkmOhiyxQQQlhJE
	 8sowAoifBDVNyDNDLEaP8lelRK7/+buyxRsYnpXg78dXMLTw7E9r/wWQq/tiEDzR6y
	 aX+wD8fLSCGmqTUIYxuEFc1dqwu6r8nwV6Y//hBCH/Ixikoyl/tEaip/uUdqQ2AyFO
	 Hsl7wCQ5MJ8vCIV28zr9nojYTBgUQpEh6I3Qfn7gkQr2IO9fL1vbfhzhhz3jhjCt/q
	 EfQn7sAzxdZYYzvTAFpHP0LITOOhjBJNmZidQGsmC3cKnW5zohL3e3FGKtD5LfWZ7w
	 nN9DEaZl88tjA==
Message-ID: <sashiko-outbox-199882@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 19/51] xtensa: simdisk: don't read the file
 name without the lock
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-19-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-19-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:26 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_read_simdisk() looks at dev->filename without holding dev->lock. A
> write to the same file detaches the disk and frees the name under the
> lock, so a concurrent reader can copy out freed memory. Copy the name
> with the lock held.
>=20
> Fixes: b6c7e873daf7 ("xtensa: ISS: add host file-based simulated disk")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D19

