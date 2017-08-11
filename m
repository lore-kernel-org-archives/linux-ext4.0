From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Date: Fri, 11 Aug 2017 15:41:30 +0200
Message-ID: <20170811134130.o46y5jpekrpj5qvw@rh_laptop>
References: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
 <20170805084601.GA12425@infradead.org>
 <20170807121212.nuiho4afmdjf5vsd@rh_laptop>
 <20170808090016.lxfbcrhoybmyfvlc@rh_laptop>
 <20170811100147.GB7064@infradead.org>
 <20170811121132.bj5y77scrvkgy7uo@rh_laptop>
 <20170811125849.GA15300@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752703AbdHKNld (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 11 Aug 2017 09:41:33 -0400
Content-Disposition: inline
In-Reply-To: <20170811125849.GA15300@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 11, 2017 at 05:58:49AM -0700, Christoph Hellwig wrote:
> On Fri, Aug 11, 2017 at 02:11:32PM +0200, Lukas Czerner wrote:
> > Thanks, for the answer. I do not know too much about the DAX enabled HW.
> > However I do know that there is some variety to it, some can be faster
> > than DRAM, some can be slower, or on-par with DRAM. Some can be more
> > expensive, hence probably smaller, some cheaper and bigger. What about
> > latency and throughput can there be difference as well ?
> 
> Or it could be similar for reads and much slower for writes.  Or it
> might prefer larger access sizes than a cache line.
> 
> > That said, it seems to me that there can be some user choice involved in
> > this at least based on the fact that when DAX is used system memory is not
> > used.
> 
> All of the above are charateristics of the medium, not of the
> application.
> 
> 
> > So for example when DAX HW is slower than system memory, user can make
> > a choice to exclude some inodes to speed up particular workload, while
> > saving system memory where it does not matter as much.
> 
> What should be factored into the decision might be access hints from
> the applications, which would be things like madvise/fadvise hints.
> 
> But the application should not even have to know about something like
> DAX, and the detailed access characterisics of the medium.  And even
> more importantly we should not encode those complex characterisitcs
> (see above) into a binary flag in the on-disk format.

I understand your concept, I even agree that application should not
even know, or have to know, about DAX, or any characteristics of the
medium. Application can take advantage of madvise/fadvise hints, if
implemented in this case and it will be usefull. But I am not talking
about the application here.

Administrator is the one setting up the environment and no matter what
are the capabilities of the application he (it) can and should have the
information about the the system (and the medium characteristics) and
should be able to tweak it. Per inode DAX flags give him the ability to
do so permanently in a convenient way in this case.

We have plenty of knobs in the file system we can play with to optimize
it for a given medium already. Sometimes we maybe go too far, but I do not
think it's the case here. Especially since I do not see a way to implement
the above mentioned use case in a different way - without relying on the
application to do the right thing with hints (when those are implemented).

-Lukas
