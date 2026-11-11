Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794415655;
	b=THu+IlgmaWF36pZpAcgDjAd8dCrcenYKG5AkiHE9StFYDErpVBF9gNrz/03rgpjVs5o5
	 d5mbVvT5OarsJJSU1/67TtnIdgmlXwvpdSm6XR14+H4Dm8rdmr8NM7DxFwP58TnvrPrRV
	 opAHYzYvIYmI83KtqbH+NoVimWOSV1tiA0PctONTvpGw+Yo83f4a2CBZfOWmlOotNrKCz
	 x+Ix2mWPnGddpzBA2qXU5dx8HTismHuEcwho1fVsFPydOR2YK9YIR34dy0RxKBlYkK+gf
	 yaeIBFnb8wm89ACMFc+idJ6I2XchZkkj0KN/Pdk/XZ3Cc8Uxe7HNOq9WYokHfC+zZQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415655;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=K+kwHAGEkFDNzJP5n97ktqb34uHUinchimu8hOpNZYw=;
	b=5VU5/IzlFllAE8jgQR+25bXIdyf3/FuSmaEjjzh/V1TjOYTeLYPMqIG/O6rY5xTWalVb
	 2Y4v1f2s9M9MTqb6VOoiBTPmNw3/MleQI+GwlyC5lnoIFc2qEhlS6tRePguH+XnyBqL16
	 ALVlhgvUVb8DRZQhBxtQ8lRCZmaMEKFmDt0/Tw9zKGrwvvyClV/t7RxJ439JLK3O5DNF8
	 41btsfgeTVOOZjL6EKtYuWQ66LZ5lx8NGFbfQuEwHhU3o79lTYCatQayPrA59P87Zhqdp
	 wlWhYu/uTpK9TVYAWQGOUJ5ddTN01AaXG7c1DlDKFy77KdKAnPuUcSy3SEEuDh0haUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2646606A321;
	Wed, 11 Nov 2026 16:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2646606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E5F1568D1E; Wed, 11 Nov 2026 17:47:30 +0100 (CET)
Date: Wed, 11 Nov 2026 17:47:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 2/3] common/rc: pass -V 1 when probing pwrite and
 pread -U
Message-ID: <20261111164729.GD18355@lst.de>
References: <20261107-dontcache-test-v2-0-7655bf08d6d1@columbia.edu> <20261107-dontcache-test-v2-2-7655bf08d6d1@columbia.edu>
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
In-Reply-To: <20261107-dontcache-test-v2-2-7655bf08d6d1@columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Nov 07, 2026 at 09:19:40PM -0500, Tal Zussman wrote:
> xfs_io refuses pwritev2() and preadv2() flags unless -V is given, so
> probing -U without it always fails. Pass -V 1 for -U in both the pwrite
> and pread cases.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
