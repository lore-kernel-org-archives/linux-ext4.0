Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8C52DEA7B
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 07:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777965716; cv=none; b=hs6CZ82CzrbucDo+N3oVMwH8WGVFgvyxF464V9yIJeDFeRqCS4SexY8C1nO3RDE5SGA0oSw/GQwG5d3dYsi8FtOd4nm4hueg7yHclNvun6hsauMRp/zJzTYSfoA+T5PZH+gCYi4hHWHcM4WOeFqZU5wtx+EuCQQKHDwxiNliLLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777965716; c=relaxed/simple;
	bh=l6Beqllog2k/QVvN8uoBXsYzD4dkIyFcekuF9GcbypU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uqW58XMKlMe7mlQ9iVpC8oLCydxO0Z+algr/Jc4OkwmRPp2uBUTES1T3as/Rny8CEtiz4vALG06r5254J0YM6uG3vuBusQhCZdkvHzdUCNEiRJM/6J0edwt4/cCzwkYlPLBrGiE41B9kuOgucjF+R1/6bmx4zBJs1YYKTBtn5bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=QXz11Q2w; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="QXz11Q2w"
Received: from macsyma.thunk.org (nomadix.esplanade.hr [213.147.98.98] (may be forged))
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6457Lj47012353
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 5 May 2026 03:21:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777965708; bh=INZQdOsvOb4vp9h7LlBrhlZVnYLFVs2k6ksB9kzoW+U=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=QXz11Q2wcvR9yJFocxlGo2WMiViv0qSZ7ZKQA1Cynq/cnRoPLJo6ZKMWtsMM3tdnH
	 ckaR5PawWqBsVuuf+ZskGnBAo5xFbqpQiVLZRwH5VZTdUUFwXYNt1FMGOwx6mlFnip
	 rp/xchg8851Rlma1XqxBsNXPLm1kLKqO5bcJ7WlyuTUA1rIeG6VIMOX2MopVdKe/GY
	 oXYapS5OAZyA7Z7NUnLR+3bSXXWF60qRga3WVsWRucl6KALDBLPpbjSKjv1A9vyEha
	 J9/yEAhHMSUP0xfZtQlDWZPdgWqf3JF4XpAxQ+RqKtKVG+WTj1lyJLpVgU2/tvlueO
	 hVBt2vYedRWXw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id C338F663EA19; Tue,  5 May 2026 09:21:44 +0200 (CEST)
Date: Tue, 5 May 2026 09:21:44 +0200
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/7] fix up issues from djwong/fuse4fs-fork
Message-ID: <20260505072144.GC16497@macsyma-wired.lan>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260505000831.GA1101423@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505000831.GA1101423@frogsfrogsfrogs>

On Mon, May 04, 2026 at 05:08:31PM -0700, Darrick J. Wong wrote:
> Hm, curious.  It's regrettable that I no longer have a Mac, and
> therefore can't really do much investigating.  If you give
> -o default_permissions,allow_other , does that fix the problem?
> If that fixes it, then fuse2fs has a bug somewhere in its own
> permissions checking.

Nice catch!  Yes, using default_permissions does fix things.  So now I
need to figure out what changed between v1.47.4 and next, and what
default_permissions does.  I notice that in kernel mode we enable
default_permissions?

Can you give me a suggestion at what I might try to look at next?

    	     	  	     	     - Ted



