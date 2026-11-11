Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794415674;
	b=jmyTEreSQNWNSs52AsrrW42pE28na+Wt+HOqH4y25ZYZQkbsCIF7a/XgiFu4gNbvTHUC
	 Twwfz8PdbHGcjk7AuFnLr1x8QY9DneruttcJ0zrAxXIW6oyZq9SxEfDJLeTy6QHhu6z3r
	 oE4VAJSmIAKQagCOkPf3sg+IrOLLW/H6DRY6RNVweDe5Sw4QPg5Z06FNqZ2jVM+fRoqrH
	 /WvUVjSovr4LoBzCNMzXumclgCPjEwmrU7Gb5d53nCyo+wGQF8AJjN5vJLqwyYUD+rd0f
	 uSbJGf83Vk4OzbXrbMcEd+dhZK3AZMFyWB3KJa7hVZgp8ZehAX38L/S+HnRWYPWMGsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415674;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=jaUsAjM+2qfNh+5B091OSeKQ1htzDxi3vFNpJTk7gknRccdJNEkR+0A8C766PCMBDcFJ
	 G0ZxOhEMcNJZM85AQU9d/mlBIcA3RjiGEsxqZ1nM0oTbmXuR4J1QdBZnVe2/6Rx0svv6l
	 sXE8tTs1FP4ppSl9YplksDi2VacCqoBfuuJhXCWSNzcPgte0I/Q6Kd6pE6Da8+sJChsMV
	 oe8jsf0nHwQoVkLzJ8LyktRBNF6V237x6xIxKWlLwLlfaV8iOjmB6kTAh8oSE4RFbuHtG
	 zIOGA5NxtA3YRavM6Oba3UDYVVbt24w2+vusj27/TU5Neeot0wgZ81py3Df+FxonIsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C8A606A324;
	Wed, 11 Nov 2026 16:47:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76C8A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 062A068D17; Wed, 11 Nov 2026 17:47:51 +0100 (CET)
Date: Wed, 11 Nov 2026 17:47:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/3] generic/810: check that RWF_DONTCACHE I/O drops
 its folios
Message-ID: <20261111164750.GE18355@lst.de>
References: <20261107-dontcache-test-v2-0-7655bf08d6d1@columbia.edu> <20261107-dontcache-test-v2-3-7655bf08d6d1@columbia.edu>
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
In-Reply-To: <20261107-dontcache-test-v2-3-7655bf08d6d1@columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

