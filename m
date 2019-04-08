Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5545DC282CE
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 17:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BC3E21473
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 17:41:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3O4gEkr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbfDHRlV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 13:41:21 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35383 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfDHRlV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 13:41:21 -0400
Received: by mail-yb1-f195.google.com with SMTP id e190so1978240ybf.2;
        Mon, 08 Apr 2019 10:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jbAW/VFspfHDIS8JkcU+S6gUCaiynxkGwxtdG3YKX9c=;
        b=P3O4gEkr+MddCE/pX1wNa3asw8CUw4j4OTLuyDNouiYleVHImmVqeVzLkgPq/mHnFp
         +vcHu5dez2wkOPrOtefrs6BuuFQ0qNT1PpkHvMoMbH3gptPHZ593YjzWVMgmhQnsaO8O
         omTf+DwPVKHO4GY084JBUVthkvK6NCFpf0/vyqYshQupnBvoN9PoGmAZo79wwJFtgLQw
         gJPiE50iOXi2suh/lRlbwYtB/RCTQSziOpuY3OXwqRy/icWPgq3lRAie2xqJDP/wqFUW
         MOt2CVEnsiYJwISL1AfzVpcaoVlbcRONC5Xifaq8x9eGKYsyJdHjKq4Eh8tew7k2au+c
         AEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jbAW/VFspfHDIS8JkcU+S6gUCaiynxkGwxtdG3YKX9c=;
        b=dtfPJcralI/sz5tzODRztnauqCzasJeo0S1p2ZM6YNr4oamLoxRHDb1tCDI1yhUmZx
         sdg5AYu08g9F1mMxd2tgeA+AnwrHfH1Wab49GQuIcSxvwAJn/5wmzw6gX+DKrSIgdybk
         d3DLbH/5naPwinWL1emV9D0aKAtemn+RJHOgbdohfWpAL7Pn9hZJ5cyT4LKCXctGES4u
         4Ed02aodT02tU4FXp76S2RPBRiRNqACGZjc6q44l53jkadVlZ+hmIMuIX05bwSYw8GFs
         TWHYWWGcfW7oagLmcbwAQZaWEM+4gT6NiEP8/L0zt4NxItskc/gqMhRgwkGwHdrwk/Mf
         0q9Q==
X-Gm-Message-State: APjAAAV5uCGZckVEbwAowaQTeBUcZNqJKBWXDKCYKlFqLAKMVL+8MNCS
        Bo6SQDWvPQWu9uazASSH9g80FfDmSyNyOZViokU=
X-Google-Smtp-Source: APXvYqxqr5v8Bu7ob8/WVMpNjL4W5SZSU3obzJPs0PNpdZEpcCC82LPqRTi3gn0yEuy5dFeHPKYFMqobGEiUn1jDoJE=
X-Received: by 2002:a25:774f:: with SMTP id s76mr15541738ybc.197.1554745280313;
 Mon, 08 Apr 2019 10:41:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190404165737.30889-1-amir73il@gmail.com> <20190404211730.GD26298@dastard>
 <CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com>
 <20190407232728.GF26298@dastard> <CAOQ4uxgD4ErSUtbu0xqb5dSm_tM4J92qt6=hGH8GRc5KNGqP9A@mail.gmail.com>
 <20190408141114.GC15023@quack2.suse.cz>
In-Reply-To: <20190408141114.GC15023@quack2.suse.cz>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 8 Apr 2019 20:41:09 +0300
Message-ID: <CAOQ4uxhxgYASST1k-UaqfbLL9ERquHaKL2jtydB2+iF9aT8SRQ@mail.gmail.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw workload
To:     Jan Kara <jack@suse.cz>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 8, 2019 at 5:11 PM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 08-04-19 12:02:34, Amir Goldstein wrote:
> > On Mon, Apr 8, 2019 at 2:27 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Fri, Apr 05, 2019 at 05:02:33PM +0300, Amir Goldstein wrote:
> > > > On Fri, Apr 5, 2019 at 12:17 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > >
> > > > > On Thu, Apr 04, 2019 at 07:57:37PM +0300, Amir Goldstein wrote:
> > > > > > This patch improves performance of mixed random rw workload
> > > > > > on xfs without relaxing the atomic buffered read/write guaranty
> > > > > > that xfs has always provided.
> > > > > >
> > > > > > We achieve that by calling generic_file_read_iter() twice.
> > > > > > Once with a discard iterator to warm up page cache before taking
> > > > > > the shared ilock and once again under shared ilock.
> > > > >
> > > > > This will race with thing like truncate, hole punching, etc that
> > > > > serialise IO and invalidate the page cache for data integrity
> > > > > reasons under the IOLOCK. These rely on there being no IO to the
> > > > > inode in progress at all to work correctly, which this patch
> > > > > violates. IOWs, while this is fast, it is not safe and so not a
> > > > > viable approach to solving the problem.
> > > > >
> > > >
> > > > This statement leaves me wondering, if ext4 does not takes
> > > > i_rwsem on generic_file_read_iter(), how does ext4 (or any other
> > > > fs for that matter) guaranty buffered read synchronization with
> > > > truncate, hole punching etc?
> > > > The answer in ext4 case is i_mmap_sem, which is read locked
> > > > in the page fault handler.
> > >
> > > Nope, the  i_mmap_sem is for serialisation of /page faults/ against
> > > truncate, holepunching, etc. Completely irrelevant to the read()
> > > path.
> > >
> >
> > I'm at lost here. Why are page faults completely irrelevant to read()
> > path? Aren't full pages supposed to be faulted in on read() after
> > truncate_pagecache_range()?
>
> During read(2), pages are not "faulted in". Just look at
> what generic_file_buffered_read() does. It uses completely separate code to
> add page to page cache, trigger readahead, and possibly call ->readpage() to
> fill the page with data. "fault" path (handled by filemap_fault()) applies
> only to accesses from userspace to mmaps.
>

Oh! thanks for fixing my blind spot.
So if you agree with Dave that ext4, and who knows what other fs,
are vulnerable to populating page cache with stale "uptodate" data,
then it seems to me that also xfs is vulnerable via readahead(2) and
posix_fadvise().
Mind you, I recently added an fadvise f_op, so it could be used by
xfs to synchronize with IOLOCK.

Perhaps a better solution would be for truncate_pagecache_range()
to leave zeroed or Unwritten (i.e. lazy zeroed by read) pages in page
cache. When we have shared pages for files, these pages could be
deduped.

Thanks,
Amir.
