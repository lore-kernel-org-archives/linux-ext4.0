Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57476 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729918AbfAJRfI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Jan 2019 12:35:08 -0500
Date: Thu, 10 Jan 2019 18:35:07 +0100
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?5aec6L+O?= <jiangying13@meituan.com>
Cc: Jan Kara <jack@suse.cz>, "tytso@mit.edu" <tytso@mit.edu>,
        "jack@suse.com" <jack@suse.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= [PATCH] jbd2: adjust
 location of journal->j_list_lock
Message-ID: <20190110173507.GD28450@quack2.suse.cz>
References: <1547004897-187803-1-git-send-email-jiangying13@meituan.com>
 <20190109114251.GF15397@quack2.suse.cz>
 <3eae56c31e76401081d41fb91368fb6c@meituan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3eae56c31e76401081d41fb91368fb6c@meituan.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-01-19 03:31:14, 姜迎 wrote:
> Hum, why do you think the patch below changes anything for the assertion
> failure you mention above? The code that gets additionally covered by
> j_list_lock is just handling of journal head frozen & b_committed_data
> buffers...
> 
> ==>Because kernel panic on  J_ASSERT_JH(jh, jh->b_transaction == NULL).
> 
> please see the following analysis, thanks.  jh->b_transaction is set NULL
> between  J_ASSERT_JH(jh,jh-->b_transaction == commit_transaction ) and
> __jbd2_journal_remove_checkpoint.
> 
> [X]
> 
> With which kernel version did you see the assertion failure?
> 
> ==> I found this issue on kernel-3.10. But I see that the latest kernel
> version also has this problem, but it is seldom reproduce. Can you help
> to check ?

Ah, ok. But the problem really is that __journal_remove_checkpoint() should
not drop the last jh reference (and thus we should never get to
__journal_remove_journal_head() with the assertion J_ASSERT_JH(jh,
jh->b_transaction == NULL)). The committing transaction holds
reference to the journal_head until __jbd2_journal_refile_buffer() either
moves the reference to the next transaction or drops it. So what you
observe rather seems like some bug in reference counting of journal
heads and your patch isn't going to help.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
