From: "Stephen C. Tweedie" <sct@redhat.com>
Subject: Re: [PATCH] jbd: abort instead of waiting for nonexistent
	transactions
Date: Thu, 07 Aug 2008 16:01:08 +0100
Message-ID: <1218121268.14209.13.camel@sisko.scot.localnet>
References: <1217893895-29165-1-git-send-email-duaneg@dghda.com>
	 <1217951437.3886.36.camel@sisko.scot.localnet>
	 <e9e943910808061747x57dc2ed0s614785d9d0a087a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Sami Liedes <sliedes@cc.hut.fi>,
	Stephen Tweedie <sct@redhat.com>
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbYHGPCI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Aug 2008 11:02:08 -0400
In-Reply-To: <e9e943910808061747x57dc2ed0s614785d9d0a087a8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, 2008-08-07 at 01:47 +0100, Duane Griffin wrote:

> > Surely we'd be better off detecting this in the first place at mount
> > time, not later on during checkpoint?
> 
> Sounds sensible. In fact I've got another patch, waiting for feedback
> from the reporter, that adds some very basic validation there (i.e.
> first > 0 && last >= first). Not enough, I suspect. I guess we could
> do much better?

Right: in journal.c we initialise the maximum size of a transaction to

	journal->j_max_transaction_buffers = journal->j_maxlen / 4;

(the logic being that we need the journal to be able to hold an absolute
minimum of one full transaction being checkpointed, one being committed,
and one being live concurrently for the transaction engine to work
correctly, which gives three outstanding transactions; we up that to
four to protect against rounding errors and to ensure space for the
sequence and commit blocks that take up log space in addition to the
journaled buffers themselves.)

If, during journal load, that's not enough for a minimum-sized single
update, we'll never be able to start some transactions, so that would be
a good place to check that we're starting off with a large enough
journal.

--Stephen




