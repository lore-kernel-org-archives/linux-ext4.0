Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E76C330B2E;
	Fri,  5 Jun 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780669479; cv=none; b=MePpAoFDSayR+drFt/Mr+9Ccezr7QywhXujKtxuJbkIl+HvaMifwG6a3TyLRR09yXALfCd2Mw3gS21FOVvQg+Hstq/gYvle2fOdJauNMbD85XooXrx2ZGCXipXbh1Z9HkK6tJMoNLvrkuTkRvuYG0I8LdHneaU2mM4ljebDQDP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780669479; c=relaxed/simple;
	bh=tsWcgyf+GmgWflUyW+jWruDPSGWLDIwoyP4cQPgmOGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iakUUekP3g5BVWEtAuA5cF04nf+NObpMgB7eIk3U0GLcNH5mrSNkwEutJVNjGwkeiQIQCDFXBVcnNWapMd71z6Us42iHQ2dKiqH0eURmkINh5bWvddTGiuVCoet64QYlWs2N/WPnqIKoIu11H9AFCk/lkG1zykmydvQnZY0wunU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hAYMOubf; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hAYMOubf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=A0TtP6N5mhqRYValCyJdilT+d9rpBNYThtLMIWxSlBc=; b=hAYMOubfHzR+fx7UlN7oHoRNw6
	8cuYEoYS+7fYyPKrQWoEcHI/B5Ydn4f2exRN1yWQqTsrBc+Jorc93hHEpyHR89TzWiK261Jo/mGUn
	A/Ttsjg6bFD/aWaUfI9ah0GvsZRJdjYc/UhKlaUn2xbkkRHsw2ZBzaFTb9JxXuuoiwEJOhbI5lVC6
	5KTKVaOAb7h2SnLSvhOHUIYb+7POJ3z3aGlBZL5jwzqopBMJIeLACzRngM4drxD+7oNKlgZAnlxBq
	aas4SumT1HsHBt/S0WVS8mPHFgPkgcsD0r8X8CQKhwj+M96VvjfBZCkdblmX2BahPZ0rNCSr85h0m
	wTam6UUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVVTB-000000083Zm-0AlL;
	Fri, 05 Jun 2026 14:24:21 +0000
Date: Fri, 5 Jun 2026 15:24:20 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jia Zhu <zhujia.zj@bytedance.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: avoid full buffer walks for large folio partial
 writes
Message-ID: <aiLcFP2drmHGjEL2@casper.infradead.org>
References: <20260603134800.25155-1-zhujia.zj@bytedance.com>
 <aiBuZE5NWMfOGAA6@casper.infradead.org>
 <20260605090253.32822-1-zhujia.zj@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605090253.32822-1-zhujia.zj@bytedance.com>

On Fri, Jun 05, 2026 at 05:02:53PM +0800, Jia Zhu wrote:
> On Wed, Jun 03, 2026 at 07:11:48PM +0100, Matthew Wilcox wrote:
> > Is this a common case for you, or is this something you noticed by
> > inspection?
> 
> This was found by our kernel release benchmark.  We run libMicro as part
> of that test suite:
> 
>   https://github.com/rzezeski/libMicro
> 
> The regression shows up in buffered write/pwrite/writev overwrite tests
> on ext4 large folios.

Makes sense.  I'll assume this can correspond to a reasonable workload.
It certainly seems like something that could exist.

> > Wouldn't you get just as much benefit from this?
> 
> Yes.  I tested this approach, and it gives almost the same result as my
> original partial-commit helper.

Excellent!  Obviously it'd be even better if we didn't have to walk the
leading buffer_heads ... but there's no way to do this with the data
structure we have.

> Agreed.  The original ext4_block_write_begin() change was too aggressive.
> Seeking directly to @from also skips the prefix buffers, which makes the
> old side effects harder to prove.
> 
> For v2 I plan to drop that part and keep the existing walk from the head.
> The ext4 change would only stop after @to when the folio was already
> uptodate on entry, similar to your block_commit_write() suggestion:
> 
> +       bool folio_uptodate = folio_test_uptodate(folio);
> +
>         for (bh = head, block_start = 0;
> -            bh != head || !block_start;
> +            (bh != head || !block_start) &&
> +            (!folio_uptodate || block_start < to);
>              block++, block_start = block_end, bh = bh->b_this_page) {
>                 ...
>         }

Yes, I think that's a good approach.

> So the prefix path and all in-range handling stay unchanged.  The only
> skipped work is the tail part after @to, and only for a folio that was
> already uptodate before write_begin() started.
> 
> > ... converting ext4 to use iomap instead of buffer heads.
> 
> I strongly agree that iomap is the right direction for ext4.  The iomap
> buffered write path would make this particular buffer-head walk cost go
> away.
> 
> The reason I am still looking at this path is that the regression is
> visible in our LTS upgrade testing from 6.12 to 6.18.  It was introduced
> by the ext4 large-folio enablement in v6.16.  For example, in our
> libMicro release benchmark with THP always enabled, usecs/call, lower is
> better:
> 
> case        v6.12        v6.18        regression
> write_u1k   0.609        4.659        +665.0%
> write_u10k  1.408        4.869        +245.8%

Ouch ;-)  No wonder you want to address this.  Do you recover all the
regression with this fix?

> The iomap conversion is the long-term fix, but it does not help kernels
> which still use the buffer-head buffered write path.  I would like to keep
> this as a small regression fix for that path, and make it minimal enough
> to be suitable for stable/LTS backport.

Is it that you're using some ext4 features that aren't supported by
iomap yet?  Could you say which ones?  That might motivate someone to
prioritise that support.

> Would this v2 direction look OK to you?

Absolutely.  Very happy with this approach.
