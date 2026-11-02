Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630553;
	b=rmueAip7dawTabxmEryLLcrrgxGNhFYEXyrpyq1RuqBnR5NVuOL7d4+vuGgLHmeMKgPq
	 /EoH3p9B/9WpeD5KgOikY2OST3SnJcYIz15pPSest/2aBAeeLfoknuhuX3vGlAVY98Pto
	 brFfq5QC9z3mBbefFhThF78XqeKO43rZEOEg64J4n/ZUXVBO09qfRgnPZxgjltRnCvqkv
	 Ge5M0AVyN8nXFv48hXZo2TPwxUOPM745G9e6kkO0E1UNYfUyWPrrSQH5Ew9LuzSyk7d2H
	 s2UjAEyU0Jf0UTMcJacpgit3HoNbmV+s03aTA06oZm0tMYcTasv94EXe0P1ZR2kNnDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630553;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=t8J2du8KiJdNIeX+OPzhHpF7+XTFCCaLUEKv314oRKs=;
	b=UwIDBkZtMZs/HEUPYPxmovU3BVUf9b+R//FLr5IGOCjf91PHPR8q3baZe1MmPqiYdCnQ
	 SnqLcUNq/0pnxznuAFWuHk6cVxKlOs8W/f0ENio0hLEaMh3cK7WFdpL1GlSJqElS0hmxY
	 62i8OaY1rlE9YZw8sEmecGpD1gwetClebiQKaHuEGs46GZzed7lEB3MTOFhZrgvqDPJjH
	 wr9VGfQFYBd8lXHpcmgsvBWrfSJuLkkP/VnUx69GV1+s9PU38n/zxzN86mSitVW39a9WM
	 EOh1uV+yLAemjUdMTR1IgzK2ZNwNHrwo/wIjRG8GvDGeeDwWlVLSgPDPilVN6qPlU4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ILJHWP3V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54E6607E0D7
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ILJHWP3V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730FD1F00A16;
	Mon,  2 Nov 2026 14:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630552;
	bh=t8J2du8KiJdNIeX+OPzhHpF7+XTFCCaLUEKv314oRKs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ILJHWP3VWd6ixkpz5PnIznZpqUvKaX1ddYektoZlcoXUGrf7HGjDVKFPFoUKuMDR4
	 45squM74TX/V5MSjENNKXGGk7tJ9lswZVyndRAD+k6+ZKvyz/bRvFUD/nomEq1pq1d
	 vXrdLvNNqzplqJUCkeN7/EFUPpESaboylJ40NyeOc+knfj5OxzPwqoinch0jmXMw0b
	 ExdxXyo1m7aCkbMXhIOcSqO4JnXOt0viIQjXYajzOfbBgPgALLETXLm5VZJam+IyGL
	 /6Cj0170w/IcmDOSP/rtr5md02+7o0u1Ank8JypLibYZsI1PUeYKA3o3UJ4z6tYFHA
	 B9hO3w9iHwskw==
Message-ID: <sashiko-outbox-193594@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1.y 1/2] ext4: fix NULL folio dereference in mballoc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Elliot Berman" <elliotjb@elliotjb.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102-ext4-ntfs3-null-folio-v1-1-4fd91ee23a4a@elliotjb.com>
References: <20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com>
 <20261102-ext4-ntfs3-null-folio-v1-1-4fd91ee23a4a@elliotjb.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 14:42:32 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> In 6.1, __filemap_get_folio() returns NULL on failure. The backported
> folio conversion of mballoc keeps the original IS_ERR() checks, so they
> are always false here. The fast-path lookup in ext4_mb_load_buddy_gfp()
> has no FGP_CREAT and returns NULL whenever the bitmap or buddy page of
> an initialised group has been evicted from the page cache, e.g. by
> drop_caches or memory pressure. The next block allocation from that
> group then oopses under ext4_mb_regular_allocator().
>=20
> $ echo 3 > /proc/sys/vm/drop_caches, in 0.51 seconds)
> $ dd if=3D/dev/zero of=3D/mnt/b0 bs=3D1M count=3D4 conv=3Dfsync
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 5f19067 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 0 PID: 908 Comm: dd Not tainted 6.1.191 #1-NixOS
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-=
gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> [ ... ]
>=20
> Fixes: d34e4fd4e73f ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
> Fixes: 862483175d3d ("ext4: convert bd_buddy_page to bd_buddy_folio")
> Reported-by: Tom Bereknyei <tomberek@gmail.com>
> Signed-off-by: Elliot Berman <elliotjb@elliotjb.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-ext4-ntfs3=
-null-folio-v1-0-4fd91ee23a4a@elliotjb.com?part=3D1

