From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/9] readahead: introduce PG_readahead
Date: Sat, 19 May 2007 08:25:04 -0700
Message-ID: <20070519082504.8baa8d19.akpm@linux-foundation.org>
References: <20070516224752.500812933@mail.ustc.edu.cn>
	<379355695.83536@ustc.edu.cn>
	<20070518232824.9917d794.akpm@linux-foundation.org>
	<379577826.15160@ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759275AbXESPaW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 May 2007 11:30:22 -0400
In-Reply-To: <379577826.15160@ustc.edu.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 19 May 2007 20:30:31 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> On Fri, May 18, 2007 at 11:28:24PM -0700, Andrew Morton wrote:
> > On Thu, 17 May 2007 06:47:53 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > 
> > > Introduce a new page flag: PG_readahead.
> > 
> > Is there any way in which we can avoid adding a new page flag?
> > 
> > We have the advantage that if the kernel very occasionally gets the wrong
> > result for PageReadahead(page), nothing particularly bad will happen, so we
> > can do racy things.
> > 
> > >From a quick peek, it appears that PG_readahead is only ever set against
> > non-uptodate pages.  If true we could perhaps exploit that: say,
> > PageReadahead(page) == PG_referenced && !PG_uptodate?
> 
> PG_uptodate will flip to 1 before the reader touches the page :(

OK.

> However, it may be possible to share the same bit with PG_reclaim or PG_booked.
> Which one would be preferred?

I'd like PG_booked to go away too - I don't think we've put that under the
microscope yet.  If it remains then its scope will be "defined by the
filesystem", so readahead shouldn't use it.  PG_reclaim belongs to core VFS
so that's much better.

Let's not do anything ugly, slow or silly in there, but please do take a
look, see if there is an opportunity here.
