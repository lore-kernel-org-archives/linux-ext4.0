Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53A6371044
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2026 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623528; cv=none; b=GcmP5MVykb3bFK8uyu4v6gMjJnh0ovxaKsZbAxJkyav08he76dbbZ6Q5LRrCqj3PD1IJouiuJQqNCne2x6sQNCK2YzemQJsQ6p+5v5p1WtzLseDf6SSTcNQpbYC1JQqQgz2rJtT0+C1nbtL05ryeWFTx7+fDqUes0D5W5CrnJTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623528; c=relaxed/simple;
	bh=Ri1EempFZTNyCQq2APbOeJ3UdFU/pnhW1ckiNoYdkeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sj3wGn7Ouy9+Fn7LeNGcMMhtWXkf/mmD6AAvSjeMkRvr9qXFn3L1G4Qf/X9VhnzII2FvC0fQcUeX1MyXpcsdj5IKqvKZkQjNup8Ka9uRT84cYXeupW0yBX1IxcnO460Zwv/P4E/42y9hG9b07Lx79ApxUxYzqgWUlmSrP2CQqDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=nqmD5mU8; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="nqmD5mU8"
Received: from trampoline.thunk.org (pool-173-48-123-50.bstnma.fios.verizon.net [173.48.123.50])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60SI5IEO028687
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Jan 2026 13:05:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1769623521; bh=amKTH2EIe4WyYmdDlcr8qytBGGW8qQ7UCEM5IVbtofY=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=nqmD5mU8s+7H+OfFkAcqBlKPIpDxqIqTgMqqHOynyeReO9Qflw/Utljgqc6G9eHQo
	 H0OIQcDEHEAT3rQ8Ml4cvRra45PZMHKbDRysu6nH2JPOVk/+LB9uEvVs2G+qvIqOVm
	 aYHmQjUUiw/jKUYyGfipK4ANz5NaZYwEzM00DvXjzJwtXaSAyp8E/BQtVuXT3PXNWf
	 GuWZXyf/YXA8kGWK3hfPhssSA0G48DaOV4wiG8gWv8SDi1mloZx2C6V+XLuT40L5Nt
	 743cR4zmyHXtxmgXpnzqOTpeV6m1tz6GuVcYMLO3N61ZUDIvFX3APWqMqVSTS9RV/U
	 JHJRo1/eb4tBQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 17AE82E00DE; Wed, 28 Jan 2026 13:05:16 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Chen <me@linux.beauty>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fast commit: make s_fc_lock reclaim-safe
Date: Wed, 28 Jan 2026 13:05:04 -0500
Message-ID: <176962347640.1138505.15539456502185156934.b4-ty@mit.edu>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260106120621.440126-1-me@linux.beauty>
References: <20260106120621.440126-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 06 Jan 2026 20:06:21 +0800, Li Chen wrote:
> s_fc_lock can be acquired from inode eviction and thus is
> reclaim unsafe. Since the fast commit path holds s_fc_lock while writing
> the commit log, allocations under the lock can enter reclaim and invert
> the lock order with fs_reclaim. Add ext4_fc_lock()/ext4_fc_unlock()
> helpers which acquire s_fc_lock under memalloc_nofs_save()/restore()
> context and use them everywhere so allocations under the lock cannot
> recurse into filesystem reclaim.
> 
> [...]

Applied, thanks!

[1/1] ext4: fast commit: make s_fc_lock reclaim-safe
      commit: 491f2927ae097e2d405afe0b3fe841931ab8aad2

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
