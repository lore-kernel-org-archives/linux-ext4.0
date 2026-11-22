Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795372019;
	b=3AVSHXnLpDIwy/6y0rr7MXBAdamz08vl3KQs6l49nWBGYNE0JfkK0yciimSjbVx5xmyn
	 V8xvaaJ8YOpcdTgi2D+6bxUwLvhwBhoddizdfjAKzkrHBqqIiLJsazmuKe9D+PfZy5Q49
	 TZFdhPXbp2E0KKSAUwyblUdMTuZtv6L4BfhPU2HjGc6RboxG+4yk7SB5FTyqZFr7BphUs
	 cCEcrpMOHUGgJaIyRBbLKioJg6MqS30fTpD2QIHtEwlWl8K72j29d5ukEgHZb+3r/ix/7
	 p+bz8NLdZ6xFD+LaAHk2/Z/XI31MOzcGndajZ1SlN+FlIMh/0OH8kOnzircKqi+Iqig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795372019;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=suHQxPI1DVGXrADNU5aI8WsfNTzLpZPR7SYKPANE0KA=;
	b=hLkFgpidZVZiWqAnqb/zfzFPj89E+pwDfb7asPaTj9huid1pNF3m8YbYItjtOyv+xIKd
	 O+jyBCYrIDdB5H5wK/J2q4xp5gVj4bbP/Tzg1JZqkadoxXtmtzVv53DtSJmZ8ekPyxY0W
	 nXmL4rnev1GMKBTVCsMV/fKpHzCShrwAq0APt9jRsh8PwvCWFLFfh9Pmu8g5t8pAVkiux
	 vicRZbseh7Jco2cgVMk2CcfXOhrx3/XhZnyljh+pLQ3YG6qjpYbSryoX02F6hko+nDs9X
	 2/sn2spquGGLJGjFNvziV+6XY2YURgra87Hv9RBrKRPCKaCZSPn9E+is2guPYgRSytA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c6t6hsZM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE3F606A336
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 18:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c6t6hsZM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A8F1F000CA;
	Sun, 22 Nov 2026 18:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795372018;
	bh=suHQxPI1DVGXrADNU5aI8WsfNTzLpZPR7SYKPANE0KA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c6t6hsZMTAtRYhmOl1zjqOwRQTd1c7/oz/b05vb1VRpTX7PqeKIBMO1aLkw38jJc0
	 Kh4M2+qcFjOa3WXDvlDwTDei5xdHmYQxgYNAJRndDqa99xXeN8DOSqPmKXv5XukDhs
	 OnTlpT3DLa/YaTRopvP9aG62rkhCnHzt80HDNTFAVlmVp05AKgXpHjN/5woVaUvjx2
	 6Hw6mCfVQ9dZMrodjvHzDPyhP0vNSqo81qSRikJCy5ZCxxrG7kiwzDHG4rt92+pqiE
	 6tYLjtU4zBxaAJUTg1qU8bmopZKVqJeMSuJ2zPVZtacm/YNDXNpELSYo6pOcTjf2jq
	 XE5sS3XBZOF3w==
Message-ID: <sashiko-outbox-228178@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext2: handle NULL fc->source in ext2_msg_fc()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arbab Haider" <arbabhaider649@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261122182331.13740-2-arbabhaider649@gmail.com>
References: <20261122182331.13740-2-arbabhaider649@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 18:26:57 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With the new mount API (fsopen()/fsconfig()), userspace can pass mount
> options such as "nobh", "dax", or "reservation" before setting the
> "source" parameter, leaving fc->source as NULL during option parsing.
>=20
> In ext2_msg_fc(), when fc->purpose !=3D FS_CONTEXT_FOR_RECONFIGURE,
> strrchr(fc->source, '/') is called unconditionally without checking if
> fc->source is non-NULL, causing a kernel NULL pointer dereference:
>=20
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   RIP: 0010:strrchr+0x24/0x80
>   ext2_msg_fc+0x157/0x1e3
>=20
> Check fc->source before calling strrchr(), and omit the "(%s)" device
> prefix when s_id is NULL or empty (e.g., when source is unset, empty,
> or ends with '/').
>=20
> Tested locally in QEMU (x86_64, KASAN+UBSAN) using fsopen()/fsconfig()
> with NULL, empty, trailing-slash, relative, and full-path sources.
>=20
> Reported-by: syzbot+1d23ad199a3bfd6f9149@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D1d23ad199a3bfd6f9149
> Fixes: 98f18c76c2c3 ("ext2: create ext2_msg_fc for use during parsing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122182331.1374=
0-2-arbabhaider649@gmail.com?part=3D1
