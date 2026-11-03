Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717319;
	b=vkkIIug1mv7gifgYO5J6R0/iAqwCJufv9qszKu9lc/F7qIvBvRwPq56zBE9LJFWFF1Ol
	 1wkbCzHYfG2HgtjL8pmVVrElgroDf+1gTjFLTr+h2hqKlkoyuc49EYbnPsJHlbctGm8Hy
	 Pih3LSefiNAxqjOFTxA3f2OHN8JIwstTGxUxD/40s7nuHHSOHwvZaS4ifXkwkPM7MiS/o
	 atAlKhBB+v+ukc52GZzalMSW9dswK9G09oOtsUAs0UIJH1SL3vRICOEseR7Gv/Y0WHnZW
	 +f9BNF5AsJUTbiNco/NCmQRhYop/SZamjJPBck+ogSeHQpXlYZUDTB5NqcI3n4C9uPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717319;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=w2/IP9Nbbwaq1rM5X5TI+Z6uMBVhleLl4dqv4RtKuWA=;
	b=sXK1g486Yq0AFiAEPJKZUvDcqj7saOhIScHlBPb8Tq4FUrizlh4Qsp07AYA5uUKKq8JC
	 Xxkrs3MJKKNbs9MDd54JYCN28pCKmWN6oWmoIuZJpcuThXGNXGDp/yHnxl2Sy5MwL1sOI
	 d3XGL3Flg+AnNP05pBx20i4hY4t8X4/CF7eXCygX3nr4ePFHqXTF9dbNVxw1/RaDEoNac
	 fxaApLhI0xx3l21u5SqLMDDzURMGwIsVGOvkngy/lKpLrdVP9iMeG0ibADxWBjqUxWIav
	 Cc6Xg3EE88wXcQG0guE1dv6/bFZZRPyCjGRYvBCvlyYXoyXM83Kq1QqcmwGROVFdy/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Y7X/3tby";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8951606B263;
	Tue,  3 Nov 2026 14:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y7X/3tby
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BCD1F000C1;
	Tue,  3 Nov 2026 14:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717318;
	bh=w2/IP9Nbbwaq1rM5X5TI+Z6uMBVhleLl4dqv4RtKuWA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y7X/3tby5ok9JWnFEB65JWWmANthXkUjcXdb9uSdjW0JhmR9HZjv1YT00Y4DsNv+W
	 Biuw8DvsjPcl772z7tONEXXEXtYepxE4vSjBigB6zSeMFdoUu1aYEPpOnorED4q8/6
	 jPTA+4fCMfDW09aVM/QBTydO81RE7CgVc1Pp6JLW4SpOJYkbo9BUyN8EiUCyyjZQlp
	 kv0bhokpcFD78wxy4BaRRF0TZr/IYs/oBfNzPTLQzgQNoJpQ9WrZvetS4oHr4FTbxa
	 gW0WNwcqv3NgJchB8vagqoYRJIHigOkbqStPD4Hh4/ge7N18B2zIy8QT5B5D4G6wz1
	 nY9eJEyDXdkew==
Message-ID: <sashiko-outbox-195506@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 34/38] proc: sysctl: look at the table under
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-34-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-34-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:36 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D34

