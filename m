Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC50339A8;
	Mon, 13 Apr 2026 23:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776122927; cv=none; b=TGAvq9TPElc+w0YMnpgtijn6V19iAIY1EOuvA8WgeERu09GzFB4rar52Ie0AokTDR9d2iSNmrBt8M4R8KAme9Mc2v0e7Ggf1h8dZEJuLWdE3PnyItDiXpOqs6ZCbOG6QvnVBuNlKv1mFqQatLJXyVCVwkUK4uxOPSvlWxyoKCC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776122927; c=relaxed/simple;
	bh=yWW/LMULNo+T/K/tw2mtxV/ndC8duUlrxt1+c2s4wZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fe0KALEpLaNW+ttTeYIEpQvPrNDpWI6slI6oPcxkbKCT8aU5wOcqdnMkLTHu/2EUyQQx5DSPjOqpVne11HYoZQwwOyFJY23LE+gVKODYlxK8jpq9tP//h3bKeK78rsCLff+a0jHdyEf8x41T9TzqCExobcKCMaCA3N9/AsayPxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uge0uhKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uge0uhKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19042C2BCAF;
	Mon, 13 Apr 2026 23:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776122927;
	bh=yWW/LMULNo+T/K/tw2mtxV/ndC8duUlrxt1+c2s4wZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uge0uhKKTDR30Uwau+X7fwdPCZ7lPqatDjdt9LbK1RwlqJUykbzYw39mNHK8rNIW4
	 BrbssYPfP3T89+/Aif/NezScnaayxyH3KLgs3SM35dhC6BbbWP4RVJcgON4j+CtI5P
	 4B5y0yidwj7THwaLSnW5MxM6iQsQ3LlbZQLyRhEKYUz2ctGeztUhtdxSFP4VztWz1m
	 60gwm2lYBjWLQDgBIr+Tp8shsBkrXa3tYGooSndzb45RYn2vpr54HfY/BeV9NvJ720
	 dQtB0hWDUYWa1k9WV1IBVZhOcdLEvmWf5vHANw+eo81IbOrV4Qq2SaUIQJUO9PDsYk
	 +QPDhSs1xnQkw==
Date: Mon, 13 Apr 2026 16:28:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zorro Lang <zlang@redhat.com>,
	fstests@vger.kernel.org, fdmanana@suse.com, ritesh.list@gmail.com,
	naohiro.aota@wdc.com, wqu@suse.com,
	Disha Goel <disgoel@linux.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 4/6] generic/765: Ignore mkfs warning
Message-ID: <20260413232846.GC148064@frogsfrogsfrogs>
References: <cover.1775802601.git.ojaswin@linux.ibm.com>
 <afee4fedcc9b3685df0e05800d82b88d27f977f8.1775802601.git.ojaswin@linux.ibm.com>
 <20260410165435.GU6212@frogsfrogsfrogs>
 <advRgjl1tG4PMc6V@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <adyxi7156VAbL-G1@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <20260413162120.GV6212@frogsfrogsfrogs>
 <20260413204215.GA5461@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413204215.GA5461@macsyma-wired.lan>

On Mon, Apr 13, 2026 at 04:42:15PM -0400, Theodore Tso wrote:
> > > > > > The output can get corrupted with warnings like below because clustersize
> > > > > > more than 16xbs is experimental:
> > > > > > 
> > > > > > + 16 times the block size is considered experimental
> > > > > > 
> > > > > > Hence pipe these to seqres.full to avoid false negatives.
> 
> You could also suppress the warnings using the -q option, for example:
> 
> mke2fs -Fq -t ext4 -O bigalloc,quota -b 4096 -C 131072 /tmp/foo.img 4G
> 
> > > Futher, mke2fs has multiple instances where we print warnings to stderr,
> > > should we go and fix all of them as well?
> > 
> > "stderr" meaning "standard error", I'd say that errors are anything that
> > prohibits the format from completing, and only errors should go there.
> 
> Sure, I'll accept those changes.  But adding -q will allow the test to
> pass using older versions of e2fsprogs, while still allowing stderr to
> go out the expected output.

Aha, maybe that's why I've never run into this when QA'ing fstests.

--D
