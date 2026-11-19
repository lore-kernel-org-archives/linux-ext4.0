Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099696;
	b=oA/juUN0mK7i/r1NCD1MmCIQdtc6LuOnKGSt7IYo2c+ib1hNrvOGZtGXdBq71WPBLS4M
	 vAqhZrnKYzsgl60Ac/NArqYIeytuReC/IG55/WLsBTB5c25bplJe0FrVJml4cjbh9WrLd
	 3IUeSLAUg6keqIjhxoyeD0UTFjLbN7emwCWbfmaRSLyRAhvzOrt26kFS0s9aIeL1z0zAi
	 xytpsJnF4hVF+dAazgS8fyFsBAFj4byyGWWoN2VsKClpce9FDiksHwfSQQ/AcDDRs+E0n
	 btQf886rW+gJ+pEnahLId32i3SOC3zWLS6MZ/1wXDLhHpMsJ/qi5dkG4kjLop7G499A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099696;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=pOdqmhFSO56s8tpZHeWtvocGGjdNr5yTR91PreTEn+I=;
	b=mIXGlwTXOYrH6xdgj9eDl3x7MBhHX7KAq3QAgylEUUFScE9sDNLhhym4UxNQEnIq7eHb
	 aP8j9I0W9JJo+O3Ds1loXkqC0QM0ARDUOrOp+fsRk+RLorM2eGg6SILexWShBzc9KzCAT
	 puFtHz0B05tN/fZme+kmoaLqf07Vcj3Cd3rkVBquWmYIBu1q1qtt/ApG5d8SHjOYJFfA/
	 hcngrA90mN3OK4ShlpYZXk49FF34yxtLSNESP4aelyoCyu6fvYFFOnfDWG5GiOd7g6ocW
	 ptlZ8+rgyhgNBBxtanK8wSuWqwbfeIPWQWcjp19iOvOIso3deXn3HZoYlQwE3Uu2/Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=fK0FcpKx;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF065606C33C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF065606C33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=fK0FcpKx
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJEldel018052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=pOdqmhFSO56s8tpZHeWtvocGGjdNr5yTR91PreTEn+I=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=fK0FcpKxnT0VMf5FOTOK6IeY1oyGb311deg30AlBKZx/ZmtYcmTdTaniknHg2VuGM
	 M0FEM79eRay/5doiG3HaGgzgHF9eJfDqwiyg4NCVMYcWO4vRik7fHBHuBLPzz1WxQi
	 2rrNcZGnXSrT8BEuxj9HLbd8FDj7JTuZlt6JgjPzOmMIGyAkApT7cKZJ00k9vP6OL4
	 BnR80qXnRrKm5sY59zQXgMrhHGOwp2hqWQzhjJ4YbSlcRN7SMAl0q+aBJshppUXjd1
	 zYAdFBX2JgQDJjyYGld8NcyzREzaJZyZ5g5XxhYi9HAH7AjzKPIvSvowr6y+Ceak7J
	 6tFwSckXaHmcA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1D8C02E0162; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, hengyul@cs.unc.edu
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: do not accept rec_len 0 for block sizes below 64k
Date: Thu, 19 Nov 2026 09:46:59 -0500
Message-ID: <179509948693.1938961.4300352881330928282.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261006111546.3252481-1-hengyul@cs.unc.edu>
References: <20261006111546.3252481-1-hengyul@cs.unc.edu>
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


On Tue, 06 Oct 2026 07:15:46 -0400, hengyul@cs.unc.edu wrote:
> Commit afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len
> conversion") made ext4_rec_len_from_disk() read a rec_len of 0 as "this
> entry covers the whole block" for every block size.
> 
> However, this special value only exists for block sizes of 64k and
> more. With smaller blocks, a rec_len of 0 means that the directory
> block is corrupted. As of now, a directory block that has been
> overwritten with zeroes is treated as an empty block. The kernel no
> longer reports the corruption and can store new entries in that block,
> while e2fsck still reports the block as corrupted.
> 
> [...]

Applied, thanks!

[1/1] ext4: do not accept rec_len 0 for block sizes below 64k
      commit: a816507bd36b7199e6ca5fbed81e06ceb67477e8

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
