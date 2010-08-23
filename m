From: Jan Kara <jack@suse.cz>
Subject: Re: [patch 4/6] jbd: remove dependency on __GFP_NOFAIL
Date: Tue, 24 Aug 2010 00:21:00 +0200
Message-ID: <20100823222100.GE3380@quack.suse.cz>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008161956190.17924@chino.kir.corp.google.com>
 <20100817095103.GA3557@quack.suse.cz>
 <20100823122813.1ffa3f2e.akpm@linux-foundation.org>
 <20100823220347.GB3380@quack.suse.cz>
 <20100823151129.433875d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, David Rientjes <rientjes@google.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab0HWWVo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Aug 2010 18:21:44 -0400
Content-Disposition: inline
In-Reply-To: <20100823151129.433875d9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 23-08-10 15:11:29, Andrew Morton wrote:
> On Tue, 24 Aug 2010 00:03:47 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > So do
> > you think that we should keep __GFP_NOFAIL as long as all callers are not
> > able to handle allocation failures in more reasonable way?
> 
> The concept should be encapsulated in _some_ centralised fashion.
> 
> Helper functions would work as well as __GFP_NOFAIL, and will move any
> runtime cost away from the good code and push it onto the bad code.
  Makes sense. Removed the patch.

  David, could you provide a function for non-failing allocation and then
use this from JBD and whatever else code is also affected? That looks like
a cleaner solution as Andrew points out...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
