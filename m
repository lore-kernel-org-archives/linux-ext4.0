Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907020;
	b=3H9OkWWhK4p9tp4VpM0FIVbuq5z1MR2GROuAiDGSNRZpRYGiGpdDX6HuS2KWBubs23lg
	 og89IalqkehlDC23Oll8IE/nt8M1+TDQBrxWbgPJqKsvE4/82mHgnKdG9427gMfS4u+mM
	 xGOOkgOsiJ6cUmYgQ34ynILQ8VL0LEuYeixhArRECpzUNpdMQldCtrRUsQO/70FJKL6ZD
	 c3FvtSlzG7+gjSwtrucmQam2h6OEkt9pKM/pEz34wP+De+Kkq2HZUr3CDm1FaRWGUMtAR
	 aDy/0c5iBn1U3Q8SD0GRKt073KyMNMXZu4IQTd7KCZDG1+wF+mqREOAIT0EraWvvMHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907020;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=y9V1CIpIY4360pJxVlHm+5yZoVNA43rbHggh2CYfgcQ=;
	b=ggSStX3K3IMgM9SvO9DgJ8+przSCwikNA5+IcRkgWtUAId4tF/XsCXB0M345fLnescnb
	 YH3SrEtKBrPyix6PxJXz0DCBun/XbQ+ScMD4zW07DxusNA+Qi9YvEuE0MrF9Cldt0sYJ5
	 tXURrrV1/KwZL+QwJCLBAB4Ya7CESNhVlroMAyj9z+GKWwttS/Gy60u1tU66g+8taLXDQ
	 5oxkezkIsMXeyj30WTr5arURmlIf4ftNLtIm9lYVleE8NJ0OZ1SEDaZwrHOyOcuo75vpa
	 NT/Dk3w4y6VuBzA31wmrp5Yw63K3DoErIp3ttPAbWOQJS4n6QBg5XsyLmXus5pCccBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U6caPqpR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95457606B050;
	Thu,  5 Nov 2026 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U6caPqpR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0FC1F00A16;
	Thu,  5 Nov 2026 19:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907020;
	bh=y9V1CIpIY4360pJxVlHm+5yZoVNA43rbHggh2CYfgcQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U6caPqpRAcq7s3jABurFLTYAOyQNLF7KNwFcz7vL0owaKAFz2/Kmb1CSUDdsXURja
	 KndJt79cCtvWCvNOTwi2inAusJtSM7xFcxVXh2P+h26yFHpcllhdCgktUZVCkwtiG9
	 /H3yjzLcrbjdiUSj7RiWzxjqFY9BFACxF6rXGygYvdaL3HgamlM8WqSmnW73wwg/9a
	 HWJvJwieWwnyodMNwSKhOSyeyO8OGNd1qplxfETbINtVIeYgtd4CJo1Ro5mX0HKNqx
	 xq+lWhJhP5SWQhNMI4K00P+V9JGUm/enmo6/5lUN5kqo3zAD4JBvrPHNPgj7bQqo45
	 NaifRmjsniAKg==
Message-ID: <sashiko-outbox-199907@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 44/51] proc: sysctl: resume readdir after the
 last name it returned
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-44-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-44-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_sys_readdir() counts the entries of a directory and resumes a
> listing at the number getdents64() stopped at. The entries are sorted
> by name, so one that is registered or unregistered in between shifts
> everything behind it by one. Listing /proc/sys/net/ipv4/conf with a
> buffer that holds ".", ".." and "all" and registering a device whose
> name sorts before "all" makes the next call return "all" a second time.
> Unregistering one that sorted before the position makes it skip an
> entry instead. So a listing that takes more than one call shows a name
> twice, or not at all. Even the 64k buffer of ls needs a second call to
> find the end of the directory, so a device that comes up right then
> repeats the last entry.
>=20
> So remember the name of the last entry a call emitted in the file and
> resume at the first usable entry after it, like kernfs resumes after
> the node it stopped at. The entry itself can't be pinned across calls,
> unregistering waits for that. If the position was moved by a seek in
> between the listing counts from the start like before, seeking to an
> arbitrary position has never been better than that.
>=20
> That also takes one walk down the tree to resume instead of a walk over
> every entry in front of the position with a round trip through
> sysctl_lock for each of them.
>=20
> Fixes: 77b14db502cb ("[PATCH] sysctl: reimplement the sysctl proc support=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D44

