Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907355;
	b=X1T9IArWHaNKNlB9i5oMou0UA+/CKjoMpgvsn2/T2Fosni4mDPgiU8rKY4RBcQTbV59r
	 LTFazpsP5tMFwSufvVleq2calxat0KpCQhhVlYIzq/Mi+89+VJ1IoeYaPO6KRpkxt+4HO
	 ZKpnd0a49KSDLVq744TFzcbKAWKOzdb+ckhVRT/9mnNxt3eH426ytAkKXQL5oTySaAJAP
	 FVLD0SJ4sXw2nVx/4F0xBCE6UdkugRWAvELAoqVe67lEus4l462SVpQBKdxVElkrwdwTy
	 RmZr1P1MvHqcpqioIxGTF2hi/2a5OXNvnlvHFAsgWFdEGqE6j3UoY0mzN3/kIU238GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907355;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Uq4i262WOQaYVL9uHrrjKQ33JdfPWVKPdUraeND3OfE=;
	b=vYRtReRW6C09ecXW46Gv5hKAeOarsqQP5S+LOaqn6mjORC0lTQF1D1iOdw6WiWqFWUfv
	 SSOwxtIUFHTuxkNJOtEdnDbFhTRL76XLAU0xzwD34bbt8V+gABZKz6aGn0q8j56X283cC
	 FqsOT/+n5vVZOtZDtWTUDIdybTmMO91bS3ax1WR2hWSw965F9lXKkgjktfOZcHkB5KLac
	 zuTH4f9/C3qA/i6eMQomH4O+19FMMkbu1vAtNbYqdvKhztKHJZQ/u1SyOdsKM7uUfO9ja
	 Ejxq3a+8uYnSrKA9xxxK3gJXjZQkHqL6MO8rmM5Q+sXIi4J5j2T/LVnARTquIaO0cuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lOvMqP+c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62C96079C34;
	Thu,  5 Nov 2026 19:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lOvMqP+c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4891D1F0089F;
	Thu,  5 Nov 2026 19:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907354;
	bh=Uq4i262WOQaYVL9uHrrjKQ33JdfPWVKPdUraeND3OfE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lOvMqP+c6a7YXK9+H/ZuDenXtrEpHzLqnu+MIMYNNusWymGQVT1Q4/ec1t4w9PjCO
	 qmkMvDH17i0eObC2beXzEFzADb2Xw2kymtYtn4SFw8ANhKSVhVpcnkQtfbpcSYZg9N
	 4l7J3MSm3a+sGzpZkH8kVTx2NrNd1TkZE3b0wDS9CPx8atrywkEgH3c4qaCIcxYIm9
	 dducVG4MRPcnbp0cfT9GmqSQ0uK/VKpBfmn2Z5AJsRGEKqgwI3kPTede2Uzq0Kx9jz
	 cWMxxkM6AxN0Z0X5UmQGN06QpwBQ8vnODudNJE/T70S35JR+kfwyN2SPUyPEeWjKos
	 Y2lpLs6jftrBQ==
Message-ID: <sashiko-outbox-199949@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 19/23] proc: pin the entry around the
 vm_operations of its mappings
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
In-Reply-To: <20261104-work-procfs-core-v2-19-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-19-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_reg_mmap() pins the entry around ->proc_mmap() and that's it. What
> the entry hands out lives on without the pin: the vm_operations it put
> on the mapping run on every fault, on every write to a read-only page
> and on every ptrace access with the entry unpinned, and the mapping
> itself survives remove_proc_entry(). For /proc/vmcore that means the
> fault handler runs after vmcore_cleanup() freed what it looks at, and a
> mapping of the old memory keeps pointing at it after fadump gave that
> memory back to the page allocator. /proc/bus/pci has the same problem
> when a device goes away.
>=20
> So do what kernfs does for the mappings of sysfs files. procfs puts
> vm_operations of its own on the mapping. They pin the entry around its
> ->open(), ->fault(), ->page_mkwrite() and ->access() and fail with
> SIGBUS, or do nothing, once the entry is gone. The entry's
> vm_operations are kept in its open node, so every mapping of an entry
> [ ... ]
> window.
>=20
> Entries that are never removed aren't wrapped, procfs never pins them.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D19

