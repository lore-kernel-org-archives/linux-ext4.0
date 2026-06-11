Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFA23F7AAC
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 12:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781181380; cv=none; b=I4ndcZps5XzSaSTFk0CQt/cly5Jzr9+OAYTBqYMnisdGwj1/eAA6q4NEt26onf0HrlSZfhMK2iGWv5x6/Tfah1md+uVkaXPcSVcsidEVoGkm+INQSOrLE6dsOUz/Pha5b/gxTs9ivnon8RMiTDNdEO4kUYI70wouPNVQrVC/wmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781181380; c=relaxed/simple;
	bh=2RilpLjSpf4C3UNJJwQj6R8b1W3goRRjhGzEkHi1UwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MMkV6h9CsMYkGREff/vazKNVgGMIQXeDdKIAT2uHZdx8WPJHMraR+LjXz2IhYvE6oUcxM+ms65pWXO8e0kUVvE56tIoA9KReFGaGXnKs2DCjohnCKGN60Gqu31h/whLGutxceToMc0/h4exIqPSAX0ekYsTGKEKHoafHGqfqy/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=miaqB04C; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="miaqB04C"
Received: from trampoline.thunk.org (pool-173-48-113-189.bstnma.fios.verizon.net [173.48.113.189])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 65BCZaCd008341
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 08:35:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1781181339; bh=7YLlS3TffZmB4gYsWgVI+NR8Vfm6h0dqEIiF6z8NDdM=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=miaqB04C1YkjyBahlR9wknvSZCQLeoAt6PFZ8pYSuEsjuk7o7KjO4fcvIoa+YDW0D
	 ce9wl+fH82iD8gVCz/LmIJ2ScX/DKIxPkiIyoNAQtzF9dfFVo5WHruklgNqlexqTwt
	 fF/R6Aew3EimbAdVE2SF5GfkGuGQby1gV/YMV5XG0tGXVdjeKs7sxRntR0i6w5NoS4
	 jqscRgrckAXlTebi3xiiPIUDA1czYi1z6MasvMSWgE32b53SO++VsSlpEFuT/PJjYS
	 L29vAxPEHc9OgY6U2PV1gv6BGbcjC6x/MlU5yGz+cLoJg4bXm9r0mBoxLAwT7QopNR
	 ASUEBXRlDLxww==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1BEC62E00D5; Thu, 11 Jun 2026 08:35:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        neil@brown.name, brauner@kernel.org, jlayton@kernel.org,
        Hongling Zeng <zenghongling@kylinos.cn>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        zhongling0719@126.com
Subject: Re: [PATCH v2] ext4: Fix ERR_PTR(0) in ext4_mkdir()
Date: Thu, 11 Jun 2026 08:35:22 -0400
Message-ID: <178118128405.522716.12973722466886035238.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260604073647.211279-1-zenghongling@kylinos.cn>
References: <20260604073647.211279-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 04 Jun 2026 15:36:47 +0800, Hongling Zeng wrote:
> When mkdir succeeds, ext4_mkdir() returns ERR_PTR(0) which is incorrect.
> It should return NULL instead for success and ERR_PTR() only with
> negative error codes for failure.

Applied, thanks!

[1/1] ext4: Fix ERR_PTR(0) in ext4_mkdir()
      commit: 8e1c43af7cf5091d99db38b7c8129e394d7f45b5

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
