Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECE25C613;
	Wed,  4 Mar 2026 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631486; cv=none; b=bIRvuGoH5abL95Zu3unWkIW6w18SjdvQ2njWlZmoTOg6DWRm2CLbuKT8K0HUVuRTO+bD2i86/7c6oDFQJm3Br3TwBzOPRCnTdJao83PLLjK2j6OiJJXosWTjany/sdOrLSX0dDsFZdYVwxAmeV4qVWFJ9fbJZHa0l5HGKwMTCHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631486; c=relaxed/simple;
	bh=KcnJZ5GcRmxZSNqRVZ8ueAG/BKkaYuYvTpHl4+/qLTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=USeJEOCiNsMjR1uVLEuT2gZEA30bucr1uJovhU1SMs1aJ8KedZskdy9uU8ao1qCSkB3KvIZ116lar3Xe11MlG4z5HUwOzvPM53WfejSi08F8fQwSGZaLGd3Mr4x68MM7hYGMG2PyuOCqEe6e6r01cnrqAz1FVHlUh5fobv7IMEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ebsPMKaT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ebsPMKaT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KcnJZ5GcRmxZSNqRVZ8ueAG/BKkaYuYvTpHl4+/qLTA=; b=ebsPMKaTp9H7t/hQ92QY4u1DkG
	zKuhWcKM6/QbdMthk6UntN+XsckWYhbqpeXouW3CD/VRwr89pfmjZsMSgT/m2Ce12xpz9PN2aJ9yQ
	leWM1BsBc6hkYy4nMgzB3B9XxhkA8x3Ns96/0ESGIG3Gg54CPdFBZd2cA3cAhxhuNU/kdCp4Zjf/H
	zKX4SYZjHaOK5eqQvVn9Edh9eUXLwgrx/buazH5JiJJFhID7L3WPr2QtJ0ihGotqnVIYXfsxCJ9kJ
	cRchsSLhwhfZP8Ivkg/vFPUSD/+ERzIKBpKKn1f93mq4rGsX1xRcRN/XlFOY+Xe90/ygmn2GH696I
	rz51RF/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmQO-0000000HG8S-2KEN;
	Wed, 04 Mar 2026 13:38:04 +0000
Date: Wed, 4 Mar 2026 05:38:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 17/32] fs: Move metadata bhs tracking to a separate struct
Message-ID: <aag1vDoCVwAlIKPq@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-49-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-49-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Maybe just call the structure buffer_head_list at it really just is a
totall generic list of buffer heads with a lock?

