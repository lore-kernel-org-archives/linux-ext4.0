Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFC24ACC8F
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 12:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790167237; cv=none; b=S3pwMEW1zqZfhhUDDSp7HLNv07Bv7xp4Rp9iCoXTvELcP/MYHq/cO4hH+C+rZXJqxHqk6kD0obcfvXpdMGQCUL8wJMob4gCNTfQfuuHdq2hpfltmynZ1nALqQuhRTmbqRk1ta5nlFLd8gkZWk5mJ12l+quxuICw34BhI9aK2d+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790167237; c=relaxed/simple;
	bh=BFv/Xs6roZL24eaFE8/RYyeeauvZSO0v7s8/yczrSPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J1rVsZVYEDxqWibV51u6lFKZI3WsFbqgqNE0xgOQaH5ac6WNB9vU1dXoDg85RZ2NkfYppdGVmokX8CnqUXtU2aW1bjSsczLq2bI4ApwCkzP0DY4fyXvAquS/YxR6Uv4QQMOhOVHB/Y+8fDeOBvgId341MCHRtfY1uBZpdDmy4+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=aU9lqZDv; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="aU9lqZDv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	From:Reply-To; bh=BFv/Xs6roZL24eaFE8/RYyeeauvZSO0v7s8/yczrSPE=; b=aU9lqZDvxC0
	7L4szrQ8HrnprlnoIQKO80W0AtNUlwGuRiPu0ni8jWR6HbKyqe1tHenVhM7HLYmgQQHGC+K87AWib
	muhIb316tZQAmKTD2aoWGEmpcfLlh3X474YtOrrIf5c6b/b2uvFgobsm3G6NUXiVRHY4GvlT8K5Y6
	YLO97yTb93iR1zYR2JYe+bQ4KKp5CYDd7Y6TJVtvHOQhGgHuDbofmILF5PYdWrRreM1I7lPhruikz
	DY+mqnpATi+okOv7X5zuBAlkbszmRYmT5xJmEob1AWnAx1vlScRShG6y20HKmmlRzaXX4+4M1T1gU
	mGJVSQnK88o5VuIMGuNQRYw==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x9MGl-0068X3-MB; Wed, 23 Sep 2026 14:40:15 +0200
Received: from gate.service.igalia.com ([192.168.21.52])
	by mail.igalia.com with esmtp (Exim)
	id 1x9MGk-008BQP-Ci; Wed, 23 Sep 2026 14:40:15 +0200
Received: from berto by gate.service.igalia.com with local (Exim 4.96)
	(envelope-from <berto@igalia.com>)
	id 1x9MGk-004pwp-0j;
	Wed, 23 Sep 2026 12:40:14 +0000
Date: Wed, 23 Sep 2026 14:40:14 +0200
From: Alberto Garcia <berto@igalia.com>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <arPIrtWTXUTwqxFC@igalia.com>
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
X-Spam-Report: NO, Score=-2.1, Tests=ALL_TRUSTED=-3,BAYES_50=0.8,KAM_DMARC_NONE=0.125,KAM_DMARC_STATUS=0.005
X-Spam-Score: -20
X-Spam-Bar: --

On Wed, Sep 23, 2026 at 08:12:03PM +0800, Baokun Li wrote:
> > 1) Enable encryption on an ext4 filesystem with tune2fs -O encrypt
> Is it valid to enable encrypt at mount time?

Good question, I always understood that it was allowed and tune2fs
certainly doesn't forbid it (compare with casefold):

https://github.com/tytso/e2fsprogs/blob/v1.47.4/misc/tune2fs.c#L1599

Berto
