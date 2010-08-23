From: Jan Kara <jack@suse.cz>
Subject: Re: [patch 4/6] jbd: remove dependency on __GFP_NOFAIL
Date: Tue, 24 Aug 2010 00:03:47 +0200
Message-ID: <20100823220347.GB3380@quack.suse.cz>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008161956190.17924@chino.kir.corp.google.com>
 <20100817095103.GA3557@quack.suse.cz>
 <20100823122813.1ffa3f2e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, David Rientjes <rientjes@google.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab0HWWEb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Aug 2010 18:04:31 -0400
Content-Disposition: inline
In-Reply-To: <20100823122813.1ffa3f2e.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 23-08-10 12:28:13, Andrew Morton wrote:
> On Tue, 17 Aug 2010 11:51:03 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Mon 16-08-10 19:58:01, David Rientjes wrote:
> > > Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
> > > caller.
> > > 
> > > The error handling when kzalloc() returns NULL in start_this_handle()
> > > was removed since it was unreachable.
> >   Thanks! I've added the patch to my tree.
> 
> Please unadd it.  JBD should be fixed so that it can appropriately
> handle out-of-memory conditions.  Until that time we shouldn't hide its
> shortcomings with this open-coded equivalent.
  Well, I wanted to make it easy for David so that he can proceed with his
removal of __GFP_NOFAIL. I agree that pushing the looping from the
allocator to the callers seems of a disputable value to me as well.  So do
you think that we should keep __GFP_NOFAIL as long as all callers are not
able to handle allocation failures in more reasonable way?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
