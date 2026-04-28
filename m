Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285972874FB
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2026 01:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777339794; cv=none; b=Vp04gZJ+4vL8JvAbL7Mb2XyzBUi4hYneSrJz0nTCnIZCQxf1/9FRquqOgkEbaIZ0N65PZVrWH6pJsR1nHFsYUWkOsZwvHaVgH8ioDEveG5pVky61WwUSXZSupmM5z1fRvBRzzlpKn8xoYN7XHrMbQL4jS5CriE4ylVQlI16CGu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777339794; c=relaxed/simple;
	bh=qpgrSG8ClOQgTRhrw6/SuH6V4RCoB/x7rUrBv9a4oDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNQ4+VUrViKRel0hPRJwHKvfHAV4agAz5pDL6zpZHJeO2wad2RXfEQmXUgno/KEEAqX0kdkZgEHNbDjVOaFji4LRGYG0jpU2NS2NCxc02BJXV6pEr9hASOu5mB7tCLm82iAy63WxTNmXrFEGoNS0bThnMilQjztEuZxw85Wiqkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=bpxNAWe1; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="bpxNAWe1"
Received: from macsyma.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63S1TTY5004923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 21:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777339773; bh=anb5HoXbr6dEjzu4UFV8nxvroOX7Fqri7kDOT8ZZVTQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=bpxNAWe1scg4JxXpkEIwUkzs72lQojFaq3rGl9FCWcpi9r6M4VWbqLMgpig7nzEhr
	 43DNV2x4sl+k78fpqyB2r2QhGtFFgIw5z2DxxepQf9Q9HrJvep8wS2MvDqiV31LxnU
	 Uhmy3ywN6rPNZdFPXwoBmDZ88LpK6dgMNshbwwtACy4NFy42hjXKnasmCbazSmUe6V
	 Pk+E1Eq1NHirBU76JRIQrYyPBCL4zVLqCOhcxzxl8uaaDZcT+hiDOcBQitfzsGW8XC
	 08YnXxczIlasbhlV3ZnsH1kA3UuG7yqnMroZ9I5s2sZWrbrC6U6FvNvEC9jbseOfCO
	 tz5YHQBUP9tZQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 75A8B654B4B6; Mon, 27 Apr 2026 21:28:29 -0400 (EDT)
Date: Mon, 27 Apr 2026 21:28:29 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Chao Shi <coshi036@gmail.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        Sungwoo Kim <iam@sung-woo.kim>, Dave Tian <daveti@purdue.edu>,
        Weidong Zhu <weizhu@fiu.edu>
Subject: Re: [PATCH] ext4: avoid __GFP_NOFAIL in __ext4_get_inode_loc
 allocation
Message-ID: <20260428012829.GA16497@macsyma-wired.lan>
References: <20260427222300.1284855-1-coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427222300.1284855-1-coshi036@gmail.com>

On Mon, Apr 27, 2026 at 06:23:00PM -0400, Chao Shi wrote:
> When kswapd shrinks the dcache, the last iput() on an ext4 inode can
> trigger ext4_orphan_del(), which calls ext4_reserve_inode_write() and
> ultimately __ext4_get_inode_loc().  That function calls sb_getblk(),
> which wraps __getblk() and carries implicit __GFP_NOFAIL.  Because
> kswapd runs with PF_MEMALLOC set, combining NOFAIL with a non-reclaimable
> context trips WARN_ON_ONCE(current->flags & PF_MEMALLOC) inside
> __alloc_pages_slowpath(), producing a spurious splat even though the
> allocation could simply fail and return -ENOMEM to the caller.

NAK.  As Sashiko correctly points out:

Sashiko AI review found 1 potential issue(s):
- [Critical] Removing __GFP_NOFAIL from __ext4_get_inode_loc causes transient memory
shortages to trigger a fatal filesystem abort (remount read-only) or severe metadata
corruption, trading a memory reclaim warning for a Denial of Service.

The warning in mm/page_alloc.c is the sort of thing that causes file
system developers to decide to drop __GFP_NOFAIL and replace it with a
retry loop just to shut the mm subsystem the heck up, since some mm
developers seem to view hangs in heavy OOM conditions as the worst
thing, where as fs developers consider data corruption to be far
worse, since users tend to get cranky when they lose their data, and
(a) in practice the OOM killer tends to get triggered first, and (b)
that's what software and hardware watchdogs are for.

In any case, there are *far* worse things than a random splat, and if
you really want to make it go away, my suggestion is to remove the
WARN_ON_ONCE from __alloc_pages_slowpath().

		/*
		 * PF_MEMALLOC request from this context is rather bizarre
		 * because we cannot reclaim anything and only can loop waiting
		 * for somebody to do a work for us.
		 */
		WARN_ON_ONCE(current->flags & PF_MEMALLOC);

I disagrr the premise; it's not bizzare at all.

						- Ted

