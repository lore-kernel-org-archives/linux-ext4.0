Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906978;
	b=TqQ1fOVFzYXA0/xYnGvRXfrEpCmA9zpRhQqQh3FCp4yPUx8EqiTa6gMLR7t1TfC30pqb
	 MrrFLyCNpeJMElbDrbJHEi/ahSV28nRXKJqqGZIznleJbB5UdkfdtvQXy2w7ruC+SSYPM
	 Df478wpUWKSALMc87gI7pxELHx+utiJEzYHE11I2YWtWBxOM5yZQnFrmhq5Tv4Cvcd3pz
	 UZimW60FXMarvn8SiJbZHXcRxeph74QzTCerLt25YEyTtQZBDTE+zB74R7nnVUGJup7JB
	 LWF6hSXx7fqQCMj5/QvqWGZ5XSsCaP3+TFI2up7EYLr3ygh3rBMP1wbIhUKj7CiU1iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906978;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UR/bGeijImnk8Wnsd/tmizN5U2rV5dto4UZIl+xyMfM=;
	b=JV3FA49T7rUGd7uAJKyKlpziGYSYfBgEtVjDV9CJjJnWpfW8EbgC0f/Y5McINY1LwYVu
	 2jDc/9+MVIuoBY3ZCfoBiFIsoDuAN7KHnI5u02ALkMp+YNSBmli6jSSBCTIRCZoXFxkhl
	 lhf62PnofOKz0MF9Jb+4TI2uXoYt6IRXZakGtoks79PQ7wPs92uuruH+yv13W6FAbZad/
	 2l40K4GM/xkikPf71vh5C6Jb03CqVxad2CFRqJQSEtvm3IVxofTqTkowxPI3PW/7L73RO
	 VEifLoir0TkOkt25FXhwwGHQZbc3ub1j/6r1qQubwJW/26SCGbk7snNFuyRFDUXQx6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF38606D81D;
	Thu,  5 Nov 2026 19:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EA51F00919;
	Thu,  5 Nov 2026 19:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906978;
	bh=UR/bGeijImnk8Wnsd/tmizN5U2rV5dto4UZIl+xyMfM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VxAzMv7UFsyYnoBiL2vhlW1+tAK1RI3G9hd3638uMnnOa+X1Hd/XqYwSl1li8fliq
	 01QhsAxeUKmrnct1phcjHiDBlkTHs7H5HFNvKkpojOe2Up47iBr/sA68sM31T/h6S0
	 s1ItQIwz3EUke9VL6TKuHa6OR4G5BsKdMNyDzHw3sJFWrdLfbdMVss8m2/pslWW3kO
	 Z2bpNVkFCKMDl6PKap8s1Bfs8w8BOM0UrxtXZUW8aAbl0jCRWy07zKeWwaBY/bqScI
	 FXVCXKSbBT0TU1OECjLhNsgTdw455Z7U5ly3rnd8TVtw/5tgWX0i1IZgIKT9c/raGT
	 3wuaupfHri8xg==
Message-ID: <sashiko-outbox-199887@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 24/51] scsi: ips: don't return 0 from writes
 to the proc file
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-24-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-24-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:36 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ips_write_info() ignores what is written to /proc/scsi/ips/<n> and
> returns 0. Writers that use stdio, echo for example, take that as no
> progress and retry forever. Return the number of bytes that were
> written.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D24

