Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AD634FF79
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2026 11:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790334393; cv=none; b=lvnYvsjef1UdfDeIlQwwMYJAznSagWbWTj1BtmIhwWM71+pE5KFIzBIJ3jhk8JsKYvVkHjIlt7BgPjm13WgPCDalFORO/Q2DgTxODlGqRZrR3vllNXw0LZDCEL2xU2+OimyaPm857mDk8JSSfRxAnKEE0ZCPxT4KjFY+PNqN4V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790334393; c=relaxed/simple;
	bh=rR08VvHbvDNslU2oWwvqZuhMa2d1inGSgvhlw20pwlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvpBok52eEoFIV3AWwClN0YOdFfjgFx7u7M4H80yJ87zTJFTRMw8ba/VCSvs2AAwzgRDC20Wtrw/loAwfJsFXwTmCKr9UkkryOki7KiRh+kFDs4cal7MG4k7ClyJ1ExTvqVb8oQ5c9bT9y0apV0seyCD5kobSMzMr0cm5MLOebc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=F4+2Y84b; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="F4+2Y84b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	From:Reply-To; bh=emNS8hHng0GrB3PJuJA9IrXWETHfXUx8DUF5u+MYCz8=; b=F4+2Y84bt2q
	DflMctcyrmqbim7FVAJ5vetr1fadmezucLapqujkRXhX2tA32pvTmrzJdUObZlNncueFP4CncK8G8
	Bgoc0b5tWnJZ2vB0Kgw2x3DzCPN3h/epwalqUPbIme4i7rUPvHitrtksYALpQQAXT6TkMsTQga/yS
	dZ+tQxZUlHEhwTBXBMcRaM1ZrwPsIaYzustS7ewg3QAPLDiqhJFjOPKbuPmRx8p2o/6aJgRnWAWUL
	DLi9ozZos271XUNjz89jCKlnAOVgGQn1lpFEcPpUD51j2+1OqK2jSdIbkZRn5BgzeTPWgWkLsXJ2H
	D+zIEszUjl3zgrTuvVbRYwA==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xA3kn-00771O-JI; Fri, 25 Sep 2026 13:06:09 +0200
Received: from gate.service.igalia.com ([192.168.21.52])
	by mail.igalia.com with esmtp (Exim)
	id 1xA3km-00BMfh-Hm; Fri, 25 Sep 2026 13:06:09 +0200
Received: from berto by gate.service.igalia.com with local (Exim 4.96)
	(envelope-from <berto@igalia.com>)
	id 1xA3km-005N4l-1D;
	Fri, 25 Sep 2026 11:06:08 +0000
Date: Fri, 25 Sep 2026 13:06:08 +0200
From: Alberto Garcia <berto@igalia.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Baokun Li <libaokun@linux.alibaba.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <arZVoP0GGSNXYBLC@igalia.com>
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
 <arPIrtWTXUTwqxFC@igalia.com>
 <cbbfa461-c770-457d-bfc6-317d744f1dcd@linux.alibaba.com>
 <20260923180119.GA1506901@google.com>
 <arU-kvN-75AEmNQw@igalia.com>
 <20260924180438.GB1978@sol>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924180438.GB1978@sol>
X-Spam-Report: NO, Score=-2.1, Tests=ALL_TRUSTED=-3,BAYES_50=0.8,KAM_DMARC_NONE=0.125,KAM_DMARC_STATUS=0.005
X-Spam-Score: -20
X-Spam-Bar: --

On Thu, Sep 24, 2026 at 11:04:38AM -0700, Eric Biggers wrote:
> * And maybe a check in __ext4_iget() to prevent existing encrypted
>   inodes from being loaded when fs_block_size > PAGE_SIZE.  This would
>   be needed for fuzzing robustness, where a fuzzer generates a
>   filesystem that has encrypted files without the encrypt feature flag.

Does the kernel reject encrypted files on a fs without the encrypt
flag? I'm asking in general, regardless of the block size. Should it?

Berto
