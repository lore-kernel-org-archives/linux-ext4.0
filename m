Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718071;
	b=ajIPbWhgeoEwvnw1/unHV4ZrYbkHlBxlGjrRRrrjp7IBCzy46kPzm/b1nw+JfnPRdXPj
	 fM16bAjtjpN5aE9ZZg2Jd2HZ+q26f1il3vR8VkJ5S8jJf/orBVWIHUNiZAod5505madyb
	 93nLABTIVzcFVBC3yStbcSCtZ9t4kc8g8K5og/BqWL7rAIKsebINDJxsa36ORTQpI1TXw
	 dxBJWElH4ATbAmlJC5x6igZcy00Zgxb2rdSHKFfLaaT+t2JORPTHVeurkYfIi7/+w+oMa
	 rEnICcCDNzm6MmuoawziIQuP5DVC0PdGJ3cMxcguPlssTeWOp+b4wcdECIOXVnoClWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718071;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=paGK4Vm3mtE5b0c2DhkRMvpNzDa4nvSsw4DnEf+BgQc=;
	b=KzFjSDMnQPMFAzEHOcMPfNRnX9MU+Dq5Ktfrl0rrJ4SEc7DMtJznK9vYRvWgB44rLv46
	 TF9XoE7TIR31m5c6eu5rcN+R164DshLs1ctaXRqRi1JsehK7sgPv00BfUPBIbuPvUM0Lm
	 2/xza896AGIcNqax9OXlazr9ELOi0MD15hLcd4D+cny9VgUURpRcV3DZvdnkR5CGAoXYY
	 eMxiWevA2CUu1rCyux10sYeHoyWRdh/wAlTkyo66JPMeQq5RLt/LNT6kwLuK5TIqB13C5
	 bEBdViiMuUvx+VQI658cj3dsIPSPATu97/X3WRbA7AcW7GxUbFPasgvlDRnD7bACgnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Kz/9BmYM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C2F606EEA4;
	Tue,  3 Nov 2026 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kz/9BmYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C80F1F00919;
	Tue,  3 Nov 2026 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718071;
	bh=paGK4Vm3mtE5b0c2DhkRMvpNzDa4nvSsw4DnEf+BgQc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kz/9BmYM8ipZ0nqa4i1SDv6lAnRGk0DIAMwuEMDu9VajUTqnuibPJ60MM7nVnRyWU
	 0YGeeeZk1WD+5JhFzeeiubPttCRps/6djOG+ittG2lCUSz7LOAZYeKer7ogjO+h2Kf
	 NysxxWG34bBgucluHmCoqrvXiFc86zWo0lyI1OFo9kGGQlfblamt4HbUkUxT4PE6CV
	 LOEA6bDUBX8DU55FH/kj+Kw7Csqqg0NGPAkqtEvSpQ2QlNenqLvrP7m5r9qMAJz+Bp
	 sLUC6fAIW91wbjix1EMEC1iN30+fEqcayJA2ywzzSpskhM1z/zvbwlYUrxSQ32aLe+
	 VKbU2vNEoY5eQ==
Message-ID: <sashiko-outbox-195532@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 05/16] proc: let procfs own the seq_file of
 proc_create_seq() and friends
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
In-Reply-To: <20261102-work-procfs-core-v1-5-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-5-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:09 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_create_seq_private(), proc_create_single_data() and their network
> namespace variants keep the seq_operations or the show function in the
> entry already. Let procfs own the seq_file for all of them. For the
> network namespace variants ->proc_open() and ->proc_release() keep
> taking and dropping the reference to the network namespace.
>=20
> That's most of /proc/net, among them the files of xt_hashlimit and
> /proc/net/dev_snmp6/<dev>. A reader that faults on its buffer no longer
> holds up their removal.
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 786d7e1612f0 ("Fix rmmod/read/write races in /proc entries")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D5

