Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717286;
	b=HghSmiczDTXO74SF4E1AEDvvQJsHkI4rYYSdktDhno0AYw+a3r/LroaPxNVcHq1RbK/W
	 TVBSLHqN3ZKEhlWvDurR2TK9X1YEoOwUMjBOP7ETyItzAMJKOjwLhvode+OpaHSlGwsep
	 v/rzt0mwQ8ZTeUSgzJKnGyl+LVjWMfCA5udmc3Hw7sX3S22ftssA1O6AaNqnc1XtOnvaq
	 CSdcUilvyz/KVwvj83wd/5rCvC58F/2I2o/9E5nC3s04Glrglm8+Ex/RXrr3WyhyqJv3p
	 ZJSsei+TgvMbNs45pGGQbbtosXpb9yAxEi9atta/YEGJ+YiF5FtX4PXVbdYUk/J2CdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717286;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ooj3Pi0SRErCEL8duAq8trKUrdQD3CC9mA+kTthUPow=;
	b=2Cq1Zg/Lq6Yqqi7r5JlZ3p9lWR/RGpt9xEw51n+go3nLxyoEbfFeiLDQyX0+OjH/Q1vK
	 83LmWMXr3RznbPvMgRH89RWbhqPGd476lhWLrgq0/brTfixS83Y85BwqXN+4rtWp0EDJ8
	 QSWQN0Y7UkLLDE6rhiu//gY/gHqLHPp9jY71+4vm9wUj0RcprOiBmlJBjbC2ysSydp4oW
	 4ktk2++8RTMCGbaTGFEpo/+ZUhd/b/bx3RO/KfPA5vzQ0BPPvmfUI+q8u5FaTzuHk7QYK
	 NO+R8ENc1xZX5VE0kiqKjjoNgd8SiZNQhJDCyRDsN2fpKry/3TO6WWGjq+rOZUhPOEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NtpigpjF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4F6606EE87;
	Tue,  3 Nov 2026 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NtpigpjF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0B41F00919;
	Tue,  3 Nov 2026 14:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717285;
	bh=Ooj3Pi0SRErCEL8duAq8trKUrdQD3CC9mA+kTthUPow=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NtpigpjF9sxyzNlDIMr/kIauC0vBupDN5MuLmfVxwkf400sU8+++mUwlL1pvEUk4U
	 YdcMZMXDZjtqhHUcqJyV4raQjqK1SeIDUy2RBvl89itIx4icaaYqEgmEXXRaLQYMmb
	 jOP6Sdj3Y7zqWtxapxGQS1jXb4qxnOuvLYeJlGosFoofGNNwZrCIWMafCDB7JbNkBZ
	 Qz5Sf+jjdXOMa08tCYoT0JUtuZBq02Ez0HXq8fnSCQlQPns2Bix1SoLU4K5sqpsc2i
	 MQ5+a/FFu5rN5Hx0DeoKCx1MVxYil+GjRzwCVieeWb+tUiU4ff5gb8eX+apVlRxCYH
	 86U+GeLfMsa6A==
Message-ID: <sashiko-outbox-195491@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 19/38] proc: resume readdir after the last name it
 returned
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-19-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-19-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_readdir_de() counts the entries of a directory and resumes a
> listing at the number getdents64() stopped at. The entries are sorted
> by name, so one that is added or removed in between shifts everything
> behind it by one. Listing /proc/net/dev_snmp6 with a buffer that holds
> ".", ".." and "lo" and adding a device whose name sorts before "lo"
> makes the next call return "lo" a second time. Removing one that sorted
> before the position makes the next call skip an entry instead.
>=20
> Since commit 895b4c0c79b0 ("fs/proc: fix uaf in proc_readdir_de()") an
> entry that is removed while it is being emitted also ends the listing
> right there. pde_subdir_next() finds nothing after an erased entry, so
> proc_readdir_de() reports the end of the directory and the next call
> resumes by number, skipping another entry. For /proc itself
> proc_root_readdir() takes that as the end of the static entries and
> moves on to the pids, so the rest of the static entries is missing.
> And if the position is behind the last entry when a call starts
> proc_readdir_de() returns 0, so /proc then lists no pids at all.
>=20
> So remember the name of the last entry a call emitted in the file and
> resume at the first entry after it, like kernfs resumes after the node
> it stopped at. An entry that was removed while it was emitted is
> continued after by its name as well. If the position was moved by a
> seek in between the listing counts from the start like before.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: 895b4c0c79b0 ("fs/proc: fix uaf in proc_readdir_de()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D19

