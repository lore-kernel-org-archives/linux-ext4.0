Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907341;
	b=sx1wXDEUNtT8TpIBUK88vNzLp9jO3RJjId9VNzBHJfeXBqI/xZfUIKcnnkxQdcgIkpxE
	 nV1WvqT1o3VrAfJuXyuL28bc9Wzjb0pX1fO/0hLhIdt8t87zHNbae9EKpBbvtCd3tDUp/
	 rpTSnolOse2ELeriEK8zN7X6UGEyzlO/5NSsU8s2FZPakYDkf2y1/VOqoZxo/nr9waEW3
	 SSp0R8xdGBFOz52pt6rWY42jhevEePj+7LTh03FE8uaCxqSwL7mW0zaXcpBqFMmifc8cG
	 2kASgpFsJ/v9rm7rauH8u5h0xilRbsLaEOQKOJqunI87Q+U3Q9fFWCO1zfP6Su+4ybA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907341;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cJix24xlgst9n1WrSlWeglZeAB5lHupKhKyXWNZp4cA=;
	b=S+cSJ/HcN4rjOxm9oh5SSYsjqi7Owi/k6So8WQ62REnTyAiPMOEjEIsyt0ATIKM7F5pp
	 ruh7omCzz3EkIKmd/v845S4gvnO0+B+hobBl/fMOeh3aRgTj8jd5Dd+5Zq5n1X04rV5Dn
	 LfMlsClbhydk/4VlQCKmPnFigunFmxzl28lnwkqSK66gwYvcdX4s0oAde0a6j7d1UCFzQ
	 RpRP+OFumRvKH7vF4bFb9OY2Lzji8Qu+GD1Qsuqu1wzubg90eotuaTWapLl+rQitOBofo
	 olV0btHeI/A7mVqE56/2iGtayjvKJdg+lqdgu9NBUkpA8TcIxGREqSgc/OZjB6CK45A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L+xOHoP2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877DB606F967;
	Thu,  5 Nov 2026 19:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L+xOHoP2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9761F008A1;
	Thu,  5 Nov 2026 19:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907341;
	bh=cJix24xlgst9n1WrSlWeglZeAB5lHupKhKyXWNZp4cA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L+xOHoP2Qx5/9+jDvNfdYODhXjxiK8RqXCJAGAloJ6qzD7Elus2F01gxdiUGPSQLg
	 3hE59XNDGx3Za7IV7IDFhB9LofEWxPBNwNN/k2HxtiMoqi+Vht+upRCGoGgUOFkH3t
	 K7IF2X+TmYn4ZurNmoxh4WyCS1bWuRxOE2FTEP388C89fXUcunpJ8ImJUn3klOcRfi
	 1QcyMSKwSstZGjhnH3nI7Wpv2CbW+x291Woe+gaojDGoMmhzCTYy/uDNTr87TxD1Wq
	 B6dVO0t+pEqWn986xFrR6AlFJZfPthvQSSC5s4G8lgOL5oeFUjLAQkfCfoj1cM0Jd4
	 LCM5TqqMHZEYg==
Message-ID: <sashiko-outbox-199943@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 13/23] proc: let procfs own the seq_file of
 /proc/stat
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
In-Reply-To: <20261104-work-procfs-core-v2-13-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-13-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:39 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the show function and let procfs open and free the seq_file.
> ->proc_open() only preallocates the buffer now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D13

