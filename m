Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879AD4F7982
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812183; cv=none; b=lNrKNsjYZuBft0S0xb3g6uG2plooM78/ktCGANFtwleuDEblRNf1JrsmiOHao8T0vReEPl7in1jKWhSxxZv569TjoMnywWLEXn/8Hw+UUdISsf7dm3hl+91WRxzGN17Tria6HcYK9wCyt3mbnCaqW9vW0yyZXX86/wQ1GYF5U9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812183; c=relaxed/simple;
	bh=WZ6yLtZ8mERpnymfIA6knHpGr9SZy4I+obzVoM1OEKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M2nCY9ruOCFQQVcd/tLIEw7rmcN+ylAeLdbL3ijbmuve9IcH+MSC2/dCrrfjtwy2PiGcItjAxsY/NwAah2N86WMyOJEMez84+sZPkSGSmPm0EbehgM+dTuaxoe/UkNWzlSTBBsmxWCFyyZsjl0crqFQN9uVILGyICICh1PmqieI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=XOXAV72d; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="XOXAV72d"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND94s4017955
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812147; bh=lJSj8968yQOjhhZx3ly3NjQefq1l4/afijeumypJmmQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=XOXAV72dT/WzCf4+cmR/KCsVVM8fk1CbzYP0v2R7NLaE5po7zskFLUPTthKRZz/zG
	 /L3XlV7+0HOx7P0jGWDNfmZESu493CWg+7eHx5Ibu3rGc8Nopq0+ZQLLzEMsyObus8
	 Rt979UotrZys7CVLX+6ISdB7J6mxxhjmyMIOKmMrOtFzspsP6fEcNfXujiWzYdG4SB
	 clj5zT2L1E+Zl23zlG3cTMfqcuT0jYpbm80HFGmSTHrKpaJ/5vkLELn2PfKIRsCBGv
	 7fP8TT0ktxS+//SI6ME22ti8XSpQaOMktkUOjBQb2A8WNgEKNW1NnxaFs+3VRgTbol
	 u7nZ/rNV8z1Xw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id DAA482E3F23; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
        chengzhihao1@huawei.com, yangerkun@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH v4 0/9] ext4: fix unaligned edge handling in FALLOC_FL_WRITE_ZEROES
Date: Thu, 23 Jul 2026 09:08:51 -0400
Message-ID: <178481171753.796182.4122998257762869128.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
References: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 14 Jul 2026 16:00:35 +0800, Zhang Yi wrote:
> This is v4 of the series to fix unaligned edge handling in
> FALLOC_FL_WRITE_ZEROES. No code changes have been made relative to v3.
> This iteration solely adds a comment to document the race condition in
> ext4_block_zero_eof() that prevents zeroing of inline inode's tail
> block.
> 
> [...]

Applied, thanks!

[1/9] ext4: use FGP_WRITEBEGIN for tail block zeroing
      commit: e1cf7b5f5c8ad1e00d00c50c61c3e8fdc79cd422
[2/9] ext4: skip tail block zeroing for inline data files
      commit: 2fff82f081401a61a47e8171f6392d2b0cde5a30
[3/9] ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
      commit: 705a3fd3bac167f1dabe3d3bba46cd484c5528dd
[4/9] ext4: move partial block zeroing earlier in ext4_zero_range()
      commit: b16e9d27a643a3cf8907c994d25ed52717f36418
[5/9] ext4: clarify return semantics of ext4_load_tail_bh()
      commit: 012e6a2c9ff4d28abd4f32e4d68decff47297d06
[6/9] ext4: track partial-zero outcome per edge in ext4_zero_partial_blocks()
      commit: 4c1f6931395ad026415cbdb924ffc240f86eb557
[7/9] ext4: zero out whole block for clean edges in WRITE_ZEROES
      commit: a5179156ac1d9a6646da42254e4c461e1fc20096
[8/9] ext4: write back partial-zeroed edges in WRITE_ZEROES
      commit: d19d239ada9b7c92d086a1f051b7566538ee0089
[9/9] ext4: protect WRITE_ZEROES written extents with orphan list
      (dropped due error handling concerns; will be submitted separately)

Best regards,

-- 
Theodore Ts'o <tytso@mit.edu>
