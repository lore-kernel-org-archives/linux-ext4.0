Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099695;
	b=nSxFnVH+06r8ljsHBZmAzxiegQ1iZ1XZAA9H2QW1zDvY5N7oNrAFfqRiu9QvF7kMjE4V
	 KjKZxT4n9P51r3wBW01h3CrgJQ7AocxDQb6pPuh1CX9bOsdPyx5XUYvvPU8bfe/lfoPqd
	 LVcVzO8H/0/nw5n2hesOsgWULIXuxxZcbp889ymSjPFcXxdeOAyvOXNfTpRMEiWX2XDr5
	 sYT0vJIiHYD6Mv2fWO8ouCwTiEzqixZM7YpyILLKKfezGc0kQeUwDd3Bm2xh+7/00qV3O
	 8E5O+tL59XrUU+YNhQbx8rCd3zfYkMI7H7rMCy1AHHfKQHARMVMkFnr5979cTmnDGTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099695;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=jsYMHwoX6oQWePiRS5Y6oYPtj0U2E/irrnptBnOipMs=;
	b=Pv5WEn0kZkYKTEp476OW//GWRJqIbRmVH5bfYg60Ag/gjLxWfhCVywyOQdMdvbRo95+A
	 fFB7xjCvxGMR4/+pP02RPAGlz7bZi1hzKuzbxEYLLp6Bs+MjUiTXEFd/4lapLdpah0DHL
	 HPNcpG/DKthwxGo0P6wwB8wYSNFFY2m3PZvl2azHOlXSVMarc/l/usqb2d8K0uTYNC74U
	 C904nxjFuUUBSAqmBG8x2muGTylW2R3YHaIDCAfSnXsuN31KUPSir8nDo10kVpufJFbfS
	 UVzTALvLJ466nrGQxYJe6OOpP7m/W6ze/ELUgGK8S/ZrSv8XJoYh9cuhhsXcgRAx2xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=PzE26dOx;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29219606C323
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29219606C323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=PzE26dOx
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElcWf017952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=jsYMHwoX6oQWePiRS5Y6oYPtj0U2E/irrnptBnOipMs=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=PzE26dOxm+CVHNyDtMjDr5QH5v5OMLXjsM29jvU5k65BpVqHVH4z+R9m3hnKdK519
	 ecEVt+EpqK9DxM8jHC2pJgFAAXYSDRTFlyNwEePo4U93ykX+4jhS4YOID7LlAyrRJA
	 vcvKTt3PaCeo2G6K2YkNShkRgfz8o//Y8+oDKqVYrpzrPpy4XpCWaCoSlDI8exuhSC
	 /btXygibUXVnfhtHg1ftLvU2ufUrrrPHHA6N4oToHHwlfblK3Q3DgMixsJOnrOuYFy
	 UeiCOf2lH1+mKAPrfbPDp9WTFkw+BC54+jZzR+ol+SlhpBUHwqgkBqEBmF3HSdFphK
	 JYjI0XCJ9wIEQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E84A92E0156; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Daejun Park <daejun7.park@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Li Chen <me@linux.beauty>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ext4: fix fast commit and extent status after unwritten extent zero-out
Date: Thu, 19 Nov 2026 09:46:47 -0500
Message-ID: <179509948698.1938961.6887456285347536083.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008-ext4-fc-zeroout-v2-0-55cab1e24fa3@samsung.com>
References: <20261008-ext4-fc-zeroout-v2-0-55cab1e24fa3@samsung.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 08 Oct 2026 10:25:35 +0900, Daejun Park wrote:
> When ext4_ext_convert_to_initialized() converts part of an unwritten
> extent, it may zero out the blocks around the range and convert them
> too, and ext4_split_extent() does the same with a whole extent when a
> split fails. Two things go wrong around that.
> 
> 1/2: if the zeroout fails, the blocks on that side stay unwritten in the
> extent tree, but the extent status tree caches them as written. Reads
> return old disk contents, and writes go in place without converting the
> extent, so they read back as zeroes once the entry is dropped.
> 
> [...]

Applied, thanks!

[1/2] ext4: don't cache unzeroed blocks as written after a failed zeroout
      commit: b8ae46fd81bc3f7c537f0180951fbec8cf686c5e
[2/2] ext4: track zeroed out blocks of unwritten extents for fast commit
      commit: 9d3c10898c648d85889e53ff742c6bc8483051f3

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
