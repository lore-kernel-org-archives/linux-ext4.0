Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718067;
	b=B+uCmY+g6fZmuFGeOjsscVUlj8N0WfKf1b5K8BqHBZ/wULy2LHfGzZmey6NfG0GZD+r4
	 Njb0aeZ+rXALJMPdLTxMKnpijGUC3hsfiYb4s9CwnrfqNpTdpJkjPP+uGDrCwuGZPg5Ya
	 GTpAVvxxcB4JDuNP6MGmq03l09UOVxF3KujRNEKXaI8efWGOp1k4xE/Nfm9+6g/WNKpEs
	 0a3ZxWKbpS1hnueL0KkExcS95mXtmcylnAwLoTEwB85RazVppgChzv3mYgn2knOxnm0+j
	 HJ7oaj6Tz/ZIPCxEqLwBj9WsVa7eJ/5GvGmI1tBz4lcDFmgxCmB9SxMcIvjls3Iea7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718067;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ID7LC75za88M69BElGmlUwzZxk8blr2d/qu4Qw48pXo=;
	b=OctM8YV+wiJ0N1IvuOZZ/R+WsLyXoVYVvr32YXH63iAaNUbhNBmApDv4x3MkjCJrqCPG
	 oCuHi2fruaJT2Xdi0HyEzPC/onhykQ/JYviRWGLEhFRIWrx7SYgMPQk3s+iX+GSHs9otn
	 Uldrn53mM0+EZAjdI5+21hV7xjsj1+xhjxFij5wQmkrAYL9fV0L/Vx/fxhP1DJwugH2wM
	 G1mMiPcfy51b+jlR5WFPByhHKR+v9sXrwmQ9Kgy3YJNyvIo/wwNi9Wjnvdv7R6IRSQnLl
	 GFrcV9+daWBoH0nNqn2KUpSUxpS30AY6yIM4+25GYeiLAHkm2KPOSAZWwYiO6yxkzWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jajaKVz5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81DC606A795;
	Tue,  3 Nov 2026 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jajaKVz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5311F00A1E;
	Tue,  3 Nov 2026 15:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718066;
	bh=ID7LC75za88M69BElGmlUwzZxk8blr2d/qu4Qw48pXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jajaKVz5uF5jV8KNkaRZ9jm2p4d6qjnBibcW+RdQG415ddsGl+0d3bo5j0mleaLxm
	 RwN0oymilT3njGexXy56725ypD8aMhBv35E9z3nBKq7iYYj1uGr0z2x1vioz+IJ0zr
	 CIMhu6ko7LsevcSiGh6ht2M3uptrpuTNi8xCLl9RYAGb2JQIB1dYpM4tY3O3Yj0v1Q
	 i6wOkRWSaCouWbczxv6hLshYtafnWa40AAByma6d3JjyufxRbPRcUODDXJFJzDRzTt
	 QFQvvpET6EoFeMBD9/m6afIrzXxj97ddDjVi2YA1OzWzbIgGVogylw7h1FKknnweMl
	 qgPPLhzd74S9A==
Message-ID: <sashiko-outbox-195530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 03/16] proc: make room for more entry flags
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
In-Reply-To: <20261102-work-procfs-core-v1-3-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-3-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:04 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ->flags of struct proc_dir_entry is a u8 and the next patches need more
> flags than it has room for, so make it a u16. Bit 6 stays free,
> vfs-7.5.mount takes it for PROC_ENTRY_CANT_MOUNT.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D3

