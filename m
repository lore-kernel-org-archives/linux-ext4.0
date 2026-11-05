Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906986;
	b=NkJ+6H1/7/RUAg/6MPu790HdpNT6RRdqeleoGtr+qBhqkD8QG+26OCYbxdiOEuybgMeu
	 Ghg0o9d0nkvmRT2MWaBXC5zvwi+8lg+ZurkR3MHBtT2EIPvZTSC4WPJFBZiUErDhvJr8G
	 gcN52wmKT7JpzxJpktCp9P2YS0W3As8xft+7Ca5RZ+4sYO7ebzv/qGQh/kFnHqsr0culW
	 808pnFg5I1vF62Kyn/5CPIIKFsn980sxTj4bxo36wB1+BqDxOkBLkUSSu32epZOxM7Geb
	 RmfogO7rVccXYT5Nb+CJgMTkNe/TqaUWJKknrtcwbWmw/rj0M+93hCF2dzMnZNTGn9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906986;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qZX6TqimGj0FPnu/ads2TGWZcJdWF3Hg9sf4zFcOy0g=;
	b=EXNabSDuRS9KyCleSdCztvnRaLzhmLfjFBmmlKkyY0D/UuorngghkqvBCh2WQnNTIcwp
	 kZ+PhwwQYv5UwKroM4SH8T0jGTQq7ORFVk1vlguzt1qjxOw061wkb/HlleN9TjZuOkZBc
	 RXFYeStCftzDQO0VI3E/Qg14u3q31NWaBICUP4HMWWXO/rDpu7jeHyLeWt2NrWbr2MuFt
	 4SFGiPdJhM042G8vf+P0Ld9/uT8oMZ7EFvOxAQhWJ7u89XydkU5jqndws1HADuRH7YLRg
	 be04gdz6m4y6zTGVroFflKSsWU0RXzXWmDPBeDhoI+lrhFjCD1tF9aFNe6HL8wR8w/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZVanxKXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A565B606D806;
	Thu,  5 Nov 2026 19:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZVanxKXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0D01F00919;
	Thu,  5 Nov 2026 19:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906985;
	bh=qZX6TqimGj0FPnu/ads2TGWZcJdWF3Hg9sf4zFcOy0g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZVanxKXYs5ktHoZYv4D/uQQVfoZK40PC7mYX3MUUXNsjdgxlVN2mUV1CZyN0px3sS
	 anXxwuSYs+8OfnMy1a61hJGPZSr8HsyYjUlLU0R+HHnCLVFbUeJZ4hqEvcD9OSxhNm
	 b4yUcMf4KwRiwGKBG+O0J1WrPYTgdG7asoElB+ql62bi3qmtvieZQyAcNv0MXUEfLh
	 DNPU06edIHuWUKftt7sZUQ/o1KlFN2EELj5lVnxD3jwTWFSvVtMFCs/jL4yOLC2wT0
	 hwh0T0s0JGhXVBidtrd5QVgPIgEG9Rt/BldgHb+FXPeJchUpFRsxIMco2Y7J0eyQf+
	 Pc1dVZ24TuZ+w==
Message-ID: <sashiko-outbox-199891@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 28/51] ntfs3: don't warn when a huge label is
 written
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-28-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-28-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ntfs3_label_write() allocates as many bytes as are written with plain
> kmalloc(). A write that is larger than what kmalloc() can hand out then
> trips the page allocator's warning, which panics a panic_on_warn kernel.
> Use memdup_user(), which fails such an allocation quietly with -ENOMEM
> like before.
>=20
> Fixes: 7832e123490a ("fs/ntfs3: Add support /proc/fs/ntfs3/<dev>/volinfo =
and /proc/fs/ntfs3/<dev>/label")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D28

