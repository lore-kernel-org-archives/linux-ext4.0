From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Date: Fri, 11 Aug 2017 14:11:32 +0200
Message-ID: <20170811121132.bj5y77scrvkgy7uo@rh_laptop>
References: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
 <20170805084601.GA12425@infradead.org>
 <20170807121212.nuiho4afmdjf5vsd@rh_laptop>
 <20170808090016.lxfbcrhoybmyfvlc@rh_laptop>
 <20170811100147.GB7064@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752610AbdHKMLf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 11 Aug 2017 08:11:35 -0400
Content-Disposition: inline
In-Reply-To: <20170811100147.GB7064@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 11, 2017 at 03:01:47AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 08, 2017 at 11:00:16AM +0200, Lukas Czerner wrote:
> > So I've read the thread where you talk about this. I do not see anything
> > about it being a masive mistake. I only see that you're confident that's
> > it's a wrong thing to do. Like you're ever not confident about
> > something;) Care to elaborate on what's wrong with it and why we do not
> > want it ? On the surface it does look like a usefull option to have.
> 
> The problem is that DAX is an implementation detail on how to write
> data back.  It has absolutely no user visible semantics.  Encoding
> such a detail in the on-disk format is not a good idea.

Thanks, for the answer. I do not know too much about the DAX enabled HW.
However I do know that there is some variety to it, some can be faster
than DRAM, some can be slower, or on-par with DRAM. Some can be more
expensive, hence probably smaller, some cheaper and bigger. What about
latency and throughput can there be difference as well ?

That said, it seems to me that there can be some user choice involved in
this at least based on the fact that when DAX is used system memory is not
used.

So for example when DAX HW is slower than system memory, user can make
a choice to exclude some inodes to speed up particular workload, while
saving system memory where it does not matter as much.

Also can this flag play a role in situation of hierarchical, or heterogeneous
storage where dax enabled hardware is used ? Seems to me that it might.

What I am trying to say is that while you say that it has no user
visible semantics, it does have effect on the system that should not be
simply ignored.

-Lukas
