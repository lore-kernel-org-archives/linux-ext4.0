Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F04136D9F1;
	Tue, 24 Mar 2026 05:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331033; cv=none; b=g/fCADARLLrFF+IaU0ikeOe3UZypntiYQSAJ4MC2jhmW9evEx1GloxWgiEiP2Q1AanWA7DnPOuQaqw+fh93FuEMPgIvA3FS0HkX8qgbj5yCwMPEAyLjd2nBZ3ldJRTMIueHLnBjkKiASHsj9dcbVdYwl83R21lDv8vdmY8llSL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331033; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFnP7d0odLKXK8GuTNmoSXKS9UQiympQ+X+Qus6mwpKvWSRyGzaekGXQc89HYaJxM3mhKykTmgFhmJzcX0NSvFuriaiaZyNfNzFgs9huP8ELzQv5LToBt6y5e3FKemjjkOIBIXhgdRFxZjZ5LjuKzBdu7oLxveRp+7Qs7nNpCTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wRirh2cb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wRirh2cb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wRirh2cbRmbNh4cH4jQekvG4Vd
	Yw+iHCsdPctdRsY5U1ZIjA2quHXNt5vLTA6II1G/f/JAbZqTtQEYmBFgh3k0BK2nuWt048dTAQ5CK
	x6TSuMvZ+eWNoj93CMkcw3PU8mO59Bh3h6S+0uvIRAhtw11N9AotNAJPu/Eb+SDM8M1vi/a6LdvFy
	EvZ5EyUJwXE4iy9ps6IrRRubO9jTDG6C/UochZE43jIf3x0yq9G8CslGdtmDcVlEB0jdr9ND2Pqxz
	9GbfCgk5+79N0zBOxa5yoxyKbGZKZ5uIY13vsXz5JkZNt7GusJn+WdcFKGASah9g+41+qLmyu1br5
	mMQM4UYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uYR-00000000c6u-3u5z;
	Tue, 24 Mar 2026 05:43:51 +0000
Date: Mon, 23 Mar 2026 22:43:51 -0700
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
Subject: Re: [PATCH 24/41] fs: Remove i_private_data
Message-ID: <acIklzf-LT-3ya8g@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-65-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-65-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

