From: Vijay Chidambaram <vvijay03@gmail.com>
Subject: Re: [PATCH] ext4: fix interaction between i_size, fallocate, and
 delalloc after a crash
Date: Tue, 17 Oct 2017 18:16:24 -0500
Message-ID: <CAPaz=EJ7jOG1Ji2w7+7Z82nfMvYR7C6puDoaQQ5fpM=UysBPjg@mail.gmail.com>
References: <CAOQ4uxgc77_P472KEyHfAXSOE6DD7c=2VrJWBJT6ahiSYb=iJQ@mail.gmail.com>
 <CAFk8rvYtyraezVEP1e3LFEE+9t5YoRH2YwjKxex8hgSY74Lw7A@mail.gmail.com>
 <20171007032917.bntgnubthdstmrrt@thunk.org> <59DDFC47.3050300@cn.fujitsu.com>
 <CAFk8rvbi6eDn4P7rfBr6+90xbsQcfEBJAp0wQh+tczNEwdMTpw@mail.gmail.com>
 <CAOQ4uxjtf8_y7Hmb4GU9YN7DvMa7WNtpeRzGoK5m2=Vw=ChStA@mail.gmail.com>
 <CAFk8rvZoOcU4Di8mkV_uPd3e4ccqPrB5kg2Y5WufhJX6W73k7w@mail.gmail.com>
 <CAOQ4uxiKdRq1KyiEW-d9rp+hWQanVzMXQa1vW2JHmhtEVM1-GA@mail.gmail.com>
 <20171017000925.jdh6j66ejnebbckg@thunk.org> <CAPaz=E+jFuOmRk8+EmVhNawwogNzW3VkciFrCc0Fk23OfGbwuA@mail.gmail.com>
 <20171017144117.ispjgvwrespix5z3@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Amir Goldstein <amir73il@gmail.com>,
        Ashlie Martinez <ashmrtn@utexas.edu>,
        Eryu Guan <eguan@redhat.com>,
        Ext4 <linux-ext4@vger.kernel.org>, Josef Bacik <jbacik@fb.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        fstests <fstests@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171017144117.ispjgvwrespix5z3@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Amir, thank you for providing io recording, this is really useful!
Most of our work in recent weeks has driven by your input and your
posts to the mailing list!

Ted, I agree with your characterization of the bug. Its true that
CrashMonkey will be missing context for certain bugs, and for those
kinds of bugs, we will probably have a different project :)

But for now, we are trying to widen the scope of CrashMonkey as much
as we can. I think for the current bug, we can handle it in the
following way:
1. run CrashMonkey with the smallest journal possible
2. in the setup phase of CrashMonkey, do N random metadata operations
(that will fill up some percentage of the journal space)
3. run the test workload and collect the IO trace

We will do steps 2 and 3 with different N. For this bug, there must be
a particular N that will force the micro-transaction to be at the end
of the journal tx, revealing the bug.

In general, it might be good for CrashMonkey to force the metadata
from the test workload to be distributed across different journal
transactions. The trick is to do it without modifying the file system
itself.

Thanks,
Vijay

On Tue, Oct 17, 2017 at 9:41 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Oct 17, 2017 at 12:43:20AM +0000, Vijay Chidambaram wrote:
>> It does expand our already-large search space, but our first order of
>> business is making sure CrashMonkey can reproduce every crash-consistency
>> bug reported in recent times (mostly by Amir :) ). So for now we were just
>> analyzing the bug and trying to understand it, but it looks like the
>> post-recovery image is not very useful for this.
>
> Right, the post-recovery (after the journal replayed) is not very
> useful.  Unfortunately, the pre-recovery (after the power cut, but
> before the journal replay) I suspect won't be terribly interesting
> either.  It will show that the corruption is baked into the journal
> --- which is to say, the problem wasn't in whether the calls to the
> jbd2 layer were correct --- but rather, that one of the file system
> mutations in a specific jbd2 handle's "micro-transaction" left the
> file system is an inconsistent state.
>
> Not a terrible inconsistency, and it would be quickly papered over in
> a follow-up handle --- but one where if the handle which left the file
> system in an inconsistent state, and the handle which cleaned it up
> were in different transactions, and the power cut happened after the
> first transaction, the file system be left in a state where e2fsck
> would complain.
>
> So if you have the I/O trace where the handles in question were
> assigned to the right (wrong) set of transactions, then yes, you'll
> see the problem, just as the xfstest will see the problem.
>
> But if you want to improve the CrashMonkey's search of the problem
> space, it will require higher-level logging, because this is really a
> different sort of bug.  CrashMonkey will find (a) bugs in jbd2, and
> (b) bugs in how the jbd2 layer is called.  This bug is really a bug in
> ext4 implementation, because it is in *how* the file system was
> mutated that temporarily left it in an inconsistent state, and that's
> a different thing from (a) or (b).  Which is great --- it's arguably
> additional research work that can be segregated into a different
> "Minimum Publishable Unit".  :-)
>
>                                         - Ted
