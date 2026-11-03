Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719117;
	b=MFsGZC4cUYYCgOzAwYBXLEVtlhm30G9BQie2HbwbfLY/sFqqEgY9vGPSCQs98x6Vv9wE
	 lml3Qbjg4T2zOYKA8ew/a8fuM5IZTHnHNv5Pr3lua0QwTRmtSrr1aTnxlnSzSwRD5zovr
	 a8AMFr0P7jyT4cPTV2tLW2G/Csyh8wvtJ+15IHxDrBpOhj5jugN8ixZ52cyu7aW5+fgcE
	 2JfJcSpOtCDSKuIlwxz+sgefTQGCr7C8F/El0GJp10QIe1/oqMM/Lo7WuVsG95FMsFhu+
	 PHF7L45d5fm2yRmkdrFtTmIetYoRfzIIWgFUui2KEJayUC+2FgOiV2K/WuleIQoL+uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719117;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ntLrK1VmaHM4D3uLLozV9+SKiOYiOFuXJHMlY2hJA9o=;
	b=0JnMXEf3zWPWHmUYyDt7mEbFyAdlBnPuqG7m3VOcjw3QYsorKXpMBWFdWdefTZGP2Fcy
	 NQuaSmiIiulyIo3u3yDFPPqQ16DtdPI/6YDYXKMn9p1EA0T0W6khs6ljLywZfHGqqRvdg
	 XaP7aJD28FaEw/uVFed/hS2EVvfH/IvX/0J7hyqL9DL7bq5yzcOvDkr8k8YYqLf5Rt+Pz
	 k6OoRGh7ps77y+Xa0JjBt4Ig3a4D4jVYsqCrTjuNuMqcHnkKy49/RYyrRE3TqoZcEaIpm
	 LvByfkGY/5MugWLX1fE02KNe49oLNZ3q+llMxvMTu9dz5ljPbOVgV4aUWWVXpBIUaYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jirVnaYh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4D3606EE88;
	Tue,  3 Nov 2026 15:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jirVnaYh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9D11F0093A;
	Tue,  3 Nov 2026 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719117;
	bh=ntLrK1VmaHM4D3uLLozV9+SKiOYiOFuXJHMlY2hJA9o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jirVnaYhkMohORjRQHjNee8nF6ygqXhY8sV238z6GnKPRIdRFXtC9V57RpP5UtpYM
	 BisFVd3/AfOBIX1h4bh/i10hSU4Xwaj0/OG69yJkAtpBn3OarcL2g3SCi3pEoS1Nn6
	 fiLAHdSHKuRm9tWtKdyWN8b6+A8blaRqIhVMUC/4QSh4UvN8zzNdAr2V8Vn+QynMT8
	 wnBiOXRGdOMewKhkWEJhuLs2ejgV5WDKFupSr9OgpT6823+WP/w7wK4XuqdVs6opa0
	 n+vfL0Qc5TFEOmXT3KMIfy+47AcEixvBCTRYVL8SFodqsz0UlF26+crcochKH30ngE
	 9GdLw+MaB2T7A==
Message-ID: <sashiko-outbox-195586@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 06/23] md: let procfs own the seq_file of
 /proc/mdstat
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
In-Reply-To: <20261102-work-procfs-drivers-v1-6-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-6-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:35 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D6

