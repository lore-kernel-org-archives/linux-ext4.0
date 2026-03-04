Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4599E1F936;
	Wed,  4 Mar 2026 13:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631711; cv=none; b=WKkf0P8yCNbCOt2KsdVaGkFC/xmGsyhCTliwqY9d/6sqEKkG6TZOoRNpRGyeAxjxpnrRsSNuJKE3WFvpgIPQUrdYZG5wjAu9mp4Li50zuXu/pYorm/grpBUByfZE4KqshCCepffZUPO+TkwUiKx9GSr6H56gOGdR8ijeR+2zQjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631711; c=relaxed/simple;
	bh=lF/cbWNAZkiBRClEeQv0v8+hIPKKoDPFA2TgerpF5Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IBCFBcxYAIcWrsxD6tiskyCpF8VnHQuVUyFgozFEdM+TWSSDSMK3Ssjt1RPlq2zDqqXrc3AXG55BivfNNqMBZ+JKniv6Dtv6UoIex0qIYVgh+dLHTY0AJ2oa1+FgiFGcNUR3UGlYw3VFOskw/9pesAc7c5OT6C/gjb3EevYKk2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cd5iyByk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cd5iyByk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w0TVsxPotofUHITY70zCKKGc2w7JRgEPcs5hoEtoJ8U=; b=cd5iyBykON7MtCkmTuA2fxz6N+
	sRrRQbJGIreUITx+yGXBaJah4d0KTSszKUJqfiarfchCo81YDMCwTJhiEAX2FuG4F5U1LQnG5cX9k
	gN8cAsZbj77p610YmQ/Sbks35bGhsk/JY+AYAPJOud+CDWm2I8AURLTAZcU8naJlgKyTXquYPZWUt
	I+IT6WxxqCrOxUm8nRtEUSHe35ockE/E39cGKS5fXthlkCuZREL7igrsZeD9xH7vTn/HO4yb20XK1
	HNl/Oqai0dWBigM8bROs5iV99RFPzE8rWtNCrOFIppUiYW2WRJu6om1PQIoK81mRyByCsBbLyJqEX
	x+dI0VSw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmU1-0000000HGe2-2K0m;
	Wed, 04 Mar 2026 13:41:49 +0000
Date: Wed, 4 Mar 2026 05:41:49 -0800
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
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	ntfs3@lists.linux.dev
Subject: Re: [PATCH 19/32] ntfs3: Drop pointless sync_mapping_buffers() call
Message-ID: <aag2nTROMNra7t6l@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-51-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-51-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html


Can you move the various cleanups that don't really depend on any of
the refactoring to the front of the list?  i.e., drop all the useless
code first before doing real changes?

