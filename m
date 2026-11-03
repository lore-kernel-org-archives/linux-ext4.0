Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719152;
	b=EWex1oSCOLf0V1kR4bkFRkuX51NdS8/5oczvKJy5XMNK7YhtESrH6tiVOagUDY9rGNWW
	 Yl/re0N9lFdqXwsvGPv1/fkyFiYyNDMppjx3QQMYWzdlw1yBz87ce1KXQeVZvpju5jtA0
	 iFUtkbLXZCHxcuEzAdQjhM1Eyshz3APAzcQAof8f/yxke95Sv0Vg5XXugtlIDwUr1qpaA
	 aU0YPuPmpgCCLqjB7AeynUkF2w1Fs8Nf7a9xT3Owd0qO1LnwO01r8Aa+4GhAfCQP3e1f2
	 UEmLLmHQulrJDs7iMw0PTXGY/g0+TovlBro4KPuxO+VCEqllKW49lj+BhZ62TVsgAQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719152;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IE8V4iOQ7iI3noML0i5KQeIyzNJfUBdSgWgy06IridI=;
	b=GRZl3ehneNz3XRL+DULTxzZLPLI/Lsku90NSyZJULol0vQxuIM2RlskpIMFCpP/sNpup
	 OKKwiZSrFbvCUXzGi5qFDJmWwgrPzQ/xmv5OgEyvY773fUKxU1WKezghR5BDlpx/02HOt
	 lzUK3KtdyfAgZ1X+p0m6F2KaUsD+UlsK+wkPyFcAOF6t90zcE8X0jrXMRWRQUWdRHVdhA
	 YNv6eX0GdH6jgDxYekI3cMuen/Jwyh9q6ti5hJ4wH69015HKsiLw4X2l3otQ23JcsSktU
	 +Dfm8qoyd4ae21uVZ6Odp9412edjhE9mJBvEssLEU90CHajzEFUEb6kTc4d6aXXR+Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cs0xmh0H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3ED606A7B6;
	Tue,  3 Nov 2026 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cs0xmh0H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9221F00A15;
	Tue,  3 Nov 2026 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719151;
	bh=IE8V4iOQ7iI3noML0i5KQeIyzNJfUBdSgWgy06IridI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cs0xmh0HG7ocfJncY6yGq152uWyliT7jK3rRJJRKtLfkqNGd4BuVAJlOcb+TB+c0Y
	 m0Zz6URXX9JFhDTjvz0btUBc2CWv7FjEi3y6D5tXMrKmYkp9oyNuzqetMapTf/+0DR
	 2nMRuZTjUqzUKSfEQTPamTNPXOGtTI1lOCkmiX322AlBF+9FPWIY7SJfqsYtgr3yOl
	 xnDfFDDLRRbH0BOzQbHQ8WOunVlJVuUeRtZ+RcN0G0MEnwurIY+Un6kGJOKkXOmJn/
	 cVi3EVheLLtxmmdwiWpSBGXkZu1R/PXVQuUD6eJ2mFWhwzkWYnZksSTusi17FIGRdl
	 JTP7AxeqzaokQ==
Message-ID: <sashiko-outbox-195601@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 21/23] ALSA: info: let procfs copy in writes
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
In-Reply-To: <20261102-work-procfs-drivers-v1-21-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-21-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:19:09 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for data and text entries so procfs copies
> in what is written before it pins the entry.
>=20
> Data entries take writes a page at a time with PROC_ENTRY_SHORT_WRITES.
> They used to get the whole write at once. ->write() of struct
> snd_info_entry_ops gets the kernel copy and opl4, its only user, writes
> it to the sample memory without bouncing it through a vmalloc() buffer
> of its own.
>=20
> Text entries take up to SND_INFO_TEXT_WRITE_MAX bytes at once like
> before. A single write that is larger fails with -EINVAL from procfs
> instead of -EIO now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D21

