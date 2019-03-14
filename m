Return-Path: <SRS0=Ur5Y=RR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92797C10F06
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 20:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 636E221872
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 20:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfCNUS4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 16:18:56 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:10998 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726444AbfCNUS4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Mar 2019 16:18:56 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 15 Mar 2019 06:48:53 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h4WoW-0004SF-0t; Fri, 15 Mar 2019 07:18:52 +1100
Date:   Fri, 15 Mar 2019 07:18:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Ross Zwisler <zwisler@kernel.org>
Subject: Re: question about writeback
Message-ID: <20190314201851.GH23020@dastard>
References: <CAGRrVHxhK9Bsk42m5D2LEiVzoWxbK7Z5=FGynLcbqsX-5iWT0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGRrVHxhK9Bsk42m5D2LEiVzoWxbK7Z5=FGynLcbqsX-5iWT0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 14, 2019 at 02:03:08PM -0600, Ross Zwisler wrote:
> Hi,
> 
> I'm trying to understand a failure I'm seeing with both v4.14 and
> v4.19 based kernels, and I was hoping you could point me in the right
> direction.
> 
> What seems to be happening is that under heavy I/O we get into a
> situation where for a given inode/mapping we eventually reach a steady
> state where one task is continuously dirtying pages and marking them
> for writeback via ext4_writepages(), and another task is continuously
> completing I/Os via ext4_end_bio() and clearing the
> PAGECACHE_TAG_WRITEBACK flags.  So, we are making forward progress as
> far as I/O is concerned.
> 
> The problem is that another task calls filemap_fdatwait_range(), and
> that call never returns because it always finds pages that are tagged
> for writeback.  I've added some prints to __filemap_fdatawait_range(),
> and the total number of pages tagged for writeback seems pretty
> constant.  It goes up and down a bit, but does not seem to move
> towards 0.  If we halt I/O the system eventually recovers, but if we
> keep I/O going we can block the task waiting in
> __filemap_fdatawait_range() long enough for the system to reboot due
> to what it perceives as hung task.
> 
> My question is: Is there some mechanism that is supposed to prevent
> this sort of situation?  Or is it expected that with slow enough
> storage and a high enough I/O load, we could block inside of
> filemap_fdatawait_range() indefinitely since we never run out of dirty
> pages that are marked for writeback?

SO your problem is that you are doing an extending write, and then
doing __filemap_fdatawait_range(end = LLONG_MAX), and while it
blocks on the pages under IO, the file is further extended and so
the next radix tree lookup finds more pages past that page under
writeback?

i.e. because it is waiting for pages to complete, it never gets
ahead of the extending write or writeback and always ends up with
more pages to wait on and so never reached the end of the file as
directed?

So perhaps the caller should be waiting on a specific range to bound
the wait (e.g.  isize as the end of the wait) rather than using the
default "keep going until the end of file is reached" semantics?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
