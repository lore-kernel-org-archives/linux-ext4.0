Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6AC2C15BE
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009596; cv=none; b=ZVkKdF+AtgMgJVsm9jGfakh55D78QzyXn0dYdHhiEum4FnRqFiYnqMqhX3Dl8gnNKlOXmQuYxjqzmUSTm5FdvGTJMR+VWcKIDuwEfRDHr2SD7Zow1cPgtajNUQAVGL0Yw/1oB8Jhe9+wtcX98cSlTZqd1Vst1erEVzDetb4Scdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009596; c=relaxed/simple;
	bh=+FjOSzXvR1diobylzv76SbtHxJySI69Q+Sh7QTCDPl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCczuYdbjRE4iThWOB+dOr+6hXaXXJxQGL+3gWe6Ij2/o9o5wN5/+oaKB1R3L8WWannDHrFvlet9dFqHE08B7yy5huZZ/i8NJ7b69gVoiUTowBYbKII38jjxRLAp3jzKd6/cbK0pt7gPTdSF/+fkcdHO6kwE0DOApAX3fY/2TRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=gqaMLq+C; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="gqaMLq+C"
Received: from macsyma.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 67HNWkuK028821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 19:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1787009569; bh=bg4W0O/WmClw+aPueltMBtgRzW6b6oA8GvkmueVlPxU=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=gqaMLq+Cy57KCXeNmGETv6beyhd1ZIEjkO2xSoNSnNlyPwONM6VVo/Hx2R0PCVpZk
	 a8MaZeycLEBS9aiywellyidn3AbprLpqy9nhMGFJwjfQ2l/96Z9Bq0MYrspXGctYHp
	 f+2TGteRfKkoAt34yg+heE4VW4DeBHCL8TqSdNoyyCn+AsWfoiX4QvgRBmIrN25hDt
	 MG6VtXBAppQxT7zM0Y+ZcV2TVC3/HyGUMh7//1kQhmnmHeKB3ksJRvfT0o0bqOw1ck
	 POMTUUOqQVBPxqP7x6VxPy3LlOzLWAsIgrHvissmg2x4GhAcdDsSl3lqNY9qvhZGgg
	 V51UpqHCv/BRg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9090AF623C5; Mon, 17 Aug 2026 19:31:46 -0400 (EDT)
Date: Mon, 17 Aug 2026 19:31:46 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 0/3] ext4: Fix credit estimates for extent tree
 modifications
Message-ID: <aoOYvl2tsk1o6TR9@mit.edu>
References: <20260805153202.29814-1-jack@suse.cz>
 <178632560650.1021605.3694902133748235095.b4-ty@b4>
 <an66zNiouBCgpS9M@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an66zNiouBCgpS9M@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>

On Fri, Aug 14, 2026 at 12:21:30PM -0500, Ojaswin Mujoo wrote:
> 
> I just noticed that the RVBs were not picked in your ext4/dev branch. I
> think they got missed somehow.

Hmm, I see them on the dev branch:

   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/log/?h=dev

and they are on today's linux-next branch.

						- Ted
