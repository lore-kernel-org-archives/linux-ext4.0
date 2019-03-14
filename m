Return-Path: <SRS0=Ur5Y=RR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC1FC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 23:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75BF121874
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 23:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfCNXDL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 19:03:11 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44138 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727765AbfCNXDK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Mar 2019 19:03:10 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2EN2vMl021220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Mar 2019 19:02:58 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id BE32F420AA8; Thu, 14 Mar 2019 19:02:56 -0400 (EDT)
Date:   Thu, 14 Mar 2019 19:02:56 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ross Zwisler <zwisler@google.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Ross Zwisler <zwisler@kernel.org>
Subject: Re: question about writeback
Message-ID: <20190314230256.GD6482@mit.edu>
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

On Thu, Mar 14, 2019 at 02:37:55PM -0600, Ross Zwisler wrote:
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

I think jbd2 needs to call a new filemap_fdatawait_range_keep_errors()
(to be defined in mm/filemap.c).

> Would it have to be an extending write?  Or could it work the same if
> you have one thread just moving forward through a very large file,
> dirtying pages, and the __filemap_fdatawait_range() call will just
> keep finding new pages as it moves forward through the big file?

No, that case is fine because we'll eventually make our way to the end
of the file and stop.

In the long term I want to get rid of data=ordered mode (while still
avoids the stale data problem) without going through all of this hair
so we don't have to call filemap_fdatawait from the commit thread.
The real problem is that ext2/3 allocates blocks, updates the inode
metadata, and then writes the data blocks out.  What we need to do is
to swap the 2nd and 3rd steps....

					- Ted
