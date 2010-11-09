From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Don't call sb_issue_discard() in
 ext4_free_blocks()
Date: Tue, 9 Nov 2010 15:03:18 -0500
Message-ID: <20101109200318.GG3099@thunk.org>
References: <1289196382-31239-1-git-send-email-tytso@mit.edu>
 <4CD97875.6050703@redhat.com>
 <AANLkTikmExLtH0-LKEvH=WoL=o550EJQuO33dRsoFNWB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38564 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0KIUDZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Nov 2010 15:03:25 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTikmExLtH0-LKEvH=WoL=o550EJQuO33dRsoFNWB@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 09, 2010 at 10:00:37AM -0800, Jiaying Zhang wrote:
> I would like to spend some time to see whether we can add
> sb_issue_discard() somewhere else for non-journaled mode.
> It is a useful feature to be included for both modes.

It certainly can be done, but we'll have to do the trim from a kernel
thread or workqueue context.  (Of course, we need to make sure that
the blocks don't get reused until the trim happens --- or, if we want
to use those blocks, that we take them off the to-be-trimmed list
before we reuse them.)

I am a bit concerned about just adding a new thread, though.
Especially if it's per filesystem, since on a system with a very high
spindle/ext4 file system count, this could get a bit crazy.  It's a
bit better in 2.6.36 now that with concurrency managed workqueues,
there's only one workqueue thread per file system, instead of one
workqueue thread per file system per core (so on a system with 50
spindles and 32 cores, there would be 1600 workqueue threads!).

						- Ted

