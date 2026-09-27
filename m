Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DC7361DAB
	for <linux-ext4@vger.kernel.org>; Sun, 27 Sep 2026 22:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790547210; cv=none; b=IpszUmLA5bz2q2hqVXEBv2BcY16gOldYBP0K0qsn6Wf+dHNC/S0e7Td77ilz9s845ujQLlTqs7bd7jsUrp6Xj3YeeQg1mDKP9zXOEKl0RDwUNdpPMLS7VY/xbCZxRrhaJlaFr4uti0bzlwOU9JCyCNlavMed64ai6ZWFaZdAMR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790547210; c=relaxed/simple;
	bh=BdPqxHnXg45AnOfbwVevpERymMXaYYPGe59DKZdp7FM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6BYA8mW121DspbGzrxIlOJqZhEn7unQUO72/Q9QctHXKkmC9VLcv4WIvsFpz3JBcyPHdWEsqxoCHPKgBn/juNpJy8oSkJnJ6Zb977el6u8aa/XfzkV456dbsTiF9x5R66+ssSfaNZnO8AYa9CO+C3qncVP45RaUpR5PL3aLk/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=C0BLhYCG; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="C0BLhYCG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	From:Reply-To; bh=EQsuildMV2AOco38CcsA8ZYzCqgBXh4Mzx4uWVpuGNM=; b=C0BLhYCGUF3
	Wvj/TXOTJJ/Xrz8qqOP2RQCTk55/W0U1IMqZAcrx71lhhHhTEv1qzShlpOZ6Xf5ZEYYSkG6bazWNz
	NTgqpGMXNEVZV8vcneCNGveiZxJ1c6FXCQbFNJtJVLJQlZ/xobSyY4hQFaodPWnI7RlDZUtXe63S+
	YwJXq5k53/wI8E5NBc5eQ1bCFmPFQKiSF5ivIyBDRPC0XA4YRP9Cq7ukKJ0RSn7TwpUg/13Od47d7
	94RF0UWFv6y7kLk49TZ7M5Ms6eVA+e7wpu9OF0jZr0h/0ZrVh6/UdjRtXNUzFFUp5XeUxTsSZqwu9
	d2gMHV5g9aEnpBQGxTJyPXQ==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xAx79-0086iT-Q7; Mon, 28 Sep 2026 00:12:55 +0200
Received: from gate.service.igalia.com ([192.168.21.52])
	by mail.igalia.com with esmtp (Exim)
	id 1xAx79-000ld2-14;
	Mon, 28 Sep 2026 00:12:55 +0200
Received: from berto by gate.service.igalia.com with local (Exim 4.96)
	(envelope-from <berto@igalia.com>)
	id 1xAx79-005hPr-0m;
	Sun, 27 Sep 2026 22:12:55 +0000
Date: Mon, 28 Sep 2026 00:12:55 +0200
From: Alberto Garcia <berto@igalia.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Baokun Li <libaokun@linux.alibaba.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <armU51iuvA9d7zvR@igalia.com>
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
 <arPIrtWTXUTwqxFC@igalia.com>
 <cbbfa461-c770-457d-bfc6-317d744f1dcd@linux.alibaba.com>
 <20260923180119.GA1506901@google.com>
 <arU-kvN-75AEmNQw@igalia.com>
 <20260924180438.GB1978@sol>
 <arZVoP0GGSNXYBLC@igalia.com>
 <20260925190751.GB2060@quark>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925190751.GB2060@quark>
X-Spam-Report: NO, Score=-2.2, Tests=ALL_TRUSTED=-3,BAYES_50=0.8,KAM_DMARC_STATUS=0.005
X-Spam-Score: -21
X-Spam-Bar: --

On Fri, Sep 25, 2026 at 12:07:51PM -0700, Eric Biggers wrote:
> On a filesystem without the encrypt flag, ext4 rejects creating new
> encrypted directories, but it doesn't reject accessing existing
> encrypted directories.
> 
> It *should* reject accessing existing encrypted directories. [...]
> The only caveat is that, technically, if an existing encrypted
> directory is using the old policy version (which before v5.4 was the
> only option), it can be unlocked and accessed without executing any
> of the encryption ioctls.  So in theory someone could be depending
> on that on a filesystem without the encrypt flag.  I think it's
> unlikely at this point, though.

One problem that I see is that e2fsck does not seem to detect such
filesystems. Wouldn't it make sense to fix it there first? (I suppose
by setting the encrypt feature if an encrypted inode is found)

Berto
