Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099690;
	b=bhX/Loug5oKDj8oo4TUTVYHW0b0S1ry7fuj/Y5sn5VHsy1Hzeexh6HCQAWrWqcmud2s4
	 7/4wA3rDJqcvU92eH3ni0S/nq7aGPvhmkF4g7GORG7dhfYQ/aGgbZYcZiBcmr8b0Jn89x
	 Rp6i43rkkiyjq/ZhZNqyxCv5PKUaJxVU08+LBBBPjuA1NDVPiMh7f75cmjOO4KQ1P1QfV
	 DsfMh5/Z67PDNAXL945w/N7H9hBaXEn8YLyw+CjxAcjp2xiTQQIEJzJWyQHKvNYauQ3n4
	 xb0hcRlgqYpVExIa9xwTVNcFs+hp0/m+1niAcRb5y4KR22NOPQ4Bc6G0kWafi6yRpQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099690;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=O6gRNTYxms5NJYh1H6e+b86VMQtiJrvze8fWfJuIGYg=;
	b=1U4J+RkXYMj2A468e3ZjuKGqRbEhXwrPKiHPObn9w1kFUYUWFzyAaPX7CqPut0+URcV+
	 Ejd4TnxGmVWFhVYTqFhDFqLjUVvUThnGKbzOl3VX1Y/jCaPpousVJk40wN9ga+4W+FlL4
	 NGEOXhm5EmopxRChJtxxzMopfzNSoq5DcyS+ixc8yFokxbjPrGJvMXt2G7mHn9LZnTDJX
	 1n8yGNh7Uah7FcQ+GBzhJ084KdSzLpBYUlMW06H0YTy5XFPhwordnjIT8e0aXXjL543X+
	 2Yr0aYrTey/s9nf+qfCt+b+iLU8ovENDLP9bpoVcsZ1mzMEnNng30uhOP9L/w/gZ92w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=TipCgdHu;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB87606E890
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EB87606E890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=TipCgdHu
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElcnZ018018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=O6gRNTYxms5NJYh1H6e+b86VMQtiJrvze8fWfJuIGYg=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=TipCgdHummTbeWKleXn1GQCVWQ+CcwdOPz6CrrGNJq9yJNoEHfAJXulhz8owatlU5
	 cu7huE+s74VZMpoKcfvQ88prvMh5UPjbFqFRRf+3KoMPY3+ukDZ9goaGeHTdhDeb4T
	 HXEON8klRHiWzXYF6qxCM8Yzb0voQc/vlVUuEmfp0Wkk6Cxnmb/OJRuj1zVr+MEw6K
	 NReWVqr4mNVecMEu+rsJIjAvoYz41htVm/PEcELIUeuwPekDp96CjaQmYlTZCqAT5J
	 2RZyZ7cpuSykSGa/paXYKNXZGwmWI769Jcy3c2zJLhTdCfkPjAZZOpey/Ev1O6Ld1F
	 8/tlDxmggn22A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0F8F22E015E; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        guolingxing <guolingxing@tju.edu.cn>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Baokun Li <libaokun@linux.alibaba.com>,
        Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: record writeback error when discarding pages on failed delalloc
Date: Thu, 19 Nov 2026 09:46:55 -0500
Message-ID: <179509948709.1938961.11162343670709084796.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016110311.71391-1-guolingxing@tju.edu.cn>
References: <20261016110311.71391-1-guolingxing@tju.edu.cn>
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


On Fri, 16 Oct 2026 11:03:11 +0000, guolingxing wrote:
> When mpage_map_and_submit_extent() gives up on a failed block mapping,
> it sets give_up_on_write so that mpage_release_unused_pages() discards
> the remaining dirty folios. However, the error is not recorded in the
> mapping's writeback error state.
> 
> If this happens during background writeback, a later fsync() may
> report success even though the dirty data was discarded and never
> written. Returning the error from ext4_writepages() is not sufficient
> to notify a later fsync(). In addition, ext4_do_writepages() may clear
> -ENOSPC when committing the journal and retrying, even after the
> affected dirty folios have been discarded.
> 
> [...]

Applied, thanks!

[1/1] ext4: record writeback error when discarding pages on failed delalloc
      commit: bc6d92e3cd19ec6b20e66c8cfee3e1ecb5f6e778

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
