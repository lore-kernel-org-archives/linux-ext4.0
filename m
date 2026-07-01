Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FD734107D
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 14:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782915684; cv=none; b=qV5JBU6YMxH+gfz0aXNwMHz9BgSFDcjlQ0QgwYBgLUDd851hWxmRMgpGlKi65kqysPEUUmCTMYcy1hIRQ5MgfWKSbONcTiIiqGjOcOZpGzOL9rlgLbIormiPqVwdslH7aJaEcmQLpQcYa3LKU7FzXNYHECmro3RClN/33ZvuY6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782915684; c=relaxed/simple;
	bh=ipUR6dbEPBmy9uhq14GIyEe4KQRS624Rt/8LIK2vngM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUv4a0S2Mq5lPWrbzpTD+MzpMDi5n5tUMvj6WpzPzIArTjTkYClAPIRX7qmSo0LIhvI7f2HK8xzuWEzYVFf5OJ3cKDfE+oVpUvollRd6IOm2wnd0ZamIMyAZ5m1349HG6S/LBxEA8m2ROU8nGrWxHtTSyTnuXC/DJzwvnmAITl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M5V+xAr5; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5V+xAr5"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c9672e02e05so202411a12.3
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 07:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782915683; x=1783520483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=geZt5mwfxGU7cGsWcrOJqyhUil97cE4hab/MkWGmHSU=;
        b=M5V+xAr5Ml0PlQFgEZ5X77JUVwsSdGRdqy6IdlfBmuHD+D8zybMbOOIMt9Dusfdy+2
         wWAZ6TOKLOEq1bF7phX40KQA48wyDpMlEkXk84qt/VaaisDLgKo3wboECGvjCQ07otNG
         v/9/NwztKUTK/2tfmugu7gGoQWbbuUZst4VjBXGCupHpYPfRA9KVMOeZG2jOh0F70gfx
         Tr9rAI64XH47bjQjWetmJEIf3fzqrr31FjvIeqrexEd9HQNLNaMbvcXnO/i0Df4ElvWG
         QPmuJ4mD4XrRuIkNI/Io9MEVwky+vY9diSExymFKRC8c4PQYAL0IeEXqoQdjxtpHNz2Z
         YbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782915683; x=1783520483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=geZt5mwfxGU7cGsWcrOJqyhUil97cE4hab/MkWGmHSU=;
        b=Fb+uViD+AkUVEHxjOvR3ovgL6NNCsmZnYgx9HhWNOTwJKfEbxWl1UXYaqPB/K8ClYx
         foqhIfXUf44F2UGZEGgVO0RrleE454xq2/iunDKo+h9ZzmWfWS81c825oWFWZuAZPkM9
         3vIAPgNy2vsM7lzL3t7rHNCYcTm5Sp3GF40AlF4aiR9aeFcdoqMe26WANr5JHLMXmJqe
         GnMOyh0DmSf5iiFSpWJMvuMiU3c1ajL6fdQNMcqAtdA8NOyju/MKnAQ64G++8jaafUoa
         JwQ+fN9fv+4G0mXQetnFiuf6ZxE4G5pLbe5aCIFPz0lhqIGvTwRmmmBPnn3qQ+1lGI06
         2Vvw==
X-Gm-Message-State: AOJu0Yy3v82bTP2YEM9JeGJIJO0GFKFTsd4za6Z06ZUr32BWPubo6seL
	WJsnE7lO93bm//GYyfylI/E9PjYFVuHOjYb3L+c0SXzQpzjJQzxcgPMUDZ/ai50xLeA=
X-Gm-Gg: AfdE7cmkGvKbM4yZEUvyHtwuJXq4nNLhhys3PX33rCZO6HIQOWU1Pj+9smVAe1ywhNU
	PtVrSOa/1W8VlCZkFQThx0XXs5e/taT6oLm4X1447hAOhWCtHx+nng68oy+HKdaDHCWFI/1dS8J
	Wttv2WfNlubrODjjGFLd6mLsqbBYPisMuUpKRb7l8H3BYT1ddbBHuLaE9J9vFn0dRdXwUC3UFdU
	fM+Mh+Dku2I5a5T4uqbI89LgsjIxI40nRLtelf5qfo+WScffmgg86HbgphNOrb0Lzw23FafCa8K
	KS1TG6vN2UuOfPgcbGDVgS9TxFBkZQcm1Elzp6t8WFaah+xbk4EQQdLKqVegUNpoSh1KvC1MW7f
	z2z2KINHYu8YPo/iMt3oX9cl4duE3jHKvEWs/6oN6Hdvusy8QSHeRIs7eZxQIbaD9R+SRBdMqRL
	fwuwtYQCI1AgBd8LGMPJZ7uWY3BGPq8qYB
X-Received: by 2002:a05:6300:6715:b0:3bf:a0e5:999a with SMTP id adf61e73a8af0-3bfed41d909mr1937140637.48.1782915682831;
        Wed, 01 Jul 2026 07:21:22 -0700 (PDT)
Received: from DESKTOP-DK6PUT8.localdomain ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e32ef8e49sm383894a12.19.2026.07.01.07.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 07:21:22 -0700 (PDT)
From: yizhang089@gmail.com
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 5/6] ext4: write back partial-zeroed edges in WRITE_ZEROES
Date: Wed,  1 Jul 2026 22:20:08 +0800
Message-ID: <20260701142009.1510104-6-yizhang089@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701142009.1510104-1-yizhang089@gmail.com>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Yi <yi.zhang@huawei.com>

FALLOC_FL_WRITE_ZEROES requires that all blocks in the requested range
end up as written extents with zeroed content. For unaligned edges that
were partial-zeroed in dirty unwritten or delalloc state, the buffer
is left dirty while the underlying extent may not yet be converted to
written. As a result, a subsequent SYNC write to this range would still
trigger metadata changes, which violates the semantics of WRITE_ZEROES.

Fix this by calling filemap_write_and_wait_range() for partial-zeroed
edges to flush out the zeroed data and ensure the extent conversion
is complete.

Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c34505765521..c083703bf704 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4791,7 +4791,15 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	if (IS_ALIGNED(offset | end, blocksize))
 		return ret;
 
-	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
+	/*
+	 * In FALLOC_FL_WRITE_ZEROES mode, edges that have been partially
+	 * zeroed must be written back to ensure the entire zeroed range
+	 * is converted to the written state. In SYNC mode, writeback is
+	 * also required to persist the zeroed data to disk.
+	 */
+	if (partial_zeroed &&
+	    ((mode & FALLOC_FL_WRITE_ZEROES) ||
+	     (file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
 						   end - 1);
 		if (ret)
-- 
2.53.0

