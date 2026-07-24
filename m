Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE8343CE74
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2026 14:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784903649; cv=none; b=USl7RAwXQhv6W8+Xs+53CdY/xjaFcfmIfkBH1oLcSRa5TJ4fyBEAx43LZVmlhLr7ovIswtiSg59uUArWTT3vezLnnVXkdUbXu5hOnDL8pslsJI9P/cLS+wwn+zGllFuuI/yfBmpnyygI29bsOCfDidSuVZGqlr3lpm47glp9lHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784903649; c=relaxed/simple;
	bh=Z+ql/HGGh/EMK8blp3zfsQjg+RhFDX8EzarPEHWar8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VpS5KEIUMaMEd1mTsF0OoQJWgfukFW80dWOPPDx5CdrI6xP4uq+ajgO1GTpOgnvobHoRFBaeHd+KY3nDN4JyVhnL+aLAM3YXPmdR75b6FD6EMfrAv0JWUdH571eoqkY+jM2TDySPNOIHaSfc3NcSTJpKX0aO3IvP/i/Jv8wuncc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=gWwrMIce; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="gWwrMIce"
Received: from macsyma.thunk.org (pool-108-49-209-71.bstnma.fios.verizon.net [108.49.209.71])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66OEXSbt023789
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 10:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784903614; bh=WMuyxvPRU2SH/tS+BQ/D4wGzuy43+bPPjuFTbNryI6E=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=gWwrMIceGfdZassZng0wGpFoVgI4gI7QCAGryWRDKvavSpnPgeDEegBIt9+u1XzEw
	 Dx4YXYSXIEj4Wj2YAIz0vwBuS5jPWRv4NrCebTq9Tt8CPswteSFh0Ene4z/b2dLI6Y
	 lgKh04O0D3vfG3HVgxzxuCiNwmIK7PaeihRQb9Ij7Cgsss0P+QDaO+VNrI+TvQq+xT
	 ogeo3fjZPGuEMHYkit8KSFGfvNprSfVWCe9x+YBsUdot/KP09M3uKPJEWuI6/KosrS
	 l5tuJxU+h5upQUF5ecof1RoDy98ir2bNbEa973AXkHk+4joWF43kFNlw7W0CSyhpYF
	 GKMwaBc8dyOwA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 51D07BE96C9; Fri, 24 Jul 2026 10:32:28 -0400 (EDT)
Date: Fri, 24 Jul 2026 10:32:28 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Luyao Bai <bailuyao1997@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: do not WARN when starting a journal on a frozen
 filesystem
Message-ID: <amN037A4dXtbyREt@mit.edu>
References: <amNnKl4V7DPrBHX_@mit.edu>
 <20260724141659.669079-1-bailuyao1997@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724141659.669079-1-bailuyao1997@gmail.com>

On Fri, Jul 24, 2026 at 02:16:59PM -0500, Luyao Bai wrote:
> > Luyao, I'm curious what (if any) testing you performed before
> > submitting this patch?
> 
> I ran the syzbot C reproducer under QEMU on a clean mainline build to
> confirm the WARNING fires, and again with the patch applied to confirm
> it no longer does, plus a build of fs/ext4/ and checkpatch. I did not
> exercise fsync-during-freeze or the freeze/thaw transition (e.g. the
> fstests freeze tests), which is why the problems above escaped me.

In general I ask people who submit patches, especially if they are
relatively new to ext4 development to run at least the fstests smoke
tests, using (for example) "kvm-xfstests smoke" using this test
appliance.

[1] https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md

Unfortunately, this wouldn't be sufficient since the smoke tests don't
exercise the freeze/thaw transition, since the focus is on keeping
smoke tests to 15-20 minutes.  I'm *fairly* certain the problem with
this patch would have been detected by the auto group (e.g.,
"kvm-xfstests -c ext4/default -g auto") but that takes 2 to 2.5 hours
to run, and it wasn't clear we could get people to run that much
testing.

An interesting approach if we are using LLM-based tooling is to create
some kind of prompt that examines the patch, and the generates a list
of tests that exercises the code paths modified by patch.

Personally, because I have access to Cloud VM's, I'll just run
"gce-xfstests ltm -c ext4/all,ext4/64k -g auto", which takes 24 hours
of VM time (sharded across multiple VM's, so it only takes about 2.5
hours worth of wall clock time).  And since that's only about $2 of
cloud VM time, it hasn't been worth it for me to try to optimize set
of tests to run.  But if you only have access to using something like
kvm-xfstets, maybe it would be worthwhile to optimize the wall clock
time of running the tests.

Cheers,

						- Ted
