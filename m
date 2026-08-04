Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9A63F3288;
	Tue,  4 Aug 2026 03:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785813154; cv=none; b=uUxkWMK2BIUTb5H7YFgBL3yJZc/DiYW8Vl8kkrtnS78GDht3oyWBJWnrDLfdfAF/715rqUcv/uCbV1ESlOcMoG+ATXtCVMYMzFQc5XXVbP7/Bp/5lIj8Pb2qLQPfWM5res/onLsptPzjVVezh4II76wEET1+Z/ljSvIDj5oF+0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785813154; c=relaxed/simple;
	bh=rPbN4kCV4ocjVsokg17iwqO9qNBIoic1v4UZAQH6Kz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ucMbRf+AcglorBDpBzX3WM5Y9LN6q4QCfcAV77OyON0zFvc0EKbsZj4POSig8lVHed7oLLFNY4tHK9EORISY23RQg07C6n3MN8HfNdEYXmY7RYJKyxtwnxBItIfnVFoeb/3suj3TN6VykIktdZ3nvjJvWFx0/ASuPdztvsuPiXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p6Qhy4pn; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p6Qhy4pn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pYECVUmofh+K7FP99OZKg9+cLHh0oyiq4MOxV66POEU=; b=p6Qhy4pnrbsn1zQzWe9kyBsY/Q
	az/kg6xydZt2r3u5ALXFtWrUfQoGRUekNgbhKSDM9/e1UXw1Ll8lLQ//QWaFsA9jwsCXLMFgusZCm
	6Mr90t1DeGpAVSl0xKHO+KhAyE1yhcLaMs76Ecy1BJOdJdID9gqw3w3HcTnqNU90k6Wl3sbnx2TU5
	qO0Fzdo42LqKImqJSSIAeXIftWIU84LCWeqiAevDwB71aZalB/9y04w5uXrd3oINEvU+qCpPhIxVV
	FlnCWcQ571UGa57AHwX0Pfxr00urWr6Cq2MRFNcdzbbGiubRoGKCWHxcc5rkkyCQ+SkWoHXiP4kJi
	XuIDEd9A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wr5ZP-0000000FbtY-2l03;
	Tue, 04 Aug 2026 03:11:59 +0000
Date: Tue, 4 Aug 2026 04:11:59 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19] jbd2: point the shadow buffer at the frozen data
 directly
Message-ID: <anFYf1iKrNLAjJMw@casper.infradead.org>
References: <cover.1785621505.git.coshi036@gmail.com>
 <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>
 <anDZ5YG-Ljflv7Vm@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anDZ5YG-Ljflv7Vm@casper.infradead.org>

On Mon, Aug 03, 2026 at 07:11:49PM +0100, Matthew Wilcox wrote:
> On Sat, Aug 01, 2026 at 06:00:47PM -0400, Chao Shi wrote:
> > @@ -330,6 +330,8 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
> >  	char *addr;
> >  	__u32 checksum;
> >  
> > +	if (!bh->b_folio)
> > +		return crc32_be(crc32_sum, bh->b_data, bh->b_size);
> >  	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
> >  	checksum = crc32_be(crc32_sum, addr, bh->b_size);
> >  	kunmap_local(addr);
> 
> This is awkward.  How about ...

... Oh.  It's not just awkward.  The current code is actually wrong.
If one uses ext4 on a bs>PS device and one has
CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP enabled, it'll only map one
page of the buffer and we should get a crash when trying to checksum
the entire block.

Supporting mapping multiple pages from a folio simultaneously is
something we haven't figured out how to support.  Since HIGHMEM is
dying (see Arnd's recent work), I'm not inclined to spend effort
on it.

We probably just need to make ext4 depend on !DEBUG_KMAP_LOCAL_FORCE_MAP
or something?

> static inline void *kmap_local_bh(const struct buffer_head *bh)
> {
> 	if (bh->b_folio)
> 		return kmap_local_folio(bh->b_folio, bh_offset(bh));
> 	return kmap_local_page(virt_to_page(bh->b_data);
> }
> 
> (this is also somewhat awkward because it feels like we could just
> return bh->b_data, but kunmap_local_indexed() does some ... stuff)
> 
> Anyway, it all gets optimised away on non-HIGHMEM.  Or if it doesn't,
> you can force it to ;-)
> 
> 
