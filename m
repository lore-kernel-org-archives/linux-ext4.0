Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774463;
	b=MLUS6pcjWClusbAhsb1dfaAuAamDW4rNun7sy0zBqj/DwLmBx1MU7va0gEWIZIMoP88I
	 avsc6Usza7CdTN/5FYbNDUxav9dbdpBy+ScjW587AxVPxJlRcBqJs2guM180bFVOK7czH
	 mIKwU6eAP7/Yb6DEBsQsSYibebs4/6iAWFhuf/aPbAJIey+74M2+ItkELYJBBcRzUbx8L
	 lySKjDxJYtDSs39lw0DvvQmtGNS003txNu0Q0GEZ3h6RjAwW6ybxz9DL7SF1il/2Nbvm/
	 6S5e0O1s0P1Ubbf0R9GrRQ6GHfZHtJMG957tdPrmMoVeofNxovpMdKGCKxrhzvTVjWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774463;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CqmNnYbQuK3RuZsUDrlxmXbG+DK4SNo7yjgc+IpbeXI=;
	b=je/Dxy/1YwKIhQvtNdbndwIFOeI/+4hr+Kc5NdL/YEnxPG+rfwsKUsOhInEdz5GuQ4L5
	 jv1lSNN562BIvjbXyo/Mpzw/uBLcTQ7W1S7DJXMcFUA2GGCZzfdaygkCBoKJC4rxCA6F5
	 7j9CY4kSDJOWqCb6/lHKKbDQFzbpFaYXCY3anbuC35QcMpV1ULG09LZQUB92guGJMHGn2
	 frU/CW/4EW6uXTHbbGIE20aPj4PGMKBvrvfhg/u+jF9Wm8tvrA7E/wiEy40JoVIcUM351
	 91eR5aVdtkDsYzQhb5spQbgHTmUmDsY2hBBNqJM98JzfSwJMhppHahjFDTZA/2uPHTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="TNVf/0eg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDB2606A889;
	Sun, 15 Nov 2026 20:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TNVf/0eg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C27D1F000C9;
	Sun, 15 Nov 2026 20:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774463;
	bh=CqmNnYbQuK3RuZsUDrlxmXbG+DK4SNo7yjgc+IpbeXI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TNVf/0egvQUNmznhOtjCS2c0JF9mcA/aq30vZLvhIjjQiIZfmgw5aVIdF7Iq/AXmV
	 VwLw9N2hv1Y+ydH7X6jZrwkIiRrq62PLBBFKiMjeWIIuq7j1DvrJo35Zj6WWNvjMa2
	 ATn+tMpb/GcJFaDJZjQaHku6W3cRhisrGEoVO6gLHdzYWYk+PFqzvfvh2mHOuBpDbb
	 S63Z+SrQgN+4xtbIyvQj4NkPFFXvlyV6eUqlChlWdsqlFhrSWzjQCi3KprVWC77JSR
	 e3bggTH7dyB4TDbrr3z7fpnZilVJbdK8zxu5Q9gIgL5HJYtLm2tlPs/vLxOBEUZ3we
	 7+zJZsJ5bwSdg==
Message-ID: <sashiko-outbox-215803@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/12] docs: ioctl-number: update block entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261114202653.3113381-4-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-4-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:42 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where block ioctls are defined.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D3

