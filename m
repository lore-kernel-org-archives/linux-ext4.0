Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5B4C10F00
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 11:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5688320857
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 11:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfCRLib (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 07:38:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:50498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbfCRLib (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Mar 2019 07:38:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2C96EADBE;
        Mon, 18 Mar 2019 11:38:29 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 101B71E425D; Mon, 18 Mar 2019 12:38:28 +0100 (CET)
Date:   Mon, 18 Mar 2019 12:38:28 +0100
From:   Jan Kara <jack@suse.cz>
To:     Ross Zwisler <zwisler@google.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Ross Zwisler <zwisler@kernel.org>
Subject: Re: question about writeback
Message-ID: <20190318113828.GG9415@quack2.suse.cz>
References: <CAGRrVHxhK9Bsk42m5D2LEiVzoWxbK7Z5=FGynLcbqsX-5iWT0g@mail.gmail.com>
 <20190314201851.GH23020@dastard>
 <CAGRrVHxhBbMX9W9OmftUPDq5R4koJNjJDDy2xPDF073GTVo6jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGRrVHxhBbMX9W9OmftUPDq5R4koJNjJDDy2xPDF073GTVo6jw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 14-03-19 14:37:55, Ross Zwisler wrote:
> On Thu, Mar 14, 2019 at 2:18 PM Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Mar 14, 2019 at 02:03:08PM -0600, Ross Zwisler wrote:
> > > Hi,
> > >
> > > I'm trying to understand a failure I'm seeing with both v4.14 and
> > > v4.19 based kernels, and I was hoping you could point me in the right
> > > direction.
> > >
> > > What seems to be happening is that under heavy I/O we get into a
> > > situation where for a given inode/mapping we eventually reach a steady
> > > state where one task is continuously dirtying pages and marking them
> > > for writeback via ext4_writepages(), and another task is continuously
> > > completing I/Os via ext4_end_bio() and clearing the
> > > PAGECACHE_TAG_WRITEBACK flags.  So, we are making forward progress as
> > > far as I/O is concerned.
> > >
> > > The problem is that another task calls filemap_fdatwait_range(), and
> > > that call never returns because it always finds pages that are tagged
> > > for writeback.  I've added some prints to __filemap_fdatawait_range(),
> > > and the total number of pages tagged for writeback seems pretty
> > > constant.  It goes up and down a bit, but does not seem to move
> > > towards 0.  If we halt I/O the system eventually recovers, but if we
> > > keep I/O going we can block the task waiting in
> > > __filemap_fdatawait_range() long enough for the system to reboot due
> > > to what it perceives as hung task.
> > >
> > > My question is: Is there some mechanism that is supposed to prevent
> > > this sort of situation?  Or is it expected that with slow enough
> > > storage and a high enough I/O load, we could block inside of
> > > filemap_fdatawait_range() indefinitely since we never run out of dirty
> > > pages that are marked for writeback?
> >
> > SO your problem is that you are doing an extending write, and then
> > doing __filemap_fdatawait_range(end = LLONG_MAX), and while it
> > blocks on the pages under IO, the file is further extended and so
> > the next radix tree lookup finds more pages past that page under
> > writeback?
> >
> > i.e. because it is waiting for pages to complete, it never gets
> > ahead of the extending write or writeback and always ends up with
> > more pages to wait on and so never reached the end of the file as
> > directed?
> >
> > So perhaps the caller should be waiting on a specific range to bound
> > the wait (e.g.  isize as the end of the wait) rather than using the
> > default "keep going until the end of file is reached" semantics?
> 
> The call to __filemap_fdatawait_range() is happening via the jdb2 code:
> 
> jbd2_journal_commit_transaction()
>   journal_finish_inode_data_buffers()
>     filemap_fdatawait_keep_errors()
>       __filemap_fdatawait_range(end = LLONG_MAX)
> 
> Would it have to be an extending write?  Or could it work the same if
> you have one thread just moving forward through a very large file,
> dirtying pages, and the __filemap_fdatawait_range() call will just
> keep finding new pages as it moves forward through the big file?

As Ted wrote, it must be extending write or a very large file.
__filemap_fdatawait_range() is strictly monotone - it waits for each page
at most once (check the loop in __filemap_fdatawait_range()). It would be
actually good to know which case you hit if you can find it out.

> In either case, I think your description of the problem is correct.
> Is this just a "well, don't do that" type situation, or is this
> supposed to have a different result?

Let's call this a known limitation of current ext4 journalling
implementation :) As Ted has outlined, there are plans to redesign some
things which would also avoid this problem. But that's not a quick fix.
Short term we could reduce the problem by tracking in jbd2 the min-max
range that's relevant for the running transaction. It wouldn't completely
fix it as e.g. for random writes into sparse file the problem would still
trigger but that is far less common than continously extending file or
sequential write into a large file.


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
