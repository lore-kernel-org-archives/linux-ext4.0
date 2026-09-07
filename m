Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA63433CEA7
	for <linux-ext4@vger.kernel.org>; Mon,  7 Sep 2026 05:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760672; cv=none; b=VZhXBBPuhAJgpUTm8zkUvGXhbL8EeF5VKdJvcacMafsZGOnwYbl6CekrqWWyCbLNVDAus77/HOvqoQzXpYhWgyvMUukBXy8Yn6WreQDyAoD1RBheH1i50FBCr+bP7ElE5THvHP+82C43XiAZfZRx5yZnOx1qKXx9PVV8Mxrfyv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760672; c=relaxed/simple;
	bh=LnnC3aEnlCwvdXDGpRidYxqBMpkZrKXNZVh4jDN9ptI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B97OqJpVcgDmiGBFsTuPLMwXl3s8g1j1L62VtdZQIMoZ7Q5sjNhRUEqtXJ7NGjC9/XJeiUbELNqA4BgdPN9Y9XJsr1SNbIAXMDuastG272DqAulRUTx8USrmkLLDfU8pBriIpRyjNmhhSGxIQsIARTjuz1xO2miKwacLd8IhHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
Received: from zhaoxin.com (unknown [127.0.0.1])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hdbvP4zYlzcmf76;
	Mon,  7 Sep 2026 13:57:37 +0800 (CST)
Received: from zhaoxin.com (unknown [10.28.208.166])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hdbvM4KZgzcmf76;
	Mon,  7 Sep 2026 13:57:35 +0800 (CST)
Received: from zjh-os.zhaoxin.com (zjh-os.zhaoxin.com [10.28.24.13])
	by zhaoxin.com (8.30) with ESMTPb399048d5b62d7d7c3b84c1b108f50df
	Mon, 07 Sep 2026 13:57:34 +0800
X-Eyou-Smtpauth: jonaszhou-oc@zhaoxin.com
X-Eyou-EnvelopeSender: jonaszhou-oc@zhaoxin.com
X-Eyou-From: JonasZhou <jonaszhou-oc@zhaoxin.com>
From: "=?UTF-8?B?Sm9uYXNaaG91LW9j?=" <jonaszhou-oc@zhaoxin.com>
To: sashiko-bot@kernel.org
Cc: jonaszhou-oc@zhaoxin.com,
	linux-ext4@vger.kernel.org,
	sashiko-reviews@lists.linux.dev,
	tytso@mit.edu
Subject: Re: [RFC PATCH] ext4: cacheline-align inode cache to avoid false sharing
Date: Mon,  7 Sep 2026 13:57:25 +0800
Message-ID: <20260907055725.62128-1-jonaszhou-oc@zhaoxin.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827075112.B0C3E1F000E9@smtp.kernel.org>
References: <20260827075112.B0C3E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <jonaszhou-oc@zhaoxin.com>

From: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>

Thanks for pointing this out.

Yes, SLAB_HWCACHE_ALIGN aligns the allocation, but does not guarantee
that the embedded i_rwsem starts at a cache-line boundary in every
configuration. The offset of 384 bytes and the performance results
in the changelog apply only to the tested build. This dependency is
why I raised the layout question in the RFC.

In configurations with a different layout, the patch could increase
the allocation size without separating i_rwsem from the preceding
metadata. The size increase itself is also configuration-dependent;
the reported 16-byte increase applies to the tested build.

One possible refinement is to request SLAB_HWCACHE_ALIGN only when:

    IS_ALIGNED(offsetof(struct ext4_inode_info, vfs_inode) +
               offsetof(struct inode, i_rwsem),
               cache_line_size())

This would restrict the change to layouts where aligning the object
also places i_rwsem at a cache-line boundary. It would separate the
lock from preceding fields, but would not guarantee a performance
improvement or eliminate possible sharing with fields following it.

I have not yet tested this conditional variant. It would still need
configuration coverage and workload validation, including checking
the actual slab memory cost.

Would this layout-dependent opt-in be preferable, or would maintainers
prefer evaluating unconditional alignment with broader performance
and memory measurements?

Thanks,
Jonas

