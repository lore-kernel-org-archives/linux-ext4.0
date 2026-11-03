Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717307;
	b=ETjKiQ8yTVJhex/C09ntjxpqnUC+FVMVvkeb7i1Nj7Z65oGEmrktQwbQ2q3DcUlX4C30
	 a4ADiGaS35zs83SHxGOQZAanC18L8DhMwQwaaPyBo2qRsIj3b/2+fYStBmatsjvYUFTwS
	 6HJpIiR1H8FAsma7MfIH6jhO+H1sJhEUEQQZchTLsSjU4AlGe0sLYUh1mC/lq5L1Mov9v
	 w/jk1d9xDNSpYPggNSO6UGfSZ7fNVdlyrW0FsFqvF+mkJ5cbtTUuXOBFw4cwRlcKwJlbG
	 RY9TjtNKv1wNK/zibthiA0mJXX6qE10iQ3kYqMsnpU6GCYT1OzezYiwqo2Zhv80YTfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717307;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CZitfjPRWrqbc1UugEpoY/pCdHKs/Ak0rSBgNQ6MBwQ=;
	b=DO5Vol8IALcS/fLKWQtet8S8H3Rrq+r0tfT1J8wVKb2CwvpmQuXCQYbW4R84oJo1tV40
	 zrlDoNeqLfzJtUgKPC5AEYQYatOVY+zgmRGsJ22DSZHZ9sVqMIuyxED1TyhZvuSo09Q9q
	 UCF9vx7dAv0UxfR3sIIYtvuCV9cl/oLMLvjcLyQtHJeuArKOy4prrGVS3VWudmIKtmxEF
	 DqodZRpjjETtbRDemjflhYQKBhNkRV3B0lU76QL7vq/zTe+dgOj+KJLPiMwW9xnrVPzrD
	 DDATJsG4Ww7mH1/LI04oC7mjZyDfuvBbzoyQeqzxqFA6TmEH5FJ9+DdwklA8cqhHPUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="BS/unFTJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0921606B263;
	Tue,  3 Nov 2026 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BS/unFTJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7911F00A17;
	Tue,  3 Nov 2026 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717306;
	bh=CZitfjPRWrqbc1UugEpoY/pCdHKs/Ak0rSBgNQ6MBwQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BS/unFTJQBCgBdJJQEKrq3m4FFXM+1Tye2f6vDO2eS408GceaDi4Fta6UOVzoQLP4
	 zPuiIi740ueizm1BtHY/HHB7VqgikK8iTG9o8Y63KAWnNgIhl0L7fMcLj2NGI5IgNC
	 oINvup30ow3k7O9GL4AwA0eFFJfTKQRNqkKaQbf2gv/ikZr9Xx+V/SH0Empjc44JZt
	 2GySUS6y02hSvYHWLBEAjlLxTbDT6Ybn3oGw4xRi8bo6d4KF2eUQf8dpbJCu/dQFlw
	 CRpL8LrbCxYMDI2YOnG4mio8VO3TgsHCf+MaGYmj6SJlaVmu3CaHdhW9klBgICCnHW
	 5aUnXrTjG9RCg==
Message-ID: <sashiko-outbox-195501@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 29/38] powerpc/pseries: bound the lengths in the
 ofdt property parser
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-29-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-29-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The commands for /proc/powerpc/ofdt that carry properties, "add_node",
> "add_property" and "update_property", can make the parser read past the
> buffer they were copied into:
>=20
> (1) do_update_property() computes the end of the buffer after
>     parse_node() moved buf past the phandle. So the end is off by the
>     length of the phandle string, which can be padded with zeroes, and
>     parse_next_property() accepts a value that reaches that far past
>     the command. new_property() then copies those bytes into the
>     property, which everyone can read in /proc/device-tree.
>=20
> (2) parse_next_property() parses the length with simple_strtoul() into
>     an int and only rejects -1. A length above INT_MAX turns negative,
>     tmp +=3D *length moves backwards and passes the check against the
>     end, so *tmp is read up to 2G in front of the buffer.
> [ ... ]
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: 610d91511f99 ("[PATCH] powerpc: Add support for changing propertie=
s from userspace")
> Fixes: 46db2f86a3b2 ("powerpc/pseries: Fix to handle slb resize across mi=
gration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D29

