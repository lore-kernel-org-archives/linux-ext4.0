Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908163;
	b=vx8mhEp4KNtbmY0NuwY2v5N/NXv+rE6acfKwV72ixqrIbNXM6g5/HLYEap77oP6JU+Oe
	 FvPjlY1Z1yeI+bHYnBBiYzW1YWoaej0FHQ/LEe8drb60Z3JrJgM4aI74re2lxqSu/geh6
	 n5IhNA6jHrMKRifM4708+P6n5Xzvwj814GYca7Ll4D60sIK+R/PVni8oGZA9eKdIe8eDF
	 dSqX6urW6JVxgm1B92q586XfjW5pkDUoYHxfWoZtteBwqqNQmJi2x3teNRU2frviweY6i
	 eFdXSGLlVb+wm/HYLTQnGb9M61+Qk4KfJrezd5b/Mc0882SNZDTpxRcwMp6YnKQrceg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908163;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N0CtYubMYF/r7d6Gxu4w4PPm+wbOFEVbT1err3hfmPQ=;
	b=Aifp5MFaXmYiViqQv220Fj3rJnoLFYFwio8j93+3N3yAQqR8KNEnZGjlvharNZ7iBheS
	 kN7GZmWsdha5QzflhWOLFvNoRkDDBw2gOspp3Mr0NA5pzMu251jtxU0UDZ5wS3jaurUgB
	 0l8wAsq3gd5BfXz6D3EG3Dh6pC+ycGA85a4mCiwDKgZ2d9+7W2/5929dDUPC1P1Zrp7iq
	 RmwI9XUtV56E3ahDRwcnbUJ6xSMka8EtneK+ElYcn7lCGVSgyqiF3xvsy/+LXeJNH21AR
	 upMDaWfXHJ+OsxAoawaq9cns2uL9Eyjhb1PCsV2wF++XAz+F/nEySo9eltJt0MZqpOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g0UxjNU8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3636071123;
	Thu,  5 Nov 2026 19:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g0UxjNU8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23A91F0089F;
	Thu,  5 Nov 2026 19:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908163;
	bh=N0CtYubMYF/r7d6Gxu4w4PPm+wbOFEVbT1err3hfmPQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g0UxjNU8MZbO8udDcLYgRqRi2q/XSDyFGh1z9C8i7ejWdnpfWqIymFr+1IT0mc9pm
	 vUAHmObKLivs3T6QpRP5aX9275s9ITd5tnDA1AjwI86MBGTBRx2/EyT6iZGLyZTtcu
	 OBobErK0P6T4ovFlyV33ng4ldtrIqOe4K7GkXQiz/YxTKqVm9ihO9UcmDqZgtNZPk3
	 5EKghk8uC69sNlLzeG5xPOlXepVcMjZD9U07VlnT9ijbQ3xiy/Cl7PRs3Z8ghaxbYv
	 wY0bQtFDWpVNvA7aIxkVn6jiWS9nrKSqT85gUiwsLitaiKs0zgUwV7wiBMRPCCCqGR
	 iOwywSNM6+ANQ==
Message-ID: <sashiko-outbox-199994@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 08/26] s390/dasd: let procfs copy in writes to
 /proc/dasd/statistics
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
In-Reply-To: <20261104-work-procfs-drivers-v2-8-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-8-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:21 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and parse the command from that copy. Commands longer
> than PAGE_SIZE - 1 bytes are rejected now instead of cut at 64k.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D8

