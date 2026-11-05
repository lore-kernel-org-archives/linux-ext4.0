Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907019;
	b=yAWvNrpKyF1N5e1MlQhv+DlbJygdiFQZ5JOUKGgDQjgw64RyXBPkWB2n96K6RAvP7D7X
	 xplyjeV32wJhAwKiBWyB5KuuSwAfrv7bV6MQA+Y/6JcZUMbmXTzcFLw9MB9PAC7vWZ8fF
	 j2UwBdJOn7Bj4VoNsNFlZHm9W8T8DKiqfbrWCn/BFUglel2uqVxcVbHbsK7S20qZc8SYr
	 +2GkmKB3YgarhO70DxpAnHco7X02nELi059wRHwa39yq/oz9/3XrZvNCxjGKk+xwF/vJ7
	 0FyyC/mHZ771MRi2i8US4lsInckQHB5I7aUYp9hJU17ZRuo0F0YkKJdbzF8GqFBOqAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907019;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gWl/eS0i+nr4XdDXA5M0CJZ7C2TAuMbpXQ8ABOJIUDE=;
	b=FTQaKaHKGIRBAcB6AYFO+RP66cnNBz08njBBXmmHMiOMNGxms8bnstaMdhyd3NfNCg2M
	 je94lI+rUxcwxGpd6m438iuFqaL3NunIZ1Ek3a64BMIf2se0QLnCWzsS3g2o/UtU4hdoQ
	 TDvhYwCVjU6FmbcAfPnk+5b34JyQU57cb090Qb5eDGak4MBDQld3LSvx1Wny2XgTxNM6A
	 MWMkaNi3mUNpWimGg7LeUBkw+nZTrJNC5oMFN4+KgNSmsut8P56sJrauYHdyJWNDuEhsw
	 j/t9/nEFP1/WBaa7nSh28qmJEVpel+S0K6ai/LHCTiP8unoCGBEY0/aSfo51Rsh9e/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cu7eu+12;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC56560A6F6F;
	Thu,  5 Nov 2026 19:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cu7eu+12
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F881F00A15;
	Thu,  5 Nov 2026 19:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907018;
	bh=gWl/eS0i+nr4XdDXA5M0CJZ7C2TAuMbpXQ8ABOJIUDE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cu7eu+12hzXn2rBgNm5FgURzXiyF+JzZ/HlWMrHH+wloSAfrTnDuHK/4nzsGd3RJF
	 OfhkDN1FJWE2zeT0nBEOto7RrFn2Vo3CHtOHlbAtLSlIHJW3WS/ka4jpgMEdobZqj6
	 TRVRHQSZHdfrZbstLAqLE1AsQHNIhFWYraM8mxuSmv08QDshuTBKJUnVNTRRPaE9Sl
	 ZtoZMpZjJHhqEVktCV8sijDQ1MfTVKPqVWHtRNTPrsxUHp4+DE5ncU3V3cirf4h2hR
	 uG1ycvfacpeK0T3AqbcZk1NO96i54BYiLNW3IoQg4Lup6PGIZvO2ao2d0AtDNhGZpI
	 J4HUeGgLf3t9w==
Message-ID: <sashiko-outbox-199906@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 43/51] powerpc/pseries/lparcfg: return
 h_get_ppp()'s status as a long
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-43-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-43-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:16 +0000
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
> like the status of H_SET_PPP: an unknown error status is at least
> negative, and one of the positive long-busy statuses comes back as a
> byte count, as it does for H_SET_PPP already. Before commit
> 11529396ea31 ("powerpc/pseries: Split processor entitlement retrieval
> and gathering to helper routines") a failed H_GET_PPP turned into -EIO.
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 11529396ea31 ("powerpc/pseries: Split processor entitlement retrie=
val and gathering to helper routines")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D43

