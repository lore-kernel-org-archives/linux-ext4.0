From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: use kmem_cache_zalloc instead of
 kmem_cache_alloc/memset
Date: Wed, 26 Sep 2012 20:52:47 -0400
Message-ID: <20120927005247.GA15707@thunk.org>
References: <CAPgLHd_3++6=n+4qbimZprbgfn83ps3j+Fe543OZBr61DVs=vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, yongjun_wei@trendmicro.com.cn,
	linux-ext4@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52597 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab2I0AxA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 20:53:00 -0400
Content-Disposition: inline
In-Reply-To: <CAPgLHd_3++6=n+4qbimZprbgfn83ps3j+Fe543OZBr61DVs=vA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 28, 2012 at 09:39:40PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using kmem_cache_zalloc() instead of kmem_cache_alloc() and memset().
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied, thanks!

					- Ted
