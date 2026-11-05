Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906951;
	b=XDP+RfMhwBL5+i1PQ/qZhX9CHjcvlAujYcRVV6ZM1pic5zTa+8Pp7VVO0aePD9H6+Xh9
	 viUBmHO04bnrKzcVLlVN3d3epIgGHQSsFtJYX+X6oANpDCXwjoMhgfdbDHpHXt6mfhXBE
	 rkdBxtaZXQfTL2k30f0gF+wH/T6OPwZ9+21QqTrjWlJLzB6BbeXNUniHWcQCQ4SMDVO9u
	 cogPWsKFUJh239jfnYYz+3ZhfyqGE9nHSm5hz1KdDK5W47Kv0wFvGeydmWDuJ94TsirQO
	 LDUKqFbfs4JsGX7xXPQsdJSm3kdUjtCBRZFBv009VEOXU5nE/ICwdV9YpnLascZkTAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906951;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=s2I1/DcyfONVmWbtskFJJxiXW4AP+/HerBsQu/u2rpU=;
	b=0ETkRwK614Zeh26MYI+dqUUXJtQ4ebPXjR3vz9SwQ3R709Tu54dAdCbh0kVWCrL7/Cf4
	 HI1itQF6PkpBoFtYsPg1ZHh0i9o8lhtDkFfEAENF68/Kg5nw+iBlZDhFoERHQgnGxp//b
	 tZxjTjy4d92fzveCowBamczvRTK6nsQPKCfMQWuIh5yx3q48wEQbPNRXKZTImtVYd/kp0
	 zC8crN8mns7TjqF4ledJ+23V+18EuGsvNr5pcaHrmLrRXyVUbzK89qiU0UoudXign9A6r
	 GOsVLfcqhS5+Bhy5//W6l1YuoxrJ/NU1kpvDAWGhueZal7hJN0wAC6GgOTcrKxsnZhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hob1t0Fy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F40606D805;
	Thu,  5 Nov 2026 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hob1t0Fy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2771F000C1;
	Thu,  5 Nov 2026 19:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906951;
	bh=s2I1/DcyfONVmWbtskFJJxiXW4AP+/HerBsQu/u2rpU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hob1t0FySRzo9Ad4NeX/wxJ636XvG0pYfHERcgRJc+Sg4Icctgz0x9vaAElTM9XlC
	 DeKuv9MiuNdLOq07xSluaDzV5JfNZv10Cdb4YpMe3kNCTfqfHICUGtyJeiRHHklAiG
	 o++YqHIytjB4pY2nCoSP0oV0ptT5uhCu20e3Yv4WPkXDuLDrzC8G5BMKr5LZKXdO/g
	 3o/pp7jpt539+SMQvv32EonKmKe+Ve9RvbbFiZGIicJZ9ffcoawscdTJSTVjbDcbdg
	 3IMhMWg4He6bnLDFELiozvAEzPh6t3NkjMUHVvLrqfosjL7JmUxVl7OEAfd/jNb3w5
	 bT+XCtkRbrOvQ==
Message-ID: <sashiko-outbox-199874@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 11/51] sparc: led: consume the whole write
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-11-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-11-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:09 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> led_proc_write() looks at the first eight bytes of a write and returns
> that many, so a writer that loops until everything is written, stdio
> does, sends the rest as a second command. That one is unknown and
> switches the LED off. Return the whole count, the rest is ignored.
>=20
> Fixes: ee1858d3122d ("[SPARC]: Add sun4m LED driver.")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D11

