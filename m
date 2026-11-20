Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152978;
	b=iYMgrQFA2yaEyas1U2xPC4Kktn5IdMFSx2CHV3F/+2XKl7fzh7rzyTHmQeOJneLigU+U
	 LqxGRmOgkmx5VQrmxmXIBPegdgqRltkSC/8Uh2Fh8o784pg2SR+fwTTRJOBDLgN9EhgHC
	 M1fDWxh1QT4QDUQ5jnWf+jNjpGkxQXfBzBSNUO7/CmLvXQ35v05iTXHjxYnZC7Jr8Vd76
	 VarfD7rPCP5yUmHfLEIEUHkL7gKbPeKayRf90RrKSDjV0lHIcxYBXokaMAvKoLAZWY7yH
	 QdD5ixVvns31I4sUBZIwjFgfrd9UsFHMMunDjsPylANJ1GSDcAafTXDEjLZg1sH8Ncg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152978;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dz8T+rUqeBS2Ga1dV2B5qjgFbihbRCYbe2dvat+a/Rk=;
	b=go6d1gXbAji9z3L3jbi9xSFpXYSM9bH+4FU2bgkbQ3Y3vT2w9yAUQ9wXcK3NFIln+41W
	 jCuLJcIFEpnbJWunDSDWIl5AV76rSd3wNs9nbS1uwjEZ7JFpbOqd324Q8QFUEqxRLDP3C
	 xCqaJE1c2mMiCkYkz8JVHdVBWZ8vPdA/OwSCey4ThsbeYqmpVsuibthaW+kW7CLtvFPph
	 B/A1pDRvkSaNbaT7xjo08Qtjdk8dwp0a3PYhZUzyWpcEQKHMkaqIpId8YWpnE0FHoTfpF
	 Ms/wDMK1XGGggwEhOICabEpwNiUk1P3iYNXny4fNxdhOi713oROwArAvD/hHnLTdyBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="LKi9P3/A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED5B60A2607;
	Fri, 20 Nov 2026 05:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LKi9P3/A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2A21F000CA;
	Fri, 20 Nov 2026 05:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152977;
	bh=dz8T+rUqeBS2Ga1dV2B5qjgFbihbRCYbe2dvat+a/Rk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LKi9P3/AeafWe4oFukjzfbxaPCw5hGHlYFqFEIwmZfPvFH0ln5UBJAA3wY6ew1ZyO
	 dMfXp1S4qItzRJE9S/0mu0h7Gn0GvKTGCxItPapDPyGvOCK1lyNrVVZLUa3bjnBtzl
	 O5Ok1HxLSRwLIn3U7i4LnJdPI1GSRPKrvEc1s/GkuEdS6BzAX4H8Lukz7sPsKZBB6v
	 74YS6ircHHNhpWmH2sHm8WzRwLSszM0rfK8LITbAKKGUsazJS/Ky138TnMmJSQl4PI
	 505ow9GcKOU2hcfyiXR6gR5tCdBCSinbNGrhiTHzkzNM5/EKa/SifgDmDZKHwLO9pW
	 PIbqFXl1SWsRA==
Message-ID: <sashiko-outbox-224501@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/12] docs: ioctl-number: update virtualization
 entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-10-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-10-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where virtualization ioctls are defined.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D9

