Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795801543;
	b=iOobQaeH7xa7fU2AnIbUV030nx9CGoXyXwMo9kuWewJsOEWPrSoLX+FSO9d5Zkmc2M6e
	 nZNZMclvtP0Kf+VbVp6jljejl01YpV3zXnduyyICR0z4y8xjHNGm92ElrqHTr85MCXOB9
	 xd+lfuO2+Oz4J6Eis783YdqofsI5gjKzarru92H1grl2uobBesG25cTfIhRQXi5R3Yp7W
	 QvF6dCLjwNYlrHLCpZA66BCo00Ugj8bpDh4jhUQnTeEEXfVRdVlAk/A0sQSokzIofjle6
	 8Qf7e35ghSLEQSP29Dyk5deBVyNP48Kj0Ah94gB93Ljyxm/TBcdVN4wah+DoUuwSfiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795801543;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3tIZGzZp9XED1eYsjC7AojoBXQ/Rujhkgy0uNyPbeEw=;
	b=jmci2s4VxczFtu2Nh8PeaGyJHT0/87kmMPb8EcDgXJS+PhWzYN0Evhn1j0kXUdGSBi0D
	 sSlyFbHqDzr93wwsbvQDKcOOei6VaozL/RW8Gp2CQxoxqNsflAXZwNA51xpKG9x5QaLli
	 3xxIWo8wvnFG9NeFvu1hG0SfJXmVxazZI69tqd6Vz5mGcR8CsaLn/Wsgw3Zq6Qi2PqK5T
	 wr0tb7k8ig73hVXcFdPevTdJwMe3CciSrwBksbhcaxRNTt7Uo0RYZio0UyVcRx4wkxuIs
	 /hzKJ0tTfOQgSABI2bc9C0kCYyjg2n+JqWKV2bjvemcEA6WgVO4bV/GtxqLQyNE0USA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uW6sUxPu;
	arc=none smtp.remote-ip=91.218.175.207
Received: from mta0.migadu.com (out-207.mta0.migadu.com [91.218.175.207])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E0D606A31F
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 17:45:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23E0D606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uW6sUxPu
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3tIZGzZp9XED1eYsjC7AojoBXQ/Rujhkgy0uNyPbeEw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795801540; v=1; x=1796406340;
 b=uW6sUxPusHYXxL1n7RbsyImfjuRZtOucfzvlLg2Au9CK+TtjL7RGU7uCv3AbGHlH+NFCBOBu
 r/qv++sQCU68oogFTLYxyLEnfysQCq58mtBLGZAiO95xDdMvMFqI80T2hg8CI9iV24jW5q+hoRN
 e3avGhDmoA66Vaskl+ueb3fw=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c4796adf2f73c32f;
	Fri, 27 Nov 2026 17:45:39 +0000
X-Mizu-Trace-ID: c4796adf2f73c32f
X-Migadu-Flow: FLOW_OUT
Date: Fri, 27 Nov 2026 17:45:35 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: Zhang Yi <yi.zhang@huaweicloud.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	guolingxing <guolingxing@tju.edu.cn>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] ext4: silent data loss when a split at I/O
 completion gets ENOSPC
Message-ID: <20261127-jf-ext4-enospc-reply-zhangyi-r4-3-59ba31e6e023@linux.dev>
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
 <20261117-jf-ext4-enospc-reply-zhangyi-v9-b19eeb966ad0@linux.dev>
 <10712329-a587-496d-babf-620ebfd0e60e@huaweicloud.com>
 <20261118-jf-ext4-enospc-reply-zhangyi-v13-3886a3248c32@linux.dev>
 <9be1cb3e-4417-4609-bc0d-67dcfa24aa10@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9be1cb3e-4417-4609-bc0d-67dcfa24aa10@huaweicloud.com>

On Tue, Nov 24, 2026 Zhang Yi wrote:
> My idea is to make this a real reservation of currently allocatable
> clusters rather than just a counter check. We can subtract
> sbi->s_mb_free_pending from free_clusters in ext4_has_free_clusters().

This makes sense to me.

> However, the probability of returning ENOSPC for pure append writes
> increases by about 10%.

Our agents tried a close variant of it on mainline, with an exception
for EXT4_MB_USE_RESERVED. The reproducer lost 0 of 72 files instead of
32 of 72. But write() got ENOSPC on 54 of 540 delalloc files, against
none without it, with the filesystem at most about half full. The
writers ran as root. Is your 10% before or after
ext4_should_retry_alloc() gives up? Ours is after.

We can test the patch once it is posted.

- Jose
