From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix interaction between i_size, fallocate, and
 delalloc after a crash
Date: Tue, 17 Oct 2017 10:41:17 -0400
Message-ID: <20171017144117.ispjgvwrespix5z3@thunk.org>
References: <CAOQ4uxgc77_P472KEyHfAXSOE6DD7c=2VrJWBJT6ahiSYb=iJQ@mail.gmail.com>
 <CAFk8rvYtyraezVEP1e3LFEE+9t5YoRH2YwjKxex8hgSY74Lw7A@mail.gmail.com>
 <20171007032917.bntgnubthdstmrrt@thunk.org>
 <59DDFC47.3050300@cn.fujitsu.com>
 <CAFk8rvbi6eDn4P7rfBr6+90xbsQcfEBJAp0wQh+tczNEwdMTpw@mail.gmail.com>
 <CAOQ4uxjtf8_y7Hmb4GU9YN7DvMa7WNtpeRzGoK5m2=Vw=ChStA@mail.gmail.com>
 <CAFk8rvZoOcU4Di8mkV_uPd3e4ccqPrB5kg2Y5WufhJX6W73k7w@mail.gmail.com>
 <CAOQ4uxiKdRq1KyiEW-d9rp+hWQanVzMXQa1vW2JHmhtEVM1-GA@mail.gmail.com>
 <20171017000925.jdh6j66ejnebbckg@thunk.org>
 <CAPaz=E+jFuOmRk8+EmVhNawwogNzW3VkciFrCc0Fk23OfGbwuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>,
        Ashlie Martinez <ashmrtn@utexas.edu>,
        Eryu Guan <eguan@redhat.com>,
        Ext4 <linux-ext4@vger.kernel.org>, Josef Bacik <jbacik@fb.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        fstests <fstests@vger.kernel.org>
To: Vijay Chidambaram <vvijay03@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56932 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932790AbdJQOlY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 17 Oct 2017 10:41:24 -0400
Content-Disposition: inline
In-Reply-To: <CAPaz=E+jFuOmRk8+EmVhNawwogNzW3VkciFrCc0Fk23OfGbwuA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 17, 2017 at 12:43:20AM +0000, Vijay Chidambaram wrote:
> It does expand our already-large search space, but our first order of
> business is making sure CrashMonkey can reproduce every crash-consistency
> bug reported in recent times (mostly by Amir :) ). So for now we were just
> analyzing the bug and trying to understand it, but it looks like the
> post-recovery image is not very useful for this.

Right, the post-recovery (after the journal replayed) is not very
useful.  Unfortunately, the pre-recovery (after the power cut, but
before the journal replay) I suspect won't be terribly interesting
either.  It will show that the corruption is baked into the journal
--- which is to say, the problem wasn't in whether the calls to the
jbd2 layer were correct --- but rather, that one of the file system
mutations in a specific jbd2 handle's "micro-transaction" left the
file system is an inconsistent state.

Not a terrible inconsistency, and it would be quickly papered over in
a follow-up handle --- but one where if the handle which left the file
system in an inconsistent state, and the handle which cleaned it up
were in different transactions, and the power cut happened after the
first transaction, the file system be left in a state where e2fsck
would complain.

So if you have the I/O trace where the handles in question were
assigned to the right (wrong) set of transactions, then yes, you'll
see the problem, just as the xfstest will see the problem.

But if you want to improve the CrashMonkey's search of the problem
space, it will require higher-level logging, because this is really a
different sort of bug.  CrashMonkey will find (a) bugs in jbd2, and
(b) bugs in how the jbd2 layer is called.  This bug is really a bug in
ext4 implementation, because it is in *how* the file system was
mutated that temporarily left it in an inconsistent state, and that's
a different thing from (a) or (b).  Which is great --- it's arguably
additional research work that can be segregated into a different
"Minimum Publishable Unit".  :-)

					- Ted
