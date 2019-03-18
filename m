Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC4EC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 22:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EDD620989
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 22:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jAFSalGs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfCRWyx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 18:54:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42724 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfCRWyx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2019 18:54:53 -0400
Received: by mail-ed1-f68.google.com with SMTP id j89so14955284edb.9
        for <linux-ext4@vger.kernel.org>; Mon, 18 Mar 2019 15:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/OsGP+pG1JYLP58c21FWmZPraOCPyHqL+KbfAxgBKbE=;
        b=jAFSalGsXlBzaZXyu8+7MpVyoUYeTgKgdb7DncaVfMfdRk6GY2FpddL+h4RebJZ4Ih
         VGj39KvDYFXCusF5tyJcFcQDVXJ2KY/MsnzyJUb43Sl2K5GWkay7IECoXZI3nNKErhdO
         jd7KE0aGZseMJAzxIXQKatHA573nflmZZDlBIZU4eVC60u2YZBP5IHHFV0j79HTsQITq
         gYf3uoOMhBOqKeDEQYzclSqezi6hiSfO779Q6j463sDPc1vRUDp5iv9tWk07x97Q0DH7
         puCjal7R9teyreudlbus45uHtjH2fSA/4D9SBX3PJJGhaPA47W3DnA22k8ovHZESlroM
         ANZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/OsGP+pG1JYLP58c21FWmZPraOCPyHqL+KbfAxgBKbE=;
        b=ED3H8qF9kPlvqXAQk+JZ2sDtv1H+Vv2YIGdAvxWQkor/JuRRVky3HzxSossBNDl3pg
         3512sMoaJGfk7UphxVACMtMhMqf6CyTl5wm+FtiU4I4kC4w0D6fI4awl0VMy+sN3qE3Q
         8YcLYY5kw/RAhn9RM5O1nPC98frZWOZJTcYu7m4lnuE9L/TGFvUz8fDyrhoahMEdJY6O
         nh7siiD+4uTrSmEOVMXH1VflxJm+YwJ4MxyuKGjoC66HOH+rtJardrqS5FFugzKxyrLm
         /Cs3pcE5FGPZQ2NBQLtL3NhKTTLzdzfyx3GJ0mRZQUEFUyPv/on+xbdLYCII9ksqo35c
         xZvw==
X-Gm-Message-State: APjAAAVG7fnj9sWcJD4AChs/Iyrj7q7aPLwuMlZ0Jq2imFCL1xZQRqcL
        6vJzmKxzSV/aa7pHEVBUdelPHmaI3odU4V5UVMM/UQ==
X-Google-Smtp-Source: APXvYqz3J0MLJ2xWGDZggG3ZFRt4oD0n4ee2uQIOt5qkiXjAiZHE/a1HaqGEA8l4ahOjGib/DBL1xTnjvKhnudaG+QA=
X-Received: by 2002:a50:f5f4:: with SMTP id x49mr9868781edm.97.1552949690806;
 Mon, 18 Mar 2019 15:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAGRrVHxhK9Bsk42m5D2LEiVzoWxbK7Z5=FGynLcbqsX-5iWT0g@mail.gmail.com>
 <20190314201851.GH23020@dastard> <CAGRrVHxhBbMX9W9OmftUPDq5R4koJNjJDDy2xPDF073GTVo6jw@mail.gmail.com>
 <20190318113828.GG9415@quack2.suse.cz>
In-Reply-To: <20190318113828.GG9415@quack2.suse.cz>
From:   Ross Zwisler <zwisler@google.com>
Date:   Mon, 18 Mar 2019 16:54:39 -0600
Message-ID: <CAGRrVHyrNQkOKZK=HFWCOAYyEeU+pKjm9vRG78X6J2viAsWfkA@mail.gmail.com>
Subject: Re: question about writeback
To:     Jan Kara <jack@suse.cz>
Cc:     Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Ross Zwisler <zwisler@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 18, 2019 at 5:38 AM Jan Kara <jack@suse.cz> wrote:
> On Thu 14-03-19 14:37:55, Ross Zwisler wrote:
> > On Thu, Mar 14, 2019 at 2:18 PM Dave Chinner <david@fromorbit.com> wrote:
> > > On Thu, Mar 14, 2019 at 02:03:08PM -0600, Ross Zwisler wrote:
> > > > Hi,
> > > >
> > > > I'm trying to understand a failure I'm seeing with both v4.14 and
> > > > v4.19 based kernels, and I was hoping you could point me in the right
> > > > direction.
> > > >
> > > > What seems to be happening is that under heavy I/O we get into a
> > > > situation where for a given inode/mapping we eventually reach a steady
> > > > state where one task is continuously dirtying pages and marking them
> > > > for writeback via ext4_writepages(), and another task is continuously
> > > > completing I/Os via ext4_end_bio() and clearing the
> > > > PAGECACHE_TAG_WRITEBACK flags.  So, we are making forward progress as
> > > > far as I/O is concerned.
> > > >
> > > > The problem is that another task calls filemap_fdatwait_range(), and
> > > > that call never returns because it always finds pages that are tagged
> > > > for writeback.  I've added some prints to __filemap_fdatawait_range(),
> > > > and the total number of pages tagged for writeback seems pretty
> > > > constant.  It goes up and down a bit, but does not seem to move
> > > > towards 0.  If we halt I/O the system eventually recovers, but if we
> > > > keep I/O going we can block the task waiting in
> > > > __filemap_fdatawait_range() long enough for the system to reboot due
> > > > to what it perceives as hung task.
> > > >
> > > > My question is: Is there some mechanism that is supposed to prevent
> > > > this sort of situation?  Or is it expected that with slow enough
> > > > storage and a high enough I/O load, we could block inside of
> > > > filemap_fdatawait_range() indefinitely since we never run out of dirty
> > > > pages that are marked for writeback?
> > >
> > > SO your problem is that you are doing an extending write, and then
> > > doing __filemap_fdatawait_range(end = LLONG_MAX), and while it
> > > blocks on the pages under IO, the file is further extended and so
> > > the next radix tree lookup finds more pages past that page under
> > > writeback?
> > >
> > > i.e. because it is waiting for pages to complete, it never gets
> > > ahead of the extending write or writeback and always ends up with
> > > more pages to wait on and so never reached the end of the file as
> > > directed?
> > >
> > > So perhaps the caller should be waiting on a specific range to bound
> > > the wait (e.g.  isize as the end of the wait) rather than using the
> > > default "keep going until the end of file is reached" semantics?
> >
> > The call to __filemap_fdatawait_range() is happening via the jdb2 code:
> >
> > jbd2_journal_commit_transaction()
> >   journal_finish_inode_data_buffers()
> >     filemap_fdatawait_keep_errors()
> >       __filemap_fdatawait_range(end = LLONG_MAX)
> >
> > Would it have to be an extending write?  Or could it work the same if
> > you have one thread just moving forward through a very large file,
> > dirtying pages, and the __filemap_fdatawait_range() call will just
> > keep finding new pages as it moves forward through the big file?
>
> As Ted wrote, it must be extending write or a very large file.
> __filemap_fdatawait_range() is strictly monotone - it waits for each page
> at most once (check the loop in __filemap_fdatawait_range()). It would be
> actually good to know which case you hit if you can find it out.
>
> > In either case, I think your description of the problem is correct.
> > Is this just a "well, don't do that" type situation, or is this
> > supposed to have a different result?
>
> Let's call this a known limitation of current ext4 journalling
> implementation :) As Ted has outlined, there are plans to redesign some
> things which would also avoid this problem. But that's not a quick fix.
> Short term we could reduce the problem by tracking in jbd2 the min-max
> range that's relevant for the running transaction. It wouldn't completely
> fix it as e.g. for random writes into sparse file the problem would still
> trigger but that is far less common than continously extending file or
> sequential write into a large file.

Awesome, thank you for the replies.  I'll see if I can boil it down to
a relatively simple xfstest type reproducer, and I'll take a crack at
implemeting your suggested workaround in jbd2.

Thanks,
- Ross
