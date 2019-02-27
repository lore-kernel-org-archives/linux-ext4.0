Return-Path: <SRS0=GcgC=RC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E876C00319
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 13:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E34A22133D
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 13:24:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H5mxhftu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbfB0NYy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Feb 2019 08:24:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfB0NYy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Feb 2019 08:24:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XFwL8TY/dcfGWNKemGskjZiFKsKtQ8ufREkdlBJDHQg=; b=H5mxhftuDuEEx0yPZqoxnYV5F
        /w07jIjgekwvXwQ5gjo/A21wsEX7mPyWt5Pnsd73AFk9x1UlyHDfhOjduIXaiAXeUrrYHJh5BChfb
        SRuc9mX0/elvvzNeyKCPUOmcV4AzsO1WjhEOUUHgUrEvRt/pYhJm348qB45CksrTBtFfHB5jtZRwb
        Ev8p8MGEJJsXWpJgGZdbBJODY80B44p1haGi0tZFVL2qBcDLwE4eORhvNiybIsJPCgCqcMu3FNcoE
        nxeYg+bdNn0Z+o2AfjPrpki+yO9oy9x9A9vW4d0/SLQFw6uU8SZuFQ2z2XC/x0j+2G1CGL4XZ8BSq
        FdfdGDjEQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gyzCd-0005Ta-IB; Wed, 27 Feb 2019 13:24:51 +0000
Date:   Wed, 27 Feb 2019 05:24:51 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Keith Busch <keith.busch@intel.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ric Wheeler <ricwheeler@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190227132451.GL11592@bombadil.infradead.org>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
 <20190220234723.GA5999@localhost.localdomain>
 <yq18sy8ili7.fsf@oracle.com>
 <20190222164504.GB10066@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222164504.GB10066@localhost.localdomain>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 22, 2019 at 09:45:05AM -0700, Keith Busch wrote:
> On Thu, Feb 21, 2019 at 09:51:12PM -0500, Martin K. Petersen wrote:
> > 
> > Keith,
> > 
> > > With respect to fs block sizes, one thing making discards suck is that
> > > many high capacity SSDs' physical page sizes are larger than the fs
> > > block size, and a sub-page discard is worse than doing nothing.
> > 
> > That ties into the whole zeroing as a side-effect thing.
> > 
> > The devices really need to distinguish between discard-as-a-hint where
> > it is free to ignore anything that's not a whole multiple of whatever
> > the internal granularity is, and the WRITE ZEROES use case where the end
> > result needs to be deterministic.
> 
> Exactly, yes, considering the deterministic zeroing behavior. For devices
> supporting that, sub-page discards turn into a read-modify-write instead
> of invalidating the page.  That increases WAF instead of improving it
> as intended, and large page SSDs are most likely to have relatively poor
> write endurance in the first place.
> 
> We have NVMe spec changes in the pipeline so devices can report this
> granularity. But my real concern isn't with discard per se, but more
> with the writes since we don't support "sector" sizes greater than the
> system's page size. This is a bit of a different topic from where this
> thread started, though.

I don't understand how reporting a larger discard granularity helps.
Sure, if the file was written block-by-block in that large granularity
to begin with, then the drive can invalidate an entire page.  But if
even one page of that, say, 256kB block was rewritten, then discarding
the 256kB block will need to discard 252kB from one erase block and 4kB
from another erase block.

So it looks like you really just want to report a larger "optimal IO
size", which I thought we already had.
