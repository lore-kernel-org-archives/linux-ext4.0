Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907012;
	b=HmBAlKBCpUVZ5c/+XJXoEw3eDFwEfl2iZy2NdBTav4nHCH84mzLSb7ioqfOHyH1WppPG
	 rexwTVvjM3LtZY7/ncsj6too7jS16osUc6YCFaZ9CvaTcyE+OoUZKwN/M097QgDpS8mbw
	 Yocr8H9bKYvCzKVzRNH64gTALT8eBy0P49I+CTMud6L4KNb0fOxm5EbMYsPMrnzn+4Rhk
	 Sc+9KMD8Kd8YTtK+FRpiUnsCRKiSy+B5ZFS36P/aA6TjIZ+Cgt8X8CcNJMNUzXFo1N26q
	 1kSzU9gvUczI94QFKmVC1LSaBDxYlQgwK5Dk5Y86wb7FiiYtRLPV71yI3lYTxyTaZ2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907012;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=T7HKYtQp5vMTiukaVd7EQNWwSXS9b7eC5j/PqagBtrM=;
	b=Kz4m0+BRoUe5cvmd1n9czoxf7it17jeT/YxLa6aU5Qn+892e6SLfBydRU1mM4qBIcKEg
	 sv5BXByrPVje+WA8NsTRJ4+zGjIKkEOpSYoH/6lRCxOeiYJvp/rVnLDpg87KYlvrhlsu1
	 h7JDbe82OrNWNUiy6f7y2P2nqVVRGPKHhr/tY9dCWd5RD+tE3rGtbxyO4dBfQOnrpJSBA
	 YHhh1/xDydxvBBcOvCVY0i7yW//nh19jHyxbiyHohqO3db0JhnORf3F7kAec7mONJ45wL
	 d6j3qXxrJ3ZfQs8XHKtZcObD95fSBmmokAeNwv7V1PqinXpZIzofxNC9qxekZCuta8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6WJiRfI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526F6606A6DB;
	Thu,  5 Nov 2026 19:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6WJiRfI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13601F00A16;
	Thu,  5 Nov 2026 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907012;
	bh=T7HKYtQp5vMTiukaVd7EQNWwSXS9b7eC5j/PqagBtrM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B6WJiRfIIOZmOenToT8Gl5tE/rjKUnG8bXyiNR5Srz9jcDxPJtwtowXS9szFn8cZr
	 WN8BdWyUKqvCnlBB0nB37arSWwZ4beEyi9ft4NxFCy8Ur5VfbU/c52RTQ9hy3/QF1U
	 v8/Ob/jZ2E7l/WVUEKgZTcfqZIxhwV0avNcWMK5lb15TTd5+xb7ZJRFOTEDpL/V4LQ
	 qqiDfkcwDN94YOHXnBhonf/JZ0Eqfk+ZCjvAseT2pzEyIrELKIXF+gmxk2Mho54u/K
	 HI7UbMQ3PVHktWHk2inE3o+Ppb+j2wOf42ropi7s62Nha54jVE7mLXq+Gbm6pXyIYe
	 37E10HbcM17tQ==
Message-ID: <sashiko-outbox-199903@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 40/51] sunrpc: make queue_wait a global wait
 queue again
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-40-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-40-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:10 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Since commit 552d0e17ea04 ("sunrpc: convert queue_wait from global to
> per-cache-detail waitqueue") poll() and epoll queue their waiters for a
> channel file on the queue_wait head in struct cache_detail. But the
> cache_detail can be freed while its channel file is still open and
> waited on.
>=20
> The procfs channel files of a network namespace are removed when the
> namespace goes away. Removing a procfs file waits for the callers that
> are in one of its methods right now and then calls ->release on every
> file that is still open (cf. close_pdeo()). The waiters that poll() and
> epoll left on the head stay queued until their file is really closed.
> So:
>=20
>   sunrpc_exit_net()
>   -> ip_map_cache_destroy()
> [ ... ]
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 552d0e17ea04 ("sunrpc: convert queue_wait from global to per-cache=
-detail waitqueue")
> Acked-by: Chuck Lever <cel@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D40

