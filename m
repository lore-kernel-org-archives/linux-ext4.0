Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908649;
	b=pBS6qVHk35ddshB6A4HWjmC03VwE7KBU3MA7BmF2DerSx09U3RzDpJnEGVywozfN186/
	 HOsKl7UzW4NuJoi5efOjTWXxPPAHIq5aBDbXSBzsPKXn3dY7s8C/svLv5GeeZQCfAvczs
	 NJ9v3Z6l/jVCEsFqYTQXwyNJl855w/INfZXcmmxuCMO1xDthka3JSAf/R5GRRZpi4tyjR
	 vJqXRMgSR1qARwJ6JTJnKgTgRfwlW3fSVxXJ741E+4hb07RC3zUzO5YjMAjAtoPuyX+fO
	 j5ktpTVyY145z6rZbtv2iUgTjlovf3EF6bAlmiHPwsXEx4ZDxwW9Lh7lFXUXEFAoSLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908649;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Wdq9ubmWttjgXl8+8abc/GBLatPB6YvLkctn10o4MJ0=;
	b=Fd9kfYNITrDbwYG+NPlGCEIHQeWo+33N2OnbeBsyBo+E1eOtCfqqce7aEK9JvN9v1pK8
	 qXkliFPoOmiSBBBjjc3LPfk1Tkskiai3AUW3aZXF53px8CRU56Ibj2DP464xP6CWCFT3A
	 tBxFgtG390UMDz16d3tiJgt3b3lV+cHx/eAj/7PCl5IKGAL75iYGdsZ7IDyLGNdbztfub
	 zjczDwQL9gTHdDJFCwy9WqeKgxjrZvBnVNVfiEnUsBXbEsUJ2Bx9z9tWyZMwgOhA4473i
	 o/Cs38arKOF31+ZG2qn1g4RRD5WtLyfZbaCvM/Z8S7PlvbUdxJR2Gr4r178pJ2Snapw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJ6pjbyS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E86606A33E;
	Thu,  5 Nov 2026 19:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJ6pjbyS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9252D1F008A1;
	Thu,  5 Nov 2026 19:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908649;
	bh=Wdq9ubmWttjgXl8+8abc/GBLatPB6YvLkctn10o4MJ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TJ6pjbySwYPW4bkV01Rt/FbOgOqtmyAOPGD+O3TVHeq99rf/KXFpC7uZkHXuQh2Sk
	 lB1yfJfNloihr3VqdG4yyojYVlPmqgN4VM9TGihxuSSgWgGXfVzHF7AfncQjyDCnY3
	 pBqfcM8lMgy6okNe8/A3xSvVLA/lFiGj5We/OdiFdUURLaIR+EC/N0nvBgfQ1x8XGA
	 XNDHxytc8FZkJM52EHmNjCpiqXkT1r9WWykbQNf2AKXGunxR3m71gqzdclIhVQc1x4
	 grrssyB4i93FgdFCR/cDyuNHXcp8uHCwB8OC/y8mz6vTZaCbzl8Kd478uO85QBG5hj
	 oGiy809F91fOA==
Message-ID: <sashiko-outbox-200035@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 01/30] jbd2: let procfs own the seq_file of
 the info file
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
In-Reply-To: <20261104-work-procfs-fs-v2-1-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-1-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:23 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the seq_operations and the size of the session state and let
> procfs open and free the seq_file of /proc/fs/jbd2/<dev>/info.
> ->proc_open() only takes the snapshot of the statistics now and
> ->proc_release() frees it. Reading the file then no longer holds up its
> removal when the journal goes away.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D1

