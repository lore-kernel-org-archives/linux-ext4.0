Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793832969;
	b=rInYJlahNn5hzWDT4UOqPPq8OcGeTS5/015sXFV12GcWlEecp7LaNXAxbvQJp57Jvz2K
	 JhM8HKPdtk+0We+Z1g3QYF5eaM68WsxI1yGHZwyVOAIU8kIY21WKtHGaaLh/12fDqclX5
	 oKIegPUSYBZLziH3Bw1y4DMALdiI2WNOELbduaGvWqUO6T9Z2rhVPI9+cNHxzOREhhOXp
	 AC5sp4DDCrkCq6oImDHD9klEa/ibO5zAaaz6adtIv5+6mnjLZBlMRBzq09+6Mt8UCwslK
	 X8iCkx6q6bXTno53WM9n5BY+ZJ6exn0TP+atcQaiYLWJlmqKuLnnVhn1WXXpjT7CY/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793832969;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=jHWBIHfHZnm3krj+u+UJd5sE5nCuIj9CeMaueCCID+U=;
	b=cMCYCjv0FhCE0ZBYc3ajoeJK1nAuyPz1bmGFu6YMfBitfQd5Ps2Q0jTCtbWsOsaXULhP
	 iIYsY4xdtKWs8YM0PYMUZepbQkb8zGELCqqpYBTCDSdCOEdaCldqcPLNffd6vgyxKKMn1
	 iFoCRfcESY9LrSPf1mpJFVciPovoTRW4k+BNFs+KYHTPOlDMstvHFFIxhuv4KCG5Sgt2O
	 SzoJDeh7+nTD7792fFFpF7itA5IAS8RSsIl48q3XNYmFoC3CC/76R7ce31oJvJ6j89hy0
	 ynEKJ2A/AT0a9SNpbZusSwmtORbGNocFbd2GmqEL1Xh6NPu6RlXudAn5/TC1MMo9j1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b="Ha3Y/erK";
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F5C606A326
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 22:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32F5C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Ha3Y/erK
Received: from macsyma.thunk.org (pool-173-48-116-148.bstnma.fios.verizon.net [173.48.116.148])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6A4MtwHM008003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 4 Nov 2026 17:55:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1793832960; bh=jHWBIHfHZnm3krj+u+UJd5sE5nCuIj9CeMaueCCID+U=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Ha3Y/erKQ+NqG18zFVhvkUzj6/Rx7Ydh1V40Jw86IjggGLR6f6EfcY9ENWPhAhqxU
	 xAky+AnlNO5Jdxj+o2RKBgapBxEm5w2d6+xLpXnl+y7Z/z1G4cqB/O5+ZPAq+5rLhx
	 EoEC1qmlg7J6gA6ThzazJ88suavEqvnMeSDkhKZ4yDQ7J4xiT6WuvhzJg0+qK2inRx
	 imUkW7JDjFuy+m10vL721+RofqOZBUdsz+uoSlJPFzaQYuI4E/ugiH2+0uKHVjxuHs
	 /Kp/cN+Y06k24qCMRdfzxccYe64ufnkDwKl+kq+/Nw94RyEZ5aRkZN5g5FQkzUxpYh
	 y6kYQUiKSGe3g==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 002F9253BC91; Wed,  4 Nov 2026 17:55:57 -0500 (EST)
Date: Wed, 4 Nov 2026 17:55:57 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Bartos-Elekes Zsolt <muszi@kite.hu>
Cc: Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: PROBLEM: NULL pointer dereference in ext4_mb_load_buddy_gfp
Message-ID: <auujGX7hYItdD9ls@mit.edu>
References: <6b2dbf1d-43b8-f9e9-a2b6-e538f295bf94@kite.hu>
 <20261103181757.GA2224825@google.com>
 <f900231f-259d-c52e-7b53-ad009f992fd9@kite.hu>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f900231f-259d-c52e-7b53-ad009f992fd9@kite.hu>

On Tue, Nov 03, 2026 at 08:47:21PM -0500, Bartos-Elekes Zsolt wrote:
> Eric Biggers wrote:
> 
> > On Tue, Nov 03, 2026 at 03:26:08PM +0100, Bartos-Elekes Zsolt wrote:
> > > Linux version 6.1.191 (me@hostname) (gcc (Debian 12.2.0-14+deb12u1) 12.2.0,
> > 
> > Yes, the stable maintainers broke ext4 in 6.1.191.  The fix is
> > https://lore.kernel.org/linux-ext4/20261102-ext4-ntfs3-null-folio-v1-1-4fd91ee23a4a@elliotjb.com/

Note that I *strongly* recommend that people use a kernel newer than
6.1 or 6.6.  A lot of security fixes don't get backported to the older
LTS kernels due to merge/cherry-pick conflicts, so your security team
might be prohibiting or strongly disuading you from using such ancient
LTS kernels.

Furthermore, the "it builds, ship it" approach towards backporting
fixes (including security fixes) is understandable, given the huge
influx of fixes to AI-discovered security vulnerability.
Unfortunately, it leads to frequent breakages to the older LTS
kernels, and I no longer have time to debug ext4 failures to 6.1 and
6.6 LTS kernels.

This is not to criticize those people who supply fixes to the 6.1 and
6.6 LTS kernels; in fact, I'm quite grateful for the people who do the
work to support those older LTS kernels.  And BTW, if someone is
willing to be the ext4 stable backports maintainer for the older LTS
kernels, and take on that responsibility in a more formal way. please
contact me off-line.

Cheers,

					- Ted

P.S.  It's not hard to monitor the 6.1-rc and 6.6-rc LTS kernels.
That part is automated, and I can supply an e-mail feed of the
automated runs of "gce-xfstests ltm -c ext4/all -g auto --repo
stable-rc.git --watch linux-6.1.y"

It's having a human being look at the huge number of test failures and
notice when there are new failures (regressions), and then when there
inevitably is a regression, doing the bisect to figure out which
backport caused the failure is the thing I don't have time to do.

