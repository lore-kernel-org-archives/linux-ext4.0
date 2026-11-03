Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719126;
	b=w/yZ5G3aN243zxy7XV9ixsDCv3IR0EjhZidjAVLy5OS8ij74lWfKdJRQS9a/AQtRF2yr
	 WlSKz16OFS/9+f2IJtPcJEglG6wWP1OX4/a4oporyafYp5j996vU+m8wEpjRwy1BL5Kmm
	 /f/thI2oxBFtilWGVJwcPruLruj2w0leoVRX6S1fvlCM7NLRe7tkSeCzVEdfvdg/Epx6u
	 Q+5ruV2YpSdOaBiWKfRDgJz+m4UoO8q5YlSo239/0pOwvvXuUgkNgWXakaORSewvbj3/x
	 K1wrFj1H8/2InAi7JMxZMuU2hh+uWNSG7z2H+qzj9CZYkeiS+uNLX2u91PbCkDDVMAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719126;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=phsvqCB36HE5sELY0/rInYjEe9A+U+9Mkk9QZ5NX1/s=;
	b=U47d+wZLnGpIV8Rq/FcHcFEOgibNVmsCcinc+IwJN/LfFqUfPrxeKP8dEfIb9Tl7kcY8
	 C94Db50xDP5jtUiVlLd4D0Hddm8/qG8WQsU1Pj4UIxjQYnFmSROqj2IrRswPUtdNVLCAJ
	 DR2pQ2y4VUrW4v2kXfVf3Us3Zs99wm/lYyw17UOW5skY/sxAlKXce5pHU8aS3V1PxQ6h1
	 4XCFEFPF2LxECl0QAmK0ZzDpCu5jKZ+CTGTsoxnvjFfg9KIxElEZLWefiNtsHtKKGv8K1
	 iuYaGBOvewUxOlEDRDMVFOXD6Qj/S/4Z0HFgV3rOhzqKwd6L/uCC9etMk/EvmXDXHmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KKQjc6qe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9216071A12;
	Tue,  3 Nov 2026 15:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KKQjc6qe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40131F00919;
	Tue,  3 Nov 2026 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719125;
	bh=phsvqCB36HE5sELY0/rInYjEe9A+U+9Mkk9QZ5NX1/s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KKQjc6qepO2gqHcvTGoXxHF9p03eElgXkZwT0gb4LHjb9cYDFkWKpIJ8NSAW1lYDz
	 1U8Y4y6QkittHdf9VZjS4lTWM80tTjz1K2bkIiHkjuXkA5Kgqh88q4lx3XaUch514o
	 cekfhMRcd4YGGXX817s9kANAvztbs421COqKGftvoBo7aA12GYDDBOkHN+un27PuXx
	 i2Da4XJX3H7JwBQzj7yO7BWJ6LssAsDzeZiJ1BsOlB9gCQYUO+RKL1cz8HQpUvjZfg
	 +AZ73h/Gv9kWy7Y/Bal112XWIHskhd/6B9QlxXjckC6nmYEyH8m7FiF4fw32DiHONs
	 RtW4Yxv7qH2Jw==
Message-ID: <sashiko-outbox-195589@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 09/23] scsi: let procfs own the seq_file of the host
 files
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
In-Reply-To: <20261102-work-procfs-drivers-v1-9-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-9-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the show function and let procfs open and free the seq_file of
> /proc/scsi/<driver>/<host>. ->proc_open() only preallocates the buffer
> now. Reading the file then no longer holds up its removal when the host
> goes away.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D9

