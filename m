Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099688;
	b=cYh70N6FYGRFYnNyaxdD8UMyW5wGW+SI1mYvgGIlJZS3NrCS0HwTWR4iTnIkcZz+CI9r
	 NeUEyJv9LUk5+droVEkf0Mxskbnt7qPpkq9/jEJowcmqMHAlR+3jUK4CfL85Cej9ALQag
	 f3h/v0sm2Q/x7LXCszSZZW61tuqS8rgAB26Ct1NGhGFeI1/dnQVCVhUkjUCMdw5dEAT9+
	 Vc9nxG5P03Y7TXTQQYlp6jpTCVaxRjXdniJKLQCHHNer0YJ5XuJ+aZq1GrCmJbzCkDpuK
	 H7xKHSZv66ZdN0w6DtZZqqZ0qAMz1E+xFmZcVPn9NjxuLqroYpGlZ1SUliUj3v4XOvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099688;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=n9OkdHpDdor1oFm0sH46/DpAyedKXxJC3L6wB4vZ40k=;
	b=B25cpgRwGC8beLUCjYpH2rXFWpT2Rk91k/My5Bv0q9GO907D/n1ZhI1R2kpOcYixniWF
	 U/U0fuKllhQ5UIaZw0jHxrW/zzxltpJxfztj4j6D/eKDjLfugvH3CSOECkHCb7X0u/sXe
	 xsXwSEvI/jntLxG/NZdHCCbP70eEoSjAMM8TWGzFNIe7d4VxtFFh+dRC74vRx51cd4/Zl
	 +Eo828zAA6Ko+tK6JmCCEaPdnfLlA+YJD+GU157DOsmcTqmDkkq01hddTfSVTxnBT+6/q
	 Fc1apBWFcqivmIBHMrDnfl9Bu8zDLCpEMnBBkEVDoVwHfALqSL9cSgEaba4NvpJYrxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=PQnphPf2;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B4360A6F72
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37B4360A6F72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=PQnphPf2
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElc06018001
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=n9OkdHpDdor1oFm0sH46/DpAyedKXxJC3L6wB4vZ40k=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=PQnphPf2ktGvGkCZx/vk4GehWvRsVUsGx5gphGhBKsMtTb1Akw8BoEWRhJ6kJZUvF
	 AZtHUnTB7OdWz9YaPRAwTa4EetFK1zoA+L7Opx6nJoQMe8H9T7vhhHNXP8tlWrPkQO
	 GCN98lafmhMXgrhcu1/P0koZ4zhhTYoSxQOlbq1Ws12caF1yTtVT4xTDRHXYjXj+S1
	 x/kp6iUTNkSoU8Hc5NY76HlbXHcLOWUM5KevtAfgpemBGH2f2z7YVDdTsOsHuGocKZ
	 kbcEb2h4jNSgpIMNil3Gv5pX+7jnW9yFv7uJAnRpfpLA/kri/itvpeXX5/aISm9d4B
	 8A9D1xzDQLVlA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 051AB2E015B; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        guolingxing <guolingxing@tju.edu.cn>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix folio reference leak in mpage_submit_partial_folio()
Date: Thu, 19 Nov 2026 09:46:52 -0500
Message-ID: <179509948710.1938961.11030749609143156278.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016142524.655789-1-guolingxing@tju.edu.cn>
References: <20261016142524.655789-1-guolingxing@tju.edu.cn>
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


On Fri, 16 Oct 2026 14:25:24 +0000, guolingxing wrote:
> mpage_submit_partial_folio() obtains a folio reference with
> filemap_get_folio(). If the subsequent position check fails, it
> returns -EINVAL without dropping that reference.
> 
> Call folio_put() before returning from this error path. Leave the
> folio locked so that the caller can invalidate and unlock it through
> mpage_release_unused_pages().
> 
> [...]

Applied, thanks!

[1/1] ext4: fix folio reference leak in mpage_submit_partial_folio()
      commit: 49256cb63120897bdb6842c654ea46bc7700da17

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
