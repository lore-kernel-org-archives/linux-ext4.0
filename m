From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] fs-writeback: Add helper function to start
	writeback   if idle
Date: Fri, 18 Dec 2009 16:33:36 +0100
Message-ID: <20091218153336.GR4489@kernel.dk>
References: <4B22D029.5090304@redhat.com> <20091218114427.GQ4489@kernel.dk> <4B2B9FF5.4030102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36554 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbZLRPdh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Dec 2009 10:33:37 -0500
Content-Disposition: inline
In-Reply-To: <4B2B9FF5.4030102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 18 2009, Eric Sandeen wrote:
> Jens Axboe wrote:
> > On Fri, Dec 11 2009, Eric Sandeen wrote:
> >> ext4, at least, would like to start pushing on writeback if it starts
> >> to get close to ENOSPC when reserving worst-case blocks for delalloc
> >> writes.  Writing out delalloc data will convert those worst-case
> >> predictions into usually smaller actual usage, freeing up space
> >> before we hit ENOSPC based on this speculation.
> >>
> >> Thanks to Jens for the suggestion for the helper function,
> >> & the naming help.
> >>
> >> I've made the helper return status on whether writeback was
> >> started even though I don't plan to use it in the ext4 patch;
> >> it seems like it would be potentially useful to test this
> >> in some cases.
> > 
> > Eric, how do you want to merge these? I can easily take this first one
> > through any branch, but I suppose the ext4 one should go through the
> > proper ext4 channels.
> 
> Doesn't matter to me really; maybe it'd be simpler if it all went
> though the ext4 tree so that there aren't any ordering problems?

Definately :-)

-- 
Jens Axboe

