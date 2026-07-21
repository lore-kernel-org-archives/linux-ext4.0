Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB95466B5D
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2026 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784645160; cv=none; b=nmPymiqhQYLUHO8OuwvVVkrf5XiXDqkNTnA68KjpUdMc1Z7GA2+31lIY40sM5yih2WKSmWHb6CuHbKOEVbHJg1eoqn3xhfzGIgtcEz8Cw4QAZkBHyEtGVzVngZJRwNbggfszDkNJ2psHA2AxKup9WLddei87m9u0wmI/Y7K+25U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784645160; c=relaxed/simple;
	bh=HZHCKy6vJ3oAJXn4mf08AKv5q3htWNjL7HRmJJSMxM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CAN4urPbAwsmnUseAq3OpQzCtgRCsbITu4wLy9oIRS3mvFSl3PNdiZB1gm3WYXEqQd2H9EQwUNb/gUJBT6ZnbAJ20vUb4r1NoXEmV7RaaSvFx6J8kz0ZKoY0eI21uwfvx+bx38fBXKUwdSvU24PmtnfQOymuZh3AStLVCkiXK14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=DWF8gydL; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="DWF8gydL"
Received: from macsyma.thunk.org (pool-108-49-65-18.bstnma.fios.verizon.net [108.49.65.18])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66LEjoqm031242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 10:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784645152; bh=fp2HWtmMG1271pjns1ZUNWCUHlIk09MzSxVhhMZXoS4=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=DWF8gydLqAE96HaI6Nm/I7u+HJabQmwTgUxG2UKDf2y2DK/unbvrOBZJQ9st4jQAc
	 kVMfcQWGSz+HRdxiyH2YJXhSC5toSUbRX/vV1/6IK7AEn/DnedyMw+GWfO+8hmKeAG
	 69mR42G1wXXeWmFqBTqGAyEjUabNUbk1/I7r+rrfax5prZKcopMpS3jdBxPBFeAX9p
	 9UUJlg7zo9+duxNcmeUZMT1OkTkyo8hzREYeapSR+JcHUwuK3/KRZIuGUWH1iyi2oP
	 6QgFTgd9lFdi1KQEmQLeN8nq72EnCWUkmNFda9W2vTOqsqrhpupKHCxWuaQD/oBDXd
	 2G5em/wnn4tYw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A727BB86C4D; Tue, 21 Jul 2026 10:44:49 -0400 (EDT)
Date: Tue, 21 Jul 2026 10:44:49 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Daejun Park <daejun7.park@samsung.com>
Cc: "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] ext4: reduce fast-commit write amplification for
 scattered writes
Message-ID: <al-FU9wu4bZ5Euqa@mit.edu>
References: <CGME20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>
 <20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>

On Thu, Jun 11, 2026 at 01:47:33PM -0500, Daejun Park wrote:
> ext4 fast commit tracks a single coalesced logical range per inode.  When
> an inode is dirtied at several disjoint offsets between two commits (e.g.
> sparse/scattered random writes), that range is widened to span [min, max]
> of all the touched offsets, and ext4_fc_write_inode_data() then re-logs
> every extent inside that span -- including the unmodified ones.  On sparse
> allocation this inflates fast-commit traffic and frequently overflows the
> fast-commit area, forcing a fallback to a full jbd2 commit.
> 
> This series replaces the single range with a small, bounded set of disjoint
> ranges so that only the actually-modified regions are logged, while keeping
> the per-inode memory cost negligible:
> 
> Based on v6.17-rc3.

Hi Daejun,

Unfortunately, this patch series doesn't apply on top of the latest
development branch of ext4.  Li Chen has also been submitting changes
to the fast commit code and your changes are conflicting with his
work.  Could you look at rebasing your patches against the mainline
development of the Linux kernel?

Many thanks,

						- Ted
