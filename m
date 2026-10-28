Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203272;
	b=f0uif3tumNBDDITZ0b/QaXGWlNqeBKr9v3tlcbeCZ1eP+B0ohHeK09t6tnTuylwNcAs1
	 AhggY6f/k4VzM8KBIAu9aVHWP6Kzs4QtCo4Hz4elPcLeIUKq0ok1yNFAX5JK5ZfE4x4j0
	 5xo/OOeQHkKUhAfoSRuaej+CKNfmbgdkfw5p1chV84mW8w2sq7PNW3BGk3ygOrVtEJPOU
	 2wELU8iR9BMEHlF8cTqj/E6CGs5kMdYT9CVfLPas0f75Lkw23KhjiHUnv8jJaV2GKqWsQ
	 ne+oJgonx1pYDoiHq6zetCImOTxdSaD793+xstNBH6WxbwcYHzo0nCKxmc6w4O0ZmZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203272;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=el4tcfp+o+/jauZ914UOk0SYbbYJ+r53ap7ucQWvDovygnz56IsTFDOEmvAzx/+L3sou
	 AKXY3PTx+YWJdH3I5nCF0N3ghQMA6BNGQlT+5JNRfEOzYiAUfNgf/etfzIit4QULktzXI
	 sREDkB+KsV7oqpWMXLsbULIwhNQtq85s8xai3qazTU2AKG/cASx1VXSu91YOKckE7VsnZ
	 FGczn60GEOEOBaNUgr2kaNXM5kR19G9wOfRY+7b78ganHZeXPG3pJZkobf1o+u3UIwT26
	 v2/xQeB1XZSEHPiQGW0sFUUkc9Qj/THThW7zcjdIiLDst8pPy3D6fwIPiy/uX6Hj11A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBC2606A31A;
	Wed, 28 Oct 2026 16:01:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFBC2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 71B0368BFE; Wed, 28 Oct 2026 17:01:08 +0100 (CET)
Date: Wed, 28 Oct 2026 17:01:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] generic/810: check that RWF_DONTCACHE I/O drops
 its folios
Message-ID: <20261028160107.GD20501@lst.de>
References: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu> <20261015-dontcache-test-v1-3-6aa7583973a9@columbia.edu>
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
In-Reply-To: <20261015-dontcache-test-v1-3-6aa7583973a9@columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
