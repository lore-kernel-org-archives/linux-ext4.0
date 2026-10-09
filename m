Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6867501F3F
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 18:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570629; cv=none; b=VXUrA7BWfUi+eQsc8mObC5GxdLFgjPyJmKfRypNIaHO8k+4ikWxbpUWcBIyecuClCxgu1HEcdHQ95zbUtaH9K3haRdPq1vIJ9/Nx9s+ApxTqI48Yl4+/N4+DAB/pYq7sZSrRYqL1Nm8F/cJ+q5bpFhytmLMu2+GQrxTRvqFdi34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570629; c=relaxed/simple;
	bh=L0m2eL5DGHs643vM/O48SFt6nojSAOMcSMn2WKz72D8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fj1Lym7cKnH/HNb0Dl5MDn4+UC6wguHIdJVBXjMKI9DB+uFJnKuS1owcFVyjm8Gw2sGRX7YCPDaAxjoNsBMfm2A7o0auGW3YAdxXRy6jveKwAcnwVQ1aAML6Bbe9aaX0zM5aJ2RC91pz50WhLAcX9nP93e4TxMdRc7XTBPan+mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=A+0oZYGF; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="A+0oZYGF"
Received: from macsyma.thunk.org (99-196-133-108.cust.exede.net [99.196.133.108] (may be forged))
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 699IToKp000611
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 14:29:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791570603; bh=nu2YxkOxzlFd2aRModWyqZUYfXEJi/7+8yOaUHs3MmY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=A+0oZYGFK3FVTQY65Jbt7yvPe50q3pcFNemTxzq1D/r4fmbmUB51YC7IH1NKVIHBm
	 0vf252ESl/L6N5+K5KgkkZjlvPuyvVTbGCYsdpjguyvDT3GBzpac6kaz7s3SX4iVDt
	 Ewy4xfEPTbaKX7kcX+YexKIEvowu2Cwu3jnH7IilcGsfPU2+A/p2+a1vULrm2kJB0/
	 c6ZDAiqbXLjMzesVNKWqWfLCX8hmbQYrYein9QaP1RPbmMH/bLcRSEAbqwjDPRXnH8
	 U+RgWURcay5nKNpyCegF6PCZf9VGZVwxore1jyOapSj4mN3M3coMTqU4QtqNwCDYGM
	 wEOsqKCSgk8WA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 43C161FA8A71; Fri,  9 Oct 2026 14:29:47 -0400 (EDT)
Date: Fri, 9 Oct 2026 14:29:47 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Artem Dinaburg <artem@trailofbits.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Max Kellermann <max.kellermann@ionos.com>,
        Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.6.y 0/2] jbd2: backport CVE-2026-89566, CVE-2026-89567
Message-ID: <askqkXhBORyXr-v9@mit.edu>
References: <20261008192048.98833-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008192048.98833-1-artem@trailofbits.com>

On Thu, Oct 08, 2026 at 03:20:44PM -0500, Artem Dinaburg wrote:
> Hi Greg, Sasha, and maintainers,
> 
> I'm working through the smaller CVE backports still missing from 6.6.y.
> These 2 upstream changes belong together for CVE-2026-89566,
> CVE-2026-89567. They must be applied in this order because the later change
> depends on or completes the earlier one.

Note that some of the 6.1 and 6.6 LTS backports in the past have
caused ext4 test regressions.  Since I don't have the time to track
down said ext4 regressiions (the last one took a week of my time,
because bisects are painful, and even after I bisected it down to the
guilty commit, figuring out out to safely revert it also took a lot of
time), I've largely given up on those LTS releases.

In addition, many corporate security folks are advising that it's
Simply Not Safe to use an LTS as old as 6.6, because even if you are
trying to address the 6.6 ext4 CVE's, there are plenty of other CVE's
that don't necessarily get backported, leaving those older LTS kernels
vulnerable.  But if you do have a real business need to use 6.6 LTS,
would you be interested in taking over managing the 6.6 ext4 stable
backports?

It's a lot easier to revert ext4 patches if the regressions are noted
promptly, and so the easist way to do this would be to use
gce-xfstests[1].   I can send you the results of running:

    gce-xfstests ltm -c ext4/all,xfs/4k,btrfs/4k -g auto --repo stable-rc.git --watch linux-6.6.y

... or you can run it yourself if you like.

[1] https://thunk.org/gce-xfstests
[2] https://github.com/tytso/xfstests-bld/tree/master/Documentation/gce-xfstests.md

If you see failures in the latest stable-rc.git which are not in
previous test runs, then promply send a note (within 48 hours) to the
stable maintainers asking them to drop all of the ext4 and jbd2
patches that were sent to the latest stable-rc.  You can then spend
time, at your leisure, figuring out which of the ext4/jbd2 patches
caused the regressions, and then either fix them up or skip them and
send the rest to the stable maintainers.

If you see test regressions which *also* impact the xfs and btrfs
trees, then it's likely that the bug is in the vfs and mm backported
patches, so there won't be a need to request that the ext4 patches get
dropped from the stable-rc --- but if there is a test regression
impacting ext4, xfs, and btrfs, and you want to use 6.6 in production,
this might still be an issue for your company.

> The complete series is already present in 6.12.y, 6.18.y, and 7.2.y.
> These fixes also affect 6.1.y, which will need a separate backport; this
> series is only for 6.6.y.
>
> Could you please consider this series for 6.6.y?

If you haven't tried running xfstests to verify that your patches
don't cause any regressions, I strongly recommend it.  I won't NAK the
patches if you haven't, but that's because in my personal opinion, I
strongly recommend **against** using 6.1 and 6.6, and I've given up
trying to provide any ext4 support for 6.1 and 6.6 --- I just don't
have the time.  I barely have the time to pay attention to 6.12 and
6.18 LTS kernels, and those are only best efforts on my part.

Cheers,

						- Ted

P.S.  And if anyone would like to volunteer to be the ext4 stable
maintainers for 6.12 and 6.18 (and 7.3 or 7.4 when the next LTS is
declared) they would have my undying gratitude.  :-) And the newer LTS
kerenls should be much less work than the older LTS kernels, since the
chances for regressions (and the work involved in trying to track down
the regressions) are much less.

P.P.S.  It's because of the risk of regressions than XFS has opted out
from LTS backports.  A few years back, a few companies (including my
own) contributed engineering resources to test XFS patches and only
sending patches that were verified to not cause regressions to the LTS
kernels.  Unfortunately, all of the companies decided it wasn't worth
the SWE costs, and so the XFS stable backports project collapsed.  I
am happy to help provide the VM resources for a future XFS stable
backports effort, since the VM costs are relatively modest.  It's the
SWE time which is significant burden, whether it's coming out of
company funded time, or out of volunteer time late at night or on
weekends....
