Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B253AE6F5;
	Fri, 27 Mar 2026 06:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592645; cv=none; b=hF74rWpukQaQdTB1Rz4a1zVT0nnyZXSo8b0jCYNGNMpxFx8Gi3hm5T7m0PQeT46tHmHCTrCIgg9kAoNZPcgFKBfHizo0PSk2brA7vGZoZbEfA3kT8kolknVsEvUEbypkaVr2SztSLf4Sq7xAxmsFyZ6XhlLT7EGUbPF8mvwm1Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592645; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qricsGFqu7KQehYLec8D5/NqPJ4ZVae1AgSVDKZqlQ9o6ajcmrdGPEmlUqgI/vrZP/oUct7anujYRwVLQtIUv0YxgGZycMLOubePSrpOBKu7wNVkM2r+hqMsfiyAl1FiL99TVqqKpShBeaKCfa10UpNoyydzeQQ8AMwiH5ZPwTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Akq7hqCe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Akq7hqCe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Akq7hqCeq3L7qJY8xekif/H1IL
	10s/6mD8TowYHAs0Mh0fmyrkIZ0peWfvGTGNTCF+cErSPOUsAkNtmgFnPyV6AnW6wmjGUAZ4L66KL
	8JYNKgvXqMwpNaBCB0eNNjaEqkZvVKgOSpHYo0QSvmGp2pCEgBE8m8yaThFWOMuq2S3o9WujStozx
	rMN/mT7p4HMrslSDJLbee31EP2jPZkFb+Nb/laVv9ipJT0izhceDcAYP9BJhQPT7qzXo1gyOlNjPu
	tZ1u+hIcVpbYpbgdaHfORapU7b03WBQk+uKrxgZbFkKyQxKW1OzDeTjnvACv3vtnLkrzihA5Jj58F
	jv7H8M5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60bx-00000006ogq-2aDS;
	Fri, 27 Mar 2026 06:24:01 +0000
Date: Thu, 26 Mar 2026 23:24:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 41/42] fs: Drop mapping_metadata_bhs from address space
Message-ID: <acYigQf8HR6oRD9q@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-83-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-83-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

