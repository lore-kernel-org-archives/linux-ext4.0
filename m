From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] jbd2/journal_commit_transaction: relocate state lock
 to incorporate all users
Date: Mon, 10 Jun 2013 22:52:46 -0400
Message-ID: <20130611025246.GC23966@thunk.org>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370892723-30860-2-git-send-email-paul.gortmaker@windriver.com>
 <20130611021230.GA23966@thunk.org>
 <CAP=VYLroGDmJLPvb3RL+FRN_F+zMBOdMyY8GpnLt2vVYE+900Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56798 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab3FKCwu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jun 2013 22:52:50 -0400
Content-Disposition: inline
In-Reply-To: <CAP=VYLroGDmJLPvb3RL+FRN_F+zMBOdMyY8GpnLt2vVYE+900Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 10, 2013 at 10:45:50PM -0400, Paul Gortmaker wrote:
> 
> Sure, I will do so tomorrow -  but since it can't be reproduced
> on-demand, all I'll be able to do is to watch for independent
> calls with very close time stamps, and confirm they were not
> interleaved.

Well, if the resulting patch causes jbd_debug() messages to be issued
correctly, I have every confidence that they won't be interleaved; the
%pV structure was used to solve this very problem, and it's used all
over the kernel.  In fact we've used it __ext4_error()/ext4_error() to
solve this exact same issue of interleaved messages.

> What about the state assert being done outside of the state
> lock?   Should I keep that as a separate patch so that the
> assert isn't checking what could possibly be a transient value?

Ah, I missed that since I had been focusing on the jbd_debug().
That's a good catch, we'll still need this patch to make sure we're
checking the state assert under the j_state lock.  But with the fixed
jbd_debug() we can keep the jbd_debug() statement outside of the
j_state_lock critical region.

Cheers,

						- Ted
