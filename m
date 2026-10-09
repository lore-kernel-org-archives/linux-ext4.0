Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA0A3DA5B0
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 08:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536247; cv=none; b=Kp25qDxPcWKJSiwyv9QYTCrYWXOmp/BgeV0EMp6iVzHQqtyblAt/jp4rHfKisydI/6t5PkD55hR8vMQkPnRI4aXjHtdnBb5TEWqsiNh5NxC5fgjGJt2V+GFm8R2YhZTKTPyTmjF2LaXCqlot9Z3CMOjDAszOBGQN/xB5V7WmY7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536247; c=relaxed/simple;
	bh=imB7DEahsOmLAnkBRxQABiku9Ao7j0ItvPsEAe403C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mKLwbVCG/uGbWIzDNd4s07FYfGNXjcnfQehwi6ngtuPxTo5rNf9R4StpBDsNKGsiJZWLVBnnZn6Ns+knzY5DxQ2Ku8bWstV36/IAJmR6XQDvAvSmX2x3EnMvZWe8Sqjxi7jXTYYRMlwanlnBFctMyD2Nujcb0dTJNtaDDUWo6Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=CdTA9+af; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="CdTA9+af"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6998uXXa014189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 04:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791536199; bh=Ej5iqljvCNFzIPHXEwDjURyY2wp5O1VBFdioFvF7Dwo=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=CdTA9+af/akBr+sIFYSloJEDDmIXBvLjwT7g2Yv1HoMt/CMZSBrnWDqyQKPUyus3Z
	 yItomVDRtgfQHxBbkM4QH2BOw42cbvoctyB+rqtNJ9rhwUHThS117/edhkRaUtxsFS
	 lAlAvYnaVbGEv8yTnOpXy9hiHiwdbDnsB2tf/sEI7S4dMwd27HFtyho2caURzh6PK5
	 W/rWDmX5rtQ8F0pOIcKNJ42Tzz14KF2DBqUWrka3CTqCQW/zlU5/N6GvyTKpQIB+Pi
	 7DollIJuGXkp0ZBgMgdXBKMK8MhVq31piN2WObQ64MOXzvkgcst8S+rM0+Evs64rfj
	 p8xssxeJqiAqA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5E8582E0147; Fri, 09 Oct 2026 04:56:31 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: bcrl@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
        adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        sforshee@kernel.org, akpm@linux-foundation.org, pmladek@suse.com,
        rostedt@goodmis.org, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, senozhatsky@chromium.org, kees@kernel.org,
        tglx@kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jinjie Ruan <ruanjinjie@huawei.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 0/8] Convert barrier pairs to acquire/release for better performance
Date: Fri,  9 Oct 2026 04:56:22 -0400
Message-ID: <179153611734.860602.10120848143405792211.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902074805.398540-1-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 02 Sep 2026 15:47:57 +0800, Jinjie Ruan wrote:
> This series converts some existing smp_wmb()/smp_rmb() barrier pairs to
> smp_store_release()/smp_load_acquire() across various subsystems.
> 
> Background
> ==========
> 
> Many architectures support load acquire and store release instructions
> which can replace explicit memory barriers and save cycles. As noted
> in the ARM architecture reference [1]:
> 
> [...]

Applied, thanks!

[7/8] ext4: Fix out-of-bounds read in ext4_get_group_info()
      commit: b067d3c1f90b536e9aa9f48b19580475a0b34f0f
[8/8] ext4: Convert group-count barrier protocol to acquire/release
      commit: 4a87cfb9b45ae07cd28bdc1ab9059ea73eab312e

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
