Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906989;
	b=uInBmk1u0ZrhEQKWhVf7u2uoLbwKsle++nB30em7AKTL66ozSQPsSTWIzE2Yy8puCYRV
	 eE45Lh8Yb8v/T62LnhL1rN6H9Yw5JgLES+MA/lVBxNDfetqHOfrVXcDImk0mKgPKYVJnd
	 0i48jO1nqFg/AbsIXe9K2ef9s/qDxzB68SBspdfWzX1ShnZ6h/KcbC9/MQsAntAoNU8GN
	 T377M7aIEQNQIw5IeYXeXHr00MzoR7WMf02CyZWbWRLHgndz3NjbBnJdgKKnibwt9d4cE
	 cjAUIlKdt9aTB/g+clouV3UZMrKPHcY7RRO3NLfgR1UGwozqun5zi5thKC7TIclVmKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906989;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tYEaWeBl2oisDih1UdNugCXIpIq2tgZMb3sKXKsBY6I=;
	b=fO4rqtNg9swnt4jcE9qkcCBvhZo8WKPzFxr6rWR+pZm4rUskn7aXEPkVr4A5TmFuyrUz
	 R/mBoLPe41u3RiZyddKBWJhxx0wA/5+3LyvsZN9Dwp95zUZfTwbqvAjV/gwksMCDvRoSg
	 OIVY6Gh6X53SCNMfOjWc40+/DGvRvGLQAtiPlEK4w+v91GrEAbO/edoJUkG/SFdOkCj2r
	 rE0f1PH3mIYpaaJ08Z5entQ8ne6YGQ8fDtmQOBn4GNNkZaIKsdUxWaMxK+DH4YYAT58XA
	 tSTAJN+bo/bJB+eTQHDVNulAhnBuvLQQUakMT0njEIPT6ey/lkKIKS1M+wbcKUCxzlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d0zepe9O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A61360A3803;
	Thu,  5 Nov 2026 19:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d0zepe9O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97BE1F00A16;
	Thu,  5 Nov 2026 19:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906989;
	bh=tYEaWeBl2oisDih1UdNugCXIpIq2tgZMb3sKXKsBY6I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d0zepe9O8R5+t9zEwwSQfwqQ+uRDyVfLUlBPynET0r21RHNR5UG7AhOhsR02sce5r
	 TSZF+KdRu2ZE7ol7BqyFp6fDMtQgn3JGM2/h4/JQrs7WA9QImQw9XkglJVJmyXTLGd
	 Gt4w0NpzUVsmxvQy9UDNKi2oQqw/7l1DgZXzhL2SeaBSwVDpx5uLbxvtsM/PwUZN7P
	 KRGewt0VicxmCd0ZOyKwOEaPZ3eOdzSHhx5l5ZhRR105fv+OKnjzDGYzuxGv7Q46xx
	 6br2wVLNCoQuk6L/kzU76RqGHKbHIXKOeDdGgYf/5PNxNiAICsz89j9aaMbo2GUMpM
	 Lyp37dqK14gbQ==
Message-ID: <sashiko-outbox-199893@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 30/51] net: pktgen: reject device names with a
 '/'
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-30-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-30-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> "add_device" takes a name like eth0@1. Only the part in front of the
> '@' has to name a network device. The rest is free text and all of it
> becomes the name of a file in /proc/net/pktgen, where procfs takes a
> '/' as a directory separator. So "add_device lo@a/b" makes procfs look
> for a directory "lo@a" that doesn't exist and warn about it. Any user
> can do that in a network namespace of its own:
>=20
>   name 'lo@a/b'
>   WARNING: fs/proc/generic.c:174 at __xlate_proc_name+0xb1/0xf0, CPU#3: b=
ash/241
>   Call Trace:
>    __proc_create+0xd0/0x9b0
>    proc_create_reg+0x45/0xf0
>    proc_create_data+0x77/0xf0
>    pktgen_thread_write+0xd8d/0x1750
>=20
> With panic_on_warn that takes the machine down. And if "lo@a" exists
> because somebody added a device of that name, procfs used to register
> the new entry below that regular file, and removing "lo@a" freed both.
>=20
> Reject names with a '/'.
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: e6fce5b916cd ("pktgen: multiqueue etc.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D30

