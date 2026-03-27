Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AADF3B4E9C;
	Fri, 27 Mar 2026 06:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592661; cv=none; b=r5tsIVFJlFTFdyCvAkk26ITr8er/OKCTbqdkh8Ojgfnx1RMUjErukozNzVbtv+ywpdP+noNAA2EzX6Prdi75q4/QuuZI01ts2XDdZOymeuFFNT+IfdHcQI+fovh0y2BcRhzxhZ/vAGCVAfkiENeFrQq+yitVCWKJVjnx8VyHrYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592661; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJk+LuekFoNl7Z4QimYiQT+4i6Zz3VqG8NFwpkwaYJqf5vpn6KxFbPusv5YaZ7Diz8JALj6h7GbqEc+XtFMfLMh+ogcHIJ+qca3ReLUuTpVpryXzD2fCpHTdpi473Pkvb8M0fDzfueOn2Yiw0z0QtPHp8vbWpaI8oY0AaMVwzNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VxYmAxH6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VxYmAxH6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VxYmAxH622ZqprtyneBXwuBYpq
	rlXaq9f8q/OWJ8iP1aMo71+0yJBEZ1R+si1Kz2Y5ap4Tr2PiTxd+EpPkhqtxnGIcLgZweEzRbiMg+
	7MzNA6J/WBMlnn30duKN+uZYhgnFNly92QVI1grMTMIOlZzguaGQKcPQuU2u5PGPj9nXtMsF3yHpH
	R8AvobDX3n4BDZdLNMJEkcFto36O0rP43Hgxar8p5WYLG6D2EiUvvQ2V87+Mfh5JmrKfqKcHkykny
	IjBNh+iD4s5iuzA6Q/Ld/q720FO5GtoVAEbDztxFPHuC/S7xG5mas1vxgQPOCcXSNwhzxeGi6jpTl
	qgaQj2YA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60cC-00000006onL-38zE;
	Fri, 27 Mar 2026 06:24:16 +0000
Date: Thu, 26 Mar 2026 23:24:16 -0700
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
Subject: Re: [PATCH 42/42] fs: Drop i_private_list from address_space
Message-ID: <acYikG19JAVWxL4q@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-84-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-84-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

