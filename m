Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717282;
	b=EMC+HLqj5vJpAZgdy+BF7Dls8KPU6KFZEFQKyTtwt2sZ/Ij8y9D5RvljvuTQdZqDXswz
	 FRVS5pEsfdEiLr+ANPMn3hs+KpL8VtSulZPZCLTUzsjyC3+XcmqyypZYqI/b3hHspjz7d
	 9cjhYfdptg/a9nYe1PC4qyM6z0HOdS0Bhgg50PZo6h1JPwAuM6N1t+v+Fl6d6joV/JLUv
	 tp6wRqTCN/asQtSL+bDjwWjCNXQuiKr5NypbDc2OxSQOiksuGR5k1ALvsQbZy3WoXuQQV
	 M1cLVA4HLQp7v8wqFGBwZEsGzwWcPyORAN8z2UMJzML1N18UlzFIOWgGZEuII1MxREQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717282;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Jt8oSnDtjWT9Rc1lRRQoEdIpZQuLDAxwiZiNGREGvEU=;
	b=zSm+BeJbsj72cfSQPDEjkfsPZTjU6bSbp9u0Sj+Fyss38g0ncgAA1E8xEcRuqefMzIjE
	 clJNUBLB1JOgBTEj3RJbB81E3gxVgEhttnyatEAWjEdV6Ra+KpynUybXRCAkn7495shbD
	 /loQFv37AcpCqX/TmvXQ4ZH4D/Pwafgz2PpwKGJpE20GCzVOosDLCGOee8hfDecE3Xgf3
	 tX4FGkRQXOStgkAoEvsSQOH5vqvj4GNE1JE6/Juheqn2ajoDaPozQNeSU9U7W/pJUFZ6w
	 DZ2msib1CzAfmp8kpl/FdadD0Aff6GvM1RtXHVicIjJNosxczh5tK9dO56q2ikue2Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZLM25BCG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB0960A261C;
	Tue,  3 Nov 2026 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZLM25BCG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D27A1F00919;
	Tue,  3 Nov 2026 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717281;
	bh=Jt8oSnDtjWT9Rc1lRRQoEdIpZQuLDAxwiZiNGREGvEU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZLM25BCGsWNuNmJ/K9N1vryFmClM5QGd+w1e7Y/oABSSzjVbQNzdV0AlPqiqT/BZz
	 gVjtej5uWjivTFNRb8niUA/AaCtVvzYTNAGV9gc6Mg8Q73DILuzBagqZP0YjlkS4ok
	 8a5PyM62d8H3SaSHls5JF7e6qN38DCKSnLe90TyyDShwSeDWLcnDwqx5NCFzJREoSZ
	 fYkFOlYBmIxCnw6DQBk3StfjM1WgHAjuKa+F5YHphYcUyb5by0bUB2nqkyvRC6EwmM
	 mLR9qu9/cElVYgf0F7Xq0FERhwAIiwGHNA/5lHothanOlSg0abydegRnPFqWsonMYV
	 SucZjZpZ0qt0Q==
Message-ID: <sashiko-outbox-195489@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 17/38] net: pktgen: reject device names with a '/'
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-17-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-17-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> "add_device" takes a name like eth0@1. Only the part in front of the
> '@' has to name a network device. The rest is free text and all of it
> becomes the name of a file in /proc/net/pktgen, where procfs takes a
> '/' as a directory separator. So "add_device lo@a/b" makes procfs look
> for a directory "lo@a" that doesn't exist and warn about it. Any user
> can do that in a network namespace of its own:
>=20
>   name 'lo@a/b'
>   WARNING: fs/proc/generic.c:174 at __xlate_proc_name+0xb1/0xf0, CPU#3: b=
ash/241
>   Call Trace:
>    __proc_create+0xd0/0x9b0
>    proc_create_reg+0x45/0xf0
>    proc_create_data+0x77/0xf0
>    pktgen_thread_write+0xd8d/0x1750
>=20
> With panic_on_warn that takes the machine down. And if "lo@a" exists
> because somebody added a device of that name, procfs used to register
> the new entry below that regular file, and removing "lo@a" freed both.
>=20
> Reject names with a '/'.
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: e6fce5b916cd ("pktgen: multiqueue etc.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D17

