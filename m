Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718082;
	b=mb4Tw0VP+PuKF+33VMZrQBJRIEDyJJUuallp/okUjn9tZgQWPKzJZKQrehbxQ7OWAju+
	 EmWii569e0mrWmYWcXlgpeXxKQe0t20UmPFyKyGHekrqzgXYLcC6Y37KE3goYeItog+b+
	 Dwg0rwoT6AM5ssN/D6RnSMNnYVYUmPU6dLzIM4GPwVIVzGODvDT5efY4ZmCP5iW2WaZQ2
	 3pbltVM6EjLwt0RrQwgY3bsras5eXMRpopMYohKwoO7r5jA4Uv4RZkhiE6+LURA7eB5tB
	 kXYhmnC4ZLo1ivjOnz1Q/8SxTI2vImey4Vvl5dujzCZKhxh7fjcSloWa9BX9Zn0jj/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718082;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Syy1LgUFNYfSx87H66aCq59eQL5QmobeRV7Tv8sgLNY=;
	b=2vwwutHaydYIduPZJNixnW0aqQ66/GdQFXwe1/D51d+qwT4x+ziWs/nuDbdCOvE1fw2a
	 dvNxUYJYGV5t8VYk4hVhzCujWHqRLl2tIsSlO0cy0bE5RHDN4bM+7fMxvKfp5fb5y31RU
	 DzhEaHVP+CyKsLnNjBhn4eOscxCiS24E98//O+YC+uq6T2vh4MLxu6mrgFUPCZjx7osgr
	 FP6VHKjvIvYpTDo2VI3LqnEqIiPG5c7P5kN7P2J+uHF0aysxUZ/b+l3nPwl0Sg5PO/Ei5
	 kL4/8v8QEOWHC56F3s+FX3WCL06bfe9bSxavKfHtWpw78wkIbJRiQoo8q+Y4T+yw1yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQ1rFM7f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FC2606A33E;
	Tue,  3 Nov 2026 15:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQ1rFM7f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443D51F00919;
	Tue,  3 Nov 2026 15:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718081;
	bh=Syy1LgUFNYfSx87H66aCq59eQL5QmobeRV7Tv8sgLNY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XQ1rFM7fpR8B7CuMfEAfO0MPeFB7bviklzJDC9drMf0sVFPBUxtSxRBwsAET6uLuq
	 86A/lVnXs2ElYSj4vKDjmBCYKvJP458x5hONgHu5bQd7fbGpMj/t34dciWXfi7wqDJ
	 fFU+zJ2crZV7Xpsjn+tHMvlBjozine7jdlnmk5SGbQsExLyqTK/2RbNWtbH4IIfczT
	 j+/yszVdEI2WEGpOCFfohvzHDpftk4H2/o8Xj1NATPp/4Sz/Frs7Oa+VUWRBUk8Fne
	 yAUJyeEi14LhQD6cE/FmxhetOv8CXAF3q6i2fz2LXak81erXq8XJdvZZpFYfJ57Z0O
	 KP55d1fdx2dfA==
Message-ID: <sashiko-outbox-195536@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 09/16] seq_file: add seq_preallocate()
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
In-Reply-To: <20261102-work-procfs-core-v1-9-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-9-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:19 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> single_open_size() allocates the buffer itself because it does the
> single_open() too. A file whose seq_file is opened by somebody else,
> like procfs does now, needs to do that after the fact. Add
> seq_preallocate() for that and use it in single_open_size().
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D9

