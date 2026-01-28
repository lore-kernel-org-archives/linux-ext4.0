Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2854437105C
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2026 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623552; cv=none; b=okelxnuMLWkr+R9EnNbbJqj3B7/6C4kgb1smnK3PbmxTJFIx5za/6lG0qs5oB2ZH+2HzqJoBrwoHd29P04qhkHKBzKs035zRk0Kj8RCr5eP4TNrIttMwZ3OK9m+ZSgNFolfCPzDPbHivVfQ0ZFWUp9b/ox7ROyJb0y56RfBNLNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623552; c=relaxed/simple;
	bh=0IaaSlfj/tMi4yxeSnvPlMcfeus7+kIDLygE1Bk486o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CcwyjBA/eXBbR4YjOBThAFHH8IQEFAas9XIdpxjHCPoflPQ9cTK8mXsTXG+zIA+zDP1neiHc2Zxtgppi+YfO3w6eIvQ8FSmDjYQp9S7RPYCrTD14GvXL60OQlbDD2yjeXX+iwwWybWJUXtbl3S+46+sp5yVKGk1W8ebGQ3dN2VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=WejVM5HG; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="WejVM5HG"
Received: from trampoline.thunk.org (pool-173-48-123-50.bstnma.fios.verizon.net [173.48.123.50])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60SI5Ix7028726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Jan 2026 13:05:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1769623520; bh=XOneXklHv1jiBk7rOfudnuchHo0WNmnJWMY901JnApw=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=WejVM5HG19YQvDFYigzzR+gZNeVwH4ERlRWh4vV7/XW5h3vXmJpiT6t66z7hPDtsq
	 NgYCJy8jIPN7aDglPMzjhllARcnzfu7XYVHrw37QDfxu5+K3deDjCX+laM9j856/Nl
	 Nr8CGKBhJNkbtd+rh7NAtya8Ra5ssDVGFDBSMTK3DmutAFcGKfsw/tjLANhoz0deS+
	 lzu/8adSoV1nxvaDWrq+SRBZE/YCi8f+jb+w6bXhMGKV0yE3Mos060U5G96vtgPlsA
	 vuILM1LkPfz5DlUVsrUdrFOYnsCUrKLqUWWV4+WtMRQLOJ78d9uPnD2d0fDffc7Vjw
	 XMC8C3GE9J8cA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 20BA02E00E1; Wed, 28 Jan 2026 13:05:16 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Yongjian Sun <sunyongjian@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, yangerkun@huawei.com, yi.zhang@huawei.com,
        libaokun1@huawei.com, chengzhihao1@huawei.com, sunyongjian1@huawei.com
Subject: Re: [RFC PATCH] ext4: fix e4b bitmap inconsistency reports
Date: Wed, 28 Jan 2026 13:05:07 -0500
Message-ID: <176962347639.1138505.6141824430366295375.b4-ty@mit.edu>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260106090820.836242-1-sunyongjian@huaweicloud.com>
References: <20260106090820.836242-1-sunyongjian@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 06 Jan 2026 17:08:20 +0800, Yongjian Sun wrote:
> A bitmap inconsistency issue was observed during stress tests under
> mixed huge-page workloads. Ext4 reported multiple e4b bitmap check
> failures like:
> 
> ext4_mb_complex_scan_group:2508: group 350, 8179 free clusters as
> per group info. But got 8192 blocks
> 
> [...]

Applied, thanks!

[1/1] ext4: fix e4b bitmap inconsistency reports
      commit: bdc56a9c46b2a99c12313122b9352b619a2e719e

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
