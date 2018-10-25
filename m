Return-Path: <SRS0=KszP=NF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43986 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727208AbeJYUOX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 Oct 2018 16:14:23 -0400
Date: Thu, 25 Oct 2018 13:41:56 +0200
From: Jan Kara <jack@suse.cz>
To: Fisher <fisherthepooh@protonmail.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: Why not always do copy-out in jbd2_journal_write_metadta_buffer
Message-ID: <20181025114156.GB7711@quack2.suse.cz>
References: <usGdshd4UQ6wFx4jVDkzY1xddFnUnT7NXj6IWA-uVczdSc5_TmczQvtmULxNVQ3reUPTmyQd2YeLhPa_L2uPbaNdfBPVlLz7rQQ9oC7aSkw=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <usGdshd4UQ6wFx4jVDkzY1xddFnUnT7NXj6IWA-uVczdSc5_TmczQvtmULxNVQ3reUPTmyQd2YeLhPa_L2uPbaNdfBPVlLz7rQQ9oC7aSkw=@protonmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Mon 22-10-18 10:34:48, Fisher wrote:
> Recently I was testing my storage's performance and found that there were
> periodic performance drops when I ran sequential write benchmark.
> After profiling the duration in each step, I found that the dropping
> performance was due to wait_on_bit_io(&bh->b_state, BH_Shadow,
> TASK_UNINTERRUPTIBLE) in do_get_write_access(). And this is what made me
> confused, if my understanding was right, I thought buffer_shadow(bh)
> stands for buffer not being copied-out that's why we should wait.

No buffer_shadow() just means that some version of the buffer is being
written to the journal. 

> But why don't we do copy-out in jbd2_journal_write_metadta_buffer()? and
> if we do do the copy-out, does that mean we don't have to
> set_buffer_shadow because it refers to buffer not copied-out?

The code in do_get_write_access() checks whether the buffer already has
frozen data (by checking jh->b_frozen_data) and if not, if it is just being
written to the journal (buffer_shadow() check in there). If it is, we have
to wait because we cannot modify the version of the buffer that goes to the
journal.

> I made a test, when a buffer_head goes into
> jbd2_journal_write_metadta_buffer(), as long as it belongs to metadata,
> then force it to do copy-out and do not set_buffer_shadow, then there
> will be no periodic performance drops. Is this test reasonable?

Well, it does trade of CPU overhead (you know copy buffer for each
transaction) for the latency (no need to wait for buffer writeout when
redirtying buffer). Usually I wouldn't consider this worth it but obviously
it depends on the workload...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
