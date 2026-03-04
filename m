Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203FB2853E0;
	Wed,  4 Mar 2026 13:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772630358; cv=none; b=YhZTpWzmNwF9Lz037nmytHB4ho1+e8r5RYaWFi6gTKaVgXvaK6IMGAw9gMXNOovgbEi7WRtKME6NNZAxrw4sI+RrLLhX4kUMj1/SN5EXFz4ntiRkJ15M5xopA8qoZD1EvboAfo+H3fuIB21R53KQJM071zmMudrVvCevLGtZ2hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772630358; c=relaxed/simple;
	bh=05ISfwLDgvF4qwFlNm4OxsFHu0x6DKVuxg32b84JgwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Een/9UpON9UR57Wd80RFv03/T09ZaZqCOwFelzoDn27r0j5059WS8RqT59dJ9VMdA55HA65FYcgcTUNg1c2OWJywfI6NrmUuXVHUmLX5YOXlXkO8n+YMZ0QRaSjfE2hParqa6wiigbGgz8exfElv8Vq5BarHW2u/TBXrxmIwwz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fXnxO9o7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fXnxO9o7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TMZH0WK1C4n56ljgVGIRCSTXXXU1JGue2xDQdEq2XRs=; b=fXnxO9o7WLxug4TIjrZkzTMZ/7
	kWI6q60pGsZahi56N7QcRB3pg9gAxK6wALzpGHemg4FYrGsHq62k5MoFGDhZEi4xgD6Kx7xSPLtoM
	Glap+HyhSQ2J382UBlQA7YYTYGcDhYf3GiA7Y/uhRlIFNUpmgNmaq9l8Bl+aVyD/I2xf5PvPEgpaw
	ECRXXVFOwQd6rD7mAyXQAqbU117UDT2fcOTutKd8u/3TVim1cLSWLNKOt6LJ+5BB9OEfh+DyCUX0n
	I2PK3ww6WzbbfHyzzZeOjXAhHnKz/0aS6UebU2c0DVagKj5Bqrvh1cnBmZbkg3H2ekPUsC4dcFimK
	4tdwNMgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxm8B-0000000HEtk-3ses;
	Wed, 04 Mar 2026 13:19:15 +0000
Date: Wed, 4 Mar 2026 05:19:15 -0800
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
Subject: Re: [PATCH 18/32] fs: Provide operation for fetching
 mapping_metadata_bhs
Message-ID: <aagxU5f1AI3y0wrw@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-50-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-50-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 11:34:07AM +0100, Jan Kara wrote:
> When we move mapping_metadata_bhs to fs-private part of an inode the
> generic code will need a way to get to this struct from general struct
> inode. Add inode operation for this similarly to operation for grabbing
> offset_ctx.

Do we even need this?  With your previous cleanups almost all of the
places that need the buffers list are called more or less directly
from the file systems.  Can we take it all the way and just pass the
mapping_metadata_bhs to those functions?

