From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Wed, 2 Sep 2009 08:09:58 -0400
Message-ID: <20090902120958.GA16415@mit.edu>
References: <4A9E5496.8050909@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sachin Sant <sachinp@in.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50896 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZIBMKE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 08:10:04 -0400
Content-Disposition: inline
In-Reply-To: <4A9E5496.8050909@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 02, 2009 at 04:48:46PM +0530, Sachin Sant wrote:
> While executing fsstress against ext4 with 2.6.31-rc8 on a
> powerpc box, ran into the following Bug.
>
> ------------[ cut here ]------------
> cpu 0x0: Vector: 700 (Program Check) at [c0000000f3ae3970]
>    pc: c000000000280f28: .jbd2_journal_commit_transaction+0x8ac/0x1bfc
>    lr: c000000000280e58: .jbd2_journal_commit_transaction+0x7dc/0x1bfc
>    sp: c0000000f3ae3bf0
>   msr: 8000000000029032
>  current = 0xc0000000f315c7d0
>  paca    = 0xc000000000b62600
>    pid   = 23139, comm = kjournald2
> kernel BUG at fs/jbd2/commit.c:533!

Hmm, that's this ASSERT:

     J_ASSERT(commit_transaction->t_nr_buffers <=
              commit_transaction->t_outstanding_credits);

in jbd2_journal_commit_transaction().  That's not something I've ever
seen before, nor have we made any changes in the jbd2 logic in quite
some time that would could be related to that code.

Is it possible to extract out the contents of the commit_transaction
structure?  In particular, the t_nr_buffers and t_outstanding_credits value?

Also, how big was /dev/sda4? 

At this point, I can't rule out a wild pointer corrupting the data
structure, however improbable that sounds... 

						- Ted
