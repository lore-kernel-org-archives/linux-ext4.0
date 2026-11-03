Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719123;
	b=EYwKTfblOpIA9eAN/Ed9+s1POmG0+5p65+NWhjn8GTfVHqIt0y8DUtezNHEt4ZDqVf63
	 ZnUh1k/pJe6NEJ78QsG7x9zJMAO6KF5Z3luFx5gYx9tiH33PLuXsEHG+nkzMdrA9zu3gu
	 J61cq5+W5tpCLAdI6Jr/SJmqd5FN8MHsQVDkYNp+ucys87zBr2O72x+4br4aZEwJ/dGqV
	 IXHoO4phtqzDoyCiKwWVFaomFa3Mbi/KXE9lppEyt/xWllW53pFECM4uGA3PcTFllVEbB
	 Nz5L0UH2uACv5uvSf0tf1WPezPQAczCtap2MFKeagwcSQsZL6IjjD+fg+2iirvWr2pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719123;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DuUWXqjsSRZJqvPrRnnQUK8F6HwoSKU+vf+Jc0u1BP4=;
	b=Cw9U7+/AwphgGgpqfs7+nlQJGJLNXYoXVMmKZQPN1DmWWpFIzhuJO2aXK1oGfCOXL4y8
	 FOVBr4rOscR8925bwBAUWJfErQw9kW6VFq6l7PfCOnZarTK3g23Kz2NkREkBqR6qKYJvv
	 vVQyNCXcZl/ClwyaWa31Xz0YfqUHK68F6MR2uVmECcr6ggNAGnVHdq1tah5T5hXXwr9J+
	 7G4VZEEOBlNFqur44CjyoVXYon9tolW0GjUfQI96SnI8SxzYNcnLO09OyW552tP9AA7sc
	 YbrgqHPP/dcl4xj6dLYCTbazpzTuChRFbyOlV9OgTK59EAGgcE1+Bu1TXWorlSIUn1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AM0tHmEK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA05606FCE3;
	Tue,  3 Nov 2026 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AM0tHmEK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34361F00A1A;
	Tue,  3 Nov 2026 15:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719123;
	bh=DuUWXqjsSRZJqvPrRnnQUK8F6HwoSKU+vf+Jc0u1BP4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AM0tHmEKokixtZONwfAH9GtAY9t8XyE8EQqFABZ4jT/4JvAwevkMeQijwg3GGuI6b
	 +uRWlXfdEm1zAuo+7Xu83HaUoLhd7v44csfZ9YCQ9XFZDzwuUrIIJ5ZJSNbLwnlYGa
	 m75nZBJXugcWf9XdVH2eCRknX8RVMsoXlE0Be3ASTz8tvYz7mmfB2q97Rx+lmFR/d/
	 P3y+Pk1FjoR6TzepE4sGWFDJ+B5VBr3/cihd1PQ5ptIU6mTwzqamjpHrgXtwTmDqHD
	 SsBfs8TF14zsa35s0UdWhnaIUoaZqYvGdNLbwEdyaDdYpcyIPY7xkys8bbdug4fGgR
	 Z1HIudLH9yC6g==
Message-ID: <sashiko-outbox-195588@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 08/23] s390/cio: let procfs copy in writes
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
In-Reply-To: <20261102-work-procfs-drivers-v1-8-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-8-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:40 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for cio_ignore and cio_settle so procfs
> copies in what is written before it pins the entry. cio_ignore parses
> the list from that copy, up to the first NUL like strncpy_from_user()
> handed it to it before. Writes larger than 64k still come up short, now
> through PROC_ENTRY_SHORT_WRITES. Writes to cio_settle larger than
> PAGE_SIZE - 1 bytes fail with -EINVAL now, it never looked at what was
> written.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D8

