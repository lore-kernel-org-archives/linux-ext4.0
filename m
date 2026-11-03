Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717297;
	b=4gZIKSufSLCP/grrGCycVmkFmT8GiubO+oxZD8UkZHe2XcglKJnyWdIgmbGllcSiDQY2
	 WlidhFWKAixtp0RSsCDYXWwMFZZYUGIQJchICKaZxe9et3ILogKdcQR2zWqsajJEUhzQQ
	 zXy7Cs8w48gWDZZrl7/+Ug9NyH0VMiMhTpGYer0ijRiqHlTlqWKV0v1JIC7vY9kXtmC2Y
	 ZFkgCxbe8m8M2S+uEV9VYd1697G2vLiV8/UjYCoLUlOFTXwKAcXgL6WivYLm8CaBVEBYk
	 RiczSN0flK4ezAJLYaNcRInSVzyOD61UGzaNTvZQw/ZjuRpWI0K7PFZqO3NcvTGqENA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717297;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=a8MklUW6PYR4NuTZFeyOULTC26VMv8Yp0HFaBobp5k0=;
	b=PYddg+ItX8mwghsuJGx5mFhr/cqDyImickYsJsMTa1xVx+agJ7D/olhfiLS15v+z5biO
	 NgyUM+1rhHM5bIHcnQP8KS1zEIbGsTrboifir0prIphGBuM8NwBxeS70GROjWnUE9821q
	 9BBSSCXYrIIashaBE48dxUvk5iLUmkG0q80VVsZH6xD9sm0Q4P8ehDrSDW71xsj9FyTZ5
	 EkIBNJg1CGBtUnP8DBMLoD8SpDH6cxttCbLeUI7m/GKQlmj+YE+VKNrs488C4wAo9JoSt
	 PQfXFEczOIPGR49x479a15grP8eoMZhaUObt97pg4CxPGFUFM1Gy2VtPwy6QyqiklXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CTW1oFOr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F3060A6F79;
	Tue,  3 Nov 2026 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CTW1oFOr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9DB1F00A1A;
	Tue,  3 Nov 2026 14:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717296;
	bh=a8MklUW6PYR4NuTZFeyOULTC26VMv8Yp0HFaBobp5k0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CTW1oFOrdzEOUPkrvvNahWHPbA0e0ufZdo6mO+cLvubWXkN1/MNhM4qfQsKcdl+Fo
	 1UwmK1ZZSf+5SRMSnemcp5A+D5jWw7205V0qOh4ixmwKW9lcVMSnynlE0ubQ/VVFJi
	 vxRny/8V9iZJ9ExkJe1Zb64JqIdngs34CEmUjkTlNHUYcB/2rTERNlv8IvRSCVxWkj
	 9ebpHdvYgFfFf7wQNgBo1bSmsBp+lLeElE2oJht2XJ26gE3MAd6LgY8lm3TBjwNy4G
	 RseVsiRDCBb06aK2dHOLefpoLHMiBjl5dg1pKc3epjazs3c6zyNP5qcXlhjNXaq4bA
	 92C480cHTH15w==
Message-ID: <sashiko-outbox-195496@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 24/38] proc/vmcore: don't let vmcore_cleanup() run
 twice at once
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-24-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-24-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> vmcore_cleanup() has a single caller, fadump's release_mem_store() on
> powerpc. That checks fw_dump.dump_active without a lock and calls
> vmcore_cleanup() without one, and kernfs only serializes the writers of
> one open file. So two tasks that write to
> /sys/kernel/fadump/release_mem through different files run
> vmcore_cleanup() at the same time.
>=20
> The first one removes /proc/vmcore and waits for its readers in
> proc_remove(). The second one finds the entry already unlinked, returns
> from proc_remove() right away and frees vmcore_list, the ELF headers
> and the device dumps while those readers still walk them. Or both of
> them free the same lists at once.
>=20
> Serialize vmcore_cleanup() with a mutex of its own. It can't be
> vmcore_mutex, removing /proc/vmcore calls release_vmcore() which takes
> it. The second caller then finds nothing left to free.
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: b500afff11f6 ("fadump: Invalidate registration and release reserve=
d memory for general use.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D24

