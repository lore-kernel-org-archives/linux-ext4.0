From: "Stephen C. Tweedie" <sct@redhat.com>
Subject: Re: [PATCH] jbd: abort instead of waiting for nonexistent
	transactions
Date: Tue, 05 Aug 2008 16:50:37 +0100
Message-ID: <1217951437.3886.36.camel@sisko.scot.localnet>
References: <1217893895-29165-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Sami Liedes <sliedes@cc.hut.fi>,
	Stephen Tweedie <sct@redhat.com>
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759767AbYHEPvz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Aug 2008 11:51:55 -0400
In-Reply-To: <1217893895-29165-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Tue, 2008-08-05 at 00:51 +0100, Duane Griffin wrote:
> The __log_wait_for_space function sits in a loop checkpointing transactions
> until there is sufficient space free in the journal. However, if there are
> no transactions to be processed (e.g. because the free space calculation is
> wrong due to a corrupted filesystem) it will never progress.
> 
> Check for space being required when no transactions are outstanding and
> abort the journal instead of endlessly looping.

I'm not sure this is the right fix --- it seems like we're fixing the
symptoms, not the problem.

The journal free space fields are reset in journal_reset() when we load
the journal, so we can't get this situation of j_free being insufficient
on an idle filesystem unless the main journal start/end pointers are
corrupt.

Surely we'd be better off detecting this in the first place at mount
time, not later on during checkpoint?

Cheers,
 Stephen


