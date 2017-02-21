From: Tejun Heo <tj@kernel.org>
Subject: Re: Saw your commit: Use mutex_lock_io() for
 journal->j_checkpoint_mutex
Date: Tue, 21 Feb 2017 15:45:08 -0500
Message-ID: <20170221204508.GB8260@htj.duckdns.org>
References: <20170221202324.7plxcp22risagxqu@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:36102 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdBUUpK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Feb 2017 15:45:10 -0500
Received: by mail-yw0-f170.google.com with SMTP id v200so70128344ywc.3
        for <linux-ext4@vger.kernel.org>; Tue, 21 Feb 2017 12:45:10 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170221202324.7plxcp22risagxqu@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, Ted.

> If this happens, it almost certainly means that the journal is too
> small.  This was something that grad student I was mentoring found
> when we were benchmarking our SMR-friendly jbd2 changes.  There's a
> footnote to this effect in the Fast 2017 paper[1] 
> 
> [1] https://www.usenix.org/conference/fast17/technical-sessions/presentation/aghayev
>     (if you want early access to the paper let me know; it's currently
>     available to registered FAST 2017 attendees and will be opened up
>     at the start of the FAST 2017 conference next week)
>
> The short version is that on average, with a 5 second commit window
> and a 30 second dirty writeback timeout, if you assume the worst case
> of 100% of the metadata blocks being already in the buffer cache (so
> they don't need to be read from disk), in 5 seconds the journal thread
> could potential spew 150*5 == 750MB in a journal transaction.  But
> that data won't be written back until 30 seconds later.  So if you are
> continuously deleting files for 30 seconds, the journal should have
> room for at least around 4500 megs worth of sequential writing.  Now,
> that's an extreme worst case.  In reality there will be some disk
> reads, not to mention the metadata writebacks, which will be random.

I see.  Yeah, that's close to what we were seeing.  We had a
malfunctioning workload which was deleting extremely high number of
files locking up the filesystem and thus other things on the host.
This was a clear misbehavior on the workload but debugging it took
longer than necessary because the waits didn't get accounted as
iowait, so the patch.

> The bottom line is that 128MiB, which was the previous maximum journal
> size, is simply way too small.  So in the latest e2fsprogs 1.43.x
> release, the default has been changed so that for a sufficiently large
> disk, the default journal size is 1 gig.
> 
> If you are using faster media (say, SSD or PCie-attached flash), and
> you expect to have workloads that are extreme with respect to huge
> amounts of metadata changes, an even bigger journal might be called
> for.  (And these are the workloads where the lazy journalling that we
> studied in the FAST paper is helpful, even on convential HDD's.)
> 
> Anyway, you might want to pass onto the system administrators (or the
> SRE's, as applicable :-) that if they were hitting this case often,
> they should seriously consider increasing the size of their ext4
> journal.

Thanks a lot for the explanation!

-- 
tejun
