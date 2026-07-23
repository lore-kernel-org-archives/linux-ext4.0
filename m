Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CB14DD6DA
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812176; cv=none; b=OCYoX447Yp6pm5+napStQ0e5uS1CHxiEZQSLHU2yPQ73x8Cz53JkXFPvOpOXnxbClXKOi5fy0R17xJeLxfxSgF8wbQ6TiMFuwjsliVwNjc8QYDROj7SUCIVR2muk+3Zj12dw34BUJji2NVDT0+AEkZD1xdF5I3/828jJCnXkpdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812176; c=relaxed/simple;
	bh=KnsXRr0+DH4egSouVKAH0TjMQh+oRBQ5/LiyQRMWKDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ms3PGfmA+zugRHUupseh5///4e3zEv0wM1qyIuruuqTHLgIfotib5jix4MMvgSiLbXSUaYZkkehFvlF96MxvpxwS0rXIjRP7dHZX/yiY3yanRRbmqtlfwCxqxq8z3HF3RQTQksAKNs3z5hU67p07NtqBAQYcDFpWb2rUwNwrsAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=FClMtTq9; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="FClMtTq9"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND92fS017914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812145; bh=jdWuApn1xQm7zxrcQwPWBOgZB7hCiX4Wb6jaGSn4Xb8=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=FClMtTq9pSTleuXEGAdxXGKQYDPrxWvlpfBQhT+L/Y91KXmK7b9v4akWqPISL5824
	 +W2mJCwoFe3R0r9uFvT1VHfjmHUOgunTn/gCr+88WTrMMOW1blrDVKRzzJKvOvA8gQ
	 noLcfLjY1EV79O+6eiEaBGoWoQWytU2iqjucvh54MSIdY2I8Kpnkq3NM9VRGp+rR3j
	 vIve9McRTwG9nuBRYVT/fsJvaOoO2KevL5mHQL1frn8UuAS0JeDJmDVLpDqh4IBO7C
	 AFrpUJTPg42+9y2q5s7xEa08/7c6vf2PtpzsF4v4T3jQJsmwQY0NF9EqHk+UmiC0Tv
	 UeGgdJTecIcCw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id C55262E3F1D; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca, jack@suse.cz,
        yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
        peng_wang@linux.alibaba.com
Subject: Re: [PATCH v4 0/6] ext4: allow more DIO writes under shared i_rwsem
Date: Thu, 23 Jul 2026 09:08:45 -0400
Message-ID: <178481171741.796182.4956323917321468146.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260629113827.4074335-1-libaokun@linux.alibaba.com>
References: <20260629113827.4074335-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 29 Jun 2026 19:38:21 +0800, Baokun Li wrote:
> Changes since v3:
>   * Collect RVB from Honza. (Thank you for your review!)
>   * Dropped Patches 6-8 (EXT4_GET_BLOCKS_CACHED_NOWAIT handling,
>     cache-only lookup in ext4_iomap_begin, and cache-only lookup in
>     ext4_dio_needs_zeroing). The NOWAIT support in ext4_map_blocks()
>     and the i_size anomaly reported by Sashiko are pre-existing
>     issues, not introduced by the lock relaxation in this series.
>     They will be addressed in a separate patchset.
>   * Patches 1-5 and 9 from v3 are unchanged (renumbered to 1-6).
> 
> [...]

Applied, thanks!

[1/6] ext4: prevent sleeping allocation in NOWAIT write path
      commit: 07d62890ef19e41a87735b8fe1ec65922b5ecd8c
[2/6] ext4: drain in-flight DIO before buffered write fallback
      commit: 15cdefd0c0522f9d5e12d947fa04f4c11649b699
[3/6] ext4: skip overwrite check for aligned non-extending DIO writes
      commit: 63b314a7795e026424e5b3a4443f854c51c839f7
[4/6] ext4: base unaligned DIO lock decision on partial block zeroing
      commit: 07961ebb09c9c9fd7fd95fe9fa6d1455df41a7dd
[5/6] ext4: use kiocb_modified instead of file_modified in DIO/DAX write path
      commit: 59a9d0814d9f2566ea127a993f5b602da913a61a
[6/6] ext4: fix NOWAIT semantic violation in DAX extending writes
      commit: 802b8aa8ff6b5877610a62b99b54d84980dcb8b0

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
