Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3C719B5A3
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 05:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774675904; cv=none; b=YQEEMtbBEkRJbYM5f6lnna4AOfgj7hUbfr/4jl56o5pzdIrk2Exh5moi+9dF+CV05hp8PVMiPuAHI1wSxprMMUEHN1PKLP7oAPnY1OwRvbY0KTnoql7a9HZTMf8MauB6Y2+7PPDZ21hM3zToz69U4/2EfwyP6ZkUTbZq7S4VhAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774675904; c=relaxed/simple;
	bh=IoePcL8on17jpAjS5UyWl3N7DtfKRkwVStZ1IiUVSSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJZDtTz+r1yEHnc6h7yxyovDUyv9qcxxO0VFQn2At4dZy/IB8T53LQjls/CA4xdXTMedp34jvGNEPFuLVnLX7vLLZCV7IXH4yXCxXyp7pwRUt7PWjrp8B8kA7mvxFUQFf1/lHjIOpYL4CK7yDb3cs23iCnZ691dotudQx7daz8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Zbinnt8U; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Zbinnt8U"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62S5VI1N013567
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Mar 2026 01:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774675880; bh=p1om4Lco/cBb6P6fA7cpkyZZMyd+qkbGBHZ74T5Q9/o=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Zbinnt8U9tzKK0mA1nsj+VA72s/64tmNLGrBSHqjDulshkzZuY9fUNABmy2nQ7puk
	 GABMUVqPXRgsavAkGPOxvJUmG5X4hew94GHn6eKnUB2pvY2OzMqlXHEa351zkDr36u
	 +n4jxdOwpsAcy6gk/1j16lsUxZrTrwByr0x21ma8zxvU6O1Kqo4fnFUhLkg0heEQ4U
	 sSeVh42oltAwOcYOMCEekTS4T6chfJWMWeHhnQvvO1ID0r3yEipdpgLdXUek+BhmCa
	 NLoXJONrf41JdDf77hyD+7BoenCerwgMSTY/MmOBwizr40PSUh0oNl5et8kArQ6DSd
	 JwTrXTQahDv/A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 090DB2E00DC; Sat, 28 Mar 2026 01:31:15 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: jack@suse.cz, Milos Nikic <nikic.milos@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Zhang Yi <yi.zhang@huawei.com>, Baokun Li <libaokun@linux.alibaba.com>
Subject: Re: [PATCH v2 1/1] jbd2: gracefully abort on checkpointing state corruptions
Date: Sat, 28 Mar 2026 01:31:09 -0400
Message-ID: <177467585125.1335526.1078518910512966536.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260311041548.159424-1-nikic.milos@gmail.com>
References: <20260311041548.159424-1-nikic.milos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 10 Mar 2026 21:15:48 -0700, Milos Nikic wrote:
> This patch targets two internal state machine invariants in checkpoint.c
> residing inside functions that natively return integer error codes.
> 
> - In jbd2_cleanup_journal_tail(): A blocknr of 0 indicates a severely
> corrupted journal superblock. Replaced the J_ASSERT with a WARN_ON_ONCE
> and a graceful journal abort, returning -EFSCORRUPTED.
> 
> [...]

Applied, thanks!

[1/1] jbd2: gracefully abort on checkpointing state corruptions
      commit: bac3190a8e79beff6ed221975e0c9b1b5f2a21da

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
