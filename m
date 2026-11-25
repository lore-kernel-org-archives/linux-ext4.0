Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795566105;
	b=5hXxLe7AuqxWe9/ax1EJ6Yi1Xjl5PTnCLAVRZ362oe6/4MsPSP0mxhTiZSazlNvNBGk8
	 BULnDXRzylVHWzYJQIa1XT0RMtgRIR7YzkcVp1MbYeqekJFaB6ONgpDlxz7h+1pQ+6PKI
	 OOQ48VbYOrCqi1oi70iQVBQGcBZEJ4rO7u72eyHteGuVaq/2SkX3GmlA3ZsbaKqB/sE8R
	 kL/ECMB4P7O81v80KIYcy3vcKlSNCBqKhI0thr5+R5mrUkXWCNNQ+oIVnRIX4QZDPx2ax
	 O7ceqixUdcukfdQyVS//YTQ3Fr8XDuNV+Ast2tPmKtK8tlDTFHLXK5iG38vEG3gut2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795566105;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=uuEjghpv1/pr9D4Pebl1ME5DZktj3XNKNZYdSrj4oiw=;
	b=Wslg8jCHh99BoTjZpk9/Wmdxzes3LQbrLmOTGs25FGTeZkgf5XYNuCyhBMUJbB59dW9j
	 iIOSI2BKuo19RTyBQXPgSkDggAcToo/RSokfguTtXJ82ybmndgI97KdNBhSpbgHntPlVS
	 6+sYL+55pcc9RbNP1MZgpb5wjD4MER74ZuC/GYEMb84JLG99374lCgKtHgWNpn89wEGo/
	 EfgBF0L5lqMPgEl/3vXUopod/4SAlrWe7WCdo+HiuKCdvKONu2H1oAV/HtlDWeoErxRCX
	 tTRGpQd/Pq8u3XiXXpOVxC8YKcAM6xNKzunwEf7YXgY3nDV5GeZ5sjh8mKAhaRCpNSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=qPEwqDwS;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C46606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 00:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10C46606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=qPEwqDwS
Received: from macsyma.thunk.org (pool-173-48-102-184.bstnma.fios.verizon.net [173.48.102.184])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AP0Lcxt030254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 19:21:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795566100; bh=uuEjghpv1/pr9D4Pebl1ME5DZktj3XNKNZYdSrj4oiw=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=qPEwqDwSDiBEV45rKI96bWz5fNqw2a+endazNnQXYdEW6AIs8n6Uyq+f8+ggJgjod
	 IJMrGcCECZ5ojkNfheiIBvafWbDrBB6kWicyulTbl/HXS/CraOspa9IOATfWWcgTi4
	 gIMsOA21aVlxju/eo0ALvGin+Wt4NNM7ebJYe6wlbNiDtckXlo34sQSGuZKvdeg/sN
	 BdGTP2WiAWDmwJi/JS29sSCr3mD4znha2EEdgiPToXiNKqb5XqGkb2qee4w30p+F3r
	 KsP3UmsvR/4RkBxeE1lvTRkXlcvSQtOs9Zs0LZOh3A6Aso/3WEdKYMYy6M2cTtZ2yY
	 wVtZ1udGTBUmA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id BAC2229642B0; Tue, 24 Nov 2026 19:21:38 -0500 (EST)
Date: Tue, 24 Nov 2026 19:21:38 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] updates for 7.4-rc5
Message-ID: <awYonzw5rsvf0cnZ@mit.edu>
References: <awW86EI5fYafQx-o@mit.edu>
 <CAHk-=whyUfwzMDMTpih8Xs1MxmhwTCDAc_YwUSZG79vXFMLU=Q@mail.gmail.com>
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
In-Reply-To: <CAHk-=whyUfwzMDMTpih8Xs1MxmhwTCDAc_YwUSZG79vXFMLU=Q@mail.gmail.com>

On Tue, Nov 24, 2026 at 12:36:19PM -0500, Linus Torvalds wrote:
> 
> Honestly, I don't think this was appropriate for this stage. You
> should have kept your tests in a separate branch for your testing, and
> done this *huge* update for the next merge window.

Yeah, sorry.  The tests were on a separate branch, and I deliberately
put it at the end so if you had objected, I could very easily drop
them from the pull request and just send you the commits up to
308c3c2e ("jbd2: document the h_invalid handle flag").  So if you want
to unpull I can send you a revised pull request and I'll save the
tests for the merge window.

						- Ted
