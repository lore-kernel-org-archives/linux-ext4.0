Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717309;
	b=RqBvIweOAsWzmj/RufDI3YuDMQLgBsVZjoIx8RLCOpNHlb6XmSwEQ5/App8T4bo+A4To
	 SENKZQKRjgxnjGU/WW/1n+XBjJWrnuCnEGY4yFleKdNF2kxwfjTFHfOhVFaTUP4QgVXe5
	 ghKeR3J8xx0NYwO4iGw3413Biw6cw/pCtXUKmajj/IdSSpIgdl+r1ZYM5xLy7KpNruXjV
	 QFih97qg/k8mFw4JbXvagTRZDVlUc8aMNqF4Ms3hVoVgxjHl7RaxJZBGAJCvgTaj/oJsH
	 rCxvazyhHCS4pakfe2io9iU+ek/8x46kRwh07S/hqpNQB5YzcFITUyay2NG5yVZJwsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717309;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oZNMg0XOhOF82NdxKw8m3fuJZ/CwTFkJ3vKS6G2BA+8=;
	b=c8l0nn379j/Ze26EqC6Kc8GsaXBkLle8I914+DBx7tA9mCKQVrwq1yXvvpmMgPCESC9o
	 aZabRYzl6Pg7YFdbENiwGfjXhAkaGcVDLqoIjtetMaL+6qOAfGTMtGXzgFGjK6Yd4bymG
	 FULh6RFA5mkzlUznoi82jgIa3MMNW1wnXhlVeo/MbZKzH8xDRWmbvJbWi+lVn+rgWDhoT
	 E8pirJSMr8dhQ+pmY/eMoPyIFLUFCkcICaqXhiizkKQa3lnyKRdMPo+N6/gK4PWNRP4Xe
	 osHIiJnebnrmfHmkb8VDt8MVU4N4bhPM9H8Hie/ZjT8E+QGgqlx+kR6PAODmCFHeeuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F8FNSykI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BC4606D80F;
	Tue,  3 Nov 2026 14:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F8FNSykI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCB31F000C1;
	Tue,  3 Nov 2026 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717308;
	bh=oZNMg0XOhOF82NdxKw8m3fuJZ/CwTFkJ3vKS6G2BA+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F8FNSykIjsbIYyaW7wlpeo7Jpn0dKaAreMckL+hzdum+Nm9DhHKifm2w4cRC12Zuf
	 FMphUuoK+hWmYUdPHNzO6H8bziy31o7b+pN218q2Hp1gBYtkbTvpEUQ+x2kYJUTGbU
	 amr4aSwQRjTvoLEO8pBwqFwBIAflxH0WBNUru5M44VEqR+WrJF38qQzc5RNwaaY8rK
	 U/bSSq6pCzSaxPBgrjZXz5mOFbKW0lxZLA/85eQV8QSkyLI5I1g237UjWtVW4FOz4i
	 7eRL44CQhswG3W572187LfOOth0Bx8K25XUo4u38O9AE4bdxmCYBIrD7N596LhCSKY
	 60DTPQ7Vz2Maw==
Message-ID: <sashiko-outbox-195502@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 30/38] powerpc/pseries/lparcfg: return h_get_ppp()'s
 status as a long
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-30-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-30-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:26 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> h_get_ppp() returns the status of the H_GET_PPP hcall as an unsigned
> int. update_ppp() hands it on as its ssize_t result, and
> lparcfg_write() turns the hcall statuses it knows into an errno and
> returns anything else as it is. So when H_GET_PPP fails, say with
> H_PARAMETER (-4), the status comes back as 4294967292 and a write to
> /proc/powerpc/lparcfg reports that many bytes written.
>=20
> Return the status as the long it is. lparcfg_write() then treats it
> like the status of H_SET_PPP and an unknown one is at least negative.
> Before commit 11529396ea31 ("powerpc/pseries: Split processor
> entitlement retrieval and gathering to helper routines") a failed
> H_GET_PPP turned into -EIO.
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 11529396ea31 ("powerpc/pseries: Split processor entitlement retrie=
val and gathering to helper routines")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D30

