Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFA2355814;
	Tue, 24 Mar 2026 05:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331049; cv=none; b=gKh0M4O3kUWNMkVoDrFFgTqyV0l07rtZsKafoMk+Etef+5lfgorHFn1IUN4oYSnYeIsp7bNT2Pd6IbTYIgJl6qhTB1QMn1qOuIWjeY0VI8QO1+E/4qrP1p34iMKPB5w3A9r7sP/xIufk5d8Wu+9e3b3F0Y5IAKEcV8ck7bFwPa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331049; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G67KzSMjOW+vO4Pa5yhki9awpLxNNue+QmIuZ+c8MthoZPSqz4BGr6fDH1y9rD/FXLY1lpmoyYRz8VGxwmy69ujBUPekDOH7We9/f74d7peXbRNolK9g3pBr490Uxh89naHSBT2dBYWT+APyG/uonK5OycPfAuWdzRjqFcfGDyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iB+BQ94t; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iB+BQ94t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iB+BQ94t6POntYcGmZm0b2BevR
	BvndDgRFojdkEyZc9t1c7bzI0WM0Wj3Xm/EQnMgZcvsWtnRrb5CZSSr+S1wHMN4J6RDlnlTzauFSc
	wbzXnpHc4oVIe0+KQfcFXOE73yIM+4Mz/+SwYuXh2+593bv42/b1h/hPSkGHKTcmoUEf5BAKJyG5Y
	/HaVPYFMOOiDkgiGprR+3GmjWXItALuYDMHxVvNnAG90EIKrHeGw0bJF5eNaKxy7KzV3pzawj6oHo
	/3vfom51sBi1PgxgIPRPLhhwwSv2q7mRxU/sWgpbEWpV7p6dWXqEeq24ahPKXNH4o93FwcyozX6HA
	8HcEoumQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uYh-00000000cD4-43Ak;
	Tue, 24 Mar 2026 05:44:07 +0000
Date: Mon, 23 Mar 2026 22:44:07 -0700
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
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 25/41] kvm: Use private inode list instead of
 i_private_list
Message-ID: <acIkp0M8NCZs7kNN@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-66-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-66-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

