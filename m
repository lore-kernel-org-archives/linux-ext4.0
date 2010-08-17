From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 4/6] jbd: remove dependency on __GFP_NOFAIL
Date: Tue, 17 Aug 2010 10:48:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008171046330.6486@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161956190.17924@chino.kir.corp.google.com> <20100817095103.GA3557@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:26128 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab0HQRtD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Aug 2010 13:49:03 -0400
In-Reply-To: <20100817095103.GA3557@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 17 Aug 2010, Jan Kara wrote:

> > Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
> > caller.
> > 
> > The error handling when kzalloc() returns NULL in start_this_handle()
> > was removed since it was unreachable.
>   Thanks! I've added the patch to my tree. Since rc1 is over, I think this
> is a material for the next merge window, right?

Yes, we still need to switch over GFP_KERNEL callers and remove the flag 
completely, so there's no hurry for this to go into 2.6.36.
