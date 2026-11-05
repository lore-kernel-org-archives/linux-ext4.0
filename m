Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908181;
	b=g1f6yvExoRlR3FpWbkyWeZ6FGWjnGGKBNwTXulZ6xcNdNOOO4JbDp4ppAYFrwxVaomNe
	 BW8sF+XFd9ynF4zTvzoaUXt4TIiTGP5stAfgPuF4Me98EhgtF5NBhGQqlFov2DAh/GJFx
	 1PPf2IK2lZHg8vaQoJPCgsPg3vR34K+QnlqB0AvVQlE3I1QuJrmce5+e6+LWKDn6sPi6y
	 mmZyTh6BmGPBut8fKNTTUY2ExpjaSP90L4P1iVXxMx5ink4Rs8mMIMYX+NQJUd1lEIRg3
	 E6WLqn0f5vn/5Y2tCrKs3hxrq4kEExeFkFAIk5GlP4Nklb7JxAJfl19dH+h7xjYw6fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908181;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7Djl1QiL5dGG3+hqSXIciJOl2M7vmre3NWilqCBHK4s=;
	b=d2ZPYC3/4TLqvuXOZJAuCzcvZxDG93fksesIohflvh83mB2fGNTb4CzSjHU+U6uMNmc7
	 ZDUJe/Zk2jYFjFajjJmZQYCMTeqBeJVwPcgfc6wXZ+uznI43Rz6mXxFp05SpV2CY14ziT
	 5TBN1IL2xXNuA56FRf3XImDDn61JQafAIzlBFuVpui2Zu6TNHSNbnMb30Udbz2pjdgZEd
	 xn1ADPF7QtP5JuhylLV08j3z4PZd+3jF63UrCIlBJlq0hZKA7ZrWTftoapx2RJaKJCJsT
	 DF8VmpscMpu1csi7uuvXtJD5CtcYlbTtdbSwBfRjeOWMkPAmPp94um9OunpPim0a6Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gVTF/DeA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6BF6075300;
	Thu,  5 Nov 2026 19:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gVTF/DeA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C851F0089F;
	Thu,  5 Nov 2026 19:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908181;
	bh=7Djl1QiL5dGG3+hqSXIciJOl2M7vmre3NWilqCBHK4s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gVTF/DeApM1r2UkSX3BbyQWqcY89YeD5NRV2LSch7GeeuU5KhRBPab+JMDFG8cN1A
	 GdMGsJR6HlcXdZxXBaDVO0yYzoVGUEBmuITdPOPGnZup50Tt36LsyeBXXyTO7jXqO7
	 MSwYN/BhLDomcOHTRo0s8dbFJCcAWnvNDuv7aEVQNHEdNUkfyO5btDTI8EL437WKq6
	 CpQZ9iEJaVQEuUEHv4xe8T7k59dl4qU3XQ/IAkuUUVmfgFZ8gDE9oNOnyGumscbVo1
	 5w44l0n0v6cSl9+sS1ZpHN84/Xjw1YkB+D2kkFxzPRrSzwEP6waImkgF16hG+cOWGy
	 k95eu6tjsdqcg==
Message-ID: <sashiko-outbox-200002@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 16/26] hwmon: (dell-smm) let procfs copy the
 i8k ioctl arguments
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
In-Reply-To: <20261104-work-procfs-drivers-v2-16-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-16-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:39 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_ioctl_buf() so procfs copies the arguments in before
> it pins the entry and back out after unpinning it. The command numbers
> in <uapi/linux/i8k.h> encode the wrong sizes, so the table lists what
> is really copied: an int or the 16 bytes of the machine id out, and one
> or two ints in.
>=20
> A NULL argument fails with -EFAULT now instead of -EINVAL, and so does
> a bad pointer to SET_FAN from an unprivileged task, which got -EPERM
> before, since procfs copies the argument in before the entry's own
> checks run. 32-bit tasks can use the commands whose numbers don't
> depend on the size of size_t.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D16

