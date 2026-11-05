Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908150;
	b=KsYbJI/yZh7z188k1+PDylwsBsxqo9Xp+Itwkk0vR4i+k/MD2zTuFFgkYi0KNjPELqDs
	 4f74sE2RwUuL5KNCoXKDz+2/crgRLTORhy7qcEF781n/J1l0PUYUDaxLEf6pNZ5JCmEms
	 7Y00KxfIJ+LQDiRg5ipBAzQJ6Dvz5yPuuETEVoNOaGWuT7IfTtSBM2ZFTJVaWWrnTrQPJ
	 mUl8J3V2k+hiN/hjqJA3fvhdtEswDsNu/8ReoK2WEHYYVB9cwtBzGH1ooIC40qSUP4fby
	 y5ra9EKdT3T8HyKEYGY6QL3StbL72NDlFvAURZI3E/+ILNKYi4t8zriYX6vLVC+XnNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908150;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=j576KRHcZP9yIpKTo/UJghDk0+rXi8RvjS6Qhj4O5uA=;
	b=fI5Sje94smOs2RfyG/kq6TJY8hw4TswIsj35/aEjbvLv3PaxHsGUuCVztlk1KEoQq+bY
	 FRC9fBiiB8nWQcCwY7+bDQ6LfTipKHzWJ4/xIOx8/6Hpz9y5efD46nzEa6aTWk1IGAbJh
	 xrIPakbYNy1L0SFQBIogMA5rAuiLz1iiGFCPv/hQh9hAzkAToIghbjCJJGNYcaBrLILN/
	 m15Qv/ghKomUl1/zI64tmpUip43TIOg6BSO0+Fm3D3S716uFgyHoXuOG/uOIVvN4ARiXq
	 yFkwYIS8814xM0xQtLZOiJXvaEqttb63IGupduEYWjkn/eAyjt2TDXX3Sci0AwYVu0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MW+F2Ga8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEF1606E407;
	Thu,  5 Nov 2026 19:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MW+F2Ga8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2571F0089F;
	Thu,  5 Nov 2026 19:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908150;
	bh=j576KRHcZP9yIpKTo/UJghDk0+rXi8RvjS6Qhj4O5uA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MW+F2Ga81KEAj1TlwAXZ72uDvQycuqtR1M88dTEq7ZM8hTowZMbGHRtOLi73+/5V9
	 HKeBdRHxyE39PQVrF7RgQb4XLKCf7nj1LbHH8y826+nvLGF46X8C9sqIk9B0xXEDZ+
	 KPshaYv5tvVnNDId73WCrSUIzluua/PnssViJXznvL7a0q5uUw1yO43+IR0MD0EjHo
	 GG+GTrDDIuCbZjKWBUtdpmGvFrKbhDioUGi0S8ughk/HKFMqWK19qP7/7yr47zF8B/
	 wnFgrxAsWqOviOiZSWMXDxwvRpOths20CszfABGqDZs1JYmn230CEaxTxFFude2YOt
	 SAT6pwqtZXtzg==
Message-ID: <sashiko-outbox-199988@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 02/26] zorro: let procfs copy out reads
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
In-Reply-To: <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:06 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_read_buf() so procfs copies what is read from
> /proc/bus/zorro/<slot> to userspace after it unpinned the entry.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D2

