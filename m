Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906992;
	b=R/EOKgtAieTYuGwcTN/efWBtD00mCkGK8jttUydIR96fTje/SPEpiDWcJrZ2f9zCEfHM
	 6IRfXv3zc+321mpGa0+3S7v9TzyazWhVO5UjiTD5MEre8UsM7KoK4VEQXiahvZRvsFjg0
	 pWixzwzvuwM7QN/M1mhiMlrLh9v7F3SBVuw3lSnxqYkcsJ8MnWDf1fUgHGvG5J5cVeP4Q
	 Ioov9nFl+THZ/s52ahGJO+yn6vBbdey3VHq5vUkMx7I+AfwQkeC1S+uyFFCalgfClzKc7
	 Wf2g67v8Dtz96I9QrPLKsurAdyGzmXA7qCNuii7RL3AKJYVrkSy5n2B+IvLSYBdrEWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906992;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ru/qyz255iW10fX/xYGvqKwjOThmYmiF9XoSZGKM7R0=;
	b=fpXXboGjJ2v2z7KLO/bOq8x9ZvAqtFocWHubUIxNVws2i5xDiiGv3OSkS1mWDpmReH6o
	 qXYJIWRQ01TVz/M0x+QcjH0oD70vdNptslzFSboNuOP1toDi3rubQQEOz3RuZYIq34YQZ
	 5PCphfkWlQasrL7Z1PCZLR9DsI6LXSaNhOLibat/35g8Xdp3KS7uGRYQPW6MDW4Y6oyXD
	 eK/RehW9N4NG5MjJyXSeDwM3MiLbY5Ng8YnFa2MNYu6K/7vylsjEqFGDwA2oD6nFFuDDB
	 HI0XgGBuCVJtb2ct5cfbeUS7BS8Wixd6H0vEx2P/SqHunj3TZ7kXWooEEQig4OlF2BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MJtgcSMf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56716082BCD;
	Thu,  5 Nov 2026 19:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MJtgcSMf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C5C1F00A17;
	Thu,  5 Nov 2026 19:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906991;
	bh=Ru/qyz255iW10fX/xYGvqKwjOThmYmiF9XoSZGKM7R0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MJtgcSMfLpnK3zQ8ve5AytNoGwVGMCdIK3G/+WxnM1JzzDcQ8DAnN5v4DQpZqVkNE
	 JIFRqjboUyRPr1h1Dl1DKUbwP7QphpfK/YvUU9TIXGy/tTS0d+xdV2MLivsLV8Dgu4
	 UzSkOJsM/jDsL0ZM5k9XUlcPM1VkW2J4kRWeL7ktokcrjcRTTBioEI2YpgLZh5eP7W
	 u6bhsGA2WwPT6st0KQcgRf2kcMXrl5bjJKLXx/8iPS2CkkO8y5/gPDeqZL10iGDxGi
	 ryctgUStVMh1y8vZQVQju8TMtjpBqM9jPCUp5nhZiIt7GtigUzscvBis/aL4RTjcOy
	 LOwDNub5ShbCw==
Message-ID: <sashiko-outbox-199894@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 31/51] proc: don't WARN about a name that is
 already registered
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-31-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-31-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:49 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_register() WARNs when the directory already has an entry of the
> same name and fails the registration. Callers that pick their names
> themselves should never get there but some take names from userspace.
> pktgen creates a file for each device a writer of "add_device" adds,
> named after the device. A device can have any name, including "pgctrl"
> or "kpktgend_0", the names of pktgen's own files:
>=20
>   ip link set lo name pgctrl
>   ip link set pgctrl up
>   echo "add_device pgctrl" > /proc/net/pktgen/kpktgend_0
>=20
>   proc_dir_entry 'pktgen/pgctrl' already registered
>   WARNING: fs/proc/generic.c:404 at proc_register+0x555/0x8b0, CPU#0: bas=
h/241
>   Call Trace:
>    proc_create_data+0x9f/0xf0
> [ ... ]
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 6c2f91e077f1 ("proc: use WARN() rather than printk+backtrace")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D31

