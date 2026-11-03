Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719144;
	b=fyP3gEZPlg2ep+KuRjd5RrelXFITwGpocqcm2mdlKEmZqgrZrNlTq7UkrXLTj/UslnB/
	 RnHM8xyswYafaaP4jrCjTwwSyGM2PngHvRVnrQW2rv1V5ZXjpnqcuTHi+rZ4Z/x7ZzG+J
	 A/wj98e/iEzQoxKu2jLAR71258KDdznZ6U6dq2g5JVx8ln458lIDjuYjq33bdotCjzAUk
	 Yxq+VCn/j/vpuBqKMnlCisx+RdN7gT3VlWu4c6mIEie0JHrHRGElUIfYaVc9ffXa/XEqu
	 XcQGQjjPSIUUNzZVpNWtBldaOSHmLHiN70lWenSD7LNZYxxNQOu28qLTXfkpZR/Rgug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719144;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SjcUx5oTPLgTGLgzmcu2JufpKTLPRg1ew/w/ZvgHMGQ=;
	b=jhDzujR0lxCQh2fNOGGfMyMXrzATyfz5Je9upCilOG2sPxHsU9LyXbXBOga6+8+tqdZI
	 +hXpK+7auuALNtCvNUzULm4VCrUx2wadxJtYRvJowUm1cU7br2BLEQAoT+OAVA5W68A6G
	 EsrBVmMtYpt0FYH390IxTUIc1wNXglkQWwjKzv9Lw9XA4DwHiyf5VEBQ+aEaJFkWUY0P8
	 5k+t01XOwNToTWGvytA7aZ7r0NxSinNYN1/ow8nDz8p4fx2sqMsbBgPhGA5yzA3hW9xY6
	 8WR7WxaIhgc9J28ZNm/oXWbZ1UdhCIjrBIjyyi9uT7ILpb/UbCpXTBUajCh3iCqfUAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H14nd5Zm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68BD60A262B;
	Tue,  3 Nov 2026 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H14nd5Zm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D181F000C1;
	Tue,  3 Nov 2026 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719143;
	bh=SjcUx5oTPLgTGLgzmcu2JufpKTLPRg1ew/w/ZvgHMGQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H14nd5Zm0HOMmUow49/EVrlsioyc0r4b4F2o2FArNkwr7aVd2fSN+Yi+iAXccw4M5
	 Hrez6lVhFAVFW//WwcipwXCOlWcXfetVqSC+Hja7cB2WYSUxxSs8b7ilDnEXXV+YgG
	 Kzk5MCNjv/Z4vw0jG51MNllEeI7ATjJgL/15EIN1BVpT6LY+VCwu8YYlMt8wKRHZbJ
	 okPPnQ07EmoHQPM37MzbUMh4PUpDYEr4ijJPybDBs9yFmhlOJHAw684kdnTGf75k1n
	 dtWfihYM65eHFj7xYgCF6qY7OBa56KZmFdPeZl/oOc+JWcX05Z8c65nphAxmh0Tsxa
	 rDXtJMpHvTgqA==
Message-ID: <sashiko-outbox-195597@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 17/23] usb: gadget: function: rndis: let procfs copy
 in writes
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
In-Reply-To: <20261102-work-procfs-drivers-v1-17-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-17-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:19:01 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written to
> /proc/driver/rndis-<n> before it pins the entry, and handle the
> commands from that copy. Writes larger than PAGE_SIZE - 1 bytes fail
> with -EINVAL now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D17

