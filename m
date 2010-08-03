From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Use atomic variables to avoid taking
 t_handle_lock in jbd2_journal_stop
Date: Mon, 2 Aug 2010 20:06:09 -0400
Message-ID: <20100803000609.GI25653@thunk.org>
References: <1280753306-23871-1-git-send-email-tytso@mit.edu>
 <1280790152.3966.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: john stultz <johnstul@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53838 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0HCAGN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Aug 2010 20:06:13 -0400
Content-Disposition: inline
In-Reply-To: <1280790152.3966.14.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 02, 2010 at 04:02:32PM -0700, john stultz wrote:
> >From these numbers, it looks like the atomic variables are a minor
> improvement for -rt, but the improvement isn't as drastic as the earlier
> j_state lock change, or the vfs scalability patchset.

Thanks for doing this quick test run!  I was expecting to see a more
dramatic difference, since the j_state_lock patch removed one of the
two global locks in jbd2_journal_stop, and the t_handle_lock patch
removed the second of the two global locks.  But I guess the
j_state_lock contention in start_this_handle() is still the dominating factor.

It's interesting that apparently the latest t_handle_lock patch
doesn't seem to make much difference unless the VFS scalability patch
is also applied.  I'm not sure why that makes a difference, but it's
nice to know that with the VFS scalability patch it does seem to help,
even if it doesn't help as much as I had hoped.

OK, I guess we'll have to start working on the more aggressive
scalability fix ups....

						- Ted
