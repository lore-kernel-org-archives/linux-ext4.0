Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908170;
	b=FVbdIw+OZEyia+ZrfaK6J4nEQUbGo7YLgqbqAEPilFO0tjxjOdm+NkHo+7iPjRMgeRSH
	 g4eo0F8T7ovy96VwSnU8c3wn0Zjz7nudwulJKCg1n/xTiODa1B2ZGNa7ETgndzOt1uAT7
	 AvJUGJlzOZ9HvZen3XbVs0aIjO/KqD9jpyJ3IyMRs2Z11gLeuKPL+KQblcUD2VbT7av/u
	 DdBZvU2siC7rNfHxWdhk3uSTF1WF5247kXWPcG+oyKeoSouQ5sY2JIsDxxxGQhCAY1dns
	 bi0AEMysF9HAkVr6UPtelf2xSOJlqxYddwPNAtomwBihq+bNPZ5BtSvGYNc53SUEbDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908170;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8iqvj1j0PH0IF6Pq8SLYp4U0CTa0deUsshKxdgFjrSU=;
	b=NPwTNo4COIjjNjw9PGZ34ugFzlrm0VRLCdnoOQAtQ0VmftyWWrltNa9tFgoO/JkHn2Zf
	 7hAs/U9vxXwsOfmq5iYpPb+xOyyUn+RScXDtZM15FsdAuwGt0gXVkq+rcZ/y1GOONlV3R
	 gHHoOhu/z3EmnDmiXp1C+tLUprV8Yj8WWcPg4rHmkygRQHWnlNXbwVxDqnHKNHA4dQgwO
	 HqbbuOskSdUhVaQCLueGe4vkRQZlMV+6TAKebIQbcYQ+9zGrZzUNJ1v17VGpHadToTJR6
	 RWLjzii3cYQqwFad86qQlpNLw77+74flbB6mBRk90Y/gIs9rI0cJ5fveY2zy6vMDnYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="e/7gvIZC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51936072C4A;
	Thu,  5 Nov 2026 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e/7gvIZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B731F008BF;
	Thu,  5 Nov 2026 19:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908170;
	bh=8iqvj1j0PH0IF6Pq8SLYp4U0CTa0deUsshKxdgFjrSU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e/7gvIZCknBaFzJk1RgkLwVMr4hs78B7PL/oV4FLAzy/Q5FgSU+3GZA7Xlv9b7h97
	 sOkvwq6wF34xuVZKXVh52l/paydNnOxqbPff+W5bbrXpDh4/yvE1F3UShXMByo+45D
	 ZP5FoizEXgCQAv0L5OiypTLx4sSXgSqmby9CzJLA8KHoGb/YLurZBQ1TKSA+yvkM7G
	 bivfF57fAYinyJoezBGyj5X4rL2+oMAJs7h7PIDbP2fQWTmu3frru4bUG5Jijdi1ek
	 fft2l2rYhfa/l4HQMr/2iqtHxa5FQQ/vkF3sjCMJ8uUvc5Kkaof2EtZ21M7Zq1aqf3
	 /fBPNQAhSnZVA==
Message-ID: <sashiko-outbox-199997@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 11/26] scsi: core: let procfs copy in writes
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
In-Reply-To: <20261104-work-procfs-drivers-v2-11-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-11-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for /proc/scsi/scsi, /proc/scsi/device_info
> and the host files so procfs copies in what is written before it pins
> the entry, and parse what was written from that copy. /proc/scsi/scsi
> and device_info take up to PAGE_SIZE bytes like before. The host files
> pass the copy to ->write_info(), writes to them that are larger than
> PAGE_SIZE - 1 bytes fail with -EINVAL from procfs instead of -EOVERFLOW.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D11

