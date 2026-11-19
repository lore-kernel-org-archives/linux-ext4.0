Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099690;
	b=YlwlFY77nCdFaJ2sj17O+8QmWyq19Ea6hTQ0bW7Xv8OC2r56JyW5dqnW2q0NRxV7Y0HN
	 r+0yEp7+CDQ1xtNnmWUKkXdEqk3UJjDUjai57sGGANnwpOhK1ckq53Hxlu2WBIMemGpWp
	 gNhcn4SGmWlFbV81uSILUWtTyHDhHsZe3XW4US2yACR6x8mvebBxVWJPU2FtTTjFsEbmc
	 zExj0lNkIJiWTGFTRa63mWznTjp91KgrTNnPfUiiezay2Xqfu12n9NAENvTBJQWUSR6Jj
	 yuQWIpDp6PEjYhi5cCVVPnopt+K9Ck+CNfQgMy0nbwtQsFCYK3z8hW8hqpz1ASCOlFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099690;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=rv/IRrvWwgDAbywH9/r3JWKqi1lmqQL4KXRf1RgZ6aQ=;
	b=ZWJvtB/LWsMI9qVc4KvMN4dLbqcS4RW+rmXpqM3b3rvsHUzVDHqGr6xZ2bZ9e7wY9a5s
	 sM3vsHVNrT/Z2VkfrqdCVytasI+ia+9ZWaVtPtQsD6xox1/9GWBrSI/J3wZwHdfP5XQau
	 aKjvXSvRrPNeJ6nyLAv2N4FxAThnOJV9QCg7N6oWAyQEiNjyU7Q08QdC/Zq9gIPFE8i1i
	 R4gXH4IGezYH7+6eetFdhQNdOfl2j5fHK7fzQdpDnoYgmkkVRHb3xO3IUeaacn6xTlLlo
	 0uzbIqndtp48b6gZvFInGOVvegYEOT7qWN2oOxObooTHySppPk02GPfme6qjVOcstnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=D1htSjK0;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA2A606A82F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BA2A606A82F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=D1htSjK0
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElad3017877
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099658; bh=rv/IRrvWwgDAbywH9/r3JWKqi1lmqQL4KXRf1RgZ6aQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=D1htSjK0Hts9D0xndG5TkMMSZPc5l7qlt+IP03+oyT9ezlqVBB9uUoRqHVHhp72H3
	 wdeRaOZEv/PbV2mVWNXmrZA0Q6vFkuKZpIyCAkxzh763e2aoFTLZtrEjD3ZwBS/na/
	 D2mTbZHP0+rua9nvf7aHZrRNWWmieMXyNKGfZXV6af69/LnXVQQ+ZzhTp+KL4lDpt4
	 +hIVSzm5IZUYANG/0xSI7pDdQs1X3d7CI8xQXLoJ6aat67AGk7I5HQz9/cTxxbm0ec
	 WQz0roV6VFrGMr5gfLtIyz4Xj8S+SLdk769iSZTKjmZbL1axqi9YpmXScYZfeR5/A8
	 LfrvU5GXIFpuA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id CC2572E014E; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Yichong Chen <chenyichong@uniontech.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: clear journal restart indication after inserting extent
Date: Thu, 19 Nov 2026 09:46:39 -0500
Message-ID: <179509948663.1938961.15296142097657925008.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909033542.3087876-1-chenyichong@uniontech.com>
References: <20260909033542.3087876-1-chenyichong@uniontech.com>
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


On Wed, 09 Sep 2026 11:35:42 +0800, Yichong Chen wrote:
> ext4_datasem_ensure_credits() returns 1 when it successfully restarts
> the transaction. finish_range() leaves that value in retval when the
> subsequent ext4_ext_insert_extent() succeeds. Its callers interpret any
> nonzero return as a migration failure, so they stop building the extent
> tree and take the cleanup path instead of completing the migration.
> 
> Before ext4_ext_insert_extent() was changed to return a path, its integer
> return value overwrote the restart indication. Restore that behavior with
> PTR_ERR_OR_ZERO(), preserving insertion errors and returning zero on
> success.
> 
> [...]

Applied, thanks!

[1/1] ext4: clear journal restart indication after inserting extent
      commit: 3b6aee59883c3056bb0a5e7491f9dc995bbac964

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
