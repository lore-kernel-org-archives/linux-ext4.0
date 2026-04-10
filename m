Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CB63E1CEC
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834354; cv=none; b=dX1dtzZMDZWKGxi+Zu4rjlXMT24MU+tKumMUecBPYwXSncNGta2EyhZxF8gUp6xQACGkCoRtSlP0YTSJLcPrT/4D/Wtwh2IrQTRMcfg8ILCLp5W0JfDyKolUqatakvvftmaLuUEyXeKbodr1RdNn1430wgk7HrB6hLaX+u7ugHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834354; c=relaxed/simple;
	bh=yjy+VybcZwTxn/hQQPfOioIQbWEUa+8pmeeWkKqVfO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kMVmTROYK9bvyDwN06BYEjAoPzP+EUnT8kTu477QTwvqP6YRBiboZNPHUGNFO1oEZbNwodGxBGPS15W2z6tZ4fAUuFUDl1A/kC+9yGKQI1XT2dBaa1LxCX3ugi15MnxGq03VRO3ORq1854WsqPKjt2MZRPCcLiWbYwy1Q6D+k0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=JBuLhzZ1; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="JBuLhzZ1"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFIne0015807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834332; bh=uBTt6Lm6ZXcyr+/kAAWhmKpUxYPnkYfDAi8KW4TxZjc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=JBuLhzZ1OVlVyAolmq9ZU2okfWeFKh8SB4nXaBYWH3NJNPwbOLchM4oIOicAP10gu
	 TrfFTZSJIqX3z/M+WospTxEC7XsHjwFLQeb0zrVUCwVNqoRNXm0xI9fLsEf5aTN4vb
	 tbJYzPOJFMbpesTHUSDWThHQPVuWAyJExpDzIRG8JBDT44I0MIKvip9C9oZJjh80PB
	 oE4UGEtEOw/9sejryN7OnlcYbMIE2EllNbi5jGTagChG5WEt1TCWldhFh0z4psrKz8
	 EzGP/lXZGM2LrxwaMVuQ1Z4PuCAoq1jqlWsRv4bStFtlBUXzdexRC078nXOLT1Z0X5
	 knv8K1imw1JWQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id F1B502E00DC; Fri, 10 Apr 2026 11:18:47 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, willy@infradead.org,
        Deepanshu Kartikey <kartikey406@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huaweicloud.com,
        djwong@kernel.org,
        syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] ext4: unmap invalidated folios from page tables in mpage_release_unused_pages()
Date: Fri, 10 Apr 2026 11:18:35 -0400
Message-ID: <177583430850.2758959.10293506884129885872.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205055914.1393799-1-kartikey406@gmail.com>
References: <20251205055914.1393799-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 05 Dec 2025 11:29:14 +0530, Deepanshu Kartikey wrote:
> When delayed block allocation fails (e.g., due to filesystem corruption
> detected in ext4_map_blocks()), the writeback error handler calls
> mpage_release_unused_pages(invalidate=true) which invalidates affected
> folios by clearing their uptodate flag via folio_clear_uptodate().
> 
> However, these folios may still be mapped in process page tables. If a
> subsequent operation (such as ftruncate calling ext4_block_truncate_page)
> triggers a write fault, the existing page table entry allows access to
> the now-invalidated folio. This leads to ext4_page_mkwrite() being called
> with a non-uptodate folio, which then gets marked dirty, triggering:
> 
> [...]

Applied, thanks!

[1/1] ext4: unmap invalidated folios from page tables in mpage_release_unused_pages()
      commit: 9b25f381de6b8942645f43735cb0a4fb0ab3a6d1

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
