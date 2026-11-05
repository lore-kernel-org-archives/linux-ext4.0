Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907027;
	b=3pxO6uE4o+CDKSfKZ7TlZQs7Wu1BZ2GjUYtvNmhM+0mvNmcnO9DtYkjgyQ7uKxvOjNRg
	 lfnMvbSEXKHDXZmLgK9QuhIFo3j75zkJfjY16xjIbFQA7EgFInnitn38icdE95FqRSfTy
	 YVtHJgTLJgEE9Qo/TTfFX0XgrN5fpWcCJykvqLi30lqEJVULGZiikVMBFGiHjBzzZFj2n
	 MCNaW3qOz4SZL1DwBqcJ8JSGeEi9Tk84mXCZPJl69HQlq4o8DM/6WUPZHC8UOVK20gNO/
	 M6ws2oJXM/2ORZBKHFMo6+aA2XIT+I0+n6fEuRxo5klMwWKsR0Gj3zBnn+Uf+pkL1Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907027;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XJ6642CpUbmT9faJdQPyT1x7rBQwlIa8jLjslbId/hM=;
	b=CcVdrySUt8suy7MaVrKrs/Wljna+C3P34k3QeTIqwSEe3e56khOVWFw+ywMckQeb5Iwl
	 jFAhnwPMn4zqlA+xg81g3se8IT6Z9PTPGBuv8BIjlSi0kRZJQ6d8Ex8Bk9CnwG7rMELb2
	 BioY8xaNP1KkYxBHmYUsRJBs/xle8wpLr+HBcFvqCtL+NAaR1SVG/UuQGT4mgKpmLUh3T
	 C2EJUEulqhPLl1y9dABnuVg7SDZxLQvTAKn3J4N5zJ0GIhaZZJfPnDrK5PVfX0O6WKj3A
	 XG2TV81nupJmxkKQyKGj204d+oqRSUtd5mWX3SKhkbCxZw/XlHb8jMsxKPWc1T9nUsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="P/lqti2w";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF72606B9C8;
	Thu,  5 Nov 2026 19:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/lqti2w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6041A1F00A16;
	Thu,  5 Nov 2026 19:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907026;
	bh=XJ6642CpUbmT9faJdQPyT1x7rBQwlIa8jLjslbId/hM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P/lqti2w1OrQg4Z7Rh1XUrJV0Rjz7sHRa7GeKVhzsOuNNsupbAfab6BhPFMbRRQ6s
	 R8j5pjl35ymm8jhjHHKcL2Q4aHubkU8vyNWYsO5AmMbS2QDOO/DgRHsMLNj9TrxKe1
	 RLG6VHdhILTSjc66At8B4CNW4ugXE4mn1IgKnc09t9nIGlKrJzpXyj9W12pQoosTgz
	 Ui8sy5shZnv8JDmiwBsQgNMlMgNj3iPBOTCVS4CXbwShJnC18KKd0G7+F0OW8ooQud
	 39xpw8p1V6y27YXqhAEZFOk06bAwJKDYaY5zNC7nznc8A+Y2K4mOb6/4TJKIimOEX3
	 Yxvmf/b2YoZBw==
Message-ID: <sashiko-outbox-199910@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 47/51] proc: sysctl: look at the table under
 sysctl_lock when creating an inode
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-47-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-47-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:25 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_sys_make_inode() checks under sysctl_lock that @head isn't being
> unregistered, lets go of the lock, and then reads the mode of @table
> and calls ->set_ownership() with @head. That's fine as long as the
> caller holds @head in use, which keeps unregistering from getting past
> that check. The next patch has a caller that only pins the memory of
> @head. For that one the table, and whatever the owner of the header
> keeps behind it, is only there for as long as nobody unregisters the
> header, which happens under sysctl_lock. So read the mode and set the
> ownership before letting go of the lock. The ->set_ownership()
> callbacks only look up ids in a user namespace.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D47

