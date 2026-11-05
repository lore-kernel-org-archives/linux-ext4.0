Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908706;
	b=k9KzX4p/6MU9C9MDHtvLANA01UpTADmYFTJvIx4AHSr/rjx0VfZ1O+0zOsgjChsJKkAR
	 sCiiEWoXLxX5AEOf9c2Hz4HdbKOwA4i0Jejt0Dy/ei/kOePANV6EQTcqAcdkS8FWg0S2i
	 IPsGXW5CBNblkprguQOJVOrnQ0AbHoBPJwcAfE+nH48iH1G0Wpd2P4ytefupcqCo3EP80
	 pUvADs4WMb2XpSn5NeoUsaP/zZwBZPjWR6r0fGiXQlJuc597qEtBgUPug+4ee/qMKeZSz
	 6gc94lQRYmwFSdSet1koysBHqOUcyCXz92Y/4fe8doOofhLVQjj4CH4M9mJLWsqKdMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908706;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QCq+/Fw8y7pYoOo2Vq9cjoQwmb2wvkDQOJQ13WVM94g=;
	b=CQxe1QtSKOaXL9cwrP/mFz0wswT7eZMGZyNxJSgDJH7EsTskO4eHVHPpEMrcCqSl1xOL
	 CgiW/xNm1KKckgSlH904Wf43oa75bZzMKt/iRKLpIpimRw14NBL0fhITe5VhgD7y3ne3h
	 jGanJweXNMzZc/DNn4WowipOenMpPuDRuo4uAbK+helEc7l7kj3Y8AQUGlRI3ti3Pr+0p
	 7GD7jdqBJ/xLhR8SFX2NHYruJArLz3fQlXA6VqH47Ln/WM/mvIbYcXGg+mCw8Iw7fsPxS
	 QoesTWhAHmIYuAJHrWNKw/JX1AKwugXF1GJ10iIyw6oP8wCy9NFC+pTFj7DWZhQsQvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="i/CYgvco";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12176606A6EB;
	Thu,  5 Nov 2026 19:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i/CYgvco
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6241F008A1;
	Thu,  5 Nov 2026 19:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908705;
	bh=QCq+/Fw8y7pYoOo2Vq9cjoQwmb2wvkDQOJQ13WVM94g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i/CYgvcoLrin2CTkYgx1vi8xFWzEuHmls5KosmtGQNdgSh85S9e4TB4IJC4eocMTL
	 Ry67D7wOzIW8YL2JZzYC6aH0P/NGwi3UIy4d//bHBH0TkYaOuZmlG/oeY3JUaqz2Op
	 S5FnuLuvQCwDKLXxJgeF4xsPIadF/qLWyf2YOU5FHq3Bb7qDVswvT3kN4m/IQO8Dov
	 6q1EdR54MnceiWzoM8LUTSHx7pr1Sd7eleF7HBY0F1fhrsAnS+mEjp42ZLzCbflK30
	 uAWYCeiyI2OnT/oCV11AVAdnPCpeiQDiVnRdPxM24JpNKbhLnIDBuxuEmZhiT+G5n4
	 8xxH9tRkRDezA==
Message-ID: <sashiko-outbox-200061@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 27/30] mm/swapfile: let procfs own the
 seq_file of /proc/swaps
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
In-Reply-To: <20261104-work-procfs-fs-v2-27-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-27-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:23 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the seq_operations and let procfs open and free the seq_file.
> ->proc_open() only records the event count for ->proc_poll() now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D27

