Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBB1175A8D
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 13:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790170804; cv=none; b=KjGPnOLuIfZLHcm4aDeMwmPq0UFBl6aynWjCCBhSiCTwKOVdLgnShtlWZSyMCNvBe7AOcZJokCuJCcZEfcGMaUxCsqU3FkLrX3l9dlWn9M5Nq7vnaPMmK/CWNi0asMgZrbBHAviBaAVytJ0RWBOmXvsaE+4q6PBEMZtNRvB6GlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790170804; c=relaxed/simple;
	bh=1HBtZJd4ru7pzPoUVkKKTsnsNSZp7a2JT/zIt0B3D1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NuIS6R0glYy6yHCwb3SsxBMT/gTBT42NUoaxiwlE1j+hiAyAg2niofnsX0APsJKaXBnANh4u4g55wwszSCMJU55nbW4QyIzcyUrQ6uYFLol131pE5W/1PAsoi+JXW+s0KORuzTw9HaM3rDFpB4v/snxTIgTLStw8WZ7+jkkMmeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=Pzj8uEw8; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="Pzj8uEw8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	From:Reply-To; bh=KIokE8JbrBjyWXJR48YG++9nrgPbrKfeta1rJtsYyK0=; b=Pzj8uEw8XxZ
	JSrVomB4Y2en0YkaurlHsU2H0cK3wPfaCsfLtHVpemQlpy2ku5r6bTM7qSykEVUPHAVZ12GRGJGPp
	4ygBMDHTkN4WWok+nN0REpO6cHP6ib0+RwoaOErX4u8xPOyvzg/dai2ydLUY1vPM2SnbhPfzIQRmM
	jyaHRtGnv8nfsVsFmyjHciqHihv1KRqSu8eLPhtHjahhq1l8dmQ+fZJSsDWRq+cZfzCbWXx+ANzqk
	/BvUx6PKLrhtwZicculxSBOZ/cjoeL9nXvhATZ6/x4cgvAhEcR2wGH/fADXdtCk6iXd0YFl4jwnCs
	l6uE+DKuY/pjxbvsJfs4pnA==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x9NCJ-006A7U-9x; Wed, 23 Sep 2026 15:39:43 +0200
Received: from gate.service.igalia.com ([192.168.21.52])
	by mail.igalia.com with esmtp (Exim)
	id 1x9NCH-008IQb-Sp; Wed, 23 Sep 2026 15:39:42 +0200
Received: from berto by gate.service.igalia.com with local (Exim 4.96)
	(envelope-from <berto@igalia.com>)
	id 1x9NCH-004qtd-2L;
	Wed, 23 Sep 2026 13:39:41 +0000
Date: Wed, 23 Sep 2026 15:39:41 +0200
From: Alberto Garcia <berto@igalia.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <arPWnWhlYI3LrawG@igalia.com>
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <wb7tva6sfgioa64dqe3dqi6ql7rrnlfze75d67vujslmtk4w4f@iz2ju3a36t4c>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wb7tva6sfgioa64dqe3dqi6ql7rrnlfze75d67vujslmtk4w4f@iz2ju3a36t4c>
X-Spam-Report: NO, Score=-2.1, Tests=ALL_TRUSTED=-3,BAYES_50=0.8,KAM_DMARC_NONE=0.125,KAM_DMARC_STATUS=0.005
X-Spam-Score: -20
X-Spam-Bar: --

On Wed, Sep 23, 2026 at 03:29:37PM +0200, Jan Kara wrote:
> > I'd like to report a bug in the ext4 code. I confirm that it
> > happens with the latest stable kernel (7.2.7), but mainline
> > (7.3-rc4) does not seem to be affected.
> 
> Hum, so 709f0f1f1bf5c was merged to 6.19. So did you have a look
> what has fixed the problem in 7.3-rc4? Because I'm not aware of any
> ext4 change that should fix this.

I suspect it is this ("the original filesystem-layer file
contents encryption implementation is removed, and the blk-crypto
implementation is now used unconditionally"):

https://lore.kernel.org/linux-ext4/20260817173311.GB8327@quark/

Berto
