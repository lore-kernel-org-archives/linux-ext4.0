Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908676;
	b=J7usuNP53s/EQj2YvXf5SZQctvkA2yzchIO+EaAnCNInLVXXzkVU0GpRmLULSb67yvtM
	 vag/kbFLhRp8loI/yBuit5xSgKP5dsse5R5etjXtsrV8iYOLE2butFxTHoPzlVDP8ImXH
	 +uCiadgqB90He27MN2QalU0QVylLSJ0h5naWbIoR6QqNt6FKspw3KqyedRWCkYkPS6rIP
	 1/8kY+S4u5qfWFaZf2mMorPtz/yuK0sj6+uiHp36eURgP57T9Sp3tEmzkEq2uhlUb/oBg
	 5DSiZ/9oD+c8Obv5cIGrEHGhsVFYYCt9Mgn8dkhalPvRKKDHycezE99eHTJ8nB5fp+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908676;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0Y90+62nmTyWN8rDu95xmVr4WrW08UQZKP5u1iiw3Yc=;
	b=kvUch/f+DCZUG4kVmuNEVnnyJ+AdVuzINVudYZh763a5OTGJ9Alu0LDA55tqMrCLrtc5
	 epsnMDnHatgegAgl/fvBvIhTvw8ENstj24nMgmvBAvE4a4qHfoO2KxQu9zQHFsDgWxQLW
	 YTn9NsZxsk7xLQtMiVu9ByZtmZHsH4w13VfkoAWzaEcspC+W/rHKVEnggxoY50mnkcObq
	 odU10cd6j8KL4otMaXWiY9RBnVwXD9yjbGoq0CqMhNKDyaFYsjwzOW3H+Rs8v27S8KI++
	 w3Y/LspP/q9nwbXWT1pxy7+oGjgoVnqAtSwfES/nd7B7Ky6gGWGBV8NCntF1P+M7UCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KynCzb93;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26437606B9EB;
	Thu,  5 Nov 2026 19:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KynCzb93
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653031F008A2;
	Thu,  5 Nov 2026 19:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908675;
	bh=0Y90+62nmTyWN8rDu95xmVr4WrW08UQZKP5u1iiw3Yc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KynCzb93jkCBa5XgAWl3yl9M0MTpo3fxH9GGhodXmsFvHVjoHrH7fC+ss62AYBxh3
	 I2L0c2a5NWJkrTtaMLAFCb0YpREbRTcfJDOpJGBwIDXewFn9Z8ZiqtEhC4P6mcbj6m
	 SFTFzfvvToOSL3d4M0WtVj0ToBnc19Pvn5LF4z5IE5o4EMjoAHnxFEXg5Kkx0Ds3Os
	 12N+atsPV+EcqCPQBvgkEGTq6zB8hfUcnsT60L+cAHou3s3B6ZpTb9Oexwi673zZ6g
	 PA+M8lzFtMydtOAITauMFceBvtdRNHvZWcaRerMdas+D0BM3yOmBnUicVq3olC4LSn
	 dmNJYcXoE/eyg==
Message-ID: <sashiko-outbox-200047@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 13/30] locking/lockdep: let procfs copy in
 writes to /proc/lock_stat
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
In-Reply-To: <20261104-work-procfs-fs-v2-13-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-13-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:54 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and look at the first character of that copy. Writes
> larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D13

