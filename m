Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BD9386C38;
	Tue, 24 Mar 2026 15:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774367669; cv=none; b=DRnHbGQ7vA7Y2i+2imT79xlVj0T1nD1P0FEfSJH7oX4DNdMP5ZNFXV2Shrg7BtajubWCmI67ioxrm7qgfc/M+gO70I7dqtYNVtBhM9HbcxlOHKn8HgqdBrn6TY94Axz3NX8VZW8d+DoI2EaFnn0wXdgSmgdwoKZkUS+mpyfdHUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774367669; c=relaxed/simple;
	bh=KbYmkEWDX5xCI96hmXaNT9f7KUtmIZhSGdAp9nzN7/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a+u5V8On+V1d1zkRbMh9isSIlwxBfnSGClGOzkzswzBHgFF00qjHdKt4Xoi8JOj9zOBa+Kqx4Pd77IPMspjvnvwAOBdgyMmkZpDs6SP4TFvXPaVFIPJWZA19lBo3e6K3xcusia2Ke439Bl13DC9lXYXvBVWf7fOO5vmQdCItYi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SFRR2AU2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SFRR2AU2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0OJwGIwkcTDehRPnixVOyfTvqxydByh7rJFCM6sQA7s=; b=SFRR2AU25aXwGVjJvwFLF3gDgO
	CbdZeKb/9jBMzKy//cI8sVP8V51izbKH4hpRVvaHwZbOh82i7nQikRYyuBXjMYeYC967m3zMLJHy8
	6fVM0TP4GYzJpa7ESSVcTUm9ozOeEK03eAAsAy5Fzb13DOlWRhyOPfJK2gPJInrQKVW0Zs0SGpQ5m
	gGQrFqYn0+XosNl5gdgE/zUCzR3PuGtomDL14UimKDey4wIeHnhBuYZxW2hKBf0HwS2XZam2L1NpT
	d9+5W8CgiiDjPzRCvAGIiKiyJIp81T9jngiiv21p8l/Uld1yt1cl/xmOYjyoqD1TE5xWtWSAZTI3y
	bZNRjwVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w545G-00000001nIU-1AG0;
	Tue, 24 Mar 2026 15:54:22 +0000
Date: Tue, 24 Mar 2026 08:54:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 12/41] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <acKzrqjnKFNK0xmh@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
 <acIjxUzWFstarlwv@infradead.org>
 <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
 <acKO3NRw852FdGUO@infradead.org>
 <rsftk7gdlamfryksv63vhmewdi6etvvfyi6as5m2zs75ctvzkq@fnoiwumyfdsv>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rsftk7gdlamfryksv63vhmewdi6etvvfyi6as5m2zs75ctvzkq@fnoiwumyfdsv>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 24, 2026 at 02:36:53PM +0100, Jan Kara wrote:
> Leaving the two implementations separate certainly works for me as well
> (that's why I've put that patch to the end because I've expected some
> discussions around it :)). Just the amount of common trivial calls you need
> to do (fdatawrite(), sync_inode_metadata(),
> file_check_and_advance_wb_err(), blkdev_issue_flush()) looked high enough
> to me to be worth merging the implementations. But I don't feel strongly
> either way.

I don't really feel either way, and I really should not micro-manage
the series either.  So go for what you think works best.  The important
part is to have the fsync changes early and to avoid hardcoding
buffer_head knowledge into libfs.c.

