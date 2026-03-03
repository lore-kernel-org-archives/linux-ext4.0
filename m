Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC4F3822AD;
	Tue,  3 Mar 2026 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772546945; cv=none; b=rOJwXqRC/snk5+6uYZbWACIrGvs3hSvScw1DX2aqKButo5o/StxN4SXBD5FkNaSfrY2cXAl7+KsmM2AmcXFDUH5BFnOgcu+l8RmraLyTry/Xnhz0wR9jslejMc840S5gEay2zRuG8dFpbPDrdGt1cxKz0g52incam13v+ME65H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772546945; c=relaxed/simple;
	bh=od45ue3vu32GoRqWe7Ux4lCSbKCltE1Eibw2V39jTeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8UaVvyDRfNkT978M0v5FVu7XYCFCRH7qSzONBXdOgA6r1k8YwH09lni1svw7+QJ/P3X6fTZLCtil6YP7yJlvNAdsbN/Bn5dq0XRmwBlyqv+nkBfqxX6PystVzjKI1g+4LFe0LPodFjmvErAthpGmDZxsIj//RwV+9s7ySPXG20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KoDW+rSW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KoDW+rSW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=od45ue3vu32GoRqWe7Ux4lCSbKCltE1Eibw2V39jTeQ=; b=KoDW+rSWC0BRlHPnPMSudCi6a/
	dNEomDDqiRYTFO3dxAk3ny0bQZVUxhDlUKrhWUvlVbrjoOswnfJBNwL40HQlczaKK3hRa4j0hpcWf
	IUGK+dVJ3OJP1tflf7i5R1Dxt3oFTsAQI6fOWyEIQTafb0GwrFF/R3ZulxGZEngFJlviYzcpW0hjg
	RS5kCwoRtBTwuTbJC5Aj5/5KDXU6V5UTiQeAyq8sVet0aH4U5SUyVRt1JgND0muS+hhMuD1r4Ecsb
	BwbBwkt3qHgddXG0kDKJHw64DA4OXu/ocqMq7zSLmH9kOyOoFoSU2i80zkqjlXkLG1rWA0mpdQg5a
	9RDSefnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQQp-0000000FI17-0hgy;
	Tue, 03 Mar 2026 14:09:03 +0000
Date: Tue, 3 Mar 2026 06:09:03 -0800
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
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers()
 call
Message-ID: <aabrf4YhPJ2X7n9q@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-53-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

FYI, linux-block only got this patch which is totally messed up.
Please always send all patches to every list and person, otherwise
you fill peoples inboxes with unreviewable junk.

