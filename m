Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60A933E35B
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 04:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774584409; cv=none; b=gmipYQcsH1ZcjlTg9Aka4dQrelHQELUYgQOwIqRJteXX+mangjIFv1ZxBrf1UgM0yhh/FqeMdceC1ZjoXKlvWYiMLgp7eW7Mu2EIz1PbR/3nTmkptE545+anjnzeMF9ywAGYBDh/VFVIEfYCVFScDKqLjafNaARe7rwpfJWAc8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774584409; c=relaxed/simple;
	bh=PU1VVqJ7iONHwRy7wNiJq6XT+PygigdIz4a9pLaowRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DPIutiysk5/Upai8FaoUOAXfJv0vk7NDCVcm0WEB4MZ2RCaS/UIoF/TG/92Rzx2Q3JmRmtcsn6JNC5hy6P1OOR72jBMMB7xgz1wCovcuOTZ1t5bB9zuCddNT1I3au9L8n3YR84r8T+7GUaPMfaxJNuDf1GmlE836vphInTzpcPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=bEaGzPCn; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="bEaGzPCn"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62R46T6p005957
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 00:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774584391; bh=vP+y+riX484sDFCeC4W9Nca7aXxfJn55CpVNRMcGboI=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=bEaGzPCnvNfS1GcNVNQ8Hh7cziaX8Tc3dSuLWEacv+5J08tAcuzsgvW9ZGI8JCdCm
	 /UqPA2sB1ME8YMbAbGxEwYCx+LLPAaPrLhyyrMn1UiN+DsBPwWGUKwShQVVkjiFCmC
	 J8h0JiYrCoiP/c5ZZXWxwOFyVt9IdYIWSm6x69CBCX+e+fUfi9WQJUtHGeCp0xYCc8
	 AiyP4IslcVMqpZk8XXD2lBanAVTSw07E2dgYQKmf8eq7RRiPEsJLzyL4aatQPCMHrH
	 OODqgUghpHZXXFuZXQmIxIn3FycP2G7o63SlXyHWYR46wNnKsU6Ksc4TvDHZQMcDbo
	 bMV0x+h6RaTQw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 526B62E00DA; Fri, 27 Mar 2026 00:06:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        Ye Bin <yebin@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz
Subject: Re: [PATCH] ext4: avoid allocate block from corrupted group in ext4_mb_find_by_goal()
Date: Fri, 27 Mar 2026 00:06:24 -0400
Message-ID: <177453546541.1226823.8698046733222976051.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260302134619.3145520-1-yebin@huaweicloud.com>
References: <20260302134619.3145520-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 02 Mar 2026 21:46:19 +0800, Ye Bin wrote:
> There's issue as follows:
> ...
> EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 206 at logical offset 0 with max blocks 1 with error 117
> EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost
> 
> EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 206 at logical offset 0 with max blocks 1 with error 117
> EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost
> 
> [...]

Applied, thanks!

[1/1] ext4: avoid allocate block from corrupted group in ext4_mb_find_by_goal()
      commit: 4a1e038b056fca4a9644de1af8009c4980e158e3

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
