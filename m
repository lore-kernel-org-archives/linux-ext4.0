Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02972D8DBB
	for <linux-ext4@vger.kernel.org>; Thu,  4 Jun 2026 14:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584394; cv=none; b=ppk0AHnRKRp7b9jSmIhtIitjmN7p4z3/9g6g+YfnxGcAUugEOugXv9ewbqKyoWzAbBo8uIrq/+TvRH8VISthCuylE6wJzDpxCZecE/zU727HudYVEi3bo8O/gGDwT4G9B6zwb/KoIYaNuxUvuuyIJUcK9e+NYx1+Nmpr/4e35Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584394; c=relaxed/simple;
	bh=SQc7gFLzJwov/Yoap19Z6pOupwK0ikJmeGTaBABXN7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kV1QzdYQTFIniy4lloyxAZf+nhZZph711ET3frtWA3Wo3jnz9y0OLhx0b4cjezRZcur4hn8o3ABBlZfdtD3JTKGtePG1KNe02dLkEm8QMCLYKztKjMxRpNQOt9uVqZeJY0P/PSLo5Nm/UMpUmfg0l26K+AGsbSUlTQf8wA0DHlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=iGP8jaFw; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="iGP8jaFw"
Received: from trampoline.thunk.org (pool-173-48-113-247.bstnma.fios.verizon.net [173.48.113.247])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 654Ejv5T012381
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 4 Jun 2026 10:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780584361; bh=b5jjhhJ6yvNPdwRubcnLjRYC1Snt+Ym6i6t1zTYWXNc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=iGP8jaFwZKxBrVvvnkuWKPSNpTm65nBqyg93NXtrl7mIbCyRsfge77N2HP8vRVVC0
	 qn3oeRfntg86o8A9HFyeRFoioh0r15GrF6Atlm9ffoVMiyuSqbkU44jVDOfq4SvGSH
	 EXZEDlCESUHTE/QaKC0xmAQxARQvGxOqh6Byj3RzR5H+jncYxgZF6x08YBDPGscZOQ
	 opCvVMKuDEeiHxXeKxIWdCnypi8czBDe/QmIP6TWDgLECNsYAnD4MIl6dNNMgWYNEU
	 1vMmrm2w6yoXn5bTBtY7m+cbXVf2cwE5my5voaxhl3+krwSTQGXFkkbppBSPnm/eMh
	 UFNaDAFkS+43w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 6C9422E00D1; Thu, 04 Jun 2026 10:45:57 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Li Chen <me@linux.beauty>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sashiko AI review <sashiko-bot@kernel.org>
Subject: Re: [PATCH] ext4: fix fast commit wait/wake bit mapping on 64-bit
Date: Thu,  4 Jun 2026 10:45:50 -0400
Message-ID: <178058434000.388727.1594741203815721655.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260513085818.552432-1-me@linux.beauty>
References: <20260513085818.552432-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 13 May 2026 16:58:17 +0800, Li Chen wrote:
> On 64-bit, ext4 dynamic inode states live in the upper half of i_flags,
> and ext4_test_inode_state() applies the corresponding +32 offset.
> 
> The fast-commit wait and wake paths open-coded the wait key with the raw
> EXT4_STATE_* value. Add small helpers for the state wait word and bit,
> and use them for the FC_COMMITTING and FC_FLUSHING_DATA waits so the wait
> key follows the same mapping as the state helpers.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix fast commit wait/wake bit mapping on 64-bit
      commit: 8b3bc93fee6771775243665a0cf31857d6659775

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
