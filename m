Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719110;
	b=RsZnYWXeln/wVC6mbTcZchPenlVHsDNQnLWqjZcoOZVPzDWQbyY3KX4PhNaIVTOhLMvr
	 reo1UNTyYk0R8mCiExohGEAAWKPJPvoTCoQN28ub9qOeSRpVrcM6iwqVuOhjX74rJuY+p
	 A+83m5ieamUTfuh4cAdHnlfKxwcEmRHAh6oTaZvpqREmZ9BuHFxGpkXFNbw3EtsXbDe95
	 sLB56T3VX8yj0O28n4vMJGx8Rva+ns6cWfmb4WF2XsVpK0+mIBWFgM5D1r3eqaf2L+B3M
	 dSabxsJkUoNCqcou12jIS2+7IlKPkj5nuPgmRHZ1FqtYUuu7HWmaXakif5tCNzKOmoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719110;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1o/qScwOY5OW3AcPfET/LwYcniW1dmaX0ZfM6e2VYhw=;
	b=cjT497gVsYKYiBAOUM5NYgEcoZwvJBYdB9zILW0BOZsF1QYt/Of0sIVqaBKU6mEAUtjo
	 vbqrSH3b9amG3u9q6t5y4iSeLPQfpAiHCvbUOpGjNtIeeoxIbygtEqI3KMdF9oZ918E0D
	 mdEQrjAHDgjtNS4+f3uvnGbBXg2fU+lksTcRs8pWdORUQpBZ9VuY8JxT2Ewn20xOWid6f
	 o6kQvRsm9ZcRuCLL/p+LVXDuakgt+AZWe8IRPQ53CZJU4PCdyAsKPO35aTDcdqGTioQFk
	 5WdFlLPyJalightlokP8lZFAC7zl5yT8dCG3xXTNQwPN1RPvKxR4Sd2Yh3qlThRVMTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TcKAfBX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353F5606EEB4;
	Tue,  3 Nov 2026 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TcKAfBX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CD71F00A21;
	Tue,  3 Nov 2026 15:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719109;
	bh=1o/qScwOY5OW3AcPfET/LwYcniW1dmaX0ZfM6e2VYhw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TcKAfBX5e1XdhXILhg5rfmKhO4PgyKlj3eq0azh6XrZ1+WfufOQSJYBqlzejziYAx
	 Sb6DYr+s5coWPEgX6S1IM5k/YDXX0pvL98XkLLvnJPLg+EsxjLIhB2wgm3VZi561Cb
	 8VKdmJiB++oOsCK3xY9w9+lVosNEzmPZWtLYnjt53FuUOKgldLtg9kEklxZmPmHwiC
	 jqUerjRhuYVQxDyrizw2H6TVQG1rnSfyfBTRMuR5mGl44VbCc7aPIqfk47+B5n5uQ0
	 IMubBM/eIpHoA5BVhQqZFtR6QEgZWVeYz13eEPN4NA/t98KWQGF4Uaf2N1yKfid9Eh
	 8QFXLM1gS14JA==
Message-ID: <sashiko-outbox-195583@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 03/23] PCI/proc: let procfs copy in config space
 writes
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
In-Reply-To: <20261102-work-procfs-drivers-v1-3-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-3-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and write the config space from that copy with
> get_unaligned_le16() and get_unaligned_le32() instead of get_user().
>=20
> The copy holds at most PCI_CFG_SPACE_EXP_SIZE bytes. Larger writes come
> up short with PROC_ENTRY_SHORT_WRITES, like they did before because
> they were cut at the end of the config space.
>=20
> A buffer that can't be read used to write zeroes to the config space and
> report success. It fails with -EFAULT now and nothing is written.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D3

