Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907320;
	b=QZf+EQTbnFZvpmWrHUOWORJ3hfCPltlfPOwe56mvqAjiuvdvEzNw87CQkVZhgMPi4W3g
	 h2H64Dodre254F9syCljq/ND04y6wYHemQLjj6iJ6M2FyEfpEUyXToandSK+pURsRQo93
	 f32aan+upuptzhRnDa9urB7rxX1BOiuUHwGasih0Ko164lYboMtHRqRo4uWNpR+sW28JC
	 anSO2/FG2V9Twk/HreMwg+jHTia2KfxMSe53yKNhhF4SUw8IUFJZQxY25GFsUbb0eKC4q
	 o5myNd9hfv+rNF9pZuPL7LxDqQ+0xzAFG7E5Vv+3uTt89IrVlAZqKzA2rRsHsW/GHsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907320;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6kdeb8slgi5Epc3AUJlZlnTJq9uw2LtJTfzJG8aoTok=;
	b=0EeyEXq5cV3hliMrvmMKhNCJByJRG6mCKWkJrFWOh1GElNXPiU5dW2XuBeDl58W537rd
	 +OhPD0WRcmqtzbmTY2Dv32cdTd4lzAGrd93aWhIzw1R99GWL5r2fob7BZ42yszzPaGkMx
	 3e390o0zJEWyCsFThMenYwp1ovcOjVRoarWmSmVksC/Sy4OLZpSqj/+xkZlecrdTziAv4
	 t2el3xjYBFP572Qs9CTgeEYmrINOol6sMupLV5nCo1M/iXAcZ8hRvhD+WqmzP22jeBq+U
	 6qlIhQCUQZZp8kIwJeJ2v2P8kbuov4s5pINVgJsWMWRE9UVcWBoZIaQmsqMzcnILkEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nB2XodGr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC2260772A5;
	Thu,  5 Nov 2026 19:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nB2XodGr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879B61F0089E;
	Thu,  5 Nov 2026 19:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907320;
	bh=6kdeb8slgi5Epc3AUJlZlnTJq9uw2LtJTfzJG8aoTok=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nB2XodGrsltbbE61/MY+yy8aN79qXnaMrW8LLWpZP+0dzW4JXJ0pwkuPXIFbqI8o+
	 aUuDiq/2IV6LrgueMm0fcGlLznRR27RNE+StoOyZgUUBrn113C9xbA5rh81VwXMVPK
	 VUjsVxMGM3JYpmYf1PTEDk/e5Uf7TRieH5oanj3YbSEWS4MEoLAes6OJHouq9acGzE
	 TUHH7dJOYKuCMwdG4wrNuNFJ7FHrzzaOQAVegH3vF65CM3UFN2gW35V1Z8zXxDuW+B
	 Eq7SEBOj2oNuM5B+HjWikWursJuaXfKRpHoFMZ/wvqpsIgG8z33e9DQBOwbZIzS+yU
	 fbyKBvVlkA2pA==
Message-ID: <sashiko-outbox-199933@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 03/23] proc: share the readdir cursor with
 sysctl
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
In-Reply-To: <20261104-work-procfs-core-v2-3-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-3-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:17 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_readdir_de() and proc_sys_readdir() both resume a listing after
> the last entry it emitted and each remembers that entry in the open
> file with a cursor of its own: the same struct, the same way of
> setting it, the same release. Keep one in generic.c and let sysctl
> use it.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D3

