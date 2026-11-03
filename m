Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719154;
	b=5n3OFGJQFBaG1HBZ5QRGVfI7YmwjBGcqGK76IApt4G1r4qaK5Rkm9KI6QMnZzgBvvZMy
	 bFR7WEMO3U65MjOQ77Uycmn3C2L9MNcUtxAkPemndCd+9Xmj8yvxGiv5s84SIXlgu8Etr
	 Ldx/fEmotYdp1GWW68lJJqrYXkj0qi1RBUVvlfvrhHifyXoqAQ/7oLjPg9x1xxhzjKsUT
	 QhJVGntI2nNVdji5BqKiLLKhGKTRLnfmtaDGb2SuAU4KeIvBYO0iFIlD0BGYRM09A6TzO
	 3xL5VM/t9/tUhhxP5rnZvapXChZbz5vJL7wVGk5HW/gDeWMd98g/OIS4tCzcsLXeJEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719154;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QIotc9uipaRy1fYVILWJFOZjIjeNZQOV2tWEZh+pwRk=;
	b=vY3CF+Z6YvJvhFkAv26yaNcdUDkIZRhKNWVWtv/SZwXBa35icb8FAQSUZnCEnJlnRupU
	 dxF79PbL/fRWK0XZMDGjfTKzvFbqyXScSIqRni10B58kUCQ4zfUrNC4dcquv3CSeykiBn
	 ZWYqfjZbjoo/lOBDjTqY7NDFKLQ0dBPbIZRuazjla9t+E0l+p0FnNEFVNGEHIfpmU6pIG
	 FRN25fQOBUtDEf96SjOrpyuB5Gh5wV/tn6ZNy1FoHJqZsZBmUqiwXkwEQ3QfKEhwrQ3Y+
	 CrLy7zheSYSvWo3NOnIuyYwZMSgvwMnrFmTfOUHORi1PuldfywdHMIRavCwBi78kwbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UhGRax2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDA56082BFE;
	Tue,  3 Nov 2026 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UhGRax2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843E11F00A15;
	Tue,  3 Nov 2026 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719154;
	bh=QIotc9uipaRy1fYVILWJFOZjIjeNZQOV2tWEZh+pwRk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UhGRax2DDiXkSRlLYrZ6YprHE7VVwxA/XbrOJLCg12HZCsn4e0jikOJEn0tCq3YSq
	 VOw//CAS8p5tsReDM0FCdWFyEe8u1co+G6UNE3Dxza3JFT3TQ4o7dckveRjDK76vy2
	 tY2jrVJ2cfwVpnZf4WDSK4IobBt4sGg1BZyK3GVmeAq9oAaAjzUPT8hANCXRKvpqRN
	 l7ejjvhfOnKI+gxdoPhF5yz3jsMxIeuZUCiv2ifRbTblvbOeqt429RJIi2lN6DUha9
	 E8OxK8FB+CzBqgwGM9cRNOmo5L7Psxs2k0RoXIqxbHyIFhJ+4yEVw5VWuUAZw9sGTB
	 vMcRQv70kODkQ==
Message-ID: <sashiko-outbox-195602@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 22/23] ALSA: info: let procfs copy out reads of data
 entries
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
In-Reply-To: <20261102-work-procfs-drivers-v1-22-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-22-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:19:12 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_read_buf() for data entries so procfs copies what is
> read to userspace after it unpinned the entry. ->read() of struct
> snd_info_entry_ops fills procfs' buffer now. opl4 reads the sample
> memory into it without a vmalloc() buffer of its own, gus, cs46xx,
> emu10k1, scarlett2, cs4281 and mixart copy into it instead of to
> userspace. The driver guide still told raw callbacks to copy to and from
> userspace, so update its example as well. Data entries ask for
> PROC_ENTRY_FULL_READS so that reading all of an entry at once keeps
> working. A read that faults on its buffer in a later piece returns the
> pieces before it now instead of failing with -EFAULT.
>=20
> Unbinding a card then no longer waits for a reader that faults on its
> buffer.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D22

