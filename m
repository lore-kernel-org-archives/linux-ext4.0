Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44DE382374;
	Tue, 24 Mar 2026 05:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331285; cv=none; b=rfirTwffeI0RjORYEhO/lo3/F/FknFgUPd70kWsvgErXSuMFTurGuD2PDI9covdHpT3LOm1CgSA2WGeZdG9ZyS4xlWkzMEIDnFlvLuPMd8r8Ru4KNsyL1vDkrIU9oszdoQgPY5vEPgzeMz6/MFACKer1a495ZEWqIQlIGB5j0dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331285; c=relaxed/simple;
	bh=dFj4PXIWzhbmUJOFmzQNt1qgtQ8syeC3KliuYY5z/vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6OFzBxvuZxSP27+BExCseKlHZyFBHQFYqZ1+y74c2QegdxuS5XSkeRPOKEXSTruuGj2igRGDt9cBc0VbeCWYtZDVwwtheAe/9b/H8HaGcyJuusxpTzoPWKbyPdi8mCBJ2sq8hl9bylAVJiE6KfkEhsKVbINLNp689atglG1Yhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RkdnLp8A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RkdnLp8A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dFj4PXIWzhbmUJOFmzQNt1qgtQ8syeC3KliuYY5z/vY=; b=RkdnLp8AeMvGpxqAGV6PPJAZbP
	W4+xDfsdYs89DYje9BNAJz2dFERvYTd7KmdlLCwybcTKZKpzoiCQDCeTLbHw6/QS+PBMRwqDv2iDg
	swRxEYC8pGbTAOFaJ0RVGN8pccl3sm5QPlWUl16bsLoPhd/RQal09MSrAkgMGueKwJ814Gjdy37y9
	tpqoFiLGHxaZAnbZWj4GHT1DM2d8HvRMmFUDSBRr+1PvZs1B6UPboJrpoJs4eBEERE3FxzcM/+jGL
	AnTw/eTM94So7dk4wPuC2JhfBnzTfHJwtpqeUVXYvcDRhiQimWS3gtpjE/IV97Grdy9Jgx5pkxuwr
	mGdS/mMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4ucV-00000000cPn-3qfg;
	Tue, 24 Mar 2026 05:48:03 +0000
Date: Mon, 23 Mar 2026 22:48:03 -0700
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
Subject: Re: [PATCH 29/41] fs: Make bhs point to mapping_metadata_bhs
Message-ID: <acIlk7uLHqXCUpJB@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-70-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-70-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html


Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
