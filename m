Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E963D369208;
	Tue, 24 Mar 2026 05:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331021; cv=none; b=UPfhx9gZhb0KzueROvvJejDqJf1LkuU6XrB7298wHRHiPPgKWdBCC9lgCMiziOrjpjhhGQsJw8SOy8lqGVRqABYuJZweEBePGuLV+efEZ9zqHI86XxbCJYl3hO9LNQOvG0ajTAyLVvJ+CrTH3EkapV1hcuwgldBxPuKoOy486iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331021; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHaLMGw3O4h6lQzXm65d10j6U4Qmm5oHvVszDefBSeGcr1N0oHD9rGOOL8aBz6KFUkaG0ys4jgzxMHDu/qC8itc95a8N0074zlX53j0hSNeoWZWDAZSLns4wFfnqYZA/kASWFSxttidys6iZLo1yzbSLE0DV20iUVbGDhx9kzNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pBg3WXbP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pBg3WXbP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=pBg3WXbPnZv55WxBVyYRkoDwX/
	bhO0iH+lvaiDDmwAyc0oFQ0HRIISS6eLW2R4k/Nj/jCpSvKn0YxJt/uDuDpK0IndKu7Jy5Vlc8tvo
	YnwzD30uubsKFUTEhfipzSOXDxxlYV1n+8zpnEWVjwSfXegb1Sy4iwosuZyXDKey5Ool+RL+byTpa
	bwkUEoTbsvlFqxwPp1ZFRp1yiLTWdbWpdiGjVaBNl0iXbKLtLz7yzucfJ9t/0lYAOEpTIVSlYYZKO
	agX5bajDkIelu9eq/ZhUaAW0f5e3D00GmTO9U0Mi80khdn63tvr2LmNxYQLhBEs36PhPnrh1GG2vm
	aCp3YIyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uYG-00000000c14-1EsZ;
	Tue, 24 Mar 2026 05:43:40 +0000
Date: Mon, 23 Mar 2026 22:43:40 -0700
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
Subject: Re: [PATCH 23/41] aio: Stop using i_private_data and i_private_lock
Message-ID: <acIkjM3_-JrY7QE-@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-64-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-64-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

