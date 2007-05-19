From: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 1/9] readahead: introduce PG_readahead
Date: Sat, 19 May 2007 20:30:31 +0800
Message-ID: <379577826.15160@ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn> <379355695.83536@ustc.edu.cn> <20070518232824.9917d794.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.ustc.edu.cn ([202.38.64.16]:51909 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755761AbXESMai (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 May 2007 08:30:38 -0400
Message-ID: <20070519123031.GA6095@mail.ustc.edu.cn>
Content-Disposition: inline
In-Reply-To: <20070518232824.9917d794.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 18, 2007 at 11:28:24PM -0700, Andrew Morton wrote:
> On Thu, 17 May 2007 06:47:53 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > Introduce a new page flag: PG_readahead.
> 
> Is there any way in which we can avoid adding a new page flag?
> 
> We have the advantage that if the kernel very occasionally gets the wrong
> result for PageReadahead(page), nothing particularly bad will happen, so we
> can do racy things.
> 
> >From a quick peek, it appears that PG_readahead is only ever set against
> non-uptodate pages.  If true we could perhaps exploit that: say,
> PageReadahead(page) == PG_referenced && !PG_uptodate?

PG_uptodate will flip to 1 before the reader touches the page :(

However, it may be possible to share the same bit with PG_reclaim or PG_booked.
Which one would be preferred?
