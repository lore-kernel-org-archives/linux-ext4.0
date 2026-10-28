Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203253;
	b=ueJgJ6mVg+sWRKOEo/nV0vyCIArFk8nCordDrf9qtG9MnmfnQc20gHaGD2kcCvgG70ds
	 3eFOpJP+P9/OeQ/8FIjO0x7vnaadysrOxowyER0hjZSrXCs4eURTXF+MirLCiVlkxvUU2
	 6fChEC6Q7s/1mnH/OxjnC2ScYg6ilQVDUGmG+Sfp/Ql7G2awg35GLYVTOe//y3JeAvJhK
	 03Lo6GKmS4Kdz7A3evl6Wi2pmZSCHs8VKaktxUXAfz50wYKbVZqwu+ux+7zwY03G+MMZ2
	 u/2akX+mA93knfuYcZmalEE5uexK22rB17h7pZZmGdfmEnSkzAkR60YcGmpxItTsRAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203253;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=1JCxV0eETWN2tS7hBtxHmTkzEDJM03hNUoFHFj6+ihw=;
	b=Bqzxz/41DhysEjtjnBT3YQ3oz8OUsgSbbSqGuGCHjZzch9dQpJDbvv/iwh3xxtbgnfID
	 RpIKtuANS69THjSgjYe5rRhtT9nmW9UPYW03EZtr+egsiylUltZwv5EMBZWmV/uy5OvLn
	 TDuNijGIL1nkb3NR2VGZJ9VnE/EV/Q0W71HLiFDpQgrauc86r9Gm7QRLgBja7pwxxVKxE
	 sGhRGH8YZbnGVmvmknvKaJIKBT4h+nYgM5xKA+bKSmmYkoPZ4rQh/uAa5Ocj++wHm2szk
	 WdT0Cn9Qt3ahd3EcEaXexJ47sO0uaze+CWbbmVgVZyRKZnbu1YtbcN6eh3xk5Y5YiMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FEB606A31A;
	Wed, 28 Oct 2026 16:00:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8FEB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A2E2B68AFE; Wed, 28 Oct 2026 17:00:48 +0100 (CET)
Date: Wed, 28 Oct 2026 17:00:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Tal Zussman <tz2294@columbia.edu>, fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-ext4@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	"Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] common/rc: pass -V 1 when probing pwrite and pread
 -U
Message-ID: <20261028160047.GC20501@lst.de>
References: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu> <20261015-dontcache-test-v1-2-6aa7583973a9@columbia.edu> <atoOzsNo8zUTrxVj@bfoster>
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
In-Reply-To: <atoOzsNo8zUTrxVj@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 22, 2026 at 09:25:34AM -0400, Brian Foster wrote:
> > -			-c "pread $param 0 4k" $testfile 2>&1`
> > -		param_checked="$param"
> > +			-c "pread $pread_opts $param 0 4k" $testfile 2>&1`
> > +		param_checked="$pread_opts $param"
> >  		;;
> 
> I find it a little odd that we auto add command related options here
> even though the test still needs to know to use those options for the
> commands to work correctly. But I guess there's precedent for it, so oh
> well:

Same.  Given how annoying the required -V 1 is, maybe this defaulting
should go into xfs_io itself so that -U, -D and co can be used without
manually specifying -V ?

