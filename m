From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Date: Tue, 8 Aug 2017 11:00:16 +0200
Message-ID: <20170808090016.lxfbcrhoybmyfvlc@rh_laptop>
References: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
 <20170805084601.GA12425@infradead.org>
 <20170807121212.nuiho4afmdjf5vsd@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752113AbdHHJAT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Aug 2017 05:00:19 -0400
Content-Disposition: inline
In-Reply-To: <20170807121212.nuiho4afmdjf5vsd@rh_laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 07, 2017 at 02:12:12PM +0200, Lukas Czerner wrote:
> On Sat, Aug 05, 2017 at 01:46:01AM -0700, Christoph Hellwig wrote:
> > Please don't do this until we have a coherent DAX plan.  So far
> > the flag in XFS seems like a massive mistake and we need to get
> > rid of it instead of adding it to more file systems.
> 
> Hi, pardon my ignorance, but can you point me to the discussion where
> this was decided ? I must have missed it and I can't find it.
> 
> Thanks!
> -Lukas

So I've read the thread where you talk about this. I do not see anything
about it being a masive mistake. I only see that you're confident that's
it's a wrong thing to do. Like you're ever not confident about
something;) Care to elaborate on what's wrong with it and why we do not
want it ? On the surface it does look like a usefull option to have.

-Lukas
