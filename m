Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719128;
	b=x9vywewdzooqwUwAjmjt7iuMvtkI98T52jTjF5GPJveTNQh1eIItkNkJ76IFa+fb0V0B
	 dWL7nR7n2a11fmAP90lA34ladBz2YQTPfH4bEGWOwubtO7zOsM8XALeb9Es00f2z2g/Z9
	 96IFiATFYHSBpA3TLB9ss9v2gOyGU5QtqaydLyPB/1Jc0d0b7fhgEE3XC+91bZc9T8zOy
	 ujGSfzfK3xsFFGmKL/ffX3WILTYL5yrEuiZNVjheIJrKzeYl3UIV2+HGyq1ZmrdNzeRS4
	 w9ug0LY1Nxwwc86ESt6nQAf0rjFXeI6GIY9Ar02YyiRruAuLSiRhGxLihg17lc6keaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719128;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZU3+k3TcIYO6YkcHmMmrwZXsUbYIYwH7UeAI7gyrJ3A=;
	b=C/P3yFPoauvMpijIUXHNLn3azkUByzqAygv84mor8VTXWdaE3xf2jLd6N7nK3iJ7VqAX
	 dnkPkYifyUvci90QYQBNr1EEawWdNhlKRDPc9ngAA87cafP/iO4InyjAnF1z0bWY0dmII
	 M4iprYIJrSd4bdkwMnoEMZbzdMnkZWtCco2rbz+E2j1+tZ06ywn6z1wV5kL5e6lEci6Eg
	 e1zWIRHoD/sVxG9TLJqQG/Cp/mW9XfENQyXFc6mwGG0YP7oaRE489IsnkKNqx8P4QsbfK
	 SmnwmZ4lm5mq+YPugWwNxWJgg5CCBKLeCOmAmpvwA38wZVgF7DF0MmOhkhZJOgFKctQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U0h9UMph;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8C9606D2CC;
	Tue,  3 Nov 2026 15:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U0h9UMph
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046851F000C1;
	Tue,  3 Nov 2026 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719128;
	bh=ZU3+k3TcIYO6YkcHmMmrwZXsUbYIYwH7UeAI7gyrJ3A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U0h9UMphxrk1+mDnG0RzJJVioL/TjGuZE/m5lN4g//YG7ZBRhGM3XEQnayxkRQEtz
	 tba6IIRW7Hgbxp6euwMbzkpRpxx6lZ6mJG4Mm8FtFIdnmA1g/guNWt3PrDBwgPvIbH
	 k0wO/CWdhNQvXbaK7Lf//4AHfgVJNnRSqhFGoOYnKnxKwBPIqHIMPoXbYpog8RGwXx
	 4bP356yoryajWtdGcJRHNWblQsglDb2fE+3TkMWCf+62VKtpl6IVpsp0BiiR+VvRHs
	 CEv2c9NeeIaBjqzGREG/JV/GIiQXyAjR6LSQBpr5S3fOhe19V4s329MQ1rWhUQwDT7
	 ymXStWtbH9HnQ==
Message-ID: <sashiko-outbox-195590@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 10/23] scsi: core: let procfs copy in writes
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
In-Reply-To: <20261102-work-procfs-drivers-v1-10-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-10-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:45 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D10

