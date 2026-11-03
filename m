Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717254;
	b=u20xhdCtT6PHNTFfsRItYBBpJotsBP9QMu8QeEuPwfbsL22gMcuANgHQyZg9WG7HSzbs
	 Kd2R65CRtrRGAzqXlV520JKOaP/ztHqhfdiQpsrIBHLBK45XajZrIncsieHxVAFwGL/2Z
	 Hlhpns18ETXCm/8FTrAlCDX1x7roa/WZmc18JYiT9aAWfKVfw9sJrJJfYAJgwHrurYQeI
	 y94Evio6PJfd1O9z3SuQpREXjxxdTJyTExywgC5lY4tv/GcevRUAdewYI/ckufkwKg/SV
	 viOlkG8F+WeOIDuyQQkCRCIiHfj+Njh0qZY6L9swKTs5f8c1wWh3g1gPhZTRMWTITrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717254;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4+bnBfQZju8fpAB/8X14BeZjZQCkdXf0D+qDeon2Ak4=;
	b=ntCXVu+Jtq4/TFnvjGTOx5jfPHLxZ1uJxb6bSQ8jOBR17fONCcGWNpLBuMtlYIy/ugDU
	 fLkzb2hlYWqepjvBiKxB+p0bdfDyGUIra78EolBLSNsV3GnZsBngyx+gPjDyxR3b+l9+N
	 kamnu9KgndD0fiXle3FX7CkWNpKc6ld+nVhutpkNfBvBtyzMgvyhAEit+JnkAFdq2TzQj
	 RMYHnqeTwtj0nChVmizCyL2SvoxbXfcMmVm5bFm0KbducGVTebWoZwItySEVPpKDa1iZp
	 dQdCPMt+nIduw/gmEgmwcVv7Ow4s9Rrq72h6D51VBDoWZ0MVQc9fB6pFeX2i8ipHFYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RMc4cr4T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3185C606D80C;
	Tue,  3 Nov 2026 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RMc4cr4T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E0F1F000C1;
	Tue,  3 Nov 2026 14:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717253;
	bh=4+bnBfQZju8fpAB/8X14BeZjZQCkdXf0D+qDeon2Ak4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RMc4cr4TMiothzZr1gQV3jJQjTeueKFUXv5zwuxzcbh5/HdxeLC2IglsSlv1VEwFv
	 Ur/LQ/eR3wSsqQbS8ZUk0SCD2Jx4kztRhXfrHkH4Xo77UmXiqjwaE6vDGM+mgmJYHJ
	 tuYlF3IhQZw5QVy6DfHtL2C9tEk+v13TCjTgx+HnNYr8+fPG6IYPcoxzaksDgA2jAp
	 31qr2fSSwX5A2grnozzQ2Af9r57Tn+8pY9j8ePIL8X9VbUZE1bN2J7wgKWw8Wgp+BQ
	 6U7CHQuUZsauwLE/6W1MtHqTP42XyAHvVqnScnEzcPB+Ebjn8acd6ZXDg8/h4mKSSS
	 gUZdMs5bhS6lA==
Message-ID: <sashiko-outbox-195475@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 03/38] netfilter: xt_recent: don't remove the proc
 entries under a spinlock
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-3-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-3-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> recent_proc_net_exit() removes the proc entries of all tables with
> recent_lock held. remove_proc_entry() waits until nobody calls into the
> entry anymore, and reading one of them takes recent_lock in
> recent_seq_start() while procfs has the entry pinned. So when a reader
> gets there while the network namespace goes away, the exit path sleeps
> with a spinlock held and bh disabled, waiting for a reader that spins
> on that very lock:
>=20
>   BUG: sleeping function called from invalid context at kernel/sched/comp=
letion.c:116
>   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 12, name: kworke=
r/u16:0
>   locks held by kworker/u16:0/12: 4, last CPU#2:
>    #2: (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xbf/0x860
>    #3: (recent_lock){+...}-{3:3}, at: recent_net_exit+0x3d/0x170 [xt_rece=
nt]
>   Workqueue: netns cleanup_net
>   Call Trace:
> [ ... ]
> with a proc entry pinned takes it. So take recent_mutex instead.
>=20
> Fixes: 665e205c16c1 ("netfilter: xt_recent: fix namespace destroy path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D3

