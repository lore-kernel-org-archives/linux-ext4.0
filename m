Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CB1374743
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2026 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623561; cv=none; b=Onpr0CNgmANAokqa1ncROH00LRRrpJpbgIqNO4Lx6MDsc+BdL79q1Fd/C7LQqo+YXGLSS1NNW8CJlw5wa+Cl96bGvRC7GKhIQFAI9I1EZxyGBByhmTyErIoAqBFGmtmQPcPy5wMCzW0R8MtymMq8k0RnFcniFF5Kf8EwrV0su2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623561; c=relaxed/simple;
	bh=jsinFAx3qLYGClKyITZm7LWnXhS+ytI3d6fx69OZAqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ReBAhXPbXsY2C5QY4XG4kuRMFKCm+msDFdR0xEEASsqHIp1E+b/9FvkIgSY1X6R++oup6BDGlQqNQEMX+RJo6WXwI8RbqBJ9Y2bnb1UdRrq9CBO2apI8cFKoYA2U5ceFp9vOYanXbyru7xnNiQylQTBEWy2A2Wb/NkntJYbsGEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=p1fYOI2t; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="p1fYOI2t"
Received: from trampoline.thunk.org (pool-173-48-123-50.bstnma.fios.verizon.net [173.48.123.50])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60SI5I5r028738
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Jan 2026 13:05:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1769623521; bh=vDhsy/lq/Dw6rvp5wCr/5llOfs06iNuwkaPMfRwj9HQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=p1fYOI2tUd2NGtjrqj9bptyLzMw4RhluRFt+gc6OqR64gdk2CnzhOMagDUf+tNXn9
	 OwiV3aWJ2c8zl4ly9Cj5za7pTHhEXwmnATcKJ8PSntit7S3IucN9ih+pMtpvw/FcwG
	 oiYzXYWOLAvWq1APthHdYFNl0f28iXk+oPkza2AfSWuG7yoQvXKU6JuebMGllqtT7i
	 VcGJ0sQ7oZ2I97rYGX3FS+nmvMzBXQNhzWOvYCLk1xhAAzFJeRtQG/5tJs/tMSCwVr
	 vZZPmLCDk4Bc18nfF91MqWPEjRwF43vTaZ3rhaKlmDgS9UuZVhI5KW/BcfXevrW/Va
	 wVo7rSGPauAWQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 26B862E00E3; Wed, 28 Jan 2026 13:05:16 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        yizhang089@gmail.com, libaokun1@huawei.com, yangerkun@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH v2] ext4: don't order data when zeroing unwritten or delayed block
Date: Wed, 28 Jan 2026 13:05:09 -0500
Message-ID: <176962347638.1138505.18169489887205179764.b4-ty@mit.edu>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251223011927.34042-1-yi.zhang@huaweicloud.com>
References: <20251223011927.34042-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 23 Dec 2025 09:19:27 +0800, Zhang Yi wrote:
> When zeroing out a written partial block, it is necessary to order the
> data to prevent exposing stale data on disk. However, if the buffer is
> unwritten or delayed, it is not allocated as written, so ordering the
> data is not required. This can prevent strange and unnecessary ordered
> writes when appending data across a region within a block.
> 
> Assume we have a 2K unwritten file on a filesystem with 4K blocksize,
> and buffered write from 3K to 4K. Before this patch,
> __ext4_block_zero_page_range() would add the range [2k,3k) to the
> ordered range, and then the JBD2 commit process would write back this
> block. However, it does nothing since the block is not mapped as
> written, this folio will be redirtied and written back agian through the
> normal write back process.
> 
> [...]

Applied, thanks!

[1/1] ext4: don't order data when zeroing unwritten or delayed block
      commit: 154922b34da9770223d9883ac6976635a786b5ba

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
