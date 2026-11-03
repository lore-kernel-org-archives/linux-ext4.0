Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719133;
	b=Hkri2rL6s8UwAS67ukkDEKqrzbvdR2FREPAvNf2iRE7DKqHoDNbPAsOjFl4uIG1QWqPS
	 5OIK/6DpbmwmyEkN/zVvTlh62pFxOVHY80ILnLPL0QfFVi5WdDFw2ZwIUf84tYwtAfg3u
	 xXiE6B6CrhCZ49/LDGwZmzo3bFi58sMu7jpj57E5r6GbgdP1q9Ryhri9ceOA/bYztihCR
	 7+BiVmKwhwc+Qhrn2/EoTgPTsQ/FBsXef6ESsQk5gOhIiXgUOrQRjOcLG+0zz8rvMCGoE
	 7gBSs/LDH5T9JHThmUjos0e097lXIIUP6mfWud2JU6UCVINqeMBz6RE97X0dLoYL5Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719133;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=z6+lpoHQf6RbDNG9fFLF3VrDYJoFB8bCt7Wgh9rVIYM=;
	b=J9IPPPKW7mZDpCmhOkJJRSS2y/mRGyNgsKLNMWtde2scukCqTRsWxv+ZMiDmgMYxtrBJ
	 UqpXj8TNgguQkYa4/8QALsD4Wn82Xn2NY/JkUgJOjYOT1hXdPN/WDGBYX023fv88Nldmz
	 193QEZSEDgmJoYhO56a903HR2b/hCS5fuROxcsvs3v3NqHFGtiHf5e8VCytEqE4lqdKXj
	 epLlITjtCz1nFC46wwZAEtVbtchyu+kcK02BfkkuGH3CGJNV+g19xJCx7FH4oeO1qJMsL
	 1Qp0IewntQtze5uP88mTeavatqyvOMCgA77xpFMtVGqFNFb8BcvmHt74d3+/DNdzKog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rcjo5N6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ED7606B24F;
	Tue,  3 Nov 2026 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rcjo5N6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF021F000C1;
	Tue,  3 Nov 2026 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719132;
	bh=z6+lpoHQf6RbDNG9fFLF3VrDYJoFB8bCt7Wgh9rVIYM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rcjo5N6WbPxt2+H7rfMn0U0Qn0UK/j677OEZtoRd7RaKxV3TF0eOjybPm+Wvbn1QD
	 hSU10xi/Ht3/4EFqNAngWEFlKFjOBTZDe271HhpPKO5QqzEULVu1P5axZ8BlukFHE2
	 oyiGctcJgDzhAUtWNdK+tOSgayatUnZ1OsddqjB5Sa9aBwTAMsUI+qoCW5YBvw/inJ
	 E56t40VVP+QCWR5FL7qtLIXAdUD2SXiFQlAlvIN02UVK9jEhtzb4NOZWhSi3Mklo7S
	 1NjomUuGTNSSmAXI0piLRxDEoJT8t632y2Q993FbJx+Vtkql+a0fsVjR65UKzjfWQV
	 ++98Ev+HgB9kg==
Message-ID: <sashiko-outbox-195592@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 12/23] scsi: sg: let procfs own the seq_file of
 allow_dio and def_reserved_size
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
In-Reply-To: <20261102-work-procfs-drivers-v1-12-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-12-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Pass the integer they show as the data of the entry and declare the
> show function, procfs then opens and frees the seq_file. That makes the
> open functions unnecessary.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D12

