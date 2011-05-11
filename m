From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] ext3: Implement delayed allocation on page_mkwrite
 time
Date: Wed, 11 May 2011 12:52:07 -0700
Message-ID: <20110511125207.58d7e9d0.akpm@linux-foundation.org>
References: <1304369816-14545-1-git-send-email-jack@suse.cz>
	<1304369816-14545-5-git-send-email-jack@suse.cz>
	<20110502141230.4a7640f9.akpm@linux-foundation.org>
	<20110502222020.GB14889@quack.suse.cz>
	<20110502152917.550d2475.akpm@linux-foundation.org>
	<20110503170948.GE6009@quack.suse.cz>
	<20110511153841.GG5057@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab1EKTwN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2011 15:52:13 -0400
In-Reply-To: <20110511153841.GG5057@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 11 May 2011 17:38:41 +0200
Jan Kara <jack@suse.cz> wrote:

> > > > considerations I've decided it's worth it and and fixed the bug...
> > > 
> > > Well.  How did you come to that decision?
> >   So my thoughts were: If a company runs a hosting or similar service and
> > some load either inadvertedly or even maliciously triggers this bug, your
> > systems can be DOSed. That's bad and you need to fix that ASAP. From my
> > experience with our SLE customers, they are willing to listen to advices
> > such as fs choice when they plan a system deployment. After that they
> > vehemently refuse any major change (and fs driver change is a major one).
> > So I'm quite certain they'd rather accept this largish ext3 change.
> > Finally, admittedly, I didn't think the patch will end up so large.
> > 
> > Looking into the patch, I could split off some cleanups and code
> > reorganizations which are 20-30% of the patch but it probably does not make
> > sense to split it more. What I think is a plus of the patch is that there
> > are only two code paths that really change - ext3_get_blocks() has two new
> > cases how it is called (to allocate only indirect blocks and to allocate
> > already reserved data block) and trucate path which has to do more work to
> > check whether indirect block can be removed.
> >   
> > > Are real users hurting from this problem?
> >   I've got a report of this from NEC
> > (http://ns3.spinics.net/lists/linux-ext4/msg20239.html) and OpenVZ people
> > were also concerned
> > (http://ns3.spinics.net/lists/linux-ext4/msg20288.html). I think there was
> > one more report of this problem but I can't find it now. So yes, there are
> > users who care.
> > 
> > >  What's the real-world case for fixing it?
> >   Sorry, I don't understand the question (or how it is different from the
> > previous one).
>   Andrew, does this change your opinion in any way?

I didn't actually have an opinion - I was checking, as usual, that the
proposed change passes the cost-vs-benefit test.

Yes, if real users are hitting the problem in real life then that
strengthens the case for fixing it.

