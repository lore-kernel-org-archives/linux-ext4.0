Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717258;
	b=lVjrIV/BKmEi9LeHf6A75ESYimoH5v7VA7kP1V+VfDixMmxm82Jq63xHepR+fEwUKBFb
	 e4sUv5u8O5xUmHbr0bfOp8mb5Kkj0vI0IsdRQ1yvpI9SRd7+TD0STTyEkdhbkYvvyHQu1
	 otw8iy3JQyYRi2Ocrg6cXqaii99e1m6AekhmcLIfoQquF5+gZFM7b+YB6SrRsyG4P79MS
	 xF/rv3M0jB1o/dnHzJL7bhDAJXOnWrN1WhWnp4WBXdS9a43seCOiJ8YTFWVBUGIFn7lIB
	 efkbjSjHgwWC3xuHJtr3DwujF3Ss/lEipkRIZZyJYYWLoI+uUmc6GDV4FuIg3mbXglw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717258;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N05eG3DcsrZpQfqjL5D91LwnvEOvTP0/ov6vkT4Pvcs=;
	b=ueNhz16KqETrw0MHsZ7aK3hfWpQ+B4cEBsr4T61+bGLTdkyNr+1uzz7oB8vUeUK6r7yC
	 ccaZK77aoSSKcXYLQ3/n9mqXPWLorZs74j22/7ucqZdHUHPlfa7M9//A6B/LukbB+xbq+
	 5AodtnsjMFQQe9lLewy9fzn3JTRtruuxOanHFm4OHYg9kSU1gEHPScdS/0LcFRAQXgF9l
	 /82fl5yBl8QT+7cHA74DdAFRpUd5R+Ii8fCza0sbFYy+dyZa7YQVM4KM5TmzhxllWXuTA
	 4sibO1+eGFnzKtMREzCPJqRCm3czJsLpmds6AEvRZG2EKnKJzMAZvVYcHtuOty/LSyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hasVYka7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D14606A33E;
	Tue,  3 Nov 2026 14:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hasVYka7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80461F00A1A;
	Tue,  3 Nov 2026 14:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717257;
	bh=N05eG3DcsrZpQfqjL5D91LwnvEOvTP0/ov6vkT4Pvcs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hasVYka7WfTQX4gVG72LHVrtfNEhVp4P8ZtdcWyH+LgHzqiGmI0IYbQHO1iwq9m07
	 y/1lwfnTHWCCY+cbAgh9hskIZQ97rVMlqM95iGbxPIOe3f8RS9bNGt+mxw9ntpVqb/
	 scjaMJLEVTqoyjO6TjfG7nqX7032JBfqmizKNDbPX8HDDI6FUj87MgRMBXyr8hd/G6
	 o/Ht1P5w/7ACphg2RTZAjkTSNTX/ebWs2gke1l0yWrd0iIR+fNLltdhYI899csOJwZ
	 1y9qK6xl8eu6MrQZdcUR4uzY+8RNuZ/DmBvaIF0iaqRFYBY29TqHfRB0P45MNfIHFj
	 usD+mtvrE3OkA==
Message-ID: <sashiko-outbox-195477@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 05/38] platform/x86: toshiba_acpi: reject malformed
 brightness and fan writes
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-5-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-5-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:35 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When lcd_proc_write() and fan_proc_write() were refactored their checks
> were inverted but the && stayed. They only fail if sscanf() didn't
> parse anything and the value is out of range at the same time, and for
> the brightness value < 0 && value > levels can't be true at all. So an
> out of range brightness or fan setting is passed on to the hardware,
> and so is the uninitialized value if nothing could be parsed.
>=20
> Restore the checks as they were before the refactoring.
>=20
> Fixes: e1a949c1b988 ("toshiba_acpi: Refactor *{get, set} functions return=
 value")
> Fixes: 3e07e5baa2af ("toshiba_acpi: Add set_fan_status function")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D5

